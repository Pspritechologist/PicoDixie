#include "hardware/pio.h"
#include "hardware/pio_instructions.h"

void *fpio_get_pio0(void) { return (void *)pio0; }
void *fpio_get_pio1(void) { return (void *)pio1; }
void *fpio_get_pio2(void) { return (void *)pio2; }

void fpio_sm_config_set_out_pin_base(pio_sm_config *c, uint out_base) {
    sm_config_set_out_pin_base(c, out_base);
}

void fpio_sm_config_set_out_pin_count(pio_sm_config *c, uint out_count) {
    sm_config_set_out_pin_count(c, out_count);
}

void fpio_sm_config_set_out_pins(pio_sm_config *c, uint out_base, uint out_count) {
    sm_config_set_out_pins(c, out_base, out_count);
}

void fpio_sm_config_set_set_pin_base(pio_sm_config *c, uint set_base) {
    sm_config_set_set_pin_base(c, set_base);
}

void fpio_sm_config_set_set_pin_count(pio_sm_config *c, uint set_count) {
    sm_config_set_set_pin_count(c, set_count);
}

void fpio_sm_config_set_set_pins(pio_sm_config *c, uint set_base, uint set_count) {
    sm_config_set_set_pins(c, set_base, set_count);
}

void fpio_sm_config_set_in_pin_base(pio_sm_config *c, uint in_base) {
    sm_config_set_in_pin_base(c, in_base);
}

void fpio_sm_config_set_in_pins(pio_sm_config *c, uint in_base) {
    sm_config_set_in_pins(c, in_base);
}

void fpio_sm_config_set_in_pin_count(pio_sm_config *c, uint in_count) {
    sm_config_set_in_pin_count(c, in_count);
}

void fpio_sm_config_set_sideset_pin_base(pio_sm_config *c, uint sideset_base) {
    sm_config_set_sideset_pin_base(c, sideset_base);
}

void fpio_sm_config_set_sideset_pins(pio_sm_config *c, uint sideset_base) {
    sm_config_set_sideset_pins(c, sideset_base);
}

void fpio_sm_config_set_sideset(pio_sm_config *c, uint bit_count, bool optional, bool pindirs) {
    sm_config_set_sideset(c, bit_count, optional, pindirs);
}

void fpio_sm_config_set_clkdiv_int_frac8(pio_sm_config *c, uint32_t div_int, uint8_t div_frac8) {
    sm_config_set_clkdiv_int_frac8(c, div_int, div_frac8);
}

void fpio_sm_config_set_clkdiv_int_frac(pio_sm_config *c, uint16_t div_int, uint8_t div_frac8) {
    sm_config_set_clkdiv_int_frac(c, div_int, div_frac8);
}

void fpio_pio_calculate_clkdiv8_from_float(float div, uint32_t *div_int, uint8_t *div_frac8) {
    pio_calculate_clkdiv8_from_float(div, div_int, div_frac8);
}

void fpio_pio_calculate_clkdiv_from_float(float div, uint16_t *div_int16, uint8_t *div_frac8) {
    pio_calculate_clkdiv_from_float(div, div_int16, div_frac8);
}

void fpio_sm_config_set_clkdiv(pio_sm_config *c, float div) {
    sm_config_set_clkdiv(c, div);
}

void fpio_sm_config_set_wrap(pio_sm_config *c, uint wrap_target, uint wrap) {
    sm_config_set_wrap(c, wrap_target, wrap);
}

void fpio_sm_config_set_jmp_pin(pio_sm_config *c, uint pin) {
    sm_config_set_jmp_pin(c, pin);
}

void fpio_sm_config_set_in_shift(pio_sm_config *c, bool shift_right, bool autopush, uint push_threshold) {
    sm_config_set_in_shift(c, shift_right, autopush, push_threshold);
}

void fpio_sm_config_set_out_shift(pio_sm_config *c, bool shift_right, bool autopull, uint pull_threshold) {
    sm_config_set_out_shift(c, shift_right, autopull, pull_threshold);
}

void fpio_sm_config_set_fifo_join(pio_sm_config *c, enum pio_fifo_join join) {
    sm_config_set_fifo_join(c, join);
}

void fpio_sm_config_set_out_special(pio_sm_config *c, bool sticky, bool has_enable_pin, uint enable_bit_index) {
    sm_config_set_out_special(c, sticky, has_enable_pin, enable_bit_index);
}

void fpio_sm_config_set_mov_status(pio_sm_config *c, enum pio_mov_status_type status_sel, uint status_n) {
    sm_config_set_mov_status(c, status_sel, status_n);
}

pio_sm_config fpio_pio_get_default_sm_config() {
    return pio_get_default_sm_config();
}

uint fpio_pio_get_gpio_base(PIO pio) {
    return pio_get_gpio_base(pio);
}

