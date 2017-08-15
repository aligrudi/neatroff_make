#!/bin/sh
# Fetch fonts for setting up Neatroff

# urw-base35 URL
URWURL="http://downloads.ghostscript.com/public/fonts/urw-base35-20160926.zip"
# AMS fonts URL
AMSURL="ftp://ftp.ams.org/pub/tex/amsfonts.zip"

# HTTP retrieval program
HGET="wget -c -O"

# Ghostscript fonts
echo "Retrieving $URWURL"
$HGET urw-base35.zip $URWURL
unzip -q urw-base35.zip

# AMS and computer modern fonts
echo "Retrieving $AMSURL"
$HGET amsfonts.zip $AMSURL
unzip -q amsfonts.zip 'fonts/*'
for x in fonts/afm/public/amsfonts/cm/*.afm
do
	cp $x `basename $x .afm | tr a-z A-Z`.afm
done
for x in fonts/type1/public/amsfonts/cm/*.pfb
do
	mv $x `basename $x .pfb | tr a-z A-Z`.pfb
done
rm -r fonts/
