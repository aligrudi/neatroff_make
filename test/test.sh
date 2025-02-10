#!/bin/sh

BASE="$(dirname $0)/.."
ROFF="$BASE/neatroff/roff"
PTXT="$BASE/neatpost/txt"

TMPDIR="/tmp"

test00() {
cat <<EOF
testing neatroff...
EOF

cat 1>&2 <<EOF
       testing neatroff...
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

for t in test00; do
	testcase $t
done
