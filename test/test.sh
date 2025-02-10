#!/bin/sh

BASE="$(dirname $0)/.."
ROFF="$BASE/neatroff/roff"
PTXT="$BASE/neatpost/txt"

TMPDIR="/tmp"

test00() {
cat <<EOF
hello world
EOF
# outputs
cat 1>&2 <<EOF
       hello world
EOF
}

test01() {
cat <<EOF
hello
.ps 20
world
EOF
# outputs
cat 1>&2 <<EOF
       hello  w o r l d
EOF
}

test02() {
cat <<EOF
.po 0
.nf
hello
world
EOF
# outputs
cat 1>&2 <<EOF
hello
world
EOF
}

test03() {
cat <<EOF
.po 0
.nh
.ll 80u
hello
world
EOF
# outputs
cat 1>&2 <<EOF
hello
world
EOF
}

test04() {
cat <<EOF
.po 0
hello
.bp
world
EOF
# outputs
cat 1>&2 <<EOF
hello

world
EOF
}

test05() {
cat <<EOF
.po 0
.nr x 123
.nr 1 456
\n\nx
EOF
# outputs
cat 1>&2 <<EOF
45623
EOF
}

test06() {
cat <<EOF
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
cat 1>&2 <<EOF
72000 28346 12000 10000 5000 1000 1000 12000 1000
EOF
}

test07() {
cat <<EOF
.po 0
a \s+(10b\s-(10 \s(30c\s0.
EOF
# outputs
cat 1>&2 <<EOF
a b  c  .
EOF
}

test08() {
cat <<EOF
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
cat 1>&2 <<EOF
(abc def""ghi jkl")
( abc)
(abc)
EOF
}

test09() {
cat <<EOF
.po 0
.de a
abc def
..
\*aghi
EOF
# outputs
cat 1>&2 <<EOF
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
cat 1>&2 <<EOF
(abc) (def) ()
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

for t in test00 test01 test02 test03 test04 test05 test06 test07 test08 test09 \
	test10; do
	testcase $t
done
