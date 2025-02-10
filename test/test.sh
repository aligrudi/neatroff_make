#!/bin/sh

BASE="$(dirname $0)/.."
ROFF="$BASE/neatroff/roff"
PTXT="$BASE/neatpost/txt"

TMPDIR="/tmp"

test00() {
cat <<EOF
hello world
EOF

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

cat 1>&2 <<EOF
hello
world
EOF
}

test03() {
cat <<EOF
.po 0
.nh
.ll 800u
hello
world
EOF

cat 1>&2 <<EOF
hello
world
EOF
}

testcase() {
	printf "$1: "
	$1 2>$TMPDIR/.rofftest.2 | $ROFF -F. | $PTXT -F. >$TMPDIR/.rofftest.1
	if ! cmp -s $TMPDIR/.rofftest.[12]; then
		printf "Failed\n"
		diff -u $TMPDIR/.rofftest.[12]
		exit 1
	fi
	printf "OK\n"
}

for t in test00 test01 test02 test03; do
	testcase $t
done
