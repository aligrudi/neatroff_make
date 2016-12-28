# Neatroff demonstration directory
BASE = $(PWD)/..
ROFF = $(BASE)/neatroff/roff
POST = $(BASE)/neatpost/post
EQN = $(BASE)/neateqn/eqn
REFER = $(BASE)/neatrefer/refer
PIC = $(BASE)/troff/pic/pic
TBL = $(BASE)/troff/tbl/tbl
SOIN = $(BASE)/soin/soin
JOIN = $(BASE)/roffjoin/roffjoin
SHAPE = $(BASE)/shape/shape

all: test.pdf fa.pdf

%.ps: %.tr
	@echo "Generating $@"
	@cat $< | $(SHAPE) | $(PIC) | $(TBL) | $(EQN) | $(ROFF) | $(POST) -pa4 >$@

%.ps: %.ms
	@echo "Generating $@"
	@cat $< | $(SOIN) | $(SHAPE) | \
		$(REFER) -m -e -o ct -p ref.bib | $(PIC) | $(TBL) | $(EQN) | \
		$(ROFF) -meps -mtbl -mkeep -mfa -msrefs | $(POST) -pa4 >$@

%.pdf: %.ps
	ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sFONTPATH=$(BASE)/fonts/ $< $@

clean:
	rm -f *.ps *.pdf
