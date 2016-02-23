# Neatroff demonstration directory
BASE = $(PWD)/..
ROFF = $(BASE)/neatroff/roff
POST = $(BASE)/neatpost/post
EQN = $(BASE)/neateqn/eqn
REFER = $(BASE)/neatrefer/refer
PIC = $(BASE)/troff/pic/pic
TBL = $(BASE)/troff/tbl/tbl

all: test.pdf

%.ps: %.ms
	cat $< | $(PIC) | $(TBL) | $(EQN) | $(ROFF) | $(POST) -pa4 >$@

%.pdf: %.ps
	ps2pdf -sFONTPATH=$(BASE)/fonts/ $< $@

clean:
	rm -f *.ps *.pdf
