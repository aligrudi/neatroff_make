# Neatroff top-level makefile

# Installation prefix
PREFIX = /opt
# Input fonts directory; containing ghostscript-fonts and other fonts
GSFONTS = /usr/share/ghostscript/fonts

# Output device directory
FDIR = $(PREFIX)/share/neatroff/font
# Macro directory
MDIR = $(PREFIX)/share/neatroff/tmac
# Directory to install the executables
BDIR = $(PREFIX)/bin

all: init
	@cd neatroff && $(MAKE) FDIR="$(FDIR)" MDIR="$(MDIR)"
	@cd neatpost && $(MAKE) FDIR="$(FDIR)" MDIR="$(MDIR)"
	@cd neateqn && $(MAKE)
	@cd neatmkfn && $(MAKE)
	@cd neatrefer && $(MAKE)
	@test -d devutf || (cd neatmkfn && ./gen.sh $(GSFONTS) ../devutf)

init:
	@test -d neatroff || git clone git://repo.or.cz/neatroff.git
	@test -d neatpost || git clone git://repo.or.cz/neatpost.git
	@test -d neatmkfn || git clone git://repo.or.cz/neatmkfn.git
	@test -d neateqn || git clone git://repo.or.cz/neateqn.git
	@test -d neatrefer || git clone git://repo.or.cz/neatrefer.git

pull: init
	cd neatroff && git pull
	cd neatpost && git pull
	cd neatmkfn && git pull
	cd neateqn && git pull
	cd neatrefer && git pull

install: all
	mkdir -p $(BDIR)
	cp neatroff/roff $(BDIR)/neatroff
	cp neatpost/post $(BDIR)/neatpost
	cp neateqn/eqn $(BDIR)/neateqn
	cp neatmkfn/mkfn $(BDIR)/neatmkfn
	cp neatrefer/refer $(BDIR)/neatrefer
	mkdir -p $(MDIR)
	cp -r tmac/* $(MDIR)/
	mkdir -p $(FDIR)
	cp -r devutf $(FDIR)/

help:
	@echo "Neatroff top-level makefile"
	@echo
	@echo "   init        Initialise git repositories"
	@echo "   pull        Pull git repositories"
	@echo "   all         Compile the programs"
	@echo "   install     Install the executables and data"
	@echo "   clean       Remove generated files"

clean:
	cd neatroff && $(MAKE) clean
	cd neatpost && $(MAKE) clean
	cd neateqn && $(MAKE) clean
	cd neatmkfn && $(MAKE) clean
	cd neatrefer && $(MAKE) clean
	rm -rf devutf/
