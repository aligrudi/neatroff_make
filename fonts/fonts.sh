#!/bin/sh
# Fetch fonts for setting up Neatroff

# urw-base35 URL
URWURL="https://github.com/ArtifexSoftware/urw-base35-fonts/archive/20200910.tar.gz"
# AMS fonts URL (main URL: https://www.ams.org/arc/tex/amsfonts.zip)
AMSURL="https://mirrors.ctan.org/install/fonts/amsfonts.tds.zip"

# HTTP retrieval program
HGET="wget -c --no-check-certificate -O"

# Ghostscript fonts
echo "Retrieving $URWURL"
$HGET urw-base35.tar.gz $URWURL
test -f urw-base35.tar.gz || exit 1
if tar xzf urw-base35.tar.gz; then
	mv urw-base35*/fonts/*.t1 .
	mv urw-base35*/fonts/*.afm .
	rm -r urw-base35*/
fi

# AMS and computer modern fonts
echo "Retrieving $AMSURL"
$HGET amsfonts.zip $AMSURL
test -f amsfonts.zip || exit 1
if unzip -q amsfonts.zip 'fonts/**'; then
	for x in fonts/afm/public/amsfonts/cm/*.afm; do
		cp $x `basename $x .afm | tr a-z A-Z`.afm
	done
	for x in fonts/type1/public/amsfonts/cm/*.pfb; do
		mv $x `basename $x .pfb | tr a-z A-Z`.pfb
	done
	rm -r fonts/
fi
