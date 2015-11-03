PREFIX ?= /usr/local

install:
	cp pb $(PREFIX)/bin/pb

uninstall:
	rm -f $(PREFIX)/bin/pb
