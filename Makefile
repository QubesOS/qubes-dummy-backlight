VERSION := $(shell cat version 2>/dev/null)

# BEGIN LOCAL BUILD PART
obj-m += module/dummy_backlight.o

.PHONY: module
module:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
# END LOCAL BUILD PART

install:
	# module part
	mkdir -p $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)
	install -m 664 module/dummy_backlight.c $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/dummy_backlight.c
	install -m 664 module/dkms.conf.in $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/dkms.conf
	install -m 664 module/Makefile.dkms $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/Makefile
	sed -i 's/@VERSION@/$(VERSION)/g; s/@NAME@/dummy_backlight/g' $(DESTDIR)/usr/src/dummy_backlight-$(VERSION)/dkms.conf

	# dom0 part
	mkdir -p $(DESTDIR)/etc/qubes-rpc/policy
	install -m 664 dom0/qubes.SetBrightness.policy $(DESTDIR)/etc/qubes-rpc/policy/qubes.SetBrightness
	install -m 775 dom0/qubes.SetBrightness $(DESTDIR)/etc/qubes-rpc/

	# VM part
	mkdir -p $(DESTDIR)/etc/udev/rules.d $(DESTDIR)/usr/lib/qubes
	install -m 664 vm/80-qubes-backlight.rules $(DESTDIR)/etc/udev/rules.d/
	install -m 775 vm/qubes-set-backlight.sh $(DESTDIR)/usr/lib/qubes/