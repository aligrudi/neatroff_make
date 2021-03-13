.\" PSTITLE: Getting Started with Neatroff
.so neat__.ms
.post.info Title "Getting Started with Neatroff"
.post.info Author "Ali Gholami Rudi"
.de MH
.	sp
.	LP
.	ne 1.5
\m[#237]\fI\\$1\fP\m[]
.	IP
..
.ds en.cl "#39a
.HD
.TL
\f(HD\s+8Getting Started with Neatroff\m0\s-8\fP
.AU
\fIA. G. Rudi\fP
.sp 3
The present document explains the steps necessary for setting up and
using Neatroff.  It uses neatroff_make Git repository, which contains
a set of standard macro packages and a top-level Makefile to obtain
and build Neatroff and its helper programs, which are referred to as
Neat* throughout this document.  More details about Neatroff and the
programs that accompany it are available in its homepage at
\*[post.url http://litcave.rudi.ir/].

.SH "Using Neatroff Without Installation"
To use Neatroff without installing it, neatroff_make can be retrieved
as follows:

.cc.beg
$ git clone git://repo.or.cz/neatroff_make.git
.cc.end

.LP
This branch assumes that the resulting directory will not be removed
and shall contain Neatroff fonts, macros, and binaries when using
Neatroff.  The \(lqinit\(rq make target, clones the necessary Git
repositories and obtains Ghostscript fonts.  The \(lqneat\(rq target
compiles the programs and generates Neatroff font descriptions.
Finally, the demo/ subdirectory contains small examples and a Makefile
to demonstrate how to use Neatroff.

.cc.beg
$ make init
$ make neat
$ cd demo && make
.cc.end

.LP
To compile Neatroff documents outside neatroff_make/demo, the Makefile
in this directory is a good template.  Copy this Makefile to that
directory and modify its \s-1BASE\s+1 macro to point to neatroff_make/
directory.

To add new fonts, simply place them in the fonts/ subdirectory and
re-make the \(lqneat\(rq target.  To use the new font in Neatroff, the
file name without its extension may be mounted.  For instance, if the
name of the font is NewFont.ttf, the following Troff code mounts and
uses this font.

.cc.beg
\&.fp - F1 NewFont
\&.ft F1
Text in NewFont
.cc.end

.SH "Installing Neatroff"
This section describes how to install Neatroff in system directories.
First modify \s-1BASE\s+1 macro in neatroff_make/Makefile to point to
the installation location.  Then, after compilining Neatroff as
described in the previous section, build Makefile's install target.

.cc.beg
$ make install
.cc.end

.LP
Note that this command may need to be executed by a superuser
depending on the directory specified as \s-1BASE\s+1.  At this point
Neat* should be installed.  As described in the previous section, the
Makefile in demo/ subdirectory is a good template for compiling
Neatroff documents.  You need to update its value of \s-1BASE\s+1
macro.

.LP
\fBAdding Fonts\fP:
A remarkable design decision in troff was the separation of
output devices, for instance for Postscript, from the troff
typesetting program.  This separation requires generating
device-independent font descriptions, listing available glyphs for
each font and their metrics.
Neatroff's font descriptions can be generated with the Neatmkfn
program as follows (BASE is Neatroff's installation directory):
.LP
.cc.beg
$ mkfn -b -a <fontpath.afm >$BASE/devutf/fontname
$ mkfn -b -o <fontpath.ttf >$BASE/devutf/fontname
.cc.end

.LP
After generating font description, the new font can be mounted in
troff just as other fonts with \&.fp request:

.cc.beg
\&.fp 12 F2 fontname
.cc.end

.LP
Alternatively, you can place your fonts in neatroff_make/fonts/
directory before running make neat; the neat Makefile target generates
and installs font descriptions for all fonts in that directory
automatically.  This is specially convenient when the number of fonts
is large.

There is another method of using fonts in Neatroff that creates the
font descriptions on the fly.  Despite its overhead, this method may
be convenient when testing new fonts.  It uses the fp macro package,
which is included in neatroff_make (-mfp should be passed to
Neatroff).  First, the value of fp.src string register should specify
the directory containing new fonts.
The package defines \&.fp.ttf, \&.fp.otf, and \&.fp.afm macros, whose
behaviour is quite similar to the standard \&.fp request, except that
the third argument should be the name of the font file without its
extension.  Thus, for mounting /path/\:to/\:fonts/\:NewFont.ttf,
test.tr can contain:

.cc.beg
\&.ds fp.src "/path/\:to/\:fonts/
\&.fp.ttf - F3 NewFont
\&.ft FN
Testing the new font...
.cc.end

.SH "More Information"

.MH "Neatroff Introduction
Explains the differences between Neatroff and other
troff implementations.  Available at http:/\h'-.3n'/litcave.rudi.ir/neatroff.pdf.

.MH "Typesetting Mathematics with Neateqn"
Introduces the Neateqn preprocessor for typesetting mathematical equations.
Available at http:/\h'-.3n'/litcave.rudi.ir/neateqn.pdf.

.MH "Neatroff Introduction in Farsi
Explains specifying text direction in right-to-left languages and
Keshideh adjustment in Farsi.
Available at http:/\h'-.3n'/litcave.rudi.ir/neatfarsi.pdf.
