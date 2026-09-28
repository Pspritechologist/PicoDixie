#include "pico/stdlib.h"

void fgpio_put(uint gpio, bool state) {
	gpio_put(gpio, state);
}

bool fgpio_get(uint gpio) {
	return gpio_get(gpio);
}
