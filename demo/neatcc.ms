.\" PSTITLE: The NEATCC C Compiler
.so neat__.ms
.ds en.cl "#468
.post.info Title "The NEATCC C Compiler"
.post.info Author "Ali Gholami Rudi"
.de uc
\s-1\\$1\s+1
..
.chop uc
.de cc
\s-1\f(CB\\$1\fP\s+1
..
.de IP
.	br
.	RT
.	if \\n(.$>1 .nr en.ip \\$2
.	in +\\n[en.ip]u
.	ie \\w'\\$1'<\\n[en.ip] \h'|-\\n[en.ip]u'\\$1\h'|0i'\c
.	el \h'|-\\n[en.ip]u'\\$1
..
.chop cc
.HD
.TL
\s+8The \*[uc NEATCC] C Compiler\s-8
.AU
\fIAli Gholami Rudi\fP
.sp 3
.LP
\*[uc NEATCC] is a small C compiler that implements a large subset of
\*[uc ANSI] C.  Despite its size, \*[uc NEATCC] implements effective
optimizations and generates code for different architectures.  In this
document, I shall briefly introduce \*[uc NEATCC], its intermediate code,
its final code generation interface, and some other details that
seem helpful for inspecting its source code and extending it.

.SH "Overview"
In \*[uc NEATCC], compilation phases are implemented in different
source files, which use the interfaces declared in ncc.h to
interact.  The main components of \*[uc NEATCC] are implemented
in the following files.

.sp
.RS
.IP cpp.c 1i
Preprocessing.
.IP tok.c
Tokenisation.
.IP ncc.c
Parsing and directing compiler phases.
.IP int.c
Intermediate code generation.
.IP gen.c
Register allocation and sending intermediate code to backends.
.IP reg.c
Global register allocation.
.IP x64.c
Final code generation (x86.c and arm.c as well).
.RE

.sp
.LP
Most \*[uc NEATCC] optimizations are performed on the intermediate
code (implemented in int.c), such as using instruction immediates,
removing unused values, or constant folding; they are enabled when the
optimization level is at least one.  For global register allocation,
\*[uc NEATCC] performs liveness analysis for local variables when the
optimization level is two; level one enables a simpler register
allocation algorithm and zero disables global register allocation
altogether.

.SH "Intermediate Code"
\*[uc NEATCC]'s parser (ncc.c) calls some of the functions defined in
int.c (prefixed with \(lqo_\(rq), to generate the intermediate code.
The latter also performs optimizations on the generated intermediate
code, such as constant folding, in functions prefixed with \(lqio_\(rq.
The intermediate code is stored as an array of ic struct, which is
defined as follows:

.cc.beg
.ps -1
.vs -3
.ta 2m 9m
struct ic {
	long op;	/* instruction opcode */
	long a1;	/* first argument */
	long a2;	/* second argument */
	long a3;	/* third argument, jump target, argument count */
	long *args;	/* call arguments */
};
.cc.end

.sp
.LP
The arguments of instructions can be compiler temporaries (or
intermediate values), immediates, branch instruction targets, local
identifiers, and symbol identifiers.  A compiler temporary is
specified as positive integer, indicating the instruction that defines
them (thus, the value of compiler temporaries cannot be changed, once
defined).  For instance, temporary number 5 is the output in the 5th
intermediate code instruction, which may define it to be the result of
adding two other temporaries.

Instruction opcode (\*[cc ic->op]) can be one of the macros prefixed with
\(lq\*[cc O_]\(rq in ncc.h; \*[cc ic->op] also specifies the type of the operands
with \*[cc O_MK] macro.
.sp
.IP "\*[cc "O_ADD"]:" 5m
Performs addition for temporaries \*[cc ic->a1] and \*[cc ic->a2];
the same applies to other binary instructions such as \*[cc O_SUB].

.IP "\*[cc "O_ADD|O_NUM"]:"
Similar to \*[cc O_ADD] except that \*[cc ic->a2] is an immediate.

.IP "\*[cc "O_NEG"]:"
Negates \*[cc ic->a1];
the same applies to other unary instructions like \*[cc O_NOT].

.IP "\*[cc "O_CALL"]:"
Calls a function, whose address is stored in \*[cc ic->arg1].
\*[cc ic->a3] specifies the number of arguments
and \*[cc ic->args] is the list of arguments.

.IP "\*[cc "O_CALL|O_SYM"]:"
Similar to \*[cc O_CALL], except that the function is specified
as a symbol identifier (instead of a temporary containing the
address of the function) in \*[cc ic->a1].

.IP "\*[cc "O_MOV"]:"
Assigns the value of \*[cc ic->a1],
casting the value according to \*[cc "O_T(ic->op)"], if necessary.

.IP "\*[cc "O_MOV|O_NUM"]:"
Like \*[cc O_MOV], but loads \*[cc ic->a1] as an immediate.

.IP "\*[cc "O_MOV|O_SYM"]:"
Like \*[cc O_MOV], but loads the address of the given symbol
\*[cc ic->a1] with offset \*[cc ic->a2].

.IP "\*[cc "O_MOV|O_LOC"]:"
Like \*[cc O_MOV], but loads the address of the given local
variable \*[cc ic->a1] with offset \*[cc ic->a2].

.IP "\*[cc "O_MSET"]:"
Performs memset() with the given arguments.

.IP "\*[cc "O_MCPY"]:"
Performs memcpy() with the given arguments.

.IP "\*[cc "O_RET"]:"
Returns \*[cc ic->a1] from a function.

.IP "\*[cc "O_LD|O_NUM"]:"
Loads the value of the address specified as \*[cc ic->a1]
with offset \*[cc ic->a2];
the same applies to \*[cc O_ST] for storing values, with the
exception that the first argument is the destination and the
second argument is the address.

.IP "\*[cc "O_LD|O_SYM"]:"
Like \*[cc "O_LD|O_NUM"], except that \*[cc ic->a1] specifies a symbol.

.IP "\*[cc "O_LD|O_LOC"]:"
Like \*[cc "O_LD|O_NUM"], except that \*[cc ic->a1] specifies a local.

.IP "\*[cc "O_JMP"]:"
Unconditional branch to instruction \*[cc ic->a3].

.IP "\*[cc "O_JZ"]:"
Conditional branch to instruction \*[cc ic->a3], if \*[cc ic->a1]
is zero (\*[cc O_JNZ] for nonzero).

.IP "\*[cc "O_JCC"]:"
Conditional branch to instruction \*[cc ic->a3], if
the given relation (\*[cc "ic->op & 0x0f"]) holds for \*[cc ic->a1]
and \*[cc ic->a2].

.SH "Stack Frame Layout"
\*[uc NEATCC] uses the following stack frame layout for function.  Note
that, some of these sections may be omitted for functions that do not
require them.

.cc.beg
[ STACK ARGUMENTS               ]
[ SAVED REGISTER ARGUMENTS      ]
[ THE PREVIOUS VALUE OF IP      ]
[ THE PREVIOUS VALUE OF FP      ]  <- FP points here
[ LOCAL VARIABLES               ]
[ COMPILER TEMPORARIES          ]
[ SAVED REGISTERS               ]
[ FUNCTION ARGUMENTS            ]
[ NEXT FRAME                    ]  <- SP points here
.cc.end

.SH "Final Code Generation"
The functions whose names begin with \(lqi_\(rq are the low-level
architecture-specific code generation entry points.  For each output
architecture, a header (e.g., x64.h) is included and these entry
points are implemented in a C file (e.g., in x64.c).

The function \*[cc "i_reg(op, md, m1, m2, m3, mt)"]
returns the mask of allowed registers for each
operand of an instruction.  The first argument op, specifies the
instruction (O_* macros); i_reg() sets the value md, m1, m2, and m3 to
indicate the mask of acceptable registers for the destination,
first, second, and third operands of the instruction.
For immediates, the corresponding argument indicates the bit
width of the operand (e.g., 8 means the operand is encoded in 8 bits).
The value of these masks may be changed to zero to indicate fewer than three operands.
If md is zero and m1 nonzero, the destination register should be equal to the first
register, as is common in some \*[uc CISC] instructions.
mt denotes the mask of
registers that may lose their contents after the instruction.
The function i_ins() generates code for the given instruction.
The arguments indicate the instruction and its operands.

Some macros should be defined in architecture-dependent headers and a
few variables should be defined for each architecture, such as
tmpregs, which is an array of register numbers that can be used for
holding temporaries and argregs, which is an array of register numbers
for holding the first \*[uc N_ARGS] arguments.  Consult x64.h, as an
example for the macros defined for each architecture.

.SH "Compiling \*[uc NEATCC]"
The neatcc_make \*[uc GIT] repository, includes a makefile to obtain
and build neatcc, neatld, and neatlibc (and a few other programs).
To do so, use the following commands:

.cc.beg
.ta 12m
$ git clone git://repo.or.cz/neatcc_make.git
$ cd neatcc_make
$ make init	# fetches the required programs
$ make neat	# compiles the programs using the host compiler
$ make boot	# compiles neatcc using itself
$ cd demo && make	# to make sure it works
.cc.end

.LP
The output architecture is x86-64 by default.  To compile for other
architectures, the value of \*[uc OUT] Makefile variable can be
changed.  For instance, the following commands build and bootstrap
neatcc for \*[uc ARM32]:

.cc.beg
.ta 12m
$ make OUT=arm neat
$ make OUT=arm boot
.cc.end

.LP
After compilation, the neatcc excutable in neatrun directory can be
invoked as a C compiler.  It executes the linker or the compiler based
on the presence of -c option.