int fpio_pio_sm_set_config(PIO pio, uint sm, const pio_sm_config *config) {
    return pio_sm_set_config(pio, sm, config);
}

uint fpio_pio_get_index(PIO pio) {
    return pio_get_index(pio);
}

uint fpio_pio_get_funcsel(PIO pio) {
    return pio_get_funcsel(pio);
}

PIO fpio_pio_get_instance(uint instance) {
    return pio_get_instance(instance);
}

void fpio_pio_gpio_init(PIO pio, uint pin) {
    pio_gpio_init(pio, pin);
}

uint fpio_pio_get_dreq(PIO pio, uint sm, bool is_tx) {
    return pio_get_dreq(pio, sm, is_tx);
}

bool fpio_pio_can_add_program(PIO pio, const pio_program_t *program) {
    return pio_can_add_program(pio, program);
}

bool fpio_pio_can_add_program_at_offset(PIO pio, const pio_program_t *program, uint offset) {
    return pio_can_add_program_at_offset(pio, program, offset);
}

int fpio_pio_add_program(PIO pio, const pio_program_t *program) {
    return pio_add_program(pio, program);
}

int fpio_pio_add_program_at_offset(PIO pio, const pio_program_t *program, uint offset) {
    return pio_add_program_at_offset(pio, program, offset);
}

void fpio_pio_remove_program(PIO pio, const pio_program_t *program, uint loaded_offset) {
    pio_remove_program(pio, program, loaded_offset);
}

int fpio_pio_sm_init(PIO pio, uint sm, uint initial_pc, const pio_sm_config *config) {
    return pio_sm_init(pio, sm, initial_pc, config);
}

void fpio_pio_sm_set_enabled(PIO pio, uint sm, bool enabled) {
    pio_sm_set_enabled(pio, sm, enabled);
}

void fpio_pio_set_sm_mask_enabled(PIO pio, uint32_t mask, bool enabled) {
    pio_set_sm_mask_enabled(pio, mask, enabled);
}

void fpio_pio_set_sm_multi_mask_enabled(PIO pio, uint32_t mask_prev, uint32_t mask, uint32_t mask_next, bool enabled) {
    pio_set_sm_multi_mask_enabled(pio, mask_prev, mask, mask_next, enabled);
}

void fpio_pio_sm_restart(PIO pio, uint sm) {
    pio_sm_restart(pio, sm);
}

void fpio_pio_restart_sm_mask(PIO pio, uint32_t mask) {
    pio_restart_sm_mask(pio, mask);
}

void fpio_pio_sm_clkdiv_restart(PIO pio, uint sm) {
    pio_sm_clkdiv_restart(pio, sm);
}

void fpio_pio_clkdiv_restart_sm_mask(PIO pio, uint32_t mask) {
    pio_clkdiv_restart_sm_mask(pio, mask);
}

void fpio_pio_clkdiv_restart_sm_multi_mask(PIO pio, uint32_t mask_prev, uint32_t mask, uint32_t mask_next) {
    pio_clkdiv_restart_sm_multi_mask(pio, mask_prev, mask, mask_next);
}

void fpio_pio_enable_sm_mask_in_sync(PIO pio, uint32_t mask) {
    pio_enable_sm_mask_in_sync(pio, mask);
}

void fpio_pio_enable_sm_multi_mask_in_sync(PIO pio, uint32_t mask_prev, uint32_t mask, uint32_t mask_next) {
    pio_enable_sm_multi_mask_in_sync(pio, mask_prev, mask, mask_next);
}

void fpio_pio_set_irq0_source_enabled(PIO pio, pio_interrupt_source_t source, bool enabled) {
    pio_set_irq0_source_enabled(pio, source, enabled);
}

void fpio_pio_set_irq1_source_enabled(PIO pio, pio_interrupt_source_t source, bool enabled) {
    pio_set_irq1_source_enabled(pio, source, enabled);
}

void fpio_pio_set_irq0_source_mask_enabled(PIO pio, uint32_t source_mask, bool enabled) {
    pio_set_irq0_source_mask_enabled(pio, source_mask, enabled);
}

void fpio_pio_set_irq1_source_mask_enabled(PIO pio, uint32_t source_mask, bool enabled) {
    pio_set_irq1_source_mask_enabled(pio, source_mask, enabled);
}

void fpio_pio_set_irqn_source_enabled(PIO pio, uint irq_index, pio_interrupt_source_t source, bool enabled) {
    pio_set_irqn_source_enabled(pio, irq_index, source, enabled);
}

void fpio_pio_set_irqn_source_mask_enabled(PIO pio, uint irq_index, uint32_t source_mask, bool enabled) {
    pio_set_irqn_source_mask_enabled(pio, irq_index, source_mask, enabled);
}

