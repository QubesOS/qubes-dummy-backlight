VERSION := $(shell cat version)

# BEGIN LOCAL BUILD PART
obj-m += dummy_backlight.o

module:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
# END LOCAL BUILD PART

install:
	mkdir -p $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)
	install -m 664 dummy_backlight.c $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/dummy_backlight.c
	install -m 664 dkms.conf.in $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/dkms.conf
	install -m 664 Makefile.dkms $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/Makefile
	sed -i 's/@VERSION@/$(VERSION)/g; s/@NAME@/dummy_backlight/g' $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/dkms.conf