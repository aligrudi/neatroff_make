# Neatroff demonstration directory
BASE = $(PWD)/..
ROFF = $(BASE)/neatroff/roff
POST = $(BASE)/neatpost/post
PPDF = $(BASE)/neatpost/pdf
EQN = $(BASE)/neateqn/eqn
REFR = $(BASE)/neatrefer/refer
PIC = $(BASE)/troff/pic/pic
TBL = $(BASE)/troff/tbl/tbl
SOIN = $(BASE)/soin/soin

ROFFOPTS = -F$(BASE) -M$(BASE)/tmac -mpost -mtbl -mkeep -men -msrefs
POSTOPTS = -F$(BASE) -pa4
REFROPTS = -m -e -o ct -p ref.bib

all: test.pdf neatroff.pdf neateqn.pdf neatstart.pdf neatcc.pdf

%.ps: %.tr
	@echo "Generating $@"
	@cat $< | $(PIC) | $(TBL) | $(EQN) | $(ROFF) | $(POST) $(POSTOPTS) >$@

%.ps: %.ms
	@echo "Generating $@"
	@cat $< | $(SOIN) | \
		$(REFR) $(REFROPTS) | $(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) | $(POST) $(POSTOPTS) >$@

%.PDF: %.ms
	@echo "Generating $@"
	@cat $< | $(SOIN) | \
		$(REFR) $(REFROPTS) | $(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) | $(PPDF) $(POSTOPTS) >$@

%.pdf: %.ps
	@echo "Generating $@"
	@ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true \
		-sFONTPATH=$(BASE)/fonts/ -sFONTMAP=$(BASE)/fonts/Fontmap $< $@

clean:
	rm -f *.ps *.pdf