bool fpio_pio_interrupt_get(PIO pio, uint pio_interrupt_num) {
    return pio_interrupt_get(pio, pio_interrupt_num);
}

void fpio_pio_interrupt_clear(PIO pio, uint pio_interrupt_num) {
    pio_interrupt_clear(pio, pio_interrupt_num);
}

uint8_t fpio_pio_sm_get_pc(PIO pio, uint sm) {
    return pio_sm_get_pc(pio, sm);
}

bool fpio_pio_sm_is_exec_stalled(PIO pio, uint sm) {
    return pio_sm_is_exec_stalled(pio, sm);
}

void fpio_pio_sm_exec_wait_blocking(PIO pio, uint sm, uint instr) {
    pio_sm_exec_wait_blocking(pio, sm, instr);
}

void fpio_pio_sm_set_wrap(PIO pio, uint sm, uint wrap_target, uint wrap) {
    pio_sm_set_wrap(pio, sm, wrap_target, wrap);
}

void fpio_pio_sm_set_out_pins(PIO pio, uint sm, uint out_base, uint out_count) {
    pio_sm_set_out_pins(pio, sm, out_base, out_count);
}

void fpio_pio_sm_set_set_pins(PIO pio, uint sm, uint set_base, uint set_count) {
    pio_sm_set_set_pins(pio, sm, set_base, set_count);
}

void fpio_pio_sm_set_in_pins(PIO pio, uint sm, uint in_base) {
    pio_sm_set_in_pins(pio, sm, in_base);
}

void fpio_pio_sm_set_sideset_pins(PIO pio, uint sm, uint sideset_base) {
    pio_sm_set_sideset_pins(pio, sm, sideset_base);
}

void fpio_pio_sm_set_jmp_pin(PIO pio, uint sm, uint pin) {
    pio_sm_set_jmp_pin(pio, sm, pin);
}

void fpio_pio_sm_put(PIO pio, uint sm, uint32_t data) {
    pio_sm_put(pio, sm, data);
}

uint32_t fpio_pio_sm_get(PIO pio, uint sm) {
    return pio_sm_get(pio, sm);
}

bool fpio_pio_sm_is_rx_fifo_full(PIO pio, uint sm) {
    return pio_sm_is_rx_fifo_full(pio, sm);
}

bool fpio_pio_sm_is_rx_fifo_empty(PIO pio, uint sm) {
    return pio_sm_is_rx_fifo_empty(pio, sm);
}

uint fpio_pio_sm_get_rx_fifo_level(PIO pio, uint sm) {
    return pio_sm_get_rx_fifo_level(pio, sm);
}

bool fpio_pio_sm_is_tx_fifo_full(PIO pio, uint sm) {
    return pio_sm_is_tx_fifo_full(pio, sm);
}

bool fpio_pio_sm_is_tx_fifo_empty(PIO pio, uint sm) {
    return pio_sm_is_tx_fifo_empty(pio, sm);
}

uint fpio_pio_sm_get_tx_fifo_level(PIO pio, uint sm) {
    return pio_sm_get_tx_fifo_level(pio, sm);
}

void fpio_pio_sm_put_blocking(PIO pio, uint sm, uint32_t data) {
    pio_sm_put_blocking(pio, sm, data);
}

uint32_t fpio_pio_sm_get_blocking(PIO pio, uint sm) {
    return pio_sm_get_blocking(pio, sm);
}

void fpio_pio_sm_set_clkdiv_int_frac8(PIO pio, uint sm, uint32_t div_int, uint8_t div_frac8) {
    pio_sm_set_clkdiv_int_frac8(pio, sm, div_int, div_frac8);
}

void fpio_pio_sm_set_clkdiv_int_frac(PIO pio, uint sm, uint16_t div_int, uint8_t div_frac8) {
    pio_sm_set_clkdiv_int_frac(pio, sm, div_int, div_frac8);
}

void fpio_pio_sm_set_clkdiv(PIO pio, uint sm, float div) {
    pio_sm_set_clkdiv(pio, sm, div);
}

void fpio_pio_sm_clear_fifos(PIO pio, uint sm) {
    pio_sm_clear_fifos(pio, sm);
}

int fpio_pio_sm_set_consecutive_pindirs(PIO pio, uint sm, uint pins_base, uint pin_count, bool is_out) {
    return pio_sm_set_consecutive_pindirs(pio, sm, pins_base, pin_count, is_out);
}

int fpio_pio_claim_unused_sm(PIO pio, bool required) {
    return pio_claim_unused_sm(pio, required);
}

bool fpio_pio_sm_is_claimed(PIO pio, uint sm) {
    return pio_sm_is_claimed(pio, sm);
}

bool fpio_pio_claim_free_sm_and_add_program(const pio_program_t *program, PIO *pio_out, uint *sm_out, uint *offset_out) {
    return pio_claim_free_sm_and_add_program(program, pio_out, sm_out, offset_out);
}

