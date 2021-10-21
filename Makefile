# Neatroff top-level Makefile

# Neatroff base directory
BASE = $(PWD)

# There is no need to install it, but if you wish it, this is the location.
#BASE = /opt/share/neatroff

INSTALL = install
MKDIR = mkdir -p -m 755

all: help

help:
	@echo "Neatroff top-level makefile"
	@echo
	@echo "   init        Initialise git repositories and fonts"
	@echo "   init_fa     Initialise for Farsi"
	@echo "   neat        Compile the programs and generate the fonts"
	@echo "   pull        Update git repositories (git pull)"
	@echo "   clean       Remove the generated files"
	@echo "   install     Install Neatroff in $(BASE)"
	@echo

init:
	@echo "Cloning Git repositories"
	@test -d neatroff || git clone https://github.com/aligrudi/neatroff.git
	@test -d neatpost || git clone https://github.com/aligrudi/neatpost.git
	@test -d neatmkfn || git clone https://github.com/aligrudi/neatmkfn.git
	@test -d neateqn || git clone https://github.com/aligrudi/neateqn.git
	@test -d neatrefer || git clone https://github.com/aligrudi/neatrefer.git
	@test -d troff || git clone -b neat https://repo.or.cz/troff.git
	@echo "Downloading fonts"
	@cd fonts && sh ./fonts.sh

init_fa: init
	@cd fonts && sh ./fonts_fa.sh

pull:
	cd neatroff && git pull
	cd neatpost && git pull
	cd neatmkfn && git pull
	cd neateqn && git pull
	cd neatrefer && git pull
	cd troff && git pull
	git pull

comp:
	@echo "Compiling programs"
	@cd neatroff && $(MAKE) FDIR="$(BASE)" MDIR="$(BASE)/tmac"
	@cd neatpost && $(MAKE) FDIR="$(BASE)" MDIR="$(BASE)/tmac"
	@cd neateqn && $(MAKE)
	@cd neatmkfn && $(MAKE)
	@cd neatrefer && $(MAKE)
	@cd troff/pic && $(MAKE)
	@cd troff/tbl && $(MAKE)
	@cd soin && $(MAKE)
	@cd shape && $(MAKE)

neat: comp
	@echo "Generating font descriptions"
	@cd neatmkfn && ./gen.sh "$(PWD)/fonts" "$(PWD)/devutf" >/dev/null

install:
	@echo "Copying binaries to $(BASE)"
	@$(MKDIR) "$(BASE)/neatroff"
	@$(MKDIR) "$(BASE)/neatpost"
	@$(MKDIR) "$(BASE)/neateqn"
	@$(MKDIR) "$(BASE)/neatmkfn"
	@$(MKDIR) "$(BASE)/neatrefer"
	@$(MKDIR) "$(BASE)/troff/pic"
	@$(MKDIR) "$(BASE)/troff/tbl"
	@$(MKDIR) "$(BASE)/soin"
	@$(MKDIR) "$(BASE)/shape"
	@$(MKDIR) -p "$(BASE)/share/man/man1"
	@$(INSTALL) neatroff/roff "$(BASE)/neatroff/"
	@$(INSTALL) neatpost/post "$(BASE)/neatpost/"
	@$(INSTALL) neatpost/pdf "$(BASE)/neatpost/"
	@$(INSTALL) neateqn/eqn "$(BASE)/neateqn/"
	@$(INSTALL) neatmkfn/mkfn "$(BASE)/neatmkfn/"
	@$(INSTALL) neatrefer/refer "$(BASE)/neatrefer/"
	@$(INSTALL) soin/soin "$(BASE)/soin/"
	@$(INSTALL) shape/shape "$(BASE)/shape/"
	@$(INSTALL) troff/pic/pic "$(BASE)/troff/pic/"
	@$(INSTALL) troff/tbl/tbl "$(BASE)/troff/tbl/"
	@$(INSTALL) man/neateqn.1 "$(BASE)/share/man/man1"
	@$(INSTALL) man/neatmkfn.1 "$(BASE)/share/man/man1"
	@$(INSTALL) man/neatpost.1 "$(BASE)/share/man/man1"
	@$(INSTALL) man/neatrefer.1 "$(BASE)/share/man/man1"
	@$(INSTALL) man/neatroff.1 "$(BASE)/share/man/man1"
	@echo "Copying font descriptions to $(BASE)/tmac"
	@$(MKDIR) "$(BASE)/tmac"
	@cp -r tmac/* "$(BASE)/tmac/"
	@find "$(BASE)/tmac" -type d -exec chmod 755 {} \;
	@find "$(BASE)/tmac" -type f -exec chmod 644 {} \;
	@echo "Copying devutf device to $(BASE)/devutf"
	@$(MKDIR) "$(BASE)/devutf"
	@cp devutf/* "$(BASE)/devutf/"
	@chmod 644 "$(BASE)/devutf"/*
	@echo "Copying fonts to $(BASE)/fonts"
	@$(MKDIR) "$(BASE)/fonts"
	@cp fonts/* "$(BASE)/fonts/"
	@chmod 644 "$(BASE)/fonts"/*
	@echo "Updating fontpath in font descriptions"
	@for f in "$(BASE)/devutf"/*; do sed "/^fontpath /s=$(PWD)/fonts=$(BASE)/devutf=" <$$f >.fd.tmp; mv .fd.tmp $$f; done

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
	@rm -fr $(PWD)/devutf
