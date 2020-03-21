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
SHAPE = $(BASE)/shape/shape

ROFFOPTS = -F$(BASE) -M$(BASE)/tmac -mps -meps -mtbl -mkeep -mfa -msrefs
POSTOPTS = -F$(BASE) -pa4
REFROPTS = -m -e -o ct -p ref.bib

all: test.pdf fa.pdf

%.ps: %.tr
	@echo "Generating $@"
	@cat $< | $(SHAPE) | $(PIC) | $(TBL) | $(EQN) | $(ROFF) | $(POST) $(POSTOPTS) >$@

%.ps: %.ms
	@echo "Generating $@"
	@cat $< | $(SOIN) | $(REFR) $(REFROPTS) | $(SHAPE) | \
		$(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) | $(POST) $(POSTOPTS) >$@

%.pdf: %.ps
	@echo "Generating $@"
	@ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true \
		-sFONTPATH=$(BASE)/fonts/ -sFONTMAP=$(BASE)/fonts/Fontmap $< $@

%.PDF: %.ms
	@echo "Generating $@"
	@cat $< | $(SOIN) | $(REFR) $(REFROPTS) | $(SHAPE) | \
		$(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) | $(PPDF) $(POSTOPTS) >$@

clean:
	rm -f *.ps *.pdf
