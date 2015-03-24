# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

PREFIX = /usr
BIN = /bin
BINDIR = $(PREFIX)$(BIN)
DATA = /share
DATADIR = $(PREFIX)$(DATA)
DOCDIR = $(DATADIR)/doc
INFODIR = $(DATADIR)/info
LICENSEDIR = $(DATADIR)/licenses

PKGNAME = cerberus-securetty


.PHONY: default
default: info

.PHONY: all
all: doc

.PHONY: doc
doc: info pdf ps dvi

.PHONY: info
info: cerberus-securetty.info
%.info: info/%.texinfo
	makeinfo "$<"

.PHONY: pdf
pdf: cerberus-securetty.pdf
%.pdf: info/%.texinfo info/fdl.texinfo
	mkdir -p obj
	cd obj ; yes X | texi2pdf ../$<
	mv obj/$@ $@

.PHONY: dvi
dvi: cerberus-securetty.dvi
%.dvi: info/%.texinfo info/fdl.texinfo
	mkdir -p obj
	cd obj ; yes X | $(TEXI2DVI) ../$<
	mv obj/$@ $@

.PHONY: ps
ps: cerberus-securetty.ps
%.ps: info/%.texinfo info/fdl.texinfo
	mkdir -p obj
	cd obj ; yes X | texi2pdf --ps ../$<
	mv obj/$@ $@


.PHONY: install
install: install-base install-info

.PHONY: install-all
install-all: install-base install-doc

.PHONY: install-base
install-base: install-securetty install-license

.PHONY: install-securetty
install-securetty:
	install -dm755 -- "$(DESTDIR)$(DATADIR)/$(PKGNAME)"
	install -m755 -- src/securetty "$(DESTDIR)$(DATADIR)/$(PKGNAME)/securetty"

.PHONY: install-license
install-license:
	install -dm755 -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 -- COPYING LICENSE "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"

.PHONY: install-doc
install-doc: install-info install-pdf install-ps install-dvi

.PHONY: install-info
install-info: cerberus-securetty.info
	install -dm755 -- "$(DESTDIR)$(INFODIR)"
	install -m644 -- "$<" "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"

.PHONY: install-pdf
install-pdf: cerberus-securetty.pdf
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 -- "$<" "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"

.PHONY: install-ps
install-ps: cerberus-securetty.ps
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 -- "$<" "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"

.PHONY: install-dvi
install-dvi: cerberus-securetty.dvi
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 -- "$<" "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"


.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(DATADIR)/$(PKGNAME)/securetty"
	-rmdir -- "$(DESTDIR)$(DATADIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	-rmdir -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"


.PHONY: clean
clean:
	-rm -r bin obj *.su src/*.su

