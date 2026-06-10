.PHONY: all clean deb

all:
	@echo "Run 'make deb' to build the Debian package."

deb:
	dpkg-buildpackage -us -uc -b

clean:
	@rm -f ../mirrorix_*.deb
	@rm -f ../mirrorix_*.buildinfo
	@rm -f ../mirrorix_*.changes
	@rm -rf debian/mirrorix
	@rm -rf debian/.debhelper
	@rm -f debian/debhelper-build-stamp
	@rm -f debian/files
	@rm -f debian/mirrorix.substvars
