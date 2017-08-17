# Neatroff demonstration directory
BASE = $(PWD)/..
ROFF = $(BASE)/neatroff/roff
POST = $(BASE)/neatpost/post
EQN = $(BASE)/neateqn/eqn
REFER = $(BASE)/neatrefer/refer
PIC = $(BASE)/troff/pic/pic
TBL = $(BASE)/troff/tbl/tbl
SOIN = $(BASE)/soin/soin

all: test.pdf neatroff.pdf neateqn.pdf neatstart.pdf neatcc.pdf

%.ps: %.tr
	@echo "Generating $@"
	@cat $< | $(PIC) | $(TBL) | $(EQN) | $(ROFF) | $(POST) -pa4 >$@

%.ps: %.ms
	@echo "Generating $@"
	@cat $< | $(SOIN) | \
		$(REFER) -m -e -o ct -p ref.bib | $(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) -meps -mtbl -mkeep -men -msrefs | $(POST) -pa4 >$@

%.pdf: %.ps
	@echo "Generating $@"
	@ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sFONTPATH=$(BASE)/fonts/ $< $@

clean:
	rm -f *.ps *.pdf
