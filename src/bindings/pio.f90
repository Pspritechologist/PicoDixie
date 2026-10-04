module pio
	use, intrinsic :: iso_c_binding
	use pio_instructions

	!> PIO state machine configuration.
	!>
	!> A PIO block needs to be configured, these functions provide helpers to set up configuration
	!> structures.
	type, bind(C) :: pio_sm_config
		integer(c_int32_t) :: clkdiv
		integer(c_int32_t) :: execctrl
		integer(c_int32_t) :: shiftctrl
		integer(c_int32_t) :: pinctrl
	end type pio_sm_config

	!> PIO program definition.
	!>
	!> This structure describes a PIO program: the array of encoded instructions plus the
	!> metadata needed to load it onto a PIO instance. It is the type emitted by the `pioasm`
	!> tool (as `<program_name>_program`) and consumed by `pio_add_program`, `pio_can_add_program`
	!> and related functions. It may also be populated by hand when assembling programs at
	!> runtime with the helpers in `pio_instructions.h`.
	type, bind(C) :: pio_program_t
		!> The array of encoded instructions that make up the program.
		type(c_ptr) :: instructions
		!> The number of instructions in `instructions` (also the amount of instruction memory
		!> the program occupies).
		integer(c_int8_t) :: length
		!> The required load offset in PIO instruction memory, or -1 if the program is relocatable
		!> and may be loaded at any offset.
		integer(c_int8_t) :: origin
		!> The minimum PIO hardware version the program requires (0 for any PIO); loading a program
		!> that requires a newer version than the target PIO fails with PICO_ERROR_VERSION_MISMATCH.
		integer(c_int8_t) :: pio_version
		!> Bitmap of the 16-pin GPIO ranges the program uses (bit 0 = pins 0-15, bit 1 = pins 16-31,
		!> bit 2 = pins 32-47), checked against the PIO instance's GPIO base so that an incompatible
		!> program is rejected.
		integer(c_int8_t) :: used_gpio_ranges
	end type pio_program_t

	!> FIFO join states.
	!>
	!> TX FIFO length=4 is used for transmit, RX FIFO length=4 is used for receive.
	integer, parameter :: pio_fifo_join_none = 0
	!> TX FIFO length=8 is used for transmit, RX FIFO is disabled.
	integer, parameter :: pio_fifo_join_tx = 1
	!> RX FIFO length=8 is used for receive, TX FIFO is disabled.
	integer, parameter :: pio_fifo_join_rx = 2
	!> TX FIFO length=4 is used for transmit, RX FIFO is disabled; space is used for "get"
	!> instructions or processor writes.
	integer, parameter :: pio_fifo_join_txget = 4
	!> TX FIFO length=4 is used for transmit, RX FIFO is disabled; space is used for "put"
	!> instructions or processor reads.
	integer, parameter :: pio_fifo_join_txput = 8
	!> TX FIFO length=4 is used for transmit, RX FIFO is disabled; space is used for "put"/"get"
	!> instructions with no processor access.
	integer, parameter :: pio_fifo_join_putget = 12

	!> MOV status types.
	integer, parameter :: status_tx_lessthan = 0
	integer, parameter :: status_rx_lessthan = 1
	integer, parameter :: status_irq_set = 2

	!> PIO interrupt source numbers for PIO related IRQs.
	!> PIO interrupt 0 is raised.
	integer, parameter :: pis_interrupt0 = 8
	!> PIO interrupt 1 is raised.
	integer, parameter :: pis_interrupt1 = 9
	!> PIO interrupt 2 is raised.
	integer, parameter :: pis_interrupt2 = 10
	!> PIO interrupt 3 is raised.
	integer, parameter :: pis_interrupt3 = 11
	!> PIO interrupt 4 is raised.
	integer, parameter :: pis_interrupt4 = 12
	!> PIO interrupt 5 is raised.
	integer, parameter :: pis_interrupt5 = 13
	!> PIO interrupt 6 is raised.
	integer, parameter :: pis_interrupt6 = 14
	!> PIO interrupt 7 is raised.
	integer, parameter :: pis_interrupt7 = 15
	!> State machine 0 TX FIFO is not full.
	integer, parameter :: pis_sm0_tx_fifo_not_full = 4
	!> State machine 1 TX FIFO is not full.
	integer, parameter :: pis_sm1_tx_fifo_not_full = 5
	!> State machine 2 TX FIFO is not full.
	integer, parameter :: pis_sm2_tx_fifo_not_full = 6
	!> State machine 3 TX FIFO is not full.
	integer, parameter :: pis_sm3_tx_fifo_not_full = 7
	!> State machine 0 RX FIFO is not empty.
	integer, parameter :: pis_sm0_rx_fifo_not_empty = 0
	!> State machine 1 RX FIFO is not empty.
	integer, parameter :: pis_sm1_rx_fifo_not_empty = 1
	!> State machine 2 RX FIFO is not empty.
	integer, parameter :: pis_sm2_rx_fifo_not_empty = 2
	!> State machine 3 RX FIFO is not empty.
	integer, parameter :: pis_sm3_rx_fifo_not_empty = 3

	interface
		type(c_ptr) function fpio_pio0() bind(C, name="fpio_get_pio0")
			import c_ptr
		end function

		type(c_ptr) function fpio_pio1() bind(C, name="fpio_get_pio1")
			import c_ptr
		end function

		type(c_ptr) function fpio_pio2() bind(C, name="fpio_get_pio2")
			import c_ptr
		end function

		subroutine fsm_config_set_out_pin_base(c, out_base) bind(C, name="fsm_config_set_out_pin_base")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: out_base
		end subroutine

		subroutine fsm_config_set_out_pin_count(c, out_count) bind(C, name="fsm_config_set_out_pin_count")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: out_count
		end subroutine

		subroutine fsm_config_set_out_pins(c, out_base, out_count) bind(C, name="fsm_config_set_out_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: out_base
			integer(c_int32_t), intent(in), value :: out_count
		end subroutine

		subroutine fsm_config_set_set_pin_base(c, set_base) bind(C, name="fsm_config_set_set_pin_base")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: set_base
		end subroutine

		subroutine fsm_config_set_set_pin_count(c, set_count) bind(C, name="fsm_config_set_set_pin_count")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: set_count
		end subroutine

		subroutine fsm_config_set_set_pins(c, set_base, set_count) bind(C, name="fsm_config_set_set_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: set_base
			integer(c_int32_t), intent(in), value :: set_count
		end subroutine

		subroutine fsm_config_set_in_pin_base(c, in_base) bind(C, name="fsm_config_set_in_pin_base")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: in_base
		end subroutine

		subroutine fsm_config_set_in_pins(c, in_base) bind(C, name="fsm_config_set_in_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: in_base
		end subroutine

		subroutine fsm_config_set_in_pin_count(c, in_count) bind(C, name="fsm_config_set_in_pin_count")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: in_count
		end subroutine

		subroutine fsm_config_set_sideset_pin_base(c, sideset_base) bind(C, name="fsm_config_set_sideset_pin_base")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: sideset_base
		end subroutine

		subroutine fsm_config_set_sideset_pins(c, sideset_base) bind(C, name="fsm_config_set_sideset_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: sideset_base
		end subroutine

		subroutine fsm_config_set_sideset(c, bit_count, optional, pindirs) bind(C, name="fsm_config_set_sideset")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: bit_count
			logical(c_bool), intent(in), value :: optional
			logical(c_bool), intent(in), value :: pindirs
		end subroutine

		subroutine fsm_config_set_clkdiv_int_frac8(c, div_int, div_frac8) bind(C, name="fsm_config_set_clkdiv_int_frac8")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: div_int
			integer(c_int8_t), intent(in), value :: div_frac8
		end subroutine

		subroutine fsm_config_set_clkdiv_int_frac(c, div_int, div_frac8) bind(C, name="fsm_config_set_clkdiv_int_frac")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int16_t), intent(in), value :: div_int
			integer(c_int8_t), intent(in), value :: div_frac8
		end subroutine

		subroutine fpio_calculate_clkdiv8_from_float(div, div_int, div_frac8) bind(C, name="fpio_calculate_clkdiv8_from_float")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			real(c_float), intent(in), value :: div
			integer(c_int32_t), intent(in), value :: div_int
			integer(c_int8_t), intent(in), value :: div_frac8
		end subroutine

		subroutine fpio_calculate_clkdiv_from_float(div, div_int16, div_frac8) bind(C, name="fpio_calculate_clkdiv_from_float")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			real(c_float), intent(in), value :: div
			integer(c_int16_t), intent(in), value :: div_int16
			integer(c_int8_t), intent(in), value :: div_frac8
		end subroutine

		subroutine fsm_config_set_clkdiv(c, div) bind(C, name="fsm_config_set_clkdiv")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			real(c_float), intent(in), value :: div
		end subroutine

		subroutine fsm_config_set_wrap(c, wrap_target, wrap) bind(C, name="fsm_config_set_wrap")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: wrap_target
			integer(c_int32_t), intent(in), value :: wrap
		end subroutine

		subroutine fsm_config_set_jmp_pin(c, pin) bind(C, name="fsm_config_set_jmp_pin")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: pin
		end subroutine

		subroutine fsm_config_set_in_shift(c, shift_right, autopush, push_threshold) bind(C, name="fsm_config_set_in_shift")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			logical(c_bool), intent(in), value :: shift_right
			logical(c_bool), intent(in), value :: autopush
			integer(c_int32_t), intent(in), value :: push_threshold
		end subroutine

		subroutine fsm_config_set_out_shift(c, shift_right, autopull, pull_threshold) bind(C, name="fsm_config_set_out_shift")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			logical(c_bool), intent(in), value :: shift_right
			logical(c_bool), intent(in), value :: autopull
			integer(c_int32_t), intent(in), value :: pull_threshold
		end subroutine

		subroutine fsm_config_set_fifo_join(c, join) bind(C, name="fsm_config_set_fifo_join")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: join
		end subroutine

		subroutine fsm_config_set_out_special(c, sticky, has_enable_pin, enable_bit_index) bind(C, name="fsm_config_set_out_special")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			logical(c_bool), intent(in), value :: sticky
			logical(c_bool), intent(in), value :: has_enable_pin
			integer(c_int32_t), intent(in), value :: enable_bit_index
		end subroutine

		subroutine fsm_config_set_mov_status(c, status_sel, status_n) bind(C, name="fsm_config_set_mov_status")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: c
			integer(c_int32_t), intent(in), value :: status_sel
			integer(c_int32_t), intent(in), value :: status_n
		end subroutine

		subroutine fpio_get_default_sm_config(out) bind(C, name="fpio_get_default_sm_config")
			import c_ptr
			type(c_ptr), intent(in), value :: out
		end subroutine

		integer(c_int32_t) function fpio_get_gpio_base(pio) bind(C, name="fpio_get_gpio_base") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
		end function

		integer(c_int) function fpio_sm_set_config(pio, sm, config) bind(C, name="fpio_sm_set_config") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			type(c_ptr), intent(in), value :: config
		end function

		integer(c_int32_t) function fpio_get_index(pio) bind(C, name="fpio_get_index") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
		end function

		integer(c_int32_t) function fpio_get_funcsel(pio) bind(C, name="fpio_get_funcsel") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
		end function

		function fpio_get_instance(instance) bind(C, name="fpio_get_instance") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr) :: r
			integer(c_int32_t), intent(in), value :: instance
		end function

		subroutine fpio_gpio_init(pio, pin) bind(C, name="fpio_gpio_init")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: pin
		end subroutine

		integer(c_int32_t) function fpio_get_dreq(pio, sm, is_tx) bind(C, name="fpio_get_dreq") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			logical(c_bool), intent(in), value :: is_tx
		end function

		integer(c_int) function fpio_set_gpio_base(pio, gpio_base) bind(C, name="fpio_set_gpio_base") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: gpio_base
		end function

		logical(c_bool) function fpio_can_add_program(pio, program) bind(C, name="fpio_can_add_program")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			type(c_ptr), intent(in), value :: program
		end function

		logical(c_bool) function fpio_can_add_program_at_offset(pio, program, offset) bind(C, name="fpio_can_add_program_at_offset")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			type(c_ptr), intent(in), value :: program
			integer(c_int32_t), intent(in), value :: offset
		end function

		integer(c_int) function fpio_add_program(pio, program) bind(C, name="fpio_add_program") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			type(c_ptr), intent(in), value :: program
		end function

		integer(c_int) function fpio_add_program_at_offset(pio, program, offset) bind(C, name="fpio_add_program_at_offset") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			type(c_ptr), intent(in), value :: program
			integer(c_int32_t), intent(in), value :: offset
		end function

		subroutine fpio_remove_program(pio, program, loaded_offset) bind(C, name="fpio_remove_program")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			type(c_ptr), intent(in), value :: program
			integer(c_int32_t), intent(in), value :: loaded_offset
		end subroutine

		subroutine fpio_clear_instruction_memory(pio) bind(C, name="fpio_clear_instruction_memory")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
		end subroutine

		integer(c_int) function fpio_sm_init(pio, sm, initial_pc, config) bind(C, name="fpio_sm_init") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: initial_pc
			type(c_ptr), intent(in), value :: config
		end function

		subroutine fpio_sm_set_enabled(pio, sm, enabled) bind(C, name="fpio_sm_set_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_set_sm_mask_enabled(pio, mask, enabled) bind(C, name="fpio_set_sm_mask_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: mask
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_set_sm_multi_mask_enabled(pio, mask_prev, mask, mask_next, enabled) bind(C, name="fpio_set_sm_multi_mask_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: mask_prev
			integer(c_int32_t), intent(in), value :: mask
			integer(c_int32_t), intent(in), value :: mask_next
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_sm_restart(pio, sm) bind(C, name="fpio_sm_restart")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end subroutine

		subroutine fpio_restart_sm_mask(pio, mask) bind(C, name="fpio_restart_sm_mask")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fpio_sm_clkdiv_restart(pio, sm) bind(C, name="fpio_sm_clkdiv_restart")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end subroutine

		subroutine fpio_clkdiv_restart_sm_mask(pio, mask) bind(C, name="fpio_clkdiv_restart_sm_mask")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fpio_clkdiv_restart_sm_multi_mask(pio, mask_prev, mask, mask_next) bind(C, name="fpio_clkdiv_restart_sm_multi_mask")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: mask_prev
			integer(c_int32_t), intent(in), value :: mask
			integer(c_int32_t), intent(in), value :: mask_next
		end subroutine

		subroutine fpio_enable_sm_mask_in_sync(pio, mask) bind(C, name="fpio_enable_sm_mask_in_sync")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fpio_enable_sm_multi_mask_in_sync(pio, mask_prev, mask, mask_next) bind(C, name="fpio_enable_sm_multi_mask_in_sync")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: mask_prev
			integer(c_int32_t), intent(in), value :: mask
			integer(c_int32_t), intent(in), value :: mask_next
		end subroutine

		subroutine fpio_set_irq0_source_enabled(pio, source, enabled) bind(C, name="fpio_set_irq0_source_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: source
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_set_irq1_source_enabled(pio, source, enabled) bind(C, name="fpio_set_irq1_source_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: source
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_set_irq0_source_mask_enabled(pio, source_mask, enabled) bind(C, name="fpio_set_irq0_source_mask_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: source_mask
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_set_irq1_source_mask_enabled(pio, source_mask, enabled) bind(C, name="fpio_set_irq1_source_mask_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: source_mask
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_set_irqn_source_enabled(pio, irq_index, source, enabled) bind(C, name="fpio_set_irqn_source_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: irq_index
			integer(c_int32_t), intent(in), value :: source
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fpio_set_irqn_source_mask_enabled(pio, irq_index, source_mask, enabled) bind(C, name="fpio_set_irqn_source_mask_enabled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: irq_index
			integer(c_int32_t), intent(in), value :: source_mask
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		logical(c_bool) function fpio_interrupt_get(pio, pio_interrupt_num) bind(C, name="fpio_interrupt_get")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: pio_interrupt_num
		end function

		subroutine fpio_interrupt_clear(pio, pio_interrupt_num) bind(C, name="fpio_interrupt_clear")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: pio_interrupt_num
		end subroutine

		integer(c_int8_t) function fpio_sm_get_pc(pio, sm) bind(C, name="fpio_sm_get_pc") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		logical(c_bool) function fpio_sm_is_exec_stalled(pio, sm) bind(C, name="fpio_sm_is_exec_stalled")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		subroutine fpio_sm_exec_wait_blocking(pio, sm, instr) bind(C, name="fpio_sm_exec_wait_blocking")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: instr
		end subroutine

		subroutine fpio_sm_set_wrap(pio, sm, wrap_target, wrap) bind(C, name="fpio_sm_set_wrap")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: wrap_target
			integer(c_int32_t), intent(in), value :: wrap
		end subroutine

		subroutine fpio_sm_set_out_pins(pio, sm, out_base, out_count) bind(C, name="fpio_sm_set_out_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: out_base
			integer(c_int32_t), intent(in), value :: out_count
		end subroutine

		subroutine fpio_sm_set_set_pins(pio, sm, set_base, set_count) bind(C, name="fpio_sm_set_set_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: set_base
			integer(c_int32_t), intent(in), value :: set_count
		end subroutine

		subroutine fpio_sm_set_in_pins(pio, sm, in_base) bind(C, name="fpio_sm_set_in_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: in_base
		end subroutine

		subroutine fpio_sm_set_sideset_pins(pio, sm, sideset_base) bind(C, name="fpio_sm_set_sideset_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: sideset_base
		end subroutine

		subroutine fpio_sm_set_jmp_pin(pio, sm, pin) bind(C, name="fpio_sm_set_jmp_pin")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: pin
		end subroutine

		subroutine fpio_sm_put(pio, sm, data) bind(C, name="fpio_sm_put")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: data
		end subroutine

		integer(c_int32_t) function fpio_sm_get(pio, sm) bind(C, name="fpio_sm_get") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		logical(c_bool) function fpio_sm_is_rx_fifo_full(pio, sm) bind(C, name="fpio_sm_is_rx_fifo_full")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		logical(c_bool) function fpio_sm_is_rx_fifo_empty(pio, sm) bind(C, name="fpio_sm_is_rx_fifo_empty")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		integer(c_int32_t) function fpio_sm_get_rx_fifo_level(pio, sm) bind(C, name="fpio_sm_get_rx_fifo_level") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		logical(c_bool) function fpio_sm_is_tx_fifo_full(pio, sm) bind(C, name="fpio_sm_is_tx_fifo_full")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		logical(c_bool) function fpio_sm_is_tx_fifo_empty(pio, sm) bind(C, name="fpio_sm_is_tx_fifo_empty")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		integer(c_int32_t) function fpio_sm_get_tx_fifo_level(pio, sm) bind(C, name="fpio_sm_get_tx_fifo_level") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		subroutine fpio_sm_put_blocking(pio, sm, data) bind(C, name="fpio_sm_put_blocking")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: data
		end subroutine

		integer(c_int32_t) function fpio_sm_get_blocking(pio, sm) bind(C, name="fpio_sm_get_blocking") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		subroutine fpio_sm_drain_tx_fifo(pio, sm) bind(C, name="fpio_sm_drain_tx_fifo")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end subroutine

		subroutine fpio_sm_set_clkdiv_int_frac8(pio, sm, div_int, div_frac8) bind(C, name="fpio_sm_set_clkdiv_int_frac8")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: div_int
			integer(c_int8_t), intent(in), value :: div_frac8
		end subroutine

		subroutine fpio_sm_set_clkdiv_int_frac(pio, sm, div_int, div_frac8) bind(C, name="fpio_sm_set_clkdiv_int_frac")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int16_t), intent(in), value :: div_int
			integer(c_int8_t), intent(in), value :: div_frac8
		end subroutine

		subroutine fpio_sm_set_clkdiv(pio, sm, div) bind(C, name="fpio_sm_set_clkdiv")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			real(c_float), intent(in), value :: div
		end subroutine

		subroutine fpio_sm_clear_fifos(pio, sm) bind(C, name="fpio_sm_clear_fifos")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end subroutine

		subroutine fpio_sm_set_pins(pio, sm, pin_values) bind(C, name="fpio_sm_set_pins")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: pin_values
		end subroutine

		subroutine fpio_sm_set_pins64(pio, sm, pin_values) bind(C, name="fpio_sm_set_pins64")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int64_t), intent(in), value :: pin_values
		end subroutine

		subroutine fpio_sm_set_pins_with_mask(pio, sm, pin_values, pin_mask) bind(C, name="fpio_sm_set_pins_with_mask")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: pin_values
			integer(c_int32_t), intent(in), value :: pin_mask
		end subroutine

		subroutine fpio_sm_set_pins_with_mask64(pio, sm, pin_values, pin_mask) bind(C, name="fpio_sm_set_pins_with_mask64")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int64_t), intent(in), value :: pin_values
			integer(c_int64_t), intent(in), value :: pin_mask
		end subroutine

		subroutine fpio_sm_set_pindirs_with_mask(pio, sm, pin_dirs, pin_mask) bind(C, name="fpio_sm_set_pindirs_with_mask")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: pin_dirs
			integer(c_int32_t), intent(in), value :: pin_mask
		end subroutine

		subroutine fpio_sm_set_pindirs_with_mask64(pio, sm, pin_dirs, pin_mask) bind(C, name="fpio_sm_set_pindirs_with_mask64")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int64_t), intent(in), value :: pin_dirs
			integer(c_int64_t), intent(in), value :: pin_mask
		end subroutine

		integer(c_int) function fpio_sm_set_consecutive_pindirs(pio, sm, pins_base, pin_count, is_out) bind(C, name="fpio_sm_set_consecutive_pindirs") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: pins_base
			integer(c_int32_t), intent(in), value :: pin_count
			logical(c_bool), intent(in), value :: is_out
		end function

		subroutine fpio_set_input_sync_bypass_with_mask(pio, bypass_enables, pin_mask) bind(C, name="fpio_set_input_sync_bypass_with_mask")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: bypass_enables
			integer(c_int32_t), intent(in), value :: pin_mask
		end subroutine

		subroutine fpio_set_input_sync_bypass_with_mask64(pio, bypass_enables, pin_mask) bind(C, name="fpio_set_input_sync_bypass_with_mask64")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int64_t), intent(in), value :: bypass_enables
			integer(c_int64_t), intent(in), value :: pin_mask
		end subroutine

		subroutine fpio_sm_claim(pio, sm) bind(C, name="fpio_sm_claim")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end subroutine

		subroutine fpio_claim_sm_mask(pio, sm_mask) bind(C, name="fpio_claim_sm_mask")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm_mask
		end subroutine

		subroutine fpio_sm_unclaim(pio, sm) bind(C, name="fpio_sm_unclaim")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end subroutine

		integer(c_int) function fpio_claim_unused_sm(pio, required) bind(C, name="fpio_claim_unused_sm") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			logical(c_bool), intent(in), value :: required
		end function

		logical(c_bool) function fpio_sm_is_claimed(pio, sm) bind(C, name="fpio_sm_is_claimed")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
		end function

		logical(c_bool) function fpio_claim_free_sm_and_add_program(program, pio_out, sm_out, offset_out) bind(C, name="fpio_claim_free_sm_and_add_program")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: program
			type(c_ptr), intent(in), value :: pio_out
			integer(c_int32_t), intent(in), value :: sm_out
			integer(c_int32_t), intent(in), value :: offset_out
		end function

		logical(c_bool) function fpio_claim_free_sm_and_add_program_for_gpio_range(program, pio_out, sm_out, offset_out, gpio_start, gpio_count, set_gpio_base) bind(C, name="fpio_claim_free_sm_and_add_program_for_gpio_range")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: program
			type(c_ptr), intent(in), value :: pio_out
			integer(c_int32_t), intent(in), value :: sm_out
			integer(c_int32_t), intent(in), value :: offset_out
			integer(c_int32_t), intent(in), value :: gpio_start
			integer(c_int32_t), intent(in), value :: gpio_count
			logical(c_bool), intent(in), value :: set_gpio_base
		end function

		subroutine fpio_remove_program_and_unclaim_sm(program, pio, sm, offset) bind(C, name="fpio_remove_program_and_unclaim_sm")
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: program
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: sm
			integer(c_int32_t), intent(in), value :: offset
		end subroutine

		integer(c_int) function fpio_get_irq_num(pio, irqn) bind(C, name="fpio_get_irq_num") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			type(c_ptr), intent(in), value :: pio
			integer(c_int32_t), intent(in), value :: irqn
		end function

		integer(c_int32_t) function fpio_get_tx_fifo_not_full_interrupt_source(sm) bind(C, name="fpio_get_tx_fifo_not_full_interrupt_source") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: sm
		end function

		integer(c_int32_t) function fpio_get_rx_fifo_not_empty_interrupt_source(sm) bind(C, name="fpio_get_rx_fifo_not_empty_interrupt_source") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: sm
		end function

	end interface

	public :: pio0, pio1, pio2
	public :: pio_sm_config, pio_program_t

	public :: pio_fifo_join_none, pio_fifo_join_tx, pio_fifo_join_rx
	public :: pio_fifo_join_txget, pio_fifo_join_txput, pio_fifo_join_putget
	public :: status_tx_lessthan, status_rx_lessthan, status_irq_set
	public :: pis_interrupt0, pis_interrupt1, pis_interrupt2, pis_interrupt3
	public :: pis_interrupt4, pis_interrupt5, pis_interrupt6, pis_interrupt7
	public :: pis_sm0_tx_fifo_not_full, pis_sm1_tx_fifo_not_full
	public :: pis_sm2_tx_fifo_not_full, pis_sm3_tx_fifo_not_full
	public :: pis_sm0_rx_fifo_not_empty, pis_sm1_rx_fifo_not_empty
	public :: pis_sm2_rx_fifo_not_empty, pis_sm3_rx_fifo_not_empty

	public :: sm_config_set_out_pin_base, sm_config_set_out_pin_count
	public :: sm_config_set_out_pins
	public :: sm_config_set_set_pin_base, sm_config_set_set_pin_count
	public :: sm_config_set_set_pins
	public :: sm_config_set_in_pin_base, sm_config_set_in_pins
	public :: sm_config_set_in_pin_count
	public :: sm_config_set_sideset_pin_base, sm_config_set_sideset_pins
	public :: sm_config_set_sideset
	public :: sm_config_set_clkdiv_int_frac8, sm_config_set_clkdiv_int_frac
	public :: pio_calculate_clkdiv8_from_float, pio_calculate_clkdiv_from_float
	public :: sm_config_set_clkdiv, sm_config_set_wrap, sm_config_set_jmp_pin
	public :: sm_config_set_in_shift, sm_config_set_out_shift
	public :: sm_config_set_fifo_join, sm_config_set_out_special
	public :: sm_config_set_mov_status, pio_get_default_sm_config

	public :: pio_get_gpio_base, pio_sm_set_config, pio_get_index
	public :: pio_get_funcsel, pio_get_instance, pio_gpio_init, pio_get_dreq
	public :: pio_set_gpio_base

	public :: pio_can_add_program, pio_can_add_program_at_offset
	public :: pio_add_program, pio_add_program_at_offset
	public :: pio_remove_program, pio_clear_instruction_memory

	public :: pio_sm_init, pio_sm_set_enabled
	public :: pio_set_sm_mask_enabled, pio_set_sm_multi_mask_enabled
	public :: pio_sm_restart, pio_restart_sm_mask
	public :: pio_sm_clkdiv_restart, pio_clkdiv_restart_sm_mask
	public :: pio_clkdiv_restart_sm_multi_mask
	public :: pio_enable_sm_mask_in_sync, pio_enable_sm_multi_mask_in_sync

	public :: pio_set_irq0_source_enabled, pio_set_irq1_source_enabled
	public :: pio_set_irq0_source_mask_enabled
	public :: pio_set_irq1_source_mask_enabled
	public :: pio_set_irqn_source_enabled
	public :: pio_set_irqn_source_mask_enabled
	public :: pio_interrupt_get, pio_interrupt_clear

	public :: pio_sm_get_pc, pio_sm_is_exec_stalled
	public :: pio_sm_exec_wait_blocking, pio_sm_set_wrap
	public :: pio_sm_set_out_pins, pio_sm_set_set_pins
	public :: pio_sm_set_in_pins, pio_sm_set_sideset_pins
	public :: pio_sm_set_jmp_pin

	public :: pio_sm_put, pio_sm_get
	public :: pio_sm_is_rx_fifo_full, pio_sm_is_rx_fifo_empty
	public :: pio_sm_get_rx_fifo_level
	public :: pio_sm_is_tx_fifo_full, pio_sm_is_tx_fifo_empty
	public :: pio_sm_get_tx_fifo_level
	public :: pio_sm_put_blocking, pio_sm_get_blocking
	public :: pio_sm_drain_tx_fifo

	public :: pio_sm_set_clkdiv_int_frac8, pio_sm_set_clkdiv_int_frac
	public :: pio_sm_set_clkdiv, pio_sm_clear_fifos

	public :: pio_sm_set_pins, pio_sm_set_pins64
	public :: pio_sm_set_pins_with_mask, pio_sm_set_pins_with_mask64
	public :: pio_sm_set_pindirs_with_mask, pio_sm_set_pindirs_with_mask64
	public :: pio_sm_set_consecutive_pindirs
	public :: pio_set_input_sync_bypass_with_mask
	public :: pio_set_input_sync_bypass_with_mask64

	public :: pio_sm_claim, pio_claim_sm_mask, pio_sm_unclaim
	public :: pio_claim_unused_sm, pio_sm_is_claimed
	public :: pio_claim_free_sm_and_add_program
	public :: pio_claim_free_sm_and_add_program_for_gpio_range
	public :: pio_remove_program_and_unclaim_sm

	public :: pio_get_irq_num
	public :: pio_get_tx_fifo_not_full_interrupt_source
	public :: pio_get_rx_fifo_not_empty_interrupt_source

contains

	!> Identifier for PIO 0 hardware instance.
	type(c_ptr) function pio0() result(pio)
		pio = fpio_pio0()
	end function

	!> Identifier for PIO 1 hardware instance.
	type(c_ptr) function pio1() result(pio)
		pio = fpio_pio1()
	end function

	!> Identifier for PIO 2 hardware instance.
	type(c_ptr) function pio2() result(pio)
		pio = fpio_pio2()
	end function

	!> Set the base of the 'out' pins in a state machine configuration
	!> 'out' pins can overlap with the 'in', 'set' and 'sideset' pins
	!> @param c Pointer to the configuration structure to modify
	!> @param out_base First pin to set as output. See `sm_config_pins` "sm_config_ pins" for more detail on pin arguments
	subroutine sm_config_set_out_pin_base(c, out_base)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: out_base
		call fsm_config_set_out_pin_base(c_loc(c), int(out_base, c_int32_t))
	end subroutine

	!> Set the 'out' pins in a state machine configuration
	!> 'out' pins can overlap with the 'in', 'set' and 'sideset' pins
	!> @param c Pointer to the configuration structure to modify
	!> @param out_base First pin to set as output. See `sm_config_pins` "sm_config_ pins" for more detail on pin arguments
	!> @param out_count 0-32 Number of pins to set.
	subroutine sm_config_set_out_pin_count(c, out_count)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: out_count
		call fsm_config_set_out_pin_count(c_loc(c), int(out_count, c_int32_t))
	end subroutine

	!> sm_config_set_out_pins.
	subroutine sm_config_set_out_pins(c, out_base, out_count)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: out_base
		integer, intent(in), value :: out_count
		call fsm_config_set_out_pins(c_loc(c), int(out_base, c_int32_t), int(out_count, c_int32_t))
	end subroutine

	!> Set the base of the 'set' pins in a state machine configuration
	!> 'set' pins can overlap with the 'in', 'out' and 'sideset' pins
	!> @param c Pointer to the configuration structure to modify
	!> @param set_base First pin to use as 'set'. See `sm_config_pins` "sm_config_ pins" for more detail on pin arguments
	subroutine sm_config_set_set_pin_base(c, set_base)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: set_base
		call fsm_config_set_set_pin_base(c_loc(c), int(set_base, c_int32_t))
	end subroutine

	!> Set the 'set' pins in a state machine configuration
	!> 'set' pins can overlap with the 'in', 'out' and 'sideset' pins
	!> @param c Pointer to the configuration structure to modify
	!> @param set_base First pin to use as 'set'. See `sm_config_pins` "sm_config_ pins" for more detail on pin arguments
	!> @param set_count 0-5 Number of pins to set.
	subroutine sm_config_set_set_pin_count(c, set_count)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: set_count
		call fsm_config_set_set_pin_count(c_loc(c), int(set_count, c_int32_t))
	end subroutine

	!> sm_config_set_set_pins.
	subroutine sm_config_set_set_pins(c, set_base, set_count)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: set_base
		integer, intent(in), value :: set_count
		call fsm_config_set_set_pins(c_loc(c), int(set_base, c_int32_t), int(set_count, c_int32_t))
	end subroutine

	!> Set the base for the 'in' pins in a state machine configuration
	!> 'in' pins can overlap with the 'out', 'set' and 'sideset' pins
	!> @param c Pointer to the configuration structure to modify
	!> @param in_base First pin to use as input. See `sm_config_pins` "sm_config_ pins" for more detail on pin arguments
	subroutine sm_config_set_in_pin_base(c, in_base)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: in_base
		call fsm_config_set_in_pin_base(c_loc(c), int(in_base, c_int32_t))
	end subroutine

	!> sm_config_set_in_pins.
	subroutine sm_config_set_in_pins(c, in_base)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: in_base
		call fsm_config_set_in_pins(c_loc(c), int(in_base, c_int32_t))
	end subroutine

	!> Set the count of 'in' pins in a state machine configuration
	!> When reading pins using the IN pin mapping, this many (low) bits will be read, with the rest taking
	!> the value zero.
	!> RP2040 does not have the ability to mask unused input pins, so the in_count must be 32
	!> @param c Pointer to the configuration structure to modify
	!> @param in_count 1-32 The number of pins to include when reading via the IN pin mapping
	subroutine sm_config_set_in_pin_count(c, in_count)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: in_count
		call fsm_config_set_in_pin_count(c_loc(c), int(in_count, c_int32_t))
	end subroutine

	!> Set the 'sideset' pins in a state machine configuration
	!> This method is identical to `sm_config_set_sideset_pin_base`, and is provided
	!> for backwards compatibility
	!> 'sideset' pins can overlap with the 'in', 'out' and 'set' pins
	!> @param c Pointer to the configuration structure to modify
	!> @param sideset_base First pin to use for 'side set'. See `sm_config_pins` "sm_config_ pins" for more detail on pin arguments
	subroutine sm_config_set_sideset_pin_base(c, sideset_base)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: sideset_base
		call fsm_config_set_sideset_pin_base(c_loc(c), int(sideset_base, c_int32_t))
	end subroutine

	!> sm_config_set_sideset_pins.
	subroutine sm_config_set_sideset_pins(c, sideset_base)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: sideset_base
		call fsm_config_set_sideset_pins(c_loc(c), int(sideset_base, c_int32_t))
	end subroutine

	!> Set the 'sideset' options in a state machine configuration
	!> @param c Pointer to the configuration structure to modify
	!> @param bit_count Number of bits to steal from delay field in the instruction for use of side set (max 5)
	!> @param optional True if the topmost side set bit is used as a flag for whether to apply side set on that instruction
	!> @param pindirs True if the side set affects pin directions rather than values
	subroutine sm_config_set_sideset(c, bit_count, optional, pindirs)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: bit_count
		logical, intent(in), value :: optional
		logical, intent(in), value :: pindirs
		call fsm_config_set_sideset(c_loc(c), int(bit_count, c_int32_t), logical(optional, c_bool), logical(pindirs, c_bool))
	end subroutine

	!> Set the state machine clock divider (from a floating point value) in a state machine configuration
	!> The clock divider slows the state machine's execution by masking the
	!> system clock on some cycles, in a repeating pattern, so that the state
	!> machine does not advance. Effectively this produces a slower clock for the
	!> state machine to run from, which can be used to generate e.g. a particular
	!> UART baud rate. See the datasheet for further detail.
	!> @param c Pointer to the configuration structure to modify
	!> @param div The fractional divisor to be set. 1 for full speed. An integer clock divisor of n
	!> will cause the state machine to run 1 cycle in every n.
	!> Note that for small n, the jitter introduced by a fractional divider (e.g. 2.5) may be unacceptable
	!> although it will depend on the use case.
	subroutine sm_config_set_clkdiv_int_frac8(c, div_int, div_frac8)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: div_int
		integer, intent(in), value :: div_frac8
		call fsm_config_set_clkdiv_int_frac8(c_loc(c), int(div_int, c_int32_t), int(div_frac8, c_int8_t))
	end subroutine

	!> sm_config_set_clkdiv_int_frac.
	subroutine sm_config_set_clkdiv_int_frac(c, div_int, div_frac8)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: div_int
		integer, intent(in), value :: div_frac8
		call fsm_config_set_clkdiv_int_frac(c_loc(c), int(div_int, c_int16_t), int(div_frac8, c_int8_t))
	end subroutine

	!> Set the state machine clock divider (from integer and fractional parts - 16:8) in a state machine configuration
	!> The clock divider can slow the state machine's execution to some rate below
	!> the system clock frequency, by enabling the state machine on some cycles
	!> but not on others, in a regular pattern. This can be used to generate e.g.
	!> a given UART baud rate. See the datasheet for further detail.
	!> @param c Pointer to the configuration structure to modify
	!> @param div_int Integer part of the divisor
	!> @param div_frac8 Fractional part in 1/256ths
	!> See sm_config_set_clkdiv()
	subroutine pio_calculate_clkdiv8_from_float(div, div_int, div_frac8)
		real, intent(in), value :: div
		integer, intent(in), value :: div_int
		integer, intent(in), value :: div_frac8
		call fpio_calculate_clkdiv8_from_float(real(div, c_float), int(div_int, c_int32_t), int(div_frac8, c_int8_t))
	end subroutine

	!> pio_calculate_clkdiv_from_float.
	subroutine pio_calculate_clkdiv_from_float(div, div_int16, div_frac8)
		real, intent(in), value :: div
		integer, intent(in), value :: div_int16
		integer, intent(in), value :: div_frac8
		call fpio_calculate_clkdiv_from_float(real(div, c_float), int(div_int16, c_int16_t), int(div_frac8, c_int8_t))
	end subroutine

	!> sm_config_set_clkdiv.
	subroutine sm_config_set_clkdiv(c, div)
		type(pio_sm_config), intent(in), target :: c
		real, intent(in), value :: div
		call fsm_config_set_clkdiv(c_loc(c), real(div, c_float))
	end subroutine

	!> Set the wrap addresses in a state machine configuration
	!> @param c Pointer to the configuration structure to modify
	!> @param wrap_target the instruction memory address to wrap to
	!> @param wrap        the instruction memory address after which to set the program counter to wrap_target
	!> if the instruction does not itself update the program_counter
	subroutine sm_config_set_wrap(c, wrap_target, wrap)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: wrap_target
		integer, intent(in), value :: wrap
		call fsm_config_set_wrap(c_loc(c), int(wrap_target, c_int32_t), int(wrap, c_int32_t))
	end subroutine

	!> Set the 'jmp' pin in a state machine configuration
	!> @param c Pointer to the configuration structure to modify
	!> @param pin The raw GPIO pin number to use as the source for a `jmp pin` instruction. See `sm_config_pins` "sm_config_ pins" for more detail on pin arguments
	subroutine sm_config_set_jmp_pin(c, pin)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: pin
		call fsm_config_set_jmp_pin(c_loc(c), int(pin, c_int32_t))
	end subroutine

	!> Setup 'in' shifting parameters in a state machine configuration
	!> @param c Pointer to the configuration structure to modify
	!> @param shift_right true to shift ISR to right, false to shift ISR to left
	!> @param autopush whether autopush is enabled
	!> @param push_threshold threshold in bits to shift in before auto/conditional re-pushing of the ISR
	subroutine sm_config_set_in_shift(c, shift_right, autopush, push_threshold)
		type(pio_sm_config), intent(in), target :: c
		logical, intent(in), value :: shift_right
		logical, intent(in), value :: autopush
		integer, intent(in), value :: push_threshold
		call fsm_config_set_in_shift(c_loc(c), logical(shift_right, c_bool), logical(autopush, c_bool), int(push_threshold, c_int32_t))
	end subroutine

	!> Get the default state machine configuration
	!> Setting | Default
	!> --------|--------
	!> Clock Divider | 1
	!> Out Pins | 0 starting at 0 (see note below)
	!> Set Pins | 0 starting at 0 (see note below)
	!> In Pins | 32 starting at 0 (see note below)
	!> Side Set Pins (base) | 0 (see note below)
	!> Side Set | disabled
	!> Wrap | wrap=31, wrap_to=0
	!> In Shift | shift_direction=right, autopush=false, push_threshold=32
	!> Out Shift | shift_direction=right, autopull=false, pull_threshold=32
	!> Jmp Pin | 0 (see note below)
	!> Out Special | sticky=false, has_enable_pin=false, enable_pin_index=0
	!> Mov Status | status_sel=STATUS_TX_LESSTHAN, n=0
	!> 
	!> Note: On RP2350B with PICO_PIO_USE_GPIO_BASE = 1, the default Out/Set/In/Side Set pin
	!> bases are actually 0 relative to the GPIO_BASE of the PIO instance the pio_sm_config
	!> is applied to, so that any pin bases which aren't explicitly specified are not included in logic related to
	!> choosing a compatible PIO instance.
	!> Therefore, for example, if you intend to use Out pins starting at pin 0 on
	!> RP2350B, you should call `sm_config_set_out_pin_base(config, 0)`, or
	!> `sm_config_set_out_pins(config, 0, count)` explicitly.
	!> @return the default state machine configuration which can then be modified.
	subroutine sm_config_set_out_shift(c, shift_right, autopull, pull_threshold)
		type(pio_sm_config), intent(in), target :: c
		logical, intent(in), value :: shift_right
		logical, intent(in), value :: autopull
		integer, intent(in), value :: pull_threshold
		call fsm_config_set_out_shift(c_loc(c), logical(shift_right, c_bool), logical(autopull, c_bool), int(pull_threshold, c_int32_t))
	end subroutine

	!> Setup the FIFO joining in a state machine configuration
	!> @param c Pointer to the configuration structure to modify
	!> @param join Specifies the join type. See `pio_fifo_join`
	subroutine sm_config_set_fifo_join(c, join)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: join
		call fsm_config_set_fifo_join(c_loc(c), int(join, c_int32_t))
	end subroutine

	!> Set special 'out' operations in a state machine configuration
	!> @param c Pointer to the configuration structure to modify
	!> @param sticky to enable 'sticky' output (i.e. re-asserting most recent OUT/SET pin values on subsequent cycles)
	!> @param has_enable_pin true to enable auxiliary OUT enable pin
	!> @param enable_bit_index Data bit index for auxiliary OUT enable.
	subroutine sm_config_set_out_special(c, sticky, has_enable_pin, enable_bit_index)
		type(pio_sm_config), intent(in), target :: c
		logical, intent(in), value :: sticky
		logical, intent(in), value :: has_enable_pin
		integer, intent(in), value :: enable_bit_index
		call fsm_config_set_out_special(c_loc(c), logical(sticky, c_bool), logical(has_enable_pin, c_bool), int(enable_bit_index, c_int32_t))
	end subroutine

	!> Set source for 'mov status' in a state machine configuration
	!> @param c Pointer to the configuration structure to modify
	!> @param status_sel the status operation selector. See `pio_mov_status_type`
	!> @param status_n parameter for the mov status operation (currently a bit count)
	subroutine sm_config_set_mov_status(c, status_sel, status_n)
		type(pio_sm_config), intent(in), target :: c
		integer, intent(in), value :: status_sel
		integer, intent(in), value :: status_n
		call fsm_config_set_mov_status(c_loc(c), int(status_sel, c_int32_t), int(status_n, c_int32_t))
	end subroutine

	!> pio_get_default_sm_config.
	function pio_get_default_sm_config() result(c)
		type(pio_sm_config), target :: c
		call fpio_get_default_sm_config(c_loc(c))
	end function

	!> Set the 'jmp' pin for a state machine
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param pin The pin number to use as the source for a `jmp pin` instruction. See `pio_sm_pins` "pio_sm_ pins" for more detail on pin arguments
	function pio_get_gpio_base(pio) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		r = fpio_get_gpio_base(pio)
	end function

	!> pio_sm_set_config.
	function pio_sm_set_config(pio, sm, config) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		type(pio_sm_config), intent(in), target :: config
		r = fpio_sm_set_config(pio, int(sm, c_int32_t), c_loc(config))
	end function

	!> Return the instance number of a PIO instance
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @return the PIO instance number (0, 1, ...)
	function pio_get_index(pio) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		r = fpio_get_index(pio)
	end function

	!> Return the funcsel number of a PIO instance
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @return the PIO instance number (0, 1, ...)
	!> See gpio_function_t
	function pio_get_funcsel(pio) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		r = fpio_get_funcsel(pio)
	end function

	!> Convert PIO instance to hardware instance
	!> @param instance Instance of PIO, 0 or 1
	!> @return the PIO hardware instance
	function pio_get_instance(instance) result(r)
		type(c_ptr) :: r
		integer, intent(in), value :: instance
		r = fpio_get_instance(int(instance, c_int32_t))
	end function

	!> Setup the function select for a GPIO to use output from the given PIO instance
	!> PIO appears as an alternate function in the GPIO muxing, just like an SPI
	!> or UART. This function configures that multiplexing to connect a given PIO
	!> instance to a GPIO. It also configures the GPIO pad to pass signals in and
	!> out, by:
	!> * Clearing the pad output disable (OD) bit
	!> * Setting the pad input enable (IE) bit
	!> * (Non-RP2040) removing pad isolation
	!> This function achieves this low-level pad setup by calling gpio_set_function()
	!> internally.
	!> Note that, if your PIO program only needs the *input* from a given GPIO,
	!> it's not necessary to select the PIO GPIO function, because PIO input
	!> paths ignore the GPIO muxing. However, you must still configure the GPIO
	!> pad itself for input.
	!> Conversely, if using PIO for both input and output on a given pin, you must
	!> select the PIO GPIO function for the given PIO instance, as well as
	!> configuring the pad for input and output. Calling this function is
	!> sufficient for both the input-only and input/output case.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param pin the GPIO pin whose function select to set
	subroutine pio_gpio_init(pio, pin)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: pin
		call fpio_gpio_init(pio, int(pin, c_int32_t))
	end subroutine

	!> Return the DREQ to use for pacing transfers to/from a particular state machine FIFO
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param is_tx true for sending data to the state machine, false for receiving data from the state machine
	function pio_get_dreq(pio, sm, is_tx) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		logical, intent(in), value :: is_tx
		r = fpio_get_dreq(pio, int(sm, c_int32_t), logical(is_tx, c_bool))
	end function

	!> Set the base GPIO base for the PIO instance
	!> Since an individual PIO accesses only 32 pins, to be able to access more pins, the PIO
	!> instance must specify a base GPIO where the instance's "pin 0" maps. For RP2350 the valid
	!> values are 0 and 16, indicating the PIO instance has access to pins 0-31, or 16-47 respectively.
	!> NOTE: This method simply changes the underlying PIO register, it does not detect or attempt
	!> to prevent any side effects this change will have on in use state machines on this PIO.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param gpio_base the GPIO base (either 0 or 16)
	!> @return PICO_OK (0) on success, error code otherwise
	function pio_set_gpio_base(pio, gpio_base) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: gpio_base
		r = fpio_set_gpio_base(pio, int(gpio_base, c_int32_t))
	end function

	!> Determine whether the given program can (at the time of the call) be loaded onto the PIO instance
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param program the program definition
	!> @return true if the program can be loaded;
	!> false if not, e.g. if there is not suitable space in the instruction memory
	function pio_can_add_program(pio, program) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		type(pio_program_t), intent(in), target :: program
		r = fpio_can_add_program(pio, c_loc(program))
	end function

	!> Determine whether the given program can (at the time of the call) be loaded onto the PIO instance starting at a particular location
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param program the program definition
	!> @param offset the instruction memory offset wanted for the start of the program
	!> @return true if the program can be loaded at that location;
	!> false if not, e.g. if there is not space in the instruction memory
	function pio_can_add_program_at_offset(pio, program, offset) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		type(pio_program_t), intent(in), target :: program
		integer, intent(in), value :: offset
		r = fpio_can_add_program_at_offset(pio, c_loc(program), int(offset, c_int32_t))
	end function

	!> Attempt to load the program
	!> See pio_can_add_program() if you need to check whether the program can be loaded
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param program the program definition
	!> @return the instruction memory offset the program is loaded at, or negative for error (for
	!> backwards compatibility with prior SDK the error value is -1 i.e. PICO_ERROR_GENERIC)
	function pio_add_program(pio, program) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		type(pio_program_t), intent(in), target :: program
		r = fpio_add_program(pio, c_loc(program))
	end function

	!> Attempt to load the program at the specified instruction memory offset
	!> See pio_can_add_program_at_offset() if you need to check whether the program can be loaded
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param program the program definition
	!> @param offset the instruction memory offset wanted for the start of the program
	!> @return the instruction memory offset the program is loaded at, or negative for error (for
	!> backwards compatibility with prior SDK the error value is -1 i.e. PICO_ERROR_GENERIC)
	function pio_add_program_at_offset(pio, program, offset) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		type(pio_program_t), intent(in), target :: program
		integer, intent(in), value :: offset
		r = fpio_add_program_at_offset(pio, c_loc(program), int(offset, c_int32_t))
	end function

	!> Remove a program from a PIO instance's instruction memory
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param program the program definition
	!> @param loaded_offset the loaded offset returned when the program was added
	subroutine pio_remove_program(pio, program, loaded_offset)
		type(c_ptr), intent(in), value :: pio
		type(pio_program_t), intent(in), target :: program
		integer, intent(in), value :: loaded_offset
		call fpio_remove_program(pio, c_loc(program), int(loaded_offset, c_int32_t))
	end subroutine

	!> Clears all of a PIO instance's instruction memory
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	subroutine pio_clear_instruction_memory(pio)
		type(c_ptr), intent(in), value :: pio
		call fpio_clear_instruction_memory(pio)
	end subroutine

	!> Resets the state machine to a consistent state, and configures it
	!> This method:
	!> - Disables the state machine (if running)
	!> - Clears the FIFOs
	!> - Applies the configuration specified by 'config'
	!> - Resets any internal state e.g. shift counters
	!> - Jumps to the initial program location given by 'initial_pc'
	!> The state machine is left disabled on return from this call.
	!> See `sm_config_pins` "sm_config_ pins" for more detail on why this method might fail on RP2350B
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param initial_pc the initial program memory offset to run from
	!> @param config the configuration to apply (or NULL to apply defaults)
	!> @return PICO_OK, or < 0 for an error (see `pico_error_codes`)
	function pio_sm_init(pio, sm, initial_pc, config) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: initial_pc
		type(pio_sm_config), intent(in), target :: config
		r = fpio_sm_init(pio, int(sm, c_int32_t), int(initial_pc, c_int32_t), c_loc(config))
	end function

	!> Enable or disable a PIO state machine
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param enabled true to enable the state machine; false to disable
	subroutine pio_sm_set_enabled(pio, sm, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		logical, intent(in), value :: enabled
		call fpio_sm_set_enabled(pio, int(sm, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Enable or disable multiple PIO state machines
	!> Note that this method just sets the enabled state of the state machine;
	!> if now enabled they continue exactly from where they left off.
	!> See pio_enable_sm_mask_in_sync() if you wish to enable multiple state machines
	!> and ensure their clock dividers are in sync.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param mask bit mask of state machine indexes to modify the enabled state of
	!> @param enabled true to enable the state machines; false to disable
	subroutine pio_set_sm_mask_enabled(pio, mask, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: mask
		logical, intent(in), value :: enabled
		call fpio_set_sm_mask_enabled(pio, int(mask, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Enable or disable multiple PIO state machines on multiple PIOs
	!> Note that this method just sets the enabled state of the state machine;
	!> if now enabled they continue exactly from where they left off.
	!> See pio_enable_sm_mask_in_sync() if you wish to enable multiple state machines
	!> and ensure their clock dividers are in sync.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param mask_prev bit mask of state machine indexes to modify the enabled state of, in the next-lower numbered PIO instance
	!> @param mask bit mask of state machine indexes to modify the enabled state of, in this PIO instance
	!> @param mask bit mask of state machine indexes to modify the enabled state of, in the next-higher numbered PIO instance
	!> @param enabled true to enable the state machines; false to disable
	subroutine pio_set_sm_multi_mask_enabled(pio, mask_prev, mask, mask_next, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: mask_prev
		integer, intent(in), value :: mask
		integer, intent(in), value :: mask_next
		logical, intent(in), value :: enabled
		call fpio_set_sm_multi_mask_enabled(pio, int(mask_prev, c_int32_t), int(mask, c_int32_t), int(mask_next, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Restart a state machine with a known internal state
	!> Clears the following on the selected state machine: input and output shift
	!> counters, the contents of the input shift register, the delay counter, the
	!> waiting-on-IRQ state, any stalled instruction written to `SMx_INSTR` or run
	!> by `OUT/MOV EXEC`, and any pin write left asserted due to `OUT_STICKY`.
	!> Not affected: the state machine's enable/running state (see
	!> pio_sm_set_enabled), its program counter, the contents of its output
	!> shift register, and its X and Y scratch registers. To restart the clock
	!> divider use `pio_sm_clkdiv_restart`; to set the program counter to a
	!> specific value, follow this call with a `JMP` via `pio_sm_exec`.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	subroutine pio_sm_restart(pio, sm)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		call fpio_sm_restart(pio, int(sm, c_int32_t))
	end subroutine

	!> Restart multiple state machines with a known internal state
	!> Performs the same operation as `pio_sm_restart` for each state machine
	!> selected in \p mask. See `pio_sm_restart` for the exact list of internal
	!> state that is cleared and what is left untouched (notably, the enable/running
	!> state and program counter are preserved).
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param mask bit mask of state machine indexes to restart (bit 0 = state machine 0, etc.)
	subroutine pio_restart_sm_mask(pio, mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: mask
		call fpio_restart_sm_mask(pio, int(mask, c_int32_t))
	end subroutine

	!> Restart a state machine's clock divider from a phase of 0
	!> Each state machine's clock divider is a free-running piece of hardware,
	!> that generates a pattern of clock enable pulses for the state machine,
	!> based *only* on the configured integer/fractional divisor. The pattern of
	!> running/halted cycles slows the state machine's execution to some
	!> controlled rate.
	!> This function clears the divider's integer and fractional phase
	!> accumulators so that it restarts this pattern from the beginning. It is
	!> called automatically by pio_sm_init() but can also be called at a later
	!> time, when you enable the state machine, to ensure precisely consistent
	!> timing each time you load and run a given PIO program.
	!> More commonly this hardware mechanism is used to synchronise the execution
	!> clocks of multiple state machines -- see pio_clkdiv_restart_sm_mask().
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	subroutine pio_sm_clkdiv_restart(pio, sm)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		call fpio_sm_clkdiv_restart(pio, int(sm, c_int32_t))
	end subroutine

	!> Restart multiple state machines' clock dividers from a phase of 0.
	!> Each state machine's clock divider is a free-running piece of hardware,
	!> that generates a pattern of clock enable pulses for the state machine,
	!> based *only* on the configured integer/fractional divisor. The pattern of
	!> running/halted cycles slows the state machine's execution to some
	!> controlled rate.
	!> This function simultaneously clears the integer and fractional phase
	!> accumulators of multiple state machines' clock dividers. If these state
	!> machines all have the same integer and fractional divisors configured,
	!> their clock dividers will run in precise deterministic lockstep from this
	!> point.
	!> With their execution clocks synchronised in this way, it is then safe to
	!> e.g. have multiple state machines performing a 'wait irq' on the same flag,
	!> and all clear it on the same cycle.
	!> Also note that this function can be called whilst state machines are
	!> running (e.g. if you have just changed the clock divisors of some state
	!> machines and wish to resynchronise them), and that disabling a state
	!> machine does not halt its clock divider: that is, if multiple state
	!> machines have their clocks synchronised, you can safely disable and
	!> re-enable one of the state machines without losing synchronisation.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param mask bit mask of state machine indexes to modify the enabled state of
	subroutine pio_clkdiv_restart_sm_mask(pio, mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: mask
		call fpio_clkdiv_restart_sm_mask(pio, int(mask, c_int32_t))
	end subroutine

	!> Restart multiple state machines' clock dividers on multiple PIOs from a phase of 0.
	!> Each state machine's clock divider is a free-running piece of hardware,
	!> that generates a pattern of clock enable pulses for the state machine,
	!> based *only* on the configured integer/fractional divisor. The pattern of
	!> running/halted cycles slows the state machine's execution to some
	!> controlled rate.
	!> This function simultaneously clears the integer and fractional phase
	!> accumulators of multiple state machines' clock dividers. If these state
	!> machines all have the same integer and fractional divisors configured,
	!> their clock dividers will run in precise deterministic lockstep from this
	!> point.
	!> With their execution clocks synchronised in this way, it is then safe to
	!> e.g. have multiple state machines performing a 'wait irq' on the same flag,
	!> and all clear it on the same cycle.
	!> Also note that this function can be called whilst state machines are
	!> running (e.g. if you have just changed the clock divisors of some state
	!> machines and wish to resynchronise them), and that disabling a state
	!> machine does not halt its clock divider: that is, if multiple state
	!> machines have their clocks synchronised, you can safely disable and
	!> re-enable one of the state machines without losing synchronisation.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param mask_prev bit mask of state machine indexes to modify the enabled state of, in the next-lower numbered PIO instance
	!> @param mask bit mask of state machine indexes to modify the enabled state of, in this PIO instance
	!> @param mask_next bit mask of state machine indexes to modify the enabled state of, in the next-higher numbered PIO instance
	subroutine pio_clkdiv_restart_sm_multi_mask(pio, mask_prev, mask, mask_next)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: mask_prev
		integer, intent(in), value :: mask
		integer, intent(in), value :: mask_next
		call fpio_clkdiv_restart_sm_multi_mask(pio, int(mask_prev, c_int32_t), int(mask, c_int32_t), int(mask_next, c_int32_t))
	end subroutine

	!> Enable multiple PIO state machines synchronizing their clock dividers
	!> This is equivalent to calling both pio_set_sm_mask_enabled() and
	!> pio_clkdiv_restart_sm_mask() on the *same* clock cycle. All state machines
	!> specified by 'mask' are started simultaneously and, assuming they have the
	!> same clock divisors, their divided clocks will stay precisely synchronised.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param mask bit mask of state machine indexes to modify the enabled state of
	subroutine pio_enable_sm_mask_in_sync(pio, mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: mask
		call fpio_enable_sm_mask_in_sync(pio, int(mask, c_int32_t))
	end subroutine

	!> Enable multiple PIO state machines on multiple PIOs synchronizing their clock dividers
	!> This is equivalent to calling both pio_set_sm_multi_mask_enabled() and
	!> pio_clkdiv_restart_sm_multi_mask() on the *same* clock cycle. All state machines
	!> specified by 'mask' are started simultaneously and, assuming they have the
	!> same clock divisors, their divided clocks will stay precisely synchronised.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param mask_prev bit mask of state machine indexes to modify the enabled state of, in the next-lower numbered PIO instance
	!> @param mask bit mask of state machine indexes to modify the enabled state of, in this PIO instance
	!> @param mask_next bit mask of state machine indexes to modify the enabled state of, in the next-higher numbered PIO instance
	subroutine pio_enable_sm_multi_mask_in_sync(pio, mask_prev, mask, mask_next)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: mask_prev
		integer, intent(in), value :: mask
		integer, intent(in), value :: mask_next
		call fpio_enable_sm_multi_mask_in_sync(pio, int(mask_prev, c_int32_t), int(mask, c_int32_t), int(mask_next, c_int32_t))
	end subroutine

	!> Enable/Disable a single source on a PIO's IRQ 0
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param source the source number (see `pio_interrupt_source`)
	!> @param enabled true to enable IRQ 0 for the source, false to disable.
	subroutine pio_set_irq0_source_enabled(pio, source, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: source
		logical, intent(in), value :: enabled
		call fpio_set_irq0_source_enabled(pio, int(source, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Enable/Disable a single source on a PIO's IRQ 1
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param source the source number (see `pio_interrupt_source`)
	!> @param enabled true to enable IRQ 0 for the source, false to disable.
	subroutine pio_set_irq1_source_enabled(pio, source, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: source
		logical, intent(in), value :: enabled
		call fpio_set_irq1_source_enabled(pio, int(source, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Enable/Disable multiple sources on a PIO's IRQ 0
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param source_mask Mask of bits, one for each source number (see `pio_interrupt_source`) to affect
	!> @param enabled true to enable all the sources specified in the mask on IRQ 0, false to disable all the sources specified in the mask on IRQ 0
	subroutine pio_set_irq0_source_mask_enabled(pio, source_mask, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: source_mask
		logical, intent(in), value :: enabled
		call fpio_set_irq0_source_mask_enabled(pio, int(source_mask, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Enable/Disable multiple sources on a PIO's IRQ 1
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param source_mask Mask of bits, one for each source number (see `pio_interrupt_source`) to affect
	!> @param enabled true to enable all the sources specified in the mask on IRQ 1, false to disable all the source specified in the mask on IRQ 1
	subroutine pio_set_irq1_source_mask_enabled(pio, source_mask, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: source_mask
		logical, intent(in), value :: enabled
		call fpio_set_irq1_source_mask_enabled(pio, int(source_mask, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Enable/Disable a single source on a PIO's specified (0/1) IRQ index
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param irq_index the IRQ index; either 0 or 1
	!> @param source the source number (see `pio_interrupt_source`)
	!> @param enabled true to enable the source on the specified IRQ, false to disable.
	subroutine pio_set_irqn_source_enabled(pio, irq_index, source, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: irq_index
		integer, intent(in), value :: source
		logical, intent(in), value :: enabled
		call fpio_set_irqn_source_enabled(pio, int(irq_index, c_int32_t), int(source, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Enable/Disable multiple sources on a PIO's specified (0/1) IRQ index
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param irq_index the IRQ index; either 0 or 1
	!> @param source_mask Mask of bits, one for each source number (see `pio_interrupt_source`) to affect
	!> @param enabled true to enable all the sources specified in the mask on the specified IRQ, false to disable all the sources specified in the mask on the specified IRQ
	subroutine pio_set_irqn_source_mask_enabled(pio, irq_index, source_mask, enabled)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: irq_index
		integer, intent(in), value :: source_mask
		logical, intent(in), value :: enabled
		call fpio_set_irqn_source_mask_enabled(pio, int(irq_index, c_int32_t), int(source_mask, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Determine if a particular PIO interrupt is set
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param pio_interrupt_num the PIO interrupt number 0-7
	!> @return true if corresponding PIO interrupt is currently set
	function pio_interrupt_get(pio, pio_interrupt_num) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: pio_interrupt_num
		r = fpio_interrupt_get(pio, int(pio_interrupt_num, c_int32_t))
	end function

	!> Clear a particular PIO interrupt
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param pio_interrupt_num the PIO interrupt number 0-7
	subroutine pio_interrupt_clear(pio, pio_interrupt_num)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: pio_interrupt_num
		call fpio_interrupt_clear(pio, int(pio_interrupt_num, c_int32_t))
	end subroutine

	!> Return the current program counter for a state machine
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return the program counter
	function pio_sm_get_pc(pio, sm) result(r)
		integer(c_int8_t) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_get_pc(pio, int(sm, c_int32_t))
	end function

	!> Immediately execute an instruction on a state machine and wait for it to complete
	!> This instruction is executed instead of the next instruction in the normal control flow on the state machine.
	!> Subsequent calls to this method replace the previous executed
	!> instruction if it is still running. See pio_sm_is_exec_stalled() to see if an executed instruction
	!> is still running (i.e. it is stalled on some condition)
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param instr the encoded PIO instruction
	function pio_sm_is_exec_stalled(pio, sm) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_is_exec_stalled(pio, int(sm, c_int32_t))
	end function

	!> pio_sm_exec_wait_blocking.
	subroutine pio_sm_exec_wait_blocking(pio, sm, instr)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: instr
		call fpio_sm_exec_wait_blocking(pio, int(sm, c_int32_t), int(instr, c_int32_t))
	end subroutine

	!> Set the current wrap configuration for a state machine
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param wrap_target the instruction memory address to wrap to
	!> @param wrap        the instruction memory address after which to set the program counter to wrap_target
	!> if the instruction does not itself update the program_counter
	subroutine pio_sm_set_wrap(pio, sm, wrap_target, wrap)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: wrap_target
		integer, intent(in), value :: wrap
		call fpio_sm_set_wrap(pio, int(sm, c_int32_t), int(wrap_target, c_int32_t), int(wrap, c_int32_t))
	end subroutine

	!> pio_sm_set_out_pins.
	subroutine pio_sm_set_out_pins(pio, sm, out_base, out_count)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: out_base
		integer, intent(in), value :: out_count
		call fpio_sm_set_out_pins(pio, int(sm, c_int32_t), int(out_base, c_int32_t), int(out_count, c_int32_t))
	end subroutine

	!> pio_sm_set_set_pins.
	subroutine pio_sm_set_set_pins(pio, sm, set_base, set_count)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: set_base
		integer, intent(in), value :: set_count
		call fpio_sm_set_set_pins(pio, int(sm, c_int32_t), int(set_base, c_int32_t), int(set_count, c_int32_t))
	end subroutine

	!> pio_sm_set_in_pins.
	subroutine pio_sm_set_in_pins(pio, sm, in_base)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: in_base
		call fpio_sm_set_in_pins(pio, int(sm, c_int32_t), int(in_base, c_int32_t))
	end subroutine

	!> pio_sm_set_sideset_pins.
	subroutine pio_sm_set_sideset_pins(pio, sm, sideset_base)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: sideset_base
		call fpio_sm_set_sideset_pins(pio, int(sm, c_int32_t), int(sideset_base, c_int32_t))
	end subroutine

	!> pio_sm_set_jmp_pin.
	subroutine pio_sm_set_jmp_pin(pio, sm, pin)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pin
		call fpio_sm_set_jmp_pin(pio, int(sm, c_int32_t), int(pin, c_int32_t))
	end subroutine

	!> Write a word of data to a state machine's TX FIFO, blocking if the FIFO is full
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param data the 32 bit data value
	subroutine pio_sm_put(pio, sm, data)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: data
		call fpio_sm_put(pio, int(sm, c_int32_t), int(data, c_int32_t))
	end subroutine

	!> Read a word of data from a state machine's RX FIFO, blocking if the FIFO is empty
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	function pio_sm_get(pio, sm) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_get(pio, int(sm, c_int32_t))
	end function

	!> Determine if a state machine's RX FIFO is full
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return true if the RX FIFO is full
	function pio_sm_is_rx_fifo_full(pio, sm) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_is_rx_fifo_full(pio, int(sm, c_int32_t))
	end function

	!> Determine if a state machine's RX FIFO is empty
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return true if the RX FIFO is empty
	function pio_sm_is_rx_fifo_empty(pio, sm) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_is_rx_fifo_empty(pio, int(sm, c_int32_t))
	end function

	!> Return the number of elements currently in a state machine's RX FIFO
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return the number of elements in the RX FIFO
	function pio_sm_get_rx_fifo_level(pio, sm) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_get_rx_fifo_level(pio, int(sm, c_int32_t))
	end function

	!> Determine if a state machine's TX FIFO is full
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return true if the TX FIFO is full
	function pio_sm_is_tx_fifo_full(pio, sm) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_is_tx_fifo_full(pio, int(sm, c_int32_t))
	end function

	!> Determine if a state machine's TX FIFO is empty
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return true if the TX FIFO is empty
	function pio_sm_is_tx_fifo_empty(pio, sm) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_is_tx_fifo_empty(pio, int(sm, c_int32_t))
	end function

	!> Return the number of elements currently in a state machine's TX FIFO
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return the number of elements in the TX FIFO
	function pio_sm_get_tx_fifo_level(pio, sm) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_get_tx_fifo_level(pio, int(sm, c_int32_t))
	end function

	!> pio_sm_put_blocking.
	subroutine pio_sm_put_blocking(pio, sm, data)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: data
		call fpio_sm_put_blocking(pio, int(sm, c_int32_t), int(data, c_int32_t))
	end subroutine

	!> pio_sm_get_blocking.
	function pio_sm_get_blocking(pio, sm) result(r)
		integer(c_int32_t) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_get_blocking(pio, int(sm, c_int32_t))
	end function

	!> Empty out a state machine's TX FIFO
	!> This method executes `pull` instructions on the state machine until the TX
	!> FIFO is empty. This disturbs the contents of the OSR, so see also
	!> pio_sm_clear_fifos() which clears both FIFOs but leaves the state machine's
	!> internal state undisturbed.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> See pio_sm_clear_fifos()
	subroutine pio_sm_drain_tx_fifo(pio, sm)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		call fpio_sm_drain_tx_fifo(pio, int(sm, c_int32_t))
	end subroutine

	!> set the current clock divider for a state machine
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @param div the floating point clock divider
	subroutine pio_sm_set_clkdiv_int_frac8(pio, sm, div_int, div_frac8)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: div_int
		integer, intent(in), value :: div_frac8
		call fpio_sm_set_clkdiv_int_frac8(pio, int(sm, c_int32_t), int(div_int, c_int32_t), int(div_frac8, c_int8_t))
	end subroutine

	!> pio_sm_set_clkdiv_int_frac.
	subroutine pio_sm_set_clkdiv_int_frac(pio, sm, div_int, div_frac8)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: div_int
		integer, intent(in), value :: div_frac8
		call fpio_sm_set_clkdiv_int_frac(pio, int(sm, c_int32_t), int(div_int, c_int16_t), int(div_frac8, c_int8_t))
	end subroutine

	!> pio_sm_set_clkdiv.
	subroutine pio_sm_set_clkdiv(pio, sm, div)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		real, intent(in), value :: div
		call fpio_sm_set_clkdiv(pio, int(sm, c_int32_t), real(div, c_float))
	end subroutine

	!> Clear a state machine's TX and RX FIFOs
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	subroutine pio_sm_clear_fifos(pio, sm)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		call fpio_sm_clear_fifos(pio, int(sm, c_int32_t))
	end subroutine

	!> Use a state machine to set a value on all pins for the PIO instance
	!> This method repeatedly reconfigures the target state machine's pin configuration and executes 'set' instructions to set values on all 32 pins,
	!> before restoring the state machine's pin configuration to what it was.
	!> This method is provided as a convenience to set initial pin states, and should not be used against a state machine that is enabled.
	!> Note: This method only works for pins < 32. To use with pins >= 32 call pio_sm_set_pins64
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3) to use
	!> @param pin_values the pin values to set. See `pio_sm_pins` "pio_sm_ pins" for more detail on pin arguments
	subroutine pio_sm_set_pins(pio, sm, pin_values)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pin_values
		call fpio_sm_set_pins(pio, int(sm, c_int32_t), int(pin_values, c_int32_t))
	end subroutine

	!> Use a state machine to set a value on all pins for the PIO instance
	!> This method repeatedly reconfigures the target state machine's pin configuration and executes 'set' instructions to set values on all 32 pins,
	!> before restoring the state machine's pin configuration to what it was.
	!> This method is provided as a convenience to set initial pin states, and should not be used against a state machine that is enabled.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3) to use
	!> @param pin_values the pin values to set. See `pio_sm_pins` "pio_sm_ pins" for more detail on pin arguments
	subroutine pio_sm_set_pins64(pio, sm, pin_values)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pin_values
		call fpio_sm_set_pins64(pio, int(sm, c_int32_t), int(pin_values, c_int64_t))
	end subroutine

	!> Use a state machine to set a value on multiple pins for the PIO instance
	!> This method repeatedly reconfigures the target state machine's pin configuration and executes 'set' instructions to set values on up to 32 pins,
	!> before restoring the state machine's pin configuration to what it was.
	!> This method is provided as a convenience to set initial pin states, and should not be used against a state machine that is enabled.
	!> Note: This method only works for pins < 32. To use with pins >= 32 call pio_sm_set_pins_with_mask64
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3) to use
	!> @param pin_values the pin values to set (if the corresponding bit in pin_mask is set)
	!> @param pin_mask a bit for each pin to indicate whether the corresponding pin_value for that pin should be applied. See `pio_sm_pins` "pio_sm_ pins" for more detail on pin arguments
	subroutine pio_sm_set_pins_with_mask(pio, sm, pin_values, pin_mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pin_values
		integer, intent(in), value :: pin_mask
		call fpio_sm_set_pins_with_mask(pio, int(sm, c_int32_t), int(pin_values, c_int32_t), int(pin_mask, c_int32_t))
	end subroutine

	!> Use a state machine to set a value on multiple pins for the PIO instance
	!> This method repeatedly reconfigures the target state machine's pin configuration and executes 'set' instructions to set values on all pins,
	!> before restoring the state machine's pin configuration to what it was.
	!> This method is provided as a convenience to set initial pin states, and should not be used against a state machine that is enabled.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3) to use
	!> @param pin_values the pin values to set (if the corresponding bit in pin_mask is set)
	!> @param pin_mask a bit for each pin to indicate whether the corresponding pin_value for that pin should be applied. See `pio_sm_pins` "pio_sm_ pins" for more detail on pin arguments
	subroutine pio_sm_set_pins_with_mask64(pio, sm, pin_values, pin_mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pin_values
		integer, intent(in), value :: pin_mask
		call fpio_sm_set_pins_with_mask64(pio, int(sm, c_int32_t), int(pin_values, c_int64_t), int(pin_mask, c_int64_t))
	end subroutine

	!> Use a state machine to set the pin directions for multiple pins for the PIO instance
	!> This method repeatedly reconfigures the target state machine's pin configuration and executes 'set' instructions to set pin directions on up to 32 pins,
	!> before restoring the state machine's pin configuration to what it was.
	!> This method is provided as a convenience to set initial pin directions, and should not be used against a state machine that is enabled.
	!> Note: This method only works for pins < 32. To use with pins >= 32 call pio_sm_set_pindirs_with_mask64
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3) to use
	!> @param pin_dirs the pin directions to set - 1 = out, 0 = in (if the corresponding bit in pin_mask is set)
	!> @param pin_mask a bit for each pin to indicate whether the corresponding pin_dir for that pin should be applied.
	subroutine pio_sm_set_pindirs_with_mask(pio, sm, pin_dirs, pin_mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pin_dirs
		integer, intent(in), value :: pin_mask
		call fpio_sm_set_pindirs_with_mask(pio, int(sm, c_int32_t), int(pin_dirs, c_int32_t), int(pin_mask, c_int32_t))
	end subroutine

	!> Use a state machine to set the pin directions for multiple pins for the PIO instance
	!> This method repeatedly reconfigures the target state machine's pin configuration and executes 'set' instructions to set pin directions on all pins,
	!> before restoring the state machine's pin configuration to what it was.
	!> This method is provided as a convenience to set initial pin directions, and should not be used against a state machine that is enabled.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3) to use
	!> @param pin_dirs the pin directions to set - 1 = out, 0 = in (if the corresponding bit in pin_mask is set)
	!> @param pin_mask a bit for each pin to indicate whether the corresponding pin_dir for that pin should be applied.
	subroutine pio_sm_set_pindirs_with_mask64(pio, sm, pin_dirs, pin_mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pin_dirs
		integer, intent(in), value :: pin_mask
		call fpio_sm_set_pindirs_with_mask64(pio, int(sm, c_int32_t), int(pin_dirs, c_int64_t), int(pin_mask, c_int64_t))
	end subroutine

	!> Use a state machine to set the same pin direction for multiple consecutive pins for the PIO instance
	!> This method repeatedly reconfigures the target state machine's pin configuration and executes 'set' instructions to set the pin direction on consecutive pins,
	!> before restoring the state machine's pin configuration to what it was.
	!> This method is provided as a convenience to set initial pin directions, and should not be used against a state machine that is enabled.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3) to use
	!> @param pins_base the first pin to set a direction for. See `pio_sm_pins` "pio_sm_ pins" for more detail on pin arguments
	!> @param pin_count the count of consecutive pins to set the direction for
	!> @param is_out the direction to set; true = out, false = in
	!> @return PICO_OK (0) on success, error code otherwise
	function pio_sm_set_consecutive_pindirs(pio, sm, pins_base, pin_count, is_out) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: pins_base
		integer, intent(in), value :: pin_count
		logical, intent(in), value :: is_out
		r = fpio_sm_set_consecutive_pindirs(pio, int(sm, c_int32_t), int(pins_base, c_int32_t), int(pin_count, c_int32_t), logical(is_out, c_bool))
	end function

	!> Enable/disable the input synchronizer bypass for multiple pins for the PIO instance
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param bypass_enables the values to set - 1 = enable bypass, 0 = disable bypass (if the corresponding bit in pin_mask is set)
	!> @param pin_mask a bit for each pin to indicate whether the corresponding bypass enable bit for that pin should be updated.
	subroutine pio_set_input_sync_bypass_with_mask(pio, bypass_enables, pin_mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: bypass_enables
		integer, intent(in), value :: pin_mask
		call fpio_set_input_sync_bypass_with_mask(pio, int(bypass_enables, c_int32_t), int(pin_mask, c_int32_t))
	end subroutine

	!> Enable/disable the input synchronizer bypass for multiple pins for the PIO instance
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param bypass_enables the values to set - 1 = enable bypass, 0 = disable bypass (if the corresponding bit in pin_mask is set)
	!> @param pin_mask a bit for each pin to indicate whether the corresponding bypass enable bit for that pin should be updated.
	subroutine pio_set_input_sync_bypass_with_mask64(pio, bypass_enables, pin_mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: bypass_enables
		integer, intent(in), value :: pin_mask
		call fpio_set_input_sync_bypass_with_mask64(pio, int(bypass_enables, c_int64_t), int(pin_mask, c_int64_t))
	end subroutine

	!> Mark a state machine as used
	!> Method for cooperative claiming of hardware. Will cause a panic if the state machine
	!> is already claimed. Use of this method by libraries detects accidental
	!> configurations that would fail in unpredictable ways.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	subroutine pio_sm_claim(pio, sm)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		call fpio_sm_claim(pio, int(sm, c_int32_t))
	end subroutine

	!> Mark multiple state machines as used
	!> Method for cooperative claiming of hardware. Will cause a panic if any of the state machines
	!> are already claimed. Use of this method by libraries detects accidental
	!> configurations that would fail in unpredictable ways.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm_mask Mask of state machine indexes
	subroutine pio_claim_sm_mask(pio, sm_mask)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm_mask
		call fpio_claim_sm_mask(pio, int(sm_mask, c_int32_t))
	end subroutine

	!> Mark a state machine as no longer used
	!> Method for cooperative claiming of hardware.
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	subroutine pio_sm_unclaim(pio, sm)
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		call fpio_sm_unclaim(pio, int(sm, c_int32_t))
	end subroutine

	!> Claim a free state machine on a PIO instance
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param required if true the function will panic if none are available
	!> @return the state machine index or negative if required was false, and none were free (for
	!> backwards compatibility with prior SDK the error value is -1 i.e. PICO_ERROR_GENERIC)
	function pio_claim_unused_sm(pio, required) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		logical, intent(in), value :: required
		r = fpio_claim_unused_sm(pio, logical(required, c_bool))
	end function

	!> Determine if a PIO state machine is claimed
	!> @param pio The PIO instance; e.g. `pio0`, `pio1` etc.
	!> @param sm State machine index (0..3)
	!> @return true if claimed, false otherwise
	!> See pio_sm_claim
	!> See pio_claim_sm_mask
	function pio_sm_is_claimed(pio, sm) result(r)
		logical :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		r = fpio_sm_is_claimed(pio, int(sm, c_int32_t))
	end function

	!> Finds a PIO and statemachine and adds a program into PIO memory
	!> @param program PIO program to add
	!> @param pio_out Returns the PIO hardware instance or NULL if no PIO is available
	!> @param sm_out Returns the index of the PIO state machine that was claimed
	!> @param offset_out Returns the instruction memory offset of the start of the program
	!> @return true on success, false otherwise
	!> See pio_remove_program_and_unclaim_sm
	function pio_claim_free_sm_and_add_program(program, pio_out, sm_out, offset_out) result(r)
		logical :: r
		type(pio_program_t), intent(in), target :: program
		type(c_ptr), intent(in), value :: pio_out
		integer, intent(in), value :: sm_out
		integer, intent(in), value :: offset_out
		r = fpio_claim_free_sm_and_add_program(c_loc(program), pio_out, int(sm_out, c_int32_t), int(offset_out, c_int32_t))
	end function

	!> Finds a PIO and statemachine and adds a program into PIO memory
	!> This variation of `pio_claim_free_sm_and_add_program` is useful on RP2350B where the "GPIO Base"
	!> must be set per PIO instance to either address the 32 GPIOs (0->31) or the 32 GPIOS (16-47). No single
	!> PIO instance can interact with both pins 0->15 or 32->47 at the same time.
	!> This method takes additional information about the GPIO pins needed (via gpio_start and gpio_count),
	!> and optionally will set the GPIO base (see `pio_set_gpio_base`) of an unused PIO instance if necessary
	!> @param program PIO program to add
	!> @param pio_out Returns the PIO hardware instance or NULL if no PIO is available
	!> @param sm_out Returns the index of the PIO state machine that was claimed
	!> @param offset_out Returns the instruction memory offset of the start of the program
	!> @param gpio_start the lowest GPIO number required (0-47 on RP2350B, 0-31 otherwise)
	!> @param gpio_count the count of consecutive GPIOs required
	!> @param set_gpio_base if there is no free SM on a PIO instance with the right GPIO base, and there IS an unused PIO
	!> instance, then that PIO will be reconfigured so that this method can succeed. Note
	!> this parameter is ignored when PICO_PIO_USE_GPIO_BASE=0; i.e. by default on anything other than RP2350B
	!> @return true on success, false otherwise
	!> See pio_remove_program_and_unclaim_sm
	!> Note: On RP2040 or RP2350A (strictly when PICO_PIO_USE_GPIO_BASE == 0), gpio_start + gpio_count must be <= 32
	!> for success, and the set_gpio_base parameter is ignored
	function pio_claim_free_sm_and_add_program_for_gpio_range(program, pio_out, sm_out, offset_out, gpio_start, gpio_count, set_gpio_base) result(r)
		logical :: r
		type(pio_program_t), intent(in), target :: program
		type(c_ptr), intent(in), value :: pio_out
		integer, intent(in), value :: sm_out
		integer, intent(in), value :: offset_out
		integer, intent(in), value :: gpio_start
		integer, intent(in), value :: gpio_count
		logical, intent(in), value :: set_gpio_base
		r = fpio_claim_free_sm_and_add_program_for_gpio_range(c_loc(program), pio_out, int(sm_out, c_int32_t), int(offset_out, c_int32_t), int(gpio_start, c_int32_t), int(gpio_count, c_int32_t), logical(set_gpio_base, c_bool))
	end function

	!> Removes a program from PIO memory and unclaims the state machine
	!> @param program PIO program to remove from memory
	!> @param pio PIO hardware instance being used
	!> @param sm PIO state machine that was claimed
	!> @param offset offset of the program in PIO memory
	!> See pio_claim_free_sm_and_add_program
	subroutine pio_remove_program_and_unclaim_sm(program, pio, sm, offset)
		type(pio_program_t), intent(in), target :: program
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: sm
		integer, intent(in), value :: offset
		call fpio_remove_program_and_unclaim_sm(c_loc(program), pio, int(sm, c_int32_t), int(offset, c_int32_t))
	end subroutine

	!> Return an IRQ for a PIO hardware instance
	!> @param pio PIO hardware instance
	!> @param irqn 0 for PIOx_IRQ_0 or 1 for PIOx_IRQ_1 etc where x is the PIO number
	!> @return The IRQ number to use for the PIO
	function pio_get_irq_num(pio, irqn) result(r)
		integer(c_int) :: r
		type(c_ptr), intent(in), value :: pio
		integer, intent(in), value :: irqn
		r = fpio_get_irq_num(pio, int(irqn, c_int32_t))
	end function

	!> Return the interrupt source for a state machines TX FIFO not full interrupt
	!> @param sm State machine index (0..3)
	!> @return The interrupt source number for use in `pio_set_irqn_source_enabled` or similar functions
	function pio_get_tx_fifo_not_full_interrupt_source(sm) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: sm
		r = fpio_get_tx_fifo_not_full_interrupt_source(int(sm, c_int32_t))
	end function

	!> Return the interrupt source for a state machines RX FIFO not empty interrupt
	!> @param sm State machine index (0..3)
	!> @return The interrupt source number for use in `pio_set_irqn_source_enabled` or similar functions
	function pio_get_rx_fifo_not_empty_interrupt_source(sm) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: sm
		r = fpio_get_rx_fifo_not_empty_interrupt_source(int(sm, c_int32_t))
	end function

end module pio
