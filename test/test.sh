#!/bin/sh

BASE="$(dirname $0)/.."
ROFF="$BASE/neatroff/roff"
PTXT="$BASE/neatpost/txt"

TMPDIR="/tmp"

test00() {
cat <<'EOF'
hello world
EOF
# outputs
cat 1>&2 <<'EOF'
       hello world
EOF
}

test01() {
cat <<'EOF'
hello
.ps 20
world
EOF
# outputs
cat 1>&2 <<'EOF'
       hello  w o r l d
EOF
}

test02() {
cat <<'EOF'
.po 0
.nf
hello
world
EOF
# outputs
cat 1>&2 <<'EOF'
hello
world
EOF
}

test03() {
cat <<'EOF'
.po 0
.nh
.ll 80u
hello
world
EOF
# outputs
cat 1>&2 <<'EOF'
hello
world
EOF
}

test04() {
cat <<'EOF'
.po 0
hello
.bp
world
EOF
# outputs
cat 1>&2 <<'EOF'
hello

world
EOF
}

test05() {
cat <<'EOF'
.po 0
.nr x 123
.nr 1 456
\n\nx
EOF
# outputs
cat 1>&2 <<'EOF'
45623
EOF
}

test06() {
cat <<'EOF'
.po 0
.nf
.nr i 1000i
.nr c 1000c
.nr P 1000P
.nr m 1000m
.nr n 1000n
.nr p 1000p
.nr u 1000u
.nr v 1000v
.nr x 1000
\ni \nc \nP \nm \nn \np \nu \nv \nx
EOF
# outputs
cat 1>&2 <<'EOF'
72000 28346 12000 10000 5000 1000 1000 12000 1000
EOF
}