bool fpio_pio_claim_free_sm_and_add_program_for_gpio_range(const pio_program_t *program, PIO *pio_out, uint *sm_out, uint *offset_out, uint gpio_start, uint gpio_count, bool set_gpio_base) {
    return pio_claim_free_sm_and_add_program_for_gpio_range(program, pio_out, sm_out, offset_out, gpio_start, gpio_count, set_gpio_base);
}

void fpio_pio_remove_program_and_unclaim_sm(const pio_program_t *program, PIO pio, uint sm, uint offset) {
    pio_remove_program_and_unclaim_sm(program, pio, sm, offset);
}

int fpio_pio_get_irq_num(PIO pio, uint irqn) {
    return pio_get_irq_num(pio, irqn);
}

pio_interrupt_source_t fpio_pio_get_tx_fifo_not_full_interrupt_source(uint sm) {
    return pio_get_tx_fifo_not_full_interrupt_source(sm);
}

pio_interrupt_source_t fpio_pio_get_rx_fifo_not_empty_interrupt_source(uint sm) {
    return pio_get_rx_fifo_not_empty_interrupt_source(sm);
}

uint fpio_pio_encode_delay(uint cycles) {
    return pio_encode_delay(cycles);
}

uint fpio_pio_encode_sideset(uint sideset_bit_count, uint value) {
    return pio_encode_sideset(sideset_bit_count, value);
}

uint fpio_pio_encode_sideset_opt(uint sideset_bit_count, uint value) {
    return pio_encode_sideset_opt(sideset_bit_count, value);
}

uint fpio_pio_encode_jmp(uint addr) {
    return pio_encode_jmp(addr);
}

uint fpio_pio_encode_jmp_not_x(uint addr) {
    return pio_encode_jmp_not_x(addr);
}

uint fpio_pio_encode_jmp_x_dec(uint addr) {
    return pio_encode_jmp_x_dec(addr);
}

uint fpio_pio_encode_jmp_not_y(uint addr) {
    return pio_encode_jmp_not_y(addr);
}

uint fpio_pio_encode_jmp_y_dec(uint addr) {
    return pio_encode_jmp_y_dec(addr);
}

uint fpio_pio_encode_jmp_x_ne_y(uint addr) {
    return pio_encode_jmp_x_ne_y(addr);
}

uint fpio_pio_encode_jmp_pin(uint addr) {
    return pio_encode_jmp_pin(addr);
}

uint fpio_pio_encode_jmp_not_osre(uint addr) {
    return pio_encode_jmp_not_osre(addr);
}

uint fpio_pio_encode_wait_gpio(bool polarity, uint gpio) {
    return pio_encode_wait_gpio(polarity, gpio);
}

uint fpio_pio_encode_wait_pin(bool polarity, uint pin) {
    return pio_encode_wait_pin(polarity, pin);
}

uint fpio_pio_encode_wait_irq(bool polarity, bool relative, uint irq) {
    return pio_encode_wait_irq(polarity, relative, irq);
}

uint fpio_pio_encode_wait_jmppin(bool polarity, uint offset) {
    return pio_encode_wait_jmppin(polarity, offset);
}

uint fpio_pio_encode_in(enum pio_src_dest src, uint count) {
    return pio_encode_in(src, count);
}

uint fpio_pio_encode_out(enum pio_src_dest dest, uint count) {
    return pio_encode_out(dest, count);
}

uint fpio_pio_encode_push(bool if_full, bool block) {
    return pio_encode_push(if_full, block);
}

uint fpio_pio_encode_pull(bool if_empty, bool block) {
    return pio_encode_pull(if_empty, block);
}

uint fpio_pio_encode_mov(enum pio_src_dest dest, enum pio_src_dest src) {
    return pio_encode_mov(dest, src);
}

uint fpio_pio_encode_mov_not(enum pio_src_dest dest, enum pio_src_dest src) {
    return pio_encode_mov_not(dest, src);
}

uint fpio_pio_encode_mov_reverse(enum pio_src_dest dest, enum pio_src_dest src) {
    return pio_encode_mov_reverse(dest, src);
}

uint fpio_pio_encode_irq_set(bool relative, uint irq) {
    return pio_encode_irq_set(relative, irq);
}

uint fpio_pio_encode_irq_wait(bool relative, uint irq) {
    return pio_encode_irq_wait(relative, irq);
}

uint fpio_pio_encode_irq_clear(bool relative, uint irq) {
    return pio_encode_irq_clear(relative, irq);
}

uint fpio_pio_encode_set(enum pio_src_dest dest, uint value) {
    return pio_encode_set(dest, value);
}

uint fpio_pio_encode_nop() {
    return pio_encode_nop();
}
