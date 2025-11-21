# Neatroff template makefile
BASE = $(PWD)/..
ROFF = "$(BASE)/neatroff/roff"
POST = "$(BASE)/neatpost/post"
PPDF = "$(BASE)/neatpost/pdf"
EQN = "$(BASE)/neateqn/eqn"
REFR = "$(BASE)/neatrefer/refer"
PIC = "$(BASE)/troff/pic/pic"
TBL = "$(BASE)/troff/tbl/tbl"
SOIN = "$(BASE)/soin/soin"
SHAPE = "$(BASE)/shape/shape"

ROFFOPTS = "-F$(BASE)" "-M$(BASE)/tmac"
ROFFMACS = -mpost -mtbl -mkeep -mfa -msrefs
POSTOPTS = "-F$(BASE)" -pa4
REFROPTS = -m -e -o ct -p ref.bib

all: test.pdf fa.pdf

.SUFFIXES: .tr .ms .ps .pdf .PDF
.tr.ps:
	@echo "Generating $@"
	@cat $< | $(SHAPE) | $(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) | $(POST) $(POSTOPTS) >$@
.tr.PDF:
	@echo "Generating $@"
	@cat $< | $(SHAPE) | $(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) | $(PPDF) $(POSTOPTS) >$@

.ms.ps:
	@echo "Generating $@"
	@cat $< | $(SOIN) | $(REFR) $(REFROPTS) | $(SHAPE) | \
		$(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) $(ROFFMACS) | $(POST) $(POSTOPTS) >$@
.ms.PDF:
	@echo "Generating $@"
	@cat $< | $(SOIN) | $(REFR) $(REFROPTS) | $(SHAPE) | \
		$(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) $(ROFFOPTS) $(ROFFMACS) | $(PPDF) $(POSTOPTS) >$@

.ps.pdf:
	@echo "Generating $@"
	@ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true \
		"-sFONTPATH=$(BASE)/fonts/" "-sFONTMAP=$(BASE)/fonts/Fontmap" $< $@

clean:
	rm -f *.ps *.pdf *.PDF