test07() {
cat <<'EOF'
.po 0
a \s+(10b\s-(10 \s(30c\s0.
EOF
# outputs
cat 1>&2 <<'EOF'
a b  c  .
EOF
}

test08() {
cat <<'EOF'
.po 0
.ds a "abc def""ghi jkl"
.ds b " abc
.ds c  abc
.nf
(\*a)
(\*b)
(\*c)
EOF
# outputs
cat 1>&2 <<'EOF'
(abc def""ghi jkl")
( abc)
(abc)
EOF
}

test09() {
cat <<'EOF'
.po 0
.de a
abc def
..
\*aghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi
EOF
}

test10() {
cat <<'EOF'
.po 0
.de a
(\\$1) (\\$2) (\\$3)
..
.a abc "def"
EOF
# outputs
cat 1>&2 <<'EOF'
(abc) (def) ()
EOF
}

test11() {
cat <<'EOF'
.po 0
page 1
.bp
.sp 1
page 2
.bp
page 3
EOF
# outputs
cat 1>&2 <<'EOF'
page 1


page 2

page 3
EOF
}

test12() {
cat <<'EOF'
.po 0
\n(nl, \n(.d
.br
\n(nl, \n(.d
.br
\n(nl, \n(.d
EOF
# outputs
cat 1>&2 <<'EOF'
-1 0
12 12
24 24
EOF
}

test13() {
cat <<'EOF'
.po 0
.na
.ll 8m
.in 4m
abc def ghi
jkl
.in 0
mno pqr
EOF
# outputs
cat 1>&2 <<'EOF'
    abc
    def
    ghi
    jkl
mno pqr
EOF
}

test14() {
cat <<'EOF'
.po 0
.pl 3v
.nf
abc
.br
def
.br
ghi
.br
jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi

jkl
EOF
}

test15() {
cat <<'EOF'
.po 0
.nf
.ll 5m
abc
 def
    ghi
jkl 1  2   3    4     5      6
EOF
# outputs
cat 1>&2 <<'EOF'
abc
 def
    ghi
jkl 1  2   3    4     5      6
EOF
}

test16() {
cat <<'EOF'
.po 0
.\" testing copy-mode
abc\
def \. ghi \\
\.jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abcdef . ghi \
EOF
}

test17() {
cat <<'EOF'
.po 0
.ft I
.di x
abc def
.br
.di
.nf
.ft R
efg
.x
def
EOF
# outputs
cat 1>&2 <<'EOF'
efg
abc def
def
EOF
}

test18() {
cat <<'EOF'
.po 0
.ps 20
.vs 24
.nf
abc def

ghi
EOF
# outputs
cat 1>&2 <<'EOF'

a b c   d e f



g h i
EOF
}

test19() {
cat <<'EOF'
.po 0
abc
.ev 1
def
.ev 2
ghi
.br
.ev
.ev
.br
.ev 1
.br
.ev
EOF
# outputs
cat 1>&2 <<'EOF'
ghi
abc
def
EOF
}

test20() {
cat <<'EOF'
.po 0
.rn ps xy
.xy 20
.ps 10
abc
.rm xy
.xy 10
efg
EOF
# outputs
cat 1>&2 <<'EOF'
a b c   e f g
EOF
}

test21() {
cat <<'EOF'
.po 0
.de x
abc
..
.rn x y
def
.y
ghi
.rm y
.x
.y
EOF
# outputs
cat 1>&2 <<'EOF'
def abc ghi
EOF
}

test22() {
cat <<'EOF'
.po 0
.de x
abc
..
.am x zz
def
.zz
.x
EOF
# outputs
cat 1>&2 <<'EOF'
abc def
EOF
}

test23() {
cat <<'EOF'
.po 0
.de ps
\\$1
..
def
.ps abc
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
def abc ghi
EOF
}

test24() {
cat <<'EOF'
.po 0
.nf
.di a
abc
.di
\n(dn \n(dl
.da a
def
.da
\n(dn \n(dl
EOF
# outputs
cat 1>&2 <<'EOF'
12 30
12 30
EOF
}

test25() {
cat <<'EOF'
.po 0
.nf
.da a
abc
.da a
def
.da a
ghi
.da
.da
.da
.a
EOF
# outputs
cat 1>&2 <<'EOF'
abc
EOF
}

test26() {
cat <<'EOF'
.po 0
.nf
.de a
abc
..
.da a
\n(dl def
.di
.da a
\n(dl ghi
.da
.a
EOF
# outputs
cat 1>&2 <<'EOF'
abc
0 def
50 ghi
EOF
}

test27() {
cat <<'EOF'
.po 0
.nf
.di a
1: \n(.d
2: \n(.d
3: \n(.d
.di
4: \n(.d
.a
EOF
# outputs
cat 1>&2 <<'EOF'
4: 0
1: 0
2: 12
3: 24
EOF
}

test28() {
cat <<'EOF'
.po 0
.nf
abc
\n(.n
abcabc
\n(.n
EOF
# outputs
cat 1>&2 <<'EOF'
abc
30
abcabc
60
EOF
}

test29() {
cat <<'EOF'
.po 0
.nf
.di a
abc
def
.di
.vs 24
.a
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
EOF
}

test30() {
cat <<'EOF'
.po 0
.nf
.as x abc
\*x
.as x def
\*x
EOF
# outputs
cat 1>&2 <<'EOF'
abc
abcdef
EOF
}

test31() {
cat <<'EOF'
.po 0
.de a
123
..
.nf
.wh 1 a
abc
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
123
def
EOF
}

test32() {
cat <<'EOF'
.po 0
.de a
123
..
.nf
.wh 1 a
.wh 3 a
abc
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
123
def
123
EOF
}

test33() {
cat <<'EOF'
.po 0
.de a
123
..
.wh 1 a
abc
.br
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
123 def
EOF
}

test34() {
cat <<'EOF'
.po 0
.nf
.di a
\n(.t
.di
.a
EOF
# outputs
cat 1>&2 <<'EOF'
2147483647
EOF
}

test35() {
cat <<'EOF'
.po 0
.nf
.de a
abc
..
.wh 1 a
.bp
.bp
\n%
EOF
# outputs
cat 1>&2 <<'EOF'

abc


abc

3
abc
EOF
}

test36() {
cat <<'EOF'
.po 0
abc
'sp
def
.br
ghi
EOF
# outputs
cat 1>&2 <<'EOF'

abc def
ghi
EOF
}

test37() {
cat <<'EOF'
.po 0
.nf
.de b
123
..
.di a
.dt 1 b
abc
def
.di
.a
EOF
# outputs
cat 1>&2 <<'EOF'
abc
123
def
EOF
}

test38() {
cat <<'EOF'
.po 0
.nf
.nr a 1+2
.nr b 1-(1+1)
.nr c 1+2*3
.nr d 1i+2v*3u
\na \nb \nc \nd
EOF
# outputs
cat 1>&2 <<'EOF'
3 -1 9 288
EOF
}

test39() {
cat <<'EOF'
.po 0
.nf
.if 1 abc
.if 0 def
.if 2-1 ghi
.if -1 jkl
.if e mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc
ghi
EOF
}

test40() {
cat <<'EOF'
.po 0
.nf
.if 'abc'abc' 1
.if !'abc'abc' 2
.if 'abc'ab' 3
.if !'abc'ab' 4
EOF
# outputs
cat 1>&2 <<'EOF'
1
4
EOF
}

test41() {
cat <<'EOF'
.po 0
.nf
.if 1 \{\
abc
.ie 0 \{\
def \}
.el \{\
ghi \}
\}
jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc
ghi

jkl
EOF
}

test42() {
cat <<'EOF'
.po 0
.nf
\w'abc'
\n(ct
EOF
# outputs
cat 1>&2 <<'EOF'
30
2
EOF
}

test43() {
cat <<'EOF'
.po 0
.nf
1 \n(.z
.di ab
2 \n(.z
.di
3 \n(.z
.ab
EOF
# outputs
cat 1>&2 <<'EOF'
1
3
2 ab
EOF
}

test44() {
cat <<'EOF'
.po 0
.nf
\n(.kabc\n(.kdef\n(.k
\n(.k
EOF
# outputs
cat 1>&2 <<'EOF'
0abc40def90
0
EOF
}

test45() {
cat <<'EOF'
.po 0
.nf
.sp |2
abc
.sp |1
def
EOF
# outputs
cat 1>&2 <<'EOF'

def
abc
EOF
}

test46() {
cat <<'EOF'
.po 0
.nf
abc\v'1'def\v'-1'ghi

abc\h'1'def\h'-1'ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc   ghi
   def
abc deghi
EOF
}

test47() {
cat <<'EOF'
.po 0
abc
.ti 2
def
'ti 4
ghi
.br
jkl
.br
mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc
  def ghi
    jkl
mno
EOF
}

test48() {
cat <<'EOF'
.po 0
.ll 7
.cp 1
.nf
.ad l
abc
.ad c
def
.ad r
ghi
.ad b
jkl

.fi
.ad l
abc
.br
.ad c
def
.br
.ad r
ghi
.br
.ad b
jkl mno
.br
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi
jkl

abc
  def
    ghi
jkl mno
EOF
}

test49() {
cat <<'EOF'
.po 0
.nf
abc
.vs 24
def
.vs
ghi
.in 2
jkl
.in
mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc

def
ghi
  jkl
mno
EOF
}

test50() {
cat <<'EOF'
.po 0
.de a
123
..
.wh 3 a
abc
.ne
def
.ne 3
ghi
.sp 3
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi


123
EOF
}

test51() {
cat <<'EOF'
.po 0
.de a
123
..
.wh 3 a
abc
.ne 4
def
EOF
# outputs
cat 1>&2 <<'EOF'



abc 123 def
EOF
}

test52() {
cat <<'EOF'
.po 0
.nf
abc \D'l 2 2'\D'l2 -2' def

ghi \D'c 2' jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc      def

ghi    jkl
EOF
}

test53() {
cat <<'EOF'
.po 0
.nf
.ig
abc
..
def
.ig xy
ghi
.xy
jkl
EOF
# outputs
cat 1>&2 <<'EOF'
def
jkl
EOF
}

test54() {
cat <<'EOF'
.po 0
.nf
.nr x 1
.nr y 3 2
\nx
\n+x
\ny
\n+y
\n-y
EOF
# outputs
cat 1>&2 <<'EOF'
1
1
3
5
3
EOF
}

test55() {
cat <<'EOF'
.po 0
.nr a \n%
.nf
\n%
\na
EOF
# outputs
cat 1>&2 <<'EOF'
1
0
EOF
}

test56() {
cat <<'EOF'
.po 0
.nf
123
456
.rt -5
abc
EOF
# outputs
cat 1>&2 <<'EOF'
123
456
abc
EOF
}

test57() {
cat <<'EOF'
.po 0
.nf
.mk x
.sp
.mk
.sp
.mk y
.sp
abc
.rt +2
def
.rt 2
ghi
.rt
jkl
.sp 4
\nx \ny
EOF
# outputs
cat 1>&2 <<'EOF'

jkl
ghi
abc
def

0 24
EOF
}

test58() {
cat <<'EOF'
.po 0
.de a
123
..
.wh 2 a
.nf
abc
def \x'1'\x'-2'ghi
jkl
mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc


def ghi

123
jkl
mno
EOF
}

test59() {
cat <<'EOF'
.po 0
.nf
abc \n(.a
de\x'1'\x'-2'f \n(.a
ghi \n(.a
jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc 0


def 0

ghi 12
jkl
EOF
}

test60() {
cat <<'EOF'
.po 0
.nf
abc \n(.h
def \n(.h
.in 2
.sp |0
ghi \n(.h
jkl \n(.h
EOF
# outputs
cat 1>&2 <<'EOF'
abghi 24
dejkl224
EOF
}

test61() {
cat <<'EOF'
.po 0
\kxabc\kydef\kz
\nx \ny \nz
\kxabc\kydef\kz
\nx \ny \nz
EOF
# outputs
cat 1>&2 <<'EOF'
abcdef 0 30 60 abcdef 0 30 60
EOF
}

test62() {
cat <<'EOF'
.po 0
.nf
.de a
123
..
.wh 3 a
abc
.sv 3
def
ghi
.os
jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi
123



jkl
EOF
}

test63() {
cat <<'EOF'
.po 0
.nf
abc
.ns
.sp

.bp
def
.sp
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def

ghi
EOF
}

test64() {
cat <<'EOF'
.po 0
.nf
.ls 2
abc
.ls
def
ghi

.de a
123
..
.wh \n(.du+3v a
.ls 2
jkl
mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc

def
ghi

jkl

mno
123
EOF
}

test65() {
cat <<'EOF'
.po 0
.nf
.ll \w'abc def'u
.de a
.if 1 123
..
.wh 1 a
abc def ghi jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi jkl
123
EOF
}

test66() {
cat <<'EOF'
.po 0
.nf

abc\udef\dghi\rjkl mno\0pqr\^stu\|\d\dvwx
.br
EOF
# outputs
cat 1>&2 <<'EOF'
   def   jkl mno pqrstu
abc   ghi              vwx
EOF
}

test67() {
cat <<'EOF'
.po 0
.de a
123
.br
..
.wh 1 a
.wh 2 a
.wh 3 a
abc def ghi jkl
.sp
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi jkl
123
123
123
def
EOF
}

test68() {
cat <<'EOF'
.po 0
.de a
123
.bp
..
.wh 1 a
.wh 2 a
.wh 3 a
abc
.sp
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
123
123
123

def
123
123
123
EOF
}

test69() {
cat <<'EOF'
.po 0
.nf
.de a
123
456
.bp
..
.wh 1 a
abc
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
123
456

def
123
456


123
456
EOF
}

test70() {
cat <<'EOF'
.po 0
.nr x 1 1
.de a
123 \\n%
.bp \\n+x
..
.wh 1 a
.wh 2 a
.wh 3 a
abc
EOF
# outputs
cat 1>&2 <<'EOF'
abc
123 1
123 1
123 1
EOF
}

test71() {
cat <<'EOF'
.po 0
abc\l'2'def\L'2'ghi
.sp 2
abc\l'-2'def\L'2'ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc__def

        ghi
a__def

      ghi
EOF
}

test72() {
cat <<'EOF'
.po 0
.nf
.de a
\\n(.$
..
.a
.a a
.a a b c
EOF
# outputs
cat 1>&2 <<'EOF'
0
1
3
EOF
}

test73() {
cat <<'EOF'
.po 0
.nf
.nr a \w'a'
.de b
.nr b \w'a'
..
\na
.ps 20
.b
\na \nb
EOF
# outputs
cat 1>&2 <<'EOF'
10
1 0   2 0
EOF
}

test74() {
cat <<'EOF'
.po 0
.sp 0
.nf
.de b
.ps 20
.nr b \\$1
..
.ps 40
.b \w'a'
\nb
EOF
# outputs
cat 1>&2 <<'EOF'
2 0
EOF
}

test75() {
cat <<'EOF'
.po 0
.de a
123
..
.wh 0 a
abc
EOF
# outputs
cat 1>&2 <<'EOF'
123 abc
EOF
}

test76() {
cat <<'EOF'
.po 0
.de a
..
.wh 0 a
.pl 3
abc
.sp
def
.sp
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc

def

ghi
EOF
}

test77() {
cat <<'EOF'
.po 0
.di x
.in 4
.ti 2
abc
def
.br
.nf
.di
.x
.in
.x
.ti 3
.x
EOF
# outputs
cat 1>&2 <<'EOF'
      abc def
  abc def
     abc def
EOF
}

test78() {
cat <<'EOF'
.po 0
.nf
.de x
.ie x\\$1xabcx yes
.el no
..
.x abc
.x def
EOF
# outputs
cat 1>&2 <<'EOF'
yes
no
EOF
}

test79() {
cat <<'EOF'
.po 0
.ll .5i
.ad b
.ce 3
abc
def ghi jkl mno pqr stu
vwx yz
123 456 789 
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def ghi jkl mno pqr stu
vwx yz
123
456
789
EOF
}

test80() {
cat <<'EOF'
.po 0
.nf
abc
.ex
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
EOF
}

test81() {
cat <<'EOF'
.po 0
.nf
abc
.nx 81.ms
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
EOF
}

test82() {
cat <<'EOF'
.po 0
.nf
abc
.ti 2i
.in 1i
def
.ti .5i
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc
       def
   ghi
EOF
}

test83() {
cat <<'EOF'
.po 0
abc\c
'sp
def
.nf
ghi\c
'sp
jkl
EOF
# outputs
cat 1>&2 <<'EOF'

abcdef

ghijkl
EOF
}

test84() {
cat <<'EOF'
.po 0
.lt 19
.nf
abc
.tl 'ghi'jkl'mno'
def
.tl @pqr@-%-@stu@
.pc z
.tl 'zzz'%%%'zzz'
EOF
# outputs
cat 1>&2 <<'EOF'
abc
ghi     jkl     mno
def
pqr     -1-     stu
111     %%%     111
EOF
}

test85() {
cat <<'EOF'
.po 0
.nf
.lt 15
.tl \Kabc\Kdef\Kghi\K
\w\(ts123\(ts
EOF
# outputs
cat 1>&2 <<'EOF'
abc   def   ghi
30
EOF
}

test86() {
cat <<'EOF'
.po 0
.nf
\w'' - \n(ct \n(sb \n(st
\w'a' - \n(ct \n(sb \n(st
\w'\ua\d' - \n(ct \n(sb \n(st
\w'a\db\uc' - \n(ct \n(sb \n(st
EOF
# outputs
cat 1>&2 <<'EOF'
0 - 0 0 0
10 - 0 0 10
10 - 0 0 15
30 - 2 -5 10
EOF
}

test87() {
cat <<'EOF'
.po 0
.if 0 .if 1 \{\
abc
def
\}
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
ghi
EOF
}

test88() {
cat <<'EOF'
.po 0
.de a
\\$1
..
.if 1 \{\
.	a abc
.	if 1 .if 0 \{\
.		a def\}
.	a ghi\}
.a jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc ghi jkl
EOF
}

test89() {
cat <<'EOF'
.po 0
abc
.sp 0
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
EOF
}

test90() {
cat <<'EOF'
.po 0
\l\(ts5\(ul\(ts
EOF
# outputs
cat 1>&2 <<'EOF'
_____
EOF
}

test91() {
cat <<'EOF'
.po 0
.ta 4 8 12
abc	def	ghi
.br
.ll 12
abc	def	ghi jkl mno
.nf
.ta 5 10 15
abc	def	ghi
abc\w'def	ghi'
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi
abc def ghi
jkl mno
abc  def  ghi
abc80
EOF
}

test92() {
cat <<'EOF'
.po 0
.nf
.ta 19
.fc # ^
#abc#
#abc^def#
#abc^def^ghi#
#abc^def^ghi^jkl#
.ta 4
#abc^def#
EOF
# outputs
cat 1>&2 <<'EOF'
abc
abc             def
abc     def     ghi
abc  def  ghi   jkl
adef
EOF
}

test93() {
cat <<'EOF'
.po 0
.de x
.ev 1
.bp
.ev
..
.wh 2 x
.ll 21
.sp
abc  def  ghi  jkl  mno  pqr
EOF
# outputs
cat 1>&2 <<'EOF'

abc   def   ghi   jkl

mno  pqr
EOF
}

test94() {
cat <<'EOF'
.po 0
abc
\&  def
EOF
# outputs
cat 1>&2 <<'EOF'
abc   def
EOF
}

test95() {
cat <<'EOF'
.po 0
.de x
123

456
..
.wh 2 x
.ll 18
.sp
abc  def  ghi  jkl  mno  pqr
EOF
# outputs
cat 1>&2 <<'EOF'

abc  def  ghi  jkl
mno 123

456  pqr
EOF
}

test96() {
cat <<'EOF'
.po 0
.ll 4.1m
.br
abc def ghi jkl
.sp
abcdef g-hij-kl
.sp
abc\%def g\%hij\%kl
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi
jkl

abcdef
g-
hij-
kl

abc-
def
g-
hij-
kl
EOF
}

test97() {
cat <<'EOF'
.po 0
.hw ab-c xyz-uvw
.ll 4.1m
.br
abc xyzuvw
.sp
EOF
# outputs
cat 1>&2 <<'EOF'
abc
xyz-
uvw
EOF
}

test98() {
cat <<'EOF'
.po 0
.ll 4.1m
.br
abcdefg-h\%ijkl
.sp
EOF
# outputs
cat 1>&2 <<'EOF'
abcdefg-
h-
ijkl
EOF
}

test99() {
cat <<'EOF'
.po 0
.hw abc-def-ghi-jkl
.ll 4.1m
.br
abcdefghijkl
.sp
EOF
# outputs
cat 1>&2 <<'EOF'
abc-
def-
ghi-
jkl
EOF
}

test100() {
cat <<'EOF'
.po 0
.\"hw hy-phen-ation ma-trix
.ll 5.4m
.br
abc def hyphenation
.sp
jkl mno matrix
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
hy-
phen-
ation

jkl
mno
ma-
trix
EOF
}

test101() {
cat <<'EOF'
.po 0
.ll 5m
aaaaaaaaaaaaaaaa
.br
abc def
EOF
# outputs
cat 1>&2 <<'EOF'
aaaaaaaaaaaaaaaa
abc
def
EOF
}

test102() {
cat <<'EOF'
.po 0
.ll \w'abc def'u
abc def
.br
abc def
EOF
# outputs
cat 1>&2 <<'EOF'
abc def
abc def
EOF
}

test103() {
cat <<'EOF'
.po 0
.nf
.di x
abc
d\x'-1'ef
ghi
.di
.x
EOF
# outputs
cat 1>&2 <<'EOF'
abc

def
ghi
EOF
}

test104() {
cat <<'EOF'
.po 0
.ll 4m
abc def aaaaaaaaaaaaa jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
aaaaaaaaaaaaa
jkl
EOF
}

test105() {
cat <<'EOF'
.po 0
.hw abc-def
.ll \w'000 abcde'u
000 abcdefs
EOF
# outputs
cat 1>&2 <<'EOF'
000  abc-
defs
EOF
}

test106() {
cat <<'EOF'
.po 0
.nf
.de x
123
..
.pl 3
.wh -2 x
.pl 5
abc
def
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi
123
EOF
}

test107() {
cat <<'EOF'
.po 0
EOF
# outputs
cat 1>&2 <<'EOF'
EOF
}

test108() {
cat <<'EOF'
.po 0
.nf
.de a
123
..
.de b
456
..
.em a
.wh 2 b
EOF
# outputs
cat 1>&2 <<'EOF'
123

456
EOF
}

test109() {
cat <<'EOF'
.po 0
." \n(yr \n(mo \n(dy \n(dw
EOF
# outputs
cat 1>&2 <<'EOF'
EOF
}

test110() {
cat <<'EOF'
.po 0
.nf
.de a
.if \\$1=1	\{
\\$1
\}
..
.a 0
.a 1
.a 2
EOF
# outputs
cat 1>&2 <<'EOF'

1
EOF
}

test111() {
cat <<'EOF'
.ll 20m
.po 0
abc de\pf ghi
jkl mno
.ce
123 4\p56 789
abc def
EOF
# outputs
cat 1>&2 <<'EOF'
abc              def
ghi jkl mno
    123 456 789
abc def
EOF
}

test112() {
cat <<'EOF'
.po 0
.nf
abc
\zd
efg
EOF
# outputs
cat 1>&2 <<'EOF'
abc
d
efg
EOF
}

test113() {
cat <<'EOF'
.po 0
.nf
.nr a 0
.nr b -173
.nr c 39999
.af a 0000000
.af b 0000000
.af c 0000000
\ga \gb \gc
\na \nb \nc

.nr a 0
.nr b -173
.nr c 39999
.af a a
.af b A
.af c a
\ga \gb \gc
\na \nb \nc

.nr a 0
.nr b -173
.nr c 39999
.af a I
.af b i
.af c I
\ga \gb \gc
\na \nb \nc
EOF
# outputs
cat 1>&2 <<'EOF'
0000000 0000000 0000000
0000000 -0000173 0039999

a A a
0 -MH bgdk

I i I
0 -dxix ZZZMZCMXCIX
EOF
}

test114() {
cat <<'EOF'
.po 0
.nf
.ss 24
abc def
ghi jkl
mno pqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc  def
ghi  jkl
mno  pqr
EOF
}

test115() {
cat <<'EOF'
.po 0
.nf
.bd R 11
abc def
ghi jkl
EOF
# outputs
cat 1>&2 <<'EOF'
aabbcc  ddeeff
gghhii  jjkkll
EOF
}

test116() {
cat <<'EOF'
.po 0
.nf
.cs R 72
abc def
ghi jkl
EOF
# outputs
cat 1>&2 <<'EOF'
a b c   d e f
g h i   j k l
EOF
}

test117() {
cat <<'EOF'
.po 0
.nf
abc
.nx
def
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc
EOF
}

test118() {
cat <<'EOF'
.po 0
.nf
.nm 1 2 2 3
abc
.ti 2
def
.nn 1
ghi
klm

.nm
mno
.nm +0
pqr
EOF
# outputs
cat 1>&2 <<'EOF'
        abc
     2    def
        ghi
        klm

mno
     4  pqr
EOF
}

test119() {
cat <<'EOF'
.po 0
.nf
.de x
123
..
.it 2 x
abc
def
ghi
jkl
.it 1 x
mno
pqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
123
ghi
jkl
mno
123
pqr
EOF
}

test120() {
cat <<'EOF'
.po 0
.nf
.mc \(bu
abc
.ti 1
def
.ll 2
ghi jkl
mno pqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc
 def
ghi jkl
mno pqr
EOF
}

test121() {
cat <<'EOF'
.po 0
abc def.
ghi.  jkl
mno.
pqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc def.  ghi.  jkl mno.  pqr
EOF
}

test122() {
cat <<'EOF'
.po 0
.nf
.ta 3 6 9
a	b	c	d
abcd
.tc -
.lc *
a	b	c	d
abcd
EOF
# outputs
cat 1>&2 <<'EOF'
a  b  c  d
a..b..c..d
a--b--c--d
a**b**c**d
EOF
}

test123() {
cat <<'EOF'
.po 0
.nf
.ta 6 12R 18C
abc	def	ghi	jkl
.tc -
.ta 4mR 8mL 14mC
abcdef	123456	ghijkl	mnopqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc   defghi    jkl
abcdef--123456ghijklmnopqr
EOF
}

test124() {
cat <<'EOF'
.po 0
.sp
abc\v'-24p/2u'def
EOF
# outputs
cat 1>&2 <<'EOF'
   def
abc
EOF
}

test125() {
cat <<'EOF'
.po 0
.nf
.tr bBeEhHkK
abc def ghi jkl
.tr bbeehhkk
abc def ghi jkl
EOF
# outputs
cat 1>&2 <<'EOF'
aBc dEf gHi jKl
abc def ghi jkl
EOF
}

test126() {
cat <<'EOF'
.po 0
.ps 20
.vs 24
.ll 10
.hystop -
abcde\%fghijkl-mnopqr
EOF
# outputs
cat 1>&2 <<'EOF'

a b c d e -

f g h i j k l -

m n o p q r
EOF
}

test127() {
cat <<'EOF'
.po 0
.ll 3m
.hc ő
abcdefőghijklőmno
.hc \(xy
abcdef\(xyghijkl\(xymno
EOF
# outputs
cat 1>&2 <<'EOF'
abcde-
f-
ghi-
jkl-
mno
abcde-
f-
ghi-
jkl-
mno
EOF
}

test128() {
cat <<'EOF'
.po 0
.nf
.ll 10
.mc |
abc def
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc def    |
ghi        |
EOF
}

test129() {
cat <<'EOF'
.po 0
.nf
.ll 10
.mc |
.ta 1i 2i
.fc ő ű
őabcűdefő
EOF
# outputs
cat 1>&2 <<'EOF'
abc def    |
EOF
}

test130() {
cat <<'EOF'
.po 0
.nf
.di x
nofill
.di
.x
EOF
# outputs
cat 1>&2 <<'EOF'
nofill
EOF
}

test131() {
cat <<'EOF'
.po 0
.ls 3
.de x
123
..
.wh 3 x
abc
.sp 4
def
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc


123 def ghi
EOF
}

test132() {
cat <<'EOF'
.po 0
.hy 3
.ll 7m
.pl 1
hyphenation hyphenation
EOF
# outputs
cat 1>&2 <<'EOF'
hyphen-

ation

hyphen-

ation
EOF
}

test133() {
cat <<'EOF'
.po 0
.ll \w're-'u
.hy 1
remove
.sp
.hy 9
remove
EOF
# outputs
cat 1>&2 <<'EOF'
re-
move

remove
EOF
}

test134() {
cat <<'EOF'
.po 0
.ll \w'final-'u
.hy 1
hally
.sp
.hy 5
hally
EOF
# outputs
cat 1>&2 <<'EOF'
hally

hally
EOF
}

test135() {
cat <<'EOF'
.po 0
.nf
.di x
.in 4
abc def
.in 0
ghi jkl
.di
\n(dl
EOF
# outputs
cat 1>&2 <<'EOF'
110
EOF
}

test136() {
cat <<'EOF'
.po 0
.ll \w'hal-'u
.hy 1
hally...
.sp
.hy 5
hally...
EOF
# outputs
cat 1>&2 <<'EOF'
hal-
ly...

hally...
EOF
}

test137() {
cat <<'EOF'
.po 0
.hy 1
.ll \w'\(mo-'u
\(mobile
EOF
# outputs
cat 1>&2 <<'EOF'
bile
EOF
}

test138() {
cat <<'EOF'
.po 0
\s(20f\s0ind
\fRf\fPind
EOF
# outputs
cat 1>&2 <<'EOF'
f ind find
EOF
}

test139() {
cat <<'EOF'
.po 0
a\Tb
EOF
# outputs
cat 1>&2 <<'EOF'
aTb
EOF
}

test140() {
cat <<'EOF'
.po 0
.ds a "This is b.
.ds b "And a more.
\fR\*a
\fR\*b
EOF
# outputs
cat 1>&2 <<'EOF'
This is b.  And a more.
EOF
}

test141() {
cat <<'EOF'
.po 0
.ll \w`abc def`u
.in \w`abc`u
.ti 0
abc def ghi jkl mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc def
   ghi
   jkl
   mno
EOF
}

test142() {
cat <<'EOF'
.po 0
.ll 0
abc def ghi jkl
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi
jkl
EOF
}

test143() {
cat <<'EOF'
.po 0
.hw hyphen-ation
.hy 3
.ll \w'hyphenation hyphen-'u
.pl 2
hyphenation hyphenation
hyphenation hyphenation
hyphenation hyphenation
EOF
# outputs
cat 1>&2 <<'EOF'
hyphenation hyphen-
ation   hyphenation

hyphenation hyphen-
ation hyphenation
EOF
}

test144() {
cat <<'EOF'
.po 0
.pl 2
.de x
..
.wh 1.5 x
.ll \w'a  b c'u
.sp
.ti \w' 'u
a b c a b c a b c
EOF
# outputs
cat 1>&2 <<'EOF'

 a b c

a b  c
a b c
EOF
}

test145() {
cat <<'EOF'
.po 0
.pl 2
.de x
..
.wh 1.5 x
.ll \w'a  b c'u
.sp
.ti \w' 'u
a b c a  b c a b c
EOF
# outputs
cat 1>&2 <<'EOF'

 a b c

a  b c
a b c
EOF
}

test146() {
cat <<'EOF'
.po 0
.pl 2
.de x
a
..
.wh 1.5 x
.ne 2
EOF
# outputs
cat 1>&2 <<'EOF'

a
EOF
}

test147() {
cat <<'EOF'
.po 0
.nf
.pl 2
.de x
a
..
.wh 1.5 x
abc
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def


a
EOF
}

test148() {
cat <<'EOF'
.po 0
.de x
.sp 2
..
.wh 3 x
.ne 4
\n(.d
.br
EOF
# outputs
cat 1>&2 <<'EOF'
0
EOF
}

test149() {
cat <<'EOF'
.po 0
.pl 2
.de x
a
..
.wh 1.5 x
.sp 1
EOF
# outputs
cat 1>&2 <<'EOF'

a
EOF
}

test150() {
cat <<'EOF'
.po 0
.pl 2
.de x
z
..
.wh 1 x
.ll \w'a  b c'u
.sp
.ti \w' 'u
a b c a  b c a b c
EOF
# outputs
cat 1>&2 <<'EOF'

z

 a b c
a z  b

c a  b
c z
EOF
}

test151() {
cat <<'EOF'
.po 0
.ft R
.di x
.ds s x\ety
w\*sz
.br
.di
.nf
.x
EOF
# outputs
cat 1>&2 <<'EOF'
wx\tyz
EOF
}

test152() {
cat <<'EOF'
.po 0
abc\c
.ev 1
def
.br
.ev
ghi
EOF
# outputs
cat 1>&2 <<'EOF'
def
abcghi
EOF
}

test153() {
cat <<'EOF'
.po 0
.wh 0 TM
.pl 6
.ll 20
.wh -1 BM
.ad b
.de TM
'sp 1
..
.de BM
'bp
..
.ds X "Thomas Bernhard experiments with whole paragraph text formatting.
.de Y
\*X
\*X
..
.de Z
\*Y
..
\*Z
EOF
# outputs
cat 1>&2 <<'EOF'

Thomas Bernhard  ex-
periments with whole
paragraph text  for-
matting.      Thomas


Bernhard experiments
with whole paragraph
text formatting.

EOF
}

test154() {
cat <<'EOF'
.po 0
.ll 20
.pl 6
.wh 0 TM
.wh -1 BM
.ad b
.de TM
'sp 1
..
.de BM
'bp
..
.ds X "Thomas Bernhard experiments with whole paragraph text formatting.
.ds Y "\*X \*X
.ds Z "\*Y
\*Z
EOF
# outputs
cat 1>&2 <<'EOF'

Thomas Bernhard  ex-
periments with whole
paragraph text  for-
matting.      Thomas


Bernhard experiments
with whole paragraph
text formatting.
EOF
}

test155() {
cat <<'EOF'
.po 0
.de X
abc def ghi
..
.de Z
\*X
..
\*Z
\*Z
\*Z
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi


abc def ghi


abc def ghi
EOF
}

test156() {
cat <<'EOF'
.po 0
.nf
.ta 6cR
left	right
left aligned	right aligned
.br
left	right
EOF
# outputs
cat 1>&2 <<'EOF'
left        right
leftrightnaligned
left        right
EOF
}

test157() {
cat <<'EOF'
.po 0
.ll 5m
abc \fIdef\fP ghi jkl mno pqr sru
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi
jkl
mno
pqr
sru
EOF
}

test158() {
cat <<'EOF'
.po 0
ab
.tl
cd
EOF
# outputs
cat 1>&2 <<'EOF'

ab cd
EOF
}

test159() {
cat <<'EOF'
.po 0
.cp 1
abc
.ie 1\{\
def
ghi\}
.el\{\
jkl
mno\}
pqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi pqr
EOF
}

test160() {
cat <<'EOF'
.po 0
.cp 1
abc
.ie 1\{\
def
ghi\}
.el\{\
jkl
mno\}
pqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc def ghi pqr
EOF
}

test161() {
cat <<'EOF'
.po 0
.nf
abc
.ev 1
.nf
def
.ev	\{ \"something more
.nf
ghi
.\}
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
ghi
EOF
}

test162() {
cat <<'EOF'
.po 0
\ga \gb
\ga \gb
\na \ga
.nr b 1
\gb
EOF
# outputs
cat 1>&2 <<'EOF'


0 0 0
EOF
}

test163() {
cat <<'EOF'
.nf
.cs R 36 10
abc def
.ps 20
ghi jkl
EOF
# outputs
cat 1>&2 <<'EOF'
       abc def
      ghi jkl
EOF
}

test164() {
cat <<'EOF'
.po 0
.nf
.de x
abc
..
.wh 1 x
.sp
.ch x
.bp
EOF
# outputs
cat 1>&2 <<'EOF'

abc

EOF
}

test165() {
cat <<'EOF'
.po 0
.ds y abc
\*y
.rn x y
\*y
EOF
# outputs
cat 1>&2 <<'EOF'
abc abc
EOF
}

test166() {
cat <<'EOF'
.po 0
.cc @
@sp 2
abc
.def
@cc
.sp 2
@ghi
jkl
EOF
# outputs
cat 1>&2 <<'EOF'


abc .def


@ghi jkl
EOF
}

test167() {
cat <<'EOF'
.po 0
.if 1 \{ .ds x "a
.\}
\*x
EOF
# outputs
cat 1>&2 <<'EOF'
a
EOF
}

test168() {
cat <<'EOF'
.po 0
.if 1 \{ .ds x "a
.\}
\*x
EOF
# outputs
cat 1>&2 <<'EOF'
a
EOF
}

test169() {
cat <<'EOF'
.po 0
.nf
\s20abc\s0
\s+20def\s0
EOF
# outputs
cat 1>&2 <<'EOF'
c
0def
EOF
}

test170() {
cat <<'EOF'
.po 0
abc\c
.br
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
EOF
}

test171() {
cat <<'EOF'
.po 0
.de X
abc
..
.wh 0 X
.fl
EOF
# outputs
cat 1>&2 <<'EOF'
abc
EOF
}

test172() {
cat <<'EOF'
.po 0
.nf
\n%
.nr % 3
.bp
\n%
.pn 6
.bp
\n%
.pn 6
.nr % 9
.bp
\n%
EOF
# outputs
cat 1>&2 <<'EOF'
1

4

6

6
EOF
}

test173() {
cat <<'EOF'
.po 0
.\" .ns should not inhibit .sp requests inside diversions
.di oZ
def
.br
.di
abc
.sp 1
.ns
.nf
.oZ
EOF
# outputs
cat 1>&2 <<'EOF'
abc

def
EOF
}

test174() {
cat <<'EOF'
.po 0
.de X
abc
..
.wh 0 X
.ll \w'abc def'u
def ghi
EOF
# outputs
cat 1>&2 <<'EOF'
abc def
ghi
EOF
}

test175() {
cat <<'EOF'
.po 0
.R \\x 2
abc\n(\\xdef
EOF
# outputs
cat 1>&2 <<'EOF'
abc0def
EOF
}

test176() {
cat <<'EOF'
.po 0
.nf
.de X
.bp
..
.wh 3 X
.pl 5
abc
.ns
.ne 3
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc

def
EOF
}

test177() {
cat <<'EOF'
.po 0
.nf
.sp 2
.ns
.rt 1
.sp
abc
EOF
# outputs
cat 1>&2 <<'EOF'


abc
EOF
}

test178() {
cat <<'EOF'
.po 0
.ns

\X'-1'abc

def
EOF
# outputs
cat 1>&2 <<'EOF'
abc

def
EOF
}

test179() {
cat <<'EOF'
.po 0
.nf
.de A
abc
..
.de B A
def
.A
ghi
.B
EOF
# outputs
cat 1>&2 <<'EOF'
abc
ghi
def
EOF
}

test180() {
cat <<'EOF'
.po 0
.nf
.di X
\!.sp 2
.di
abc
.X
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc


def
EOF
}

test181() {
cat <<'EOF'
.po 0
.nf
.di X
x\!.sp 2
.di
abc
.X
def
EOF
# outputs
cat 1>&2 <<'EOF'
abc
x.sp 2
def
EOF
}

test182() {
cat <<'EOF'
.po 0
.nf
.di X
abc
.br
.di
.di Y
\!.sp
def
\!.sp
.X
\!.sp
ghi
.br
.di
.Y
EOF
# outputs
cat 1>&2 <<'EOF'

def

abc

ghi
EOF
}

test183() {
cat <<'EOF'
.po 0
.nf
.di X
abc
\!.if 1 def
jkl
.di
.X
EOF
# outputs
cat 1>&2 <<'EOF'
abc
def
jkl
EOF
}

test184() {
cat <<'EOF'
.po 0
.nf
.di x
abc
.sp -1
def
.di
.x
EOF
# outputs
cat 1>&2 <<'EOF'
def
EOF
}

test185() {
cat <<'EOF'
.po 0
.nf
.sp
abc
.sp -5
def
EOF
# outputs
cat 1>&2 <<'EOF'
def
abc
EOF
}

test186() {
cat <<'EOF'
.po 0
.nf
.di x
.sp
abc
.sp -2
def
.di
.sp 4
.x
EOF
# outputs
cat 1>&2 <<'EOF'




def
abc
EOF
}

test187() {
cat <<'EOF'
.po 0
.hw hyphen-ation
.ll 10m
abc def hyphenation\p ghi jkl mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc    def
hyphen-
ation
ghi    jkl
mno
EOF
}

test188() {
cat <<'EOF'
.po 0
.lt 20
.tl 'one't\%o'three'
EOF
# outputs
cat 1>&2 <<'EOF'
one      to    three
EOF
}

test189() {
cat <<'EOF'
.po 0
.tl 20
.tl '%'x'\%'
.pc x
.tl '%'x'\%'
.pc
.tl '%'x'\%'
EOF
# outputs
cat 1>&2 <<'EOF'
0
1                     x
%                     1
%                     x
EOF
}

test190() {
cat <<'EOF'
.po 0
.hw hyphena-tion
.ll \w'hyphena\(hy'u
hyp\%henation
EOF
# outputs
cat 1>&2 <<'EOF'
hyp-
henation
EOF
}

test191() {
cat <<'EOF'
.po 0
.ta 4mR 6m
.nr c 0 1
.de it
.	br
.	ie \\n(.$ \t\\n+c.\t\\$1
.	el \t\\n+c.\t\c
..
text before
.it first
.it second
.it
third
.it last
EOF
# outputs
cat 1>&2 <<'EOF'
text before
  1.  first
  2.  second
  3.  third
  4.  last
EOF
}

test192() {
cat <<'EOF'
.po 0
.sp |1
1v
.sp |1
1v
EOF
# outputs
cat 1>&2 <<'EOF'

1v
EOF
}

test193() {
cat <<'EOF'
.po 0
.if ! abc
.if !  abc
EOF
# outputs
cat 1>&2 <<'EOF'
abc abc
EOF
}

test194() {
cat <<'EOF'
.po 0
.hpf ./bc.pat ./bc.hyp ./bc.chr
.ll 1n
something
abcdefghi
Something
rstuvwxyz
EOF
# outputs
cat 1>&2 <<'EOF'
somet-
hing
abcd-
efghi
Somet-
hing
rstuv-
wxyz
EOF
}

test195() {
cat <<'EOF'
.po 0
.hw ab-cd-ef-gh-ij-kl-mn-op-qr-st-uv-wx-yz
.hy 14
.ll 3m
.ti 1m
abcdefghijklmnopqrstuvwxyz
EOF
# outputs
cat 1>&2 <<'EOF'
 ab-
cd-
ef-
gh-
ij-
kl-
mn-
op-
qr-
st-
uv-
wx-
yz
EOF
}

test196() {
cat <<'EOF'
.po 0
.ad p
.ll \w'abc def-'u
abc def- ghi jkl mno
EOF
# outputs
cat 1>&2 <<'EOF'
abc def-
ghi  jkl
mno
EOF
}

test197() {
cat <<'EOF'
.po 0
.hy 0
.wh 1v x
.de x
.	ll \w'abc abc'u
..
.ad pb
.ll \w'abc'u
abc abc abc abc abc abc abc abc
EOF
# outputs
cat 1>&2 <<'EOF'
abc
abc
abc abc
abc abc
abc abc
EOF
}

test198() {
cat <<'EOF'
.po 0
.ll \w'abc def'u
abc def\c
ghi
jkl mno pqr
EOF
# outputs
cat 1>&2 <<'EOF'
abc
defghi
jkl mno
pqr
EOF
}

test199() {
cat <<'EOF'
.po 0
.\"xcmp -a2
.ad p
.pl 2
.de x
z
..
.wh 1 x
.ll \w'a  b c'u
.sp
.ti \w' 'u
a b c d  e f g h i
EOF
# outputs
cat 1>&2 <<'EOF'

z

 a b c
d  e z
f g  h
i
EOF
}

test200() {
cat <<'EOF'
.po 0
.nf
.nr x 1
.de xx
1 \\nx
\\$1
2 \\nx
..
0 \nx
.xx "\R'x 2'
3 \nx
EOF
# outputs
cat 1>&2 <<'EOF'
0 1
1 1

2 2
3 2
EOF
}

test201() {
cat <<'EOF'
.po 0
.de q
a\\$1b
..
.chop q
123 \*[q 456] 789
EOF
# outputs
cat 1>&2 <<'EOF'
123 a456b 789
EOF
}

test202() {
cat <<'EOF'
.po 0
.de min
\\?'\\$1<\\$2@\\$1@\\$2@'
..
.chop min
\*[min 20 10]
\*[min 10 20]
EOF
# outputs
cat 1>&2 <<'EOF'
10 10
EOF
}

test203() {
cat <<'EOF'
.po 0
.ll 8
.nf
.>>
ABCDEF
.<<
ABCDEF
.>>
AB\<CD\>EF
.<<
AB\<CD\>EF
.<<
AB\>CD\<EF
EOF
# outputs
cat 1>&2 <<'EOF'
ABCDEF
  FEDCBA
ABDCEF
  EFDCBA
  FECDBA
EOF
}

test204() {
cat <<'EOF'
.po 0
.nf
.fspecial R I
.fmap R b one
abc
.fmap R b ---
abc
.fmap R b
abc
EOF
# outputs
cat 1>&2 <<'EOF'
a1c
abc
abc
EOF
}

test205() {
cat <<'EOF'
.po 0
.de x
\\$1 \\$2
..
.x a\ c def
EOF
# outputs
cat 1>&2 <<'EOF'
a c def
EOF
}

test206() {
cat <<'EOF'
.po 0
.de X
abc
..
.wh 0 X
.bp
EOF
# outputs
cat 1>&2 <<'EOF'
abc

abc
EOF
}

testcase() {
	printf "$1: "
	$1 2>$TMPDIR/.rofftest.1 | $ROFF -F. | $PTXT -F. >$TMPDIR/.rofftest.2
	if ! cmp -s $TMPDIR/.rofftest.[12]; then
		printf "Failed\n"
		diff -u $TMPDIR/.rofftest.[12]
		exit 1
	fi
	printf "OK\n"
}

if test -n "$1"; then
	testcase test$1
	exit $?
fi

for t in $(seq 0 206); do
	testcase test$(printf %02d $t)
done
