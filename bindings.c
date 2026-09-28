#include "pico/stdlib.h"

void fgpio_put(uint gpio, bool state) {
	return gpio_put(gpio, state);
}

bool fgpio_get(uint gpio) {
	return gpio_get(gpio);
}

void fgpio_set_dir(uint gpio, bool out) {
	return gpio_set_dir(gpio, out);
}
