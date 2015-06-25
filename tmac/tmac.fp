.\" tmac.fp - Generate font descriptions on the fly
.\"
.\" This package contains macros that generate neatroff font
.\" descriptions while neatroff is processing input files.
.\" \*[fp.src] should be a directory specified in GS_FONTPATH
.\" environment variable or via -sFONTPATH="..." option of
.\" ghostscript (viz. ps2pdf).  Temporary neatroff file
.\" descriptions are created in \*[fp.dst] directory.
.\"
.if ''\*[fp.src]' .ds fp.src "/path/to/GS_FONTPATH
.if ''\*[fp.dst]' .ds fp.dst "/tmp/
.if ''\*[fp.mkfn]' .ds fp.mkfn "neatmkfn
.\" .fp.ttf font_position troff_font_name font_name
.de fp.ttf
.	sy \\*[fp.mkfn] -b -l -o <\\*[fp.src]/\\$3.ttf >\\*[fp.dst]/\\$3
.	fp \\$1 \\$2 \\*[fp.dst]/\\$3
..
.\" .fp.otf font_position troff_font_name font_name
.de fp.otf
.	sy fontforge -lang=ff -c 'Open("\\*[fp.src]/\\$3.otf"); Generate("\\*[fp.src]/\\$3.ttf");' >/dev/null 2>&1
.	fp.ttf \\$1 \\$2 \\$3
..
.\" .fp.afm font_position troff_font_name font_name
.de fp.afm
.	sy \\*[fp.mkfn] -b -a <\\*[fp.src]/\\$3.afm >\\*[fp.dst]/\\$3
.	fp \\$1 \\$2 \\*[fp.dst]/\\$3
..
