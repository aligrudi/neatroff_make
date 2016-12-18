# Neatroff top-level Makefile

# Installation prefix
PREFIX = /opt
# Input fonts directory, containing Ghostscript fonts
GSFONTS = /usr/share/fonts/type1/gsfonts

# Output device directory
FDIR = $(PREFIX)/share/neatroff/font
# Macro directory
MDIR = $(PREFIX)/share/neatroff/tmac
# Directory to install the executables
BDIR = $(PREFIX)/bin
# Directory to install the manual pages
MANDIR = $(PREFIX)/man

INSTALL = install

all: help

help:
	@echo "Neatroff top-level makefile"
	@echo
	@echo "   init        Initialise git repositories and fonts"
	@echo "   neat        Compile the programs and generate the fonts"
	@echo "   install     Install the executables and data"
	@echo "   pull        Update git repositories (git pull)"
	@echo "   clean       Remove generated files"
	@echo

init:
	@test -d neatroff || git clone git://github.com/aligrudi/neatroff.git
	@test -d neatpost || git clone git://github.com/aligrudi/neatpost.git
	@test -d neatmkfn || git clone git://github.com/aligrudi/neatmkfn.git
	@test -d neateqn || git clone git://github.com/aligrudi/neateqn.git
	@test -d neatrefer || git clone git://github.com/aligrudi/neatrefer.git
	@test -d troff || git clone git://repo.or.cz/troff.git

pull: init
	cd neatroff && git pull
	cd neatpost && git pull
	cd neatmkfn && git pull
	cd neateqn && git pull
	cd neatrefer && git pull
	cd troff && git pull
	git pull

neat:
	@cd neatroff && $(MAKE) FDIR="$(FDIR)" MDIR="$(MDIR)"
	@cd neatpost && $(MAKE) FDIR="$(FDIR)" MDIR="$(MDIR)"
	@cd neateqn && $(MAKE)
	@cd neatmkfn && $(MAKE)
	@cd neatrefer && $(MAKE)
	@cd troff/pic && $(MAKE)
	@cd troff/tbl && $(MAKE)
	@cd soin && $(MAKE)
	@cd shape && $(MAKE)
	@cd neatmkfn && ./gen.sh $(GSFONTS) ../devutf >/dev/null

install: init neat
	mkdir -p $(BDIR)
	$(INSTALL) neatroff/roff $(BDIR)/neatroff
	$(INSTALL) neatpost/post $(BDIR)/neatpost
	$(INSTALL) neateqn/eqn $(BDIR)/neateqn
	$(INSTALL) neatmkfn/mkfn $(BDIR)/neatmkfn
	$(INSTALL) neatrefer/refer $(BDIR)/neatrefer
	$(INSTALL) shape/shape $(BDIR)/shape
	$(INSTALL) troff/tbl/tbl $(BDIR)/tbl9
	$(INSTALL) troff/pic/pic $(BDIR)/pic9

	mkdir -p -m 755 $(MDIR)
	cp -r tmac/* $(MDIR)/
	chmod 755 $(MDIR)/*/
	chmod 644 $(MDIR)/*.* $(MDIR)/*/*

	mkdir -p -m 755 $(FDIR)/devutf
	cp -r devutf/* $(FDIR)/devutf/
	chmod 644 $(FDIR)/devutf/*

	mkdir -p -m 755 $(MANDIR)/man1
	cp -r man/*.1 $(MANDIR)/man1/
	chmod 644 $(MANDIR)/man1/neat*.1

clean:
	@cd neatroff && $(MAKE) clean
	@cd neatpost && $(MAKE) clean
	@cd neateqn && $(MAKE) clean
	@cd neatmkfn && $(MAKE) clean
	@cd neatrefer && $(MAKE) clean
	@cd troff/tbl && $(MAKE) clean
	@cd troff/pic && $(MAKE) clean
	@cd soin && $(MAKE) clean
	@cd shape && $(MAKE) clean
	@rm -r devutf
