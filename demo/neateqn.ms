.\" PSTITLE: Typesetting Mathematics with Neateqn
.so neat__.ms
.ds en.cl "#936
.post.info Title "Typesetting Mathematics with Neateqn"
.post.info Author "Ali Gholami Rudi"
.HD
.TL
\f(HD\s+8Typesetting Mathematics with Neateqn\m0\s-8\fP
.AU
\fIA. G. Rudi\fP
.sp 3
This document briefly introduces Neateqn, an eqn implementation for
typesetting mathematical formulas in Neatroff.  For further
information about Neatroff and Neateqn, see
http:/\h'-.3n'/litcave.rudi.ir/.

.SH "The Algorithm"
Neatroff follows the rules described in appendix \s-1G\s+1 of Knuth's
Texbook, which explains Tex's algorithm for typesetting mathematical
formulas.  In Tex, the sub-formulas of a formula are always typeset in
one of the eight predefined styles.  The formulas inside
\&\s-1.EQ/.EN\s+1 blocks are rendered in displayed styles and inline
equations are rendered in text styles.
Their main difference is that in text styles formulas are
vertically more compact to reduce the amount of extra
spacing required to be inserted between lines.

The default value of the parameters of the typesetting algorithm,
such as the position of subscripts, can be changed.
These parameters are described in appendix \s-1G\s+1 of the Texbook
and can be modified in Neatroff with Groff eqn-style \(lqset\(rq command.
See Groff eqn manual page or the Texbook for their list and explanations.

.SH "Defining Custom Brackets
It is possible to adjust the default brackets or define new ones.  Two
commands are available for this purpose: one for specifying different
bracket sizes (bracketsizes) and one for specifying bracket building
glyphs (bracketpieces):

.cc.beg
bracketsizes sign N glyph1 glyph2 ... glyphN
bracketpieces sign top mid bot cen
.cc.end

.LP
In these commands, sign is the token placed after the \(lqleft\(rq and
\(lqright\(rq keywords in equations.  In bracketsizes command, the
glyphs should be ordered based on their size with the smallest glyph
appearing first.  Neateqn tries the specified glyphs in the same order
until it finds the glyph that is large enough for the enclosed
formula.  If this fails, it tries to build the bracket if its pieces
are defined (by default or with bracketpieces).  The four arguments of
bracketpieces specify the glyphs required for building the bracket.
The last argument can be empty if the bracket has no centre (\\(lk is
the centre of {, for instance).

As an example, the following lines show how the default opening and
closing parenthesis can be defined:

.cc.beg
bracketpieces ( "\\(LT" "\\(LX" "\\(LB" ""
bracketpieces ) "\\(RT" "\\(RX" "\\(RB" ""
.cc.end

.LP
The following lines do so for braces:

.cc.beg
bracketpieces { "\\(lt" "\\(bv" "\\(lb" "\\(lk"
bracketpieces } "\\(rt" "\\(bv" "\\(rb" "\\(rk"
.cc.end

.LP
Also the following line instructs Neateqn to use Tex's open
parenthesis glyphs with different sizes (note that in Neatroff \\\s-1N\s+1'gid' is
the glyph with device-dependent name gid):

.cc.beg
bracketsizes ( 5 "(" "\\N'parenleftbig'" "\\N'parenleftBig'"
	"\\N'parenleftbigg'" "\\N'parenleftBigg'"
.cc.end

.EQ
delim $$
.EN
.SH "Adjusting the Syntax"
The logic used in eqn to partition equations may seem odd to its new
users; for instant in \(lqO(n sup 2)\(rq, the expected result may
be $O ( n sup 2 )$, instead of $O(n sup {2)}$.
Even experienced eqn users occasionally make these
mistakes and some insert spaces around most tokens to prevent possible
surprises.  Equations like \(lqO ( n sup 2 )\(rq, which prevent
most of these problems, do not look as good as the alternative, however.  This
issue is one of the main advantages of Tex's more concise syntax.  In
Neateqn it is possible to make equations like the first work.

Neateqn splits (chops) equations at specific characters.  Equations
are always chopped at spaces and before and after open and close
braces.  By default, equations are also chopped before and after \(ha,
\(ti, and " (but these can be changed).  The -c option of Neateqn
allows specifying the characters, around which equations are chopped.
For instance, if \(lq\(ti\(ha"(),\(rq is passed with -c to Neateqn,
\(lqO(n sup 2)\(rq is interpreted as \(lqO ( n sup 2 )\(rq.  This
may be considered an improvement but a more important advantage in
the author's opinion is that these characters may be redefined.  For
instance, one may redefine open and close parenthesis as follows:
.cc.beg
define ( @{ left "(" @
define ) @right ")" }@
.cc.end
.LP
Then, it is possible to write \(lq(a over b) sup (c + 5)\(rq
to get $left ( a over b right ) sup left ( c + 5 right )$.
Note that macro arguments are never split away from macro name,
thus one can safely call \(lqlog(a, n)\(rq, if log is defined
as \(lqroman "log" sub {\N'dollar'1}({\N'dollar'2})\(rq.

.SH "Assigning Character Type
Neateqn determines the spacing between characters in an equation based
on their type (see chapter 18 of the Texbook for more information).
It is possible to specify or change the type of a character in Neateqn
with \(lqchartype\(rq command.  Possible types are \(lqord\(rq for
ordinary atoms, \(lqop\(rq for large operators, \(lqbin\(rq for
binary operators, \(lqrel\(rq for relations, \(lqopen\(rq for opening
brackets, \(lqclose\(rq for closing brackets, \(lqpunct\(rq for
punctuations, \(lqinner\(rq for fractions.
As an example, the following line declares backslash as a binary operator:
.cc.beg
chartype bin \\(rs
.cc.end

.LP
The second argument of \(lqchartype\(rq command should be a Troff
character name.  If the operator is not a character, it can be defined as one.
For instance, for \(lq>>\(rq and \(lqlog\(rq
operators, one may define the following two characters (note that
the following two lines are Neatroff requests and should be outside
\&\s-1.EQ/.EN\s+1 blocks):
.cc.beg
\&.char \\[eqn.log] "log
\&.char \\[eqn.>>]  ">\\h'-.1n'>
.cc.end

.LP
Then, the type of the operators can be specified as explained above:
.cc.beg
chartype op  \\[eqn.log]
chartype rel \\[eqn.>>]
.cc.end

.LP
Finally, macros like the following may be defined to improve the readability:
.cc.beg
define >>  @\\[eqn.>>]@
define log @\\[eqn.log]@
.cc.end

.SH "Breaking Equations"
Neateqn can break equations after top-level operators; This is
important especially when there are long inline equations in the text.
The \(lqbreakcost\(rq command can specify the cost of a line break
after different character types: its first argument is the character
type, as enumerated in the previous section, and its second argument
is the cost of line breaks after the given character type.  Costs are
specified via Neatroff's \\j escape sequence (\(lqNeatroff
Introduction\(rq explains the meaning of these costs).  The default
values are:

.cc.beg
breakcost rel 100
breakcost bin 200
breakcost punct 1000
.cc.end

.LP
A value of 0 disables breaking equations for the specified character.
Note that Neateqn breaks equations after top-level operators only.
Thus, equations surrounded by braces will not be broken.  The
following command instructs Neateqn never to break equations:

.cc.beg
breakcost any 0
.cc.end

.SH "Using Tex Mathematical Symbols"
In order to use Tex's mathematical symbols in Neatroff, \s-1CMEX10\s+1 and
\s-1CMSY10\s+1 fonts (or their equivalents, for instance \s-1TXEX\s+1 and \s-1TXSY\s+1 for
Txfonts or \s-1PXEX\s+1 and \s-1PXSY\s+1 for Pxfonts) should be mounted and declared
as the special font of eqn Roman font (the font declared as grfont in
Neateqn).

.cc.beg
\&.fp - CMEX CMEX10
\&.fp - CMSY CMSY10
\&.fspecial R CMEX CMSY
.cc.end

.LP
If the italic font lacks Greek characters, \s-1CMMI10\s+1 (or its equivalents,
like \s-1RTXMI\s+1 for Txfonts or \s-1RPXMI\s+1 for Pxfonts) can be mounted and
declared as a special font of eqn italic font (the font declared as
gfont in Neateqn).

.cc.beg
\&.fp - CMMI RPXMI
\&.fspecial I CMMI
.cc.end

.LP
Standard symbol can also be redefined to use Computer Modern glyphs,
like those for summation and product:

.cc.beg
define sum @{vcenter roman "\\N'summationdisplay'"}@
define tsum @{vcenter roman "\\N'summationtext'"}@
define prod @{vcenter roman "\\N'productdisplay'"}@
define tprod @{vcenter roman "\\N'producttext'"}@
.cc.end

.SH "Retrieving and installing Pxfonts and Txfonts"
These fonts are optional and Neatroff will run fine without them.
This document can make use of this fonts; see instructions below.
.br
Download both fonts from CPAN:
.cc.beg
https://ctan.org/pkg/pxfonts (\*[post.url https://ctan.org/pkg/pxfonts link])
https://ctan.org/pkg/txfonts (\*[post.url https://ctan.org/pkg/txfonts link])
.cc.end
.LP
Unpack both archives in separate directories.  In each directory copy
the contents of the contained \(lqafm\(rq and \(lqpfb\(rq directories
into the \(lqfonts\(rq directory under neatroff_make.
Then, edit neateqn.ms (source of this document): Search for \(lqChange this
section\(rq and comment/uncomment a few lines as described there.
Finally, submit 'make neat' in neatroff_make again, then submit 'make clean
all' in this folder (\(lqdemo\(rq).

.EQ
define sum @{vcenter roman "\N'summationdisplay'"}@
define tsum @{vcenter roman "\N'summationtext'"}@
define prod @{vcenter roman "\N'productdisplay'"}@
define tprod @{vcenter roman "\N'producttext'"}@
define small @size -4@
.EN
.bp
.SH "Some Samples For Different Fonts

.LP
Palatino and Computer Modern mathematical symbols:
.EQ
(x + y) sup n = sum from i=0 to n left ( pile {n above i} right ) x sup i y sup n-i
.EN
.sp -.5
.EQ
left [ a right ] +
left ( a over b right ) +
left { {x + a over b} over {y + c over d} }
+
sqrt {a} + sqrt {a over b} + sqrt { {x + a over b} over {y + c over d} }
.EN

.LP
Palatino and Pxfonts mathematical symbols:
\" Change this section
\" After installing the PxFonts uncomment
\" both reguests below
\".fp - CMEX Pxex
\".fp - CMSY Pxsy
\"
\" and remove all lines up to and the one including "END OF REMOVAL"
\" the following three lines are placeholders
\" until Pxfonts are installed. After installation, remove
\" these definitions.
.fp - CMEX CMEX10
.fp - CMSY CMSY10
\" END OF REMOVAL
.EQ
(x + y) sup n = sum from i=0 to n left ( pile {n above i} right ) ^ x sup i y sup n-i
.EN
.sp -.5
.EQ
left [ a right ] +
left ( a over b right ) +
left { {x + a over b} over {y + c over d} }
+
sqrt {a} + sqrt {a over b} + sqrt { {x + a over b} over {y + c over d} }
.EN

.LP
Times Roman and Txfonts mathematical symbols:
.fp - R R
.fp - I I
.fp - B B
\" Change this section
\" After installing the TxFonts uncomment
\" both reguests below
\" .fp - CMEX txex
\" .fp - CMSY txsy
\"
\" and remove all lines up to and the one including "END OF REMOVAL"
\" the following three lines are placeholders
\" until Pxfonts are installed. After installation, remove
\" these definitions.
.fp - CMEX CMEX10
.fp - CMSY CMSY10
\" END OF REMOVAL
.EQ
(x + y) sup n = sum from i=0 to n left ( pile {n above i} right ) ^ x sup i y sup n-i
.EN
.sp -.5
.EQ
left [ a right ] +
left ( a over b right ) +
left { {x + a over b} over {y + c over d}  }
+
sqrt {a} + sqrt {a over b} + sqrt { {x + a over b} over {y + c over d} }
.EN

.LP
Computer Modern:
.fp - R CMR10
.fp - I CMMI10
.fp - B CMB10
.fp - HD CMBX12
.fp - CMSY CMSY10
.fp - CMEX CMEX10
.fp - CMMI CMMI10
.fspecial R CMSY CMEX10
.fspecial I CMMI
.EQ
(x + y) sup n = sum from i=0 to n left ( pile {n above i} right ) x sup i y sup n-i
.EN
.sp -.5
.EQ
left [ a right ] +
left ( a over b right ) +
left { {x + a over b} over {y + c over d}  }
+
sqrt {a} + sqrt {a over b} + sqrt { {x + a over b} over {y + c over d} }
.EN
