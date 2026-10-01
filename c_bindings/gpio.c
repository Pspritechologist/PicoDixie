#include "pico/stdlib.h"

void fgpio_set_function_masked64(uint64_t gpio_mask, gpio_function_t fn) {
	gpio_set_function_masked64(gpio_mask, fn);
}
void fgpio_pull_up(uint gpio) {
	gpio_pull_up(gpio);
}
bool fgpio_is_pulled_up(uint gpio) {
	return gpio_is_pulled_up(gpio);
}
void fgpio_pull_down(uint gpio) {
	gpio_pull_down(gpio);
}
bool fgpio_is_pulled_down(uint gpio) {
	return gpio_is_pulled_down(gpio);
}
void fgpio_disable_pulls(uint gpio) {
	gpio_disable_pulls(gpio);
}
void fgpio_set_irq_callback(gpio_irq_callback_t callback) {
	gpio_set_irq_callback(callback);
}
void fgpio_set_irq_enabled_with_callback(uint gpio, uint32_t event_mask, bool enabled,
		gpio_irq_callback_t callback) {
	gpio_set_irq_enabled_with_callback(gpio, event_mask, enabled, callback);
}
bool fgpio_get(uint gpio) {
	return gpio_get(gpio);
}
uint32_t fgpio_get_all(void) {
	return gpio_get_all();
}
uint64_t fgpio_get_all64(void) {
	return gpio_get_all64();
}
void fgpio_set_mask(uint32_t mask) {
	gpio_set_mask(mask);
}
void fgpio_set_mask64(uint64_t mask) {
	gpio_set_mask64(mask);
}
void fgpio_set_mask_n(uint n, uint32_t mask) {
	gpio_set_mask_n(n, mask);
}
void fgpio_clr_mask(uint32_t mask) {
	gpio_clr_mask(mask);
}
void fgpio_clr_mask64(uint64_t mask) {
	gpio_clr_mask64(mask);
}
void fgpio_clr_mask_n(uint n, uint32_t mask) {
	gpio_clr_mask_n(n, mask);
}
void fgpio_xor_mask(uint32_t mask) {
	gpio_xor_mask(mask);
}
void fgpio_xor_mask64(uint64_t mask) {
	gpio_xor_mask64(mask);
}
void fgpio_xor_mask_n(uint n, uint32_t mask) {
	gpio_xor_mask_n(n, mask);
}
void fgpio_put_masked(uint32_t mask, uint32_t value) {
	gpio_put_masked(mask, value);
}
void fgpio_put_masked64(uint64_t mask, uint64_t value) {
	gpio_put_masked64(mask, value);
}
void fgpio_put_masked_n(uint n, uint32_t mask, uint32_t value) {
	gpio_put_masked_n(n, mask, value);
}
void fgpio_put_all(uint32_t value) {
	gpio_put_all(value);
}
void fgpio_put_all64(uint64_t value) {
	gpio_put_all64(value);
}
void fgpio_put(uint gpio, bool state) {
	gpio_put(gpio, state);
}
bool fgpio_get_out_level(uint gpio) {
	return gpio_get_out_level(gpio);
}
void fgpio_set_dir_out_masked(uint32_t mask) {
	gpio_set_dir_out_masked(mask);
}
void fgpio_set_dir_out_masked64(uint64_t mask) {
	gpio_set_dir_out_masked64(mask);
}
void fgpio_set_dir_in_masked(uint32_t mask) {
	gpio_set_dir_in_masked(mask);
}
void fgpio_set_dir_in_masked64(uint64_t mask) {
	gpio_set_dir_in_masked64(mask);
}
void fgpio_set_dir_masked(uint32_t mask, uint32_t value) {
	gpio_set_dir_masked(mask, value);
}
void fgpio_set_dir_masked64(uint64_t mask, uint64_t value) {
	gpio_set_dir_masked64(mask, value);
}
void fgpio_set_dir_all_bits(uint32_t value) {
	gpio_set_dir_all_bits(value);
}
void fgpio_set_dir_all_bits64(uint64_t value) {
	gpio_set_dir_all_bits64(value);
}
void fgpio_set_dir(uint gpio, bool out) {
	gpio_set_dir(gpio, out);
}
bool fgpio_is_dir_out(uint gpio) {
	return gpio_is_dir_out(gpio);
}
uint fgpio_get_dir(uint gpio) {
	return gpio_get_dir(gpio);
}
uint32_t fgpio_get_irq_event_mask(uint gpio) {
	return gpio_get_irq_event_mask(gpio);
}
void fgpio_acknowledge_irq(uint gpio, uint32_t event_mask) {
	gpio_acknowledge_irq(gpio, event_mask);
}
void fgpio_init_mask64(uint64_t gpio_mask) {
	gpio_init_mask64(gpio_mask);
}
void fgpio_add_raw_irq_handler_with_order_priority(uint gpio, irq_handler_t handler, uint8_t order_priority) {
	gpio_add_raw_irq_handler_with_order_priority(gpio, handler, order_priority);
}
void fgpio_add_raw_irq_handler(uint gpio, irq_handler_t handler) {
	gpio_add_raw_irq_handler(gpio, handler);
}
void fgpio_remove_raw_irq_handler(uint gpio, irq_handler_t handler) {
	gpio_remove_raw_irq_handler(gpio, handler);
}
