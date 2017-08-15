#!/bin/sh
# Fetch Farsi fonts for setting up Neatroff

# HTTP retrieval program
HGET="wget -c -O"

# IR fonts
#FONTURL_IR="http://scict.ir/Portal/File/ShowFile.aspx?ID=8964a122-b392-4261-9dd5-10c1938f0c8a"
FONTURL_IR="http://fs.rudi.ir/irfonts.tar.gz"
echo "Retrieving $FONTURL_IR"
$HGET irfonts.tar.gz $FONTURL_IR || exit 1
tar xzf irfonts.tar.gz && mv irfonts/*.ttf . && rm -r irfonts/
# B fonts
#FONTURL_B="http://bayanbox.ir/domain/irfont.ir/Fonts/BFonts.zip?download"
FONTURL_B="http://fs.rudi.ir/bfonts.tar.gz"
echo "Retrieving $FONTURL_B"
$HGET bfonts.tar.gz $FONTURL_B || exit 1
tar xzf bfonts.tar.gz && mv bfonts/*.ttf . && rm -r bfonts/
