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
	@cd troff/pic && $(MAKE)
	@cd troff/tbl && $(MAKE)
	@test -d devutf || (cd neatmkfn && ./gen.sh $(GSFONTS) ../devutf)

init:
	@test -d neatroff || git clone git://repo.or.cz/neatroff.git
	@test -d neatpost || git clone git://repo.or.cz/neatpost.git
	@test -d neatmkfn || git clone git://repo.or.cz/neatmkfn.git
	@test -d neateqn || git clone git://repo.or.cz/neateqn.git
	@test -d neatrefer || git clone git://repo.or.cz/neatrefer.git
	@test -d troff || git clone git://repo.or.cz/troff.git

pull: init
	cd neatroff && git pull
	cd neatpost && git pull
	cd neatmkfn && git pull
	cd neateqn && git pull
	cd neatrefer && git pull
	cd troff && git pull

install: all
	mkdir -p $(BDIR)
	cp neatroff/roff $(BDIR)/neatroff
	cp neatpost/post $(BDIR)/neatpost
	cp neateqn/eqn $(BDIR)/neateqn
	cp neatmkfn/mkfn $(BDIR)/neatmkfn
	cp neatrefer/refer $(BDIR)/neatrefer
	cp troff/tbl/tbl $(BDIR)/tbl9
	cp troff/pic/pic $(BDIR)/pic9
	chmod 755 $(BDIR)/neat{roff,post,eqn,mkfn,refer} $(BDIR)/{pic9,tbl9}

	mkdir -p -m 755 $(MDIR)
	cp -r tmac/* $(MDIR)/
	chmod 755 $(MDIR)/*/
	chmod 644 $(MDIR)/*.* $(MDIR)/*/*

	mkdir -p -m 755 $(FDIR)/devutf
	cp -r devutf/* $(FDIR)/devutf/
	chmod 644 $(FDIR)/devutf/*

help:
	@echo "Neatroff top-level makefile"
	@echo
	@echo "   all         Compile the programs"
	@echo "   install     Install the executables and data"
	@echo "   clean       Remove generated files"
	@echo
	@echo "   init        Initialise git repositories (git clone)"
	@echo "   pull        Update git repositories (git pull)"

clean:
	cd neatroff && $(MAKE) clean
	cd neatpost && $(MAKE) clean
	cd neateqn && $(MAKE) clean
	cd neatmkfn && $(MAKE) clean
	cd neatrefer && $(MAKE) clean
	cd troff/tbl && $(MAKE) clean
	cd troff/pic && $(MAKE) clean
	rm -rf devutf/
