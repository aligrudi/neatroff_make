# Neatroff top-level Makefile

# Installation prefix
PREFIX = $(PWD)
# Input fonts directory
FONTS = $(PREFIX)/fonts
# Output device directory
FDIR = $(PREFIX)/
# Macro directory
MDIR = $(PREFIX)/tmac

all: help

help:
	@echo "Neatroff top-level makefile"
	@echo
	@echo "   init        Initialise git repositories and fonts"
	@echo "   init_fa     Initialise for Farsi"
	@echo "   neat        Compile the programs and generate the fonts"
	@echo "   pull        Update git repositories (git pull)"
	@echo "   clean       Remove the generated files"
	@echo

init:
	@test -d neatroff || git clone git://repo.or.cz/neatroff.git
	@test -d neatpost || git clone git://repo.or.cz/neatpost.git
	@test -d neatmkfn || git clone git://repo.or.cz/neatmkfn.git
	@test -d neateqn || git clone git://repo.or.cz/neateqn.git
	@test -d neatrefer || git clone git://repo.or.cz/neatrefer.git
	@test -d troff || git clone git://repo.or.cz/troff.git
	@test -d soin || (wget -c http://litcave.rudi.ir/soin.tar.gz && tar xf soin.tar.gz)
	@cd fonts && sh ./fonts.sh

init_fa: init
	@cd neatroff && git checkout dir
	@test -d shape || (wget -c http://litcave.rudi.ir/shape.tar.gz && tar xf shape.tar.gz)
	@cd fonts && sh ./fonts_fa.sh

pull:
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
	@test ! -d shape || (cd shape && $(MAKE))
	@cd neatmkfn && ./gen.sh $(FONTS) $(FDIR)/devutf >/dev/null

clean:
	@cd neatroff && $(MAKE) clean
	@cd neatpost && $(MAKE) clean
	@cd neateqn && $(MAKE) clean
	@cd neatmkfn && $(MAKE) clean
	@cd neatrefer && $(MAKE) clean
	@cd troff/tbl && $(MAKE) clean
	@cd troff/pic && $(MAKE) clean
	@cd soin && $(MAKE) clean
	@test ! -d shape || (cd shape && $(MAKE) clean)
	@rm -r $(FDIR)/devutf
