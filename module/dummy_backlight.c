#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fb.h>
#include <linux/backlight.h>

static int curr_intensity;
static struct backlight_device *dummy_backlight_device;

static int set_intensity(struct backlight_device *bd)
{
	curr_intensity = bd->props.brightness;
	return 0;
}

static int get_intensity(struct backlight_device *bd)
{
	return curr_intensity;
}

static const struct backlight_ops dummy_ops = {
	.options = BL_CORE_SUSPENDRESUME,
	.get_brightness = get_intensity,
	.update_status = set_intensity,
};

static int __init dummy_backlight_init(void)
{
	struct backlight_properties props;
	const char *name = "dummy_backlight";

	memset(&props, 0, sizeof(struct backlight_properties));
	props.type = BACKLIGHT_RAW;
	props.max_brightness = 100;

	dummy_backlight_device =
		backlight_device_register(name, NULL, NULL, &dummy_ops, &props);

	if (IS_ERR(dummy_backlight_device))
		return PTR_ERR(dummy_backlight_device);

	dummy_backlight_device->props.power = FB_BLANK_UNBLANK;
	dummy_backlight_device->props.brightness = 90;
	backlight_update_status(dummy_backlight_device);

	return 0;
}
module_init(dummy_backlight_init);

static void __exit dummy_backlight_exit(void)
{
	backlight_device_unregister(dummy_backlight_device);
}
module_exit(dummy_backlight_exit);

MODULE_AUTHOR("Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>");
MODULE_DESCRIPTION("Dummy backlight Driver");
MODULE_LICENSE("GPL");
