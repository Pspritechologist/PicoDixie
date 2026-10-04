module pio_instructions
	use, intrinsic :: iso_c_binding

	! PIO instruction configuration constants
	integer, parameter :: pio_instr_bits_jmp = 0
	integer, parameter :: pio_instr_bits_wait = 8192
	integer, parameter :: pio_instr_bits_in = 16384
	integer, parameter :: pio_instr_bits_out = 24576
	integer, parameter :: pio_instr_bits_push = 32768
	integer, parameter :: pio_instr_bits_pull = 32896
	integer, parameter :: pio_instr_bits_mov = 40960
	integer, parameter :: pio_instr_bits_irq = 49152
	integer, parameter :: pio_instr_bits_set = 57344

	integer, parameter :: pio_pins = 0
	integer, parameter :: pio_x = 1
	integer, parameter :: pio_y = 2
	integer, parameter :: pio_null = 3 + 32 + 128
	integer, parameter :: pio_pindirs_mov = 3 + 8 + 64
	integer, parameter :: pio_pindirs = 4 + 8 + 64 + 256
	integer, parameter :: pio_pindirs_out = 4 + 8 + 64 + 128
	integer, parameter :: pio_exec_mov = 4 + 8 + 16 + 32 + 64
	integer, parameter :: pio_status = 5 + 8 + 16 + 32 + 128
	integer, parameter :: pio_pc = 5 + 8 + 32 + 64
	integer, parameter :: pio_isr = 6 + 32
	integer, parameter :: pio_osr = 7 + 16 + 32
	integer, parameter :: pio_exec_out = 7 + 8 + 32 + 64 + 128
	integer, parameter :: pio_exec = 7 + 8 + 32 + 64 + 256

	interface
		integer(c_int32_t) function fpio_encode_delay(cycles) bind(C, name="fpio_encode_delay") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: cycles
		end function

		integer(c_int32_t) function fpio_encode_sideset(sideset_bit_count, value) bind(C, name="fpio_encode_sideset") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: sideset_bit_count
			integer(c_int32_t), intent(in), value :: value
		end function

		integer(c_int32_t) function fpio_encode_sideset_opt(sideset_bit_count, value) bind(C, name="fpio_encode_sideset_opt") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: sideset_bit_count
			integer(c_int32_t), intent(in), value :: value
		end function

		integer(c_int32_t) function fpio_encode_jmp(addr) bind(C, name="fpio_encode_jmp") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_jmp_not_x(addr) bind(C, name="fpio_encode_jmp_not_x") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_jmp_x_dec(addr) bind(C, name="fpio_encode_jmp_x_dec") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_jmp_not_y(addr) bind(C, name="fpio_encode_jmp_not_y") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_jmp_y_dec(addr) bind(C, name="fpio_encode_jmp_y_dec") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_jmp_x_ne_y(addr) bind(C, name="fpio_encode_jmp_x_ne_y") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_jmp_pin(addr) bind(C, name="fpio_encode_jmp_pin") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_jmp_not_osre(addr) bind(C, name="fpio_encode_jmp_not_osre") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: addr
		end function

		integer(c_int32_t) function fpio_encode_wait_gpio(polarity, gpio) bind(C, name="fpio_encode_wait_gpio") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: polarity
			integer(c_int32_t), intent(in), value :: gpio
		end function

		integer(c_int32_t) function fpio_encode_wait_pin(polarity, pin) bind(C, name="fpio_encode_wait_pin") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: polarity
			integer(c_int32_t), intent(in), value :: pin
		end function

		integer(c_int32_t) function fpio_encode_wait_irq(polarity, relative, irq) bind(C, name="fpio_encode_wait_irq") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: polarity
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function

		integer(c_int32_t) function fpio_encode_wait_jmppin(polarity, offset) bind(C, name="fpio_encode_wait_jmppin") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: polarity
			integer(c_int32_t), intent(in), value :: offset
		end function

		integer(c_int32_t) function fpio_encode_in(src, count) bind(C, name="fpio_encode_in") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: src
			integer(c_int32_t), intent(in), value :: count
		end function

		integer(c_int32_t) function fpio_encode_out(dest, count) bind(C, name="fpio_encode_out") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: count
		end function

		integer(c_int32_t) function fpio_encode_push(if_full, block) bind(C, name="fpio_encode_push") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: if_full
			logical(c_bool), intent(in), value :: block
		end function

		integer(c_int32_t) function fpio_encode_pull(if_empty, block) bind(C, name="fpio_encode_pull") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: if_empty
			logical(c_bool), intent(in), value :: block
		end function

		integer(c_int32_t) function fpio_encode_mov(dest, src) bind(C, name="fpio_encode_mov") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: src
		end function

		integer(c_int32_t) function fpio_encode_mov_not(dest, src) bind(C, name="fpio_encode_mov_not") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: src
		end function

		integer(c_int32_t) function fpio_encode_mov_reverse(dest, src) bind(C, name="fpio_encode_mov_reverse") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: src
		end function

		integer(c_int32_t) function fpio_encode_irq_set(relative, irq) bind(C, name="fpio_encode_irq_set") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function

		integer(c_int32_t) function fpio_encode_irq_wait(relative, irq) bind(C, name="fpio_encode_irq_wait") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function

		integer(c_int32_t) function fpio_encode_irq_clear(relative, irq) bind(C, name="fpio_encode_irq_clear") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function

		integer(c_int32_t) function fpio_encode_set(dest, value) bind(C, name="fpio_encode_set") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: value
		end function

		integer(c_int32_t) function fpio_encode_nop() bind(C, name="fpio_encode_nop") result(r)
			import c_ptr, c_int, c_int32_t, c_int64_t, c_int16_t, c_int8_t, c_float, c_bool
		end function

	end interface

	public :: pio_instr_bits_jmp, pio_instr_bits_wait, pio_instr_bits_in
	public :: pio_instr_bits_out, pio_instr_bits_push, pio_instr_bits_pull
	public :: pio_instr_bits_mov, pio_instr_bits_irq, pio_instr_bits_set

	public :: pio_pins, pio_x, pio_y, pio_null
	public :: pio_pindirs_mov, pio_pindirs, pio_pindirs_out
	public :: pio_exec_mov, pio_status, pio_pc, pio_isr
	public :: pio_osr, pio_exec_out, pio_exec

	public :: pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	public :: pio_encode_jmp, pio_encode_jmp_not_x, pio_encode_jmp_x_dec
	public :: pio_encode_jmp_not_y, pio_encode_jmp_y_dec, pio_encode_jmp_x_ne_y
	public :: pio_encode_jmp_pin, pio_encode_jmp_not_osre

	public :: pio_encode_wait_gpio, pio_encode_wait_pin
	public :: pio_encode_wait_irq, pio_encode_wait_jmppin

	public :: pio_encode_in, pio_encode_out
	public :: pio_encode_push, pio_encode_pull
	public :: pio_encode_mov, pio_encode_mov_not, pio_encode_mov_reverse

	public :: pio_encode_irq_set, pio_encode_irq_wait, pio_encode_irq_clear
	public :: pio_encode_set, pio_encode_nop

contains

	!> Encode just the delay slot bits of an instruction
	!> Note: This function does not return a valid instruction encoding; instead it returns an encoding of the delay
	!> slot suitable for `OR`ing with the result of an encoding function for an actual instruction. Care should be taken when
	!> combining the results of this function with the results of `pio_encode_sideset` and `pio_encode_sideset_opt`
	!> as they share the same bits within the instruction encoding.
	!> @param cycles the number of cycles 0-31 (or less if side set is being used)
	!> @return the delay slot bits to be ORed with an instruction encoding
	function pio_encode_delay(cycles) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: cycles
		r = fpio_encode_delay(int(cycles, c_int32_t))
	end function

	!> Encode just the side set bits of an instruction (in non optional side set mode)
	!> Note: This function does not return a valid instruction encoding; instead it returns an encoding of the side set bits
	!> suitable for `OR`ing with the result of an encoding function for an actual instruction. Care should be taken when
	!> combining the results of this function with the results of `pio_encode_delay` as they share the same bits
	!> within the instruction encoding.
	!> @param sideset_bit_count number of side set bits as would be specified via `.sideset` in pioasm
	!> @param value the value to sideset on the pins
	!> @return the side set bits to be ORed with an instruction encoding
	function pio_encode_sideset(sideset_bit_count, value) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: sideset_bit_count
		integer, intent(in), value :: value
		r = fpio_encode_sideset(int(sideset_bit_count, c_int32_t), int(value, c_int32_t))
	end function

	!> Encode just the side set bits of an instruction (in optional -`opt` side set mode)
	!> Note: This function does not return a valid instruction encoding; instead it returns an encoding of the side set bits
	!> suitable for `OR`ing with the result of an encoding function for an actual instruction. Care should be taken when
	!> combining the results of this function with the results of `pio_encode_delay` as they share the same bits
	!> within the instruction encoding.
	!> @param sideset_bit_count number of side set bits as would be specified via `.sideset <n> opt` in pioasm
	!> @param value the value to sideset on the pins
	!> @return the side set bits to be ORed with an instruction encoding
	function pio_encode_sideset_opt(sideset_bit_count, value) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: sideset_bit_count
		integer, intent(in), value :: value
		r = fpio_encode_sideset_opt(int(sideset_bit_count, c_int32_t), int(value, c_int32_t))
	end function

	!> Encode an unconditional JMP instruction
	!> This is the equivalent of `JMP <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp(int(addr, c_int32_t))
	end function

	!> Encode a conditional JMP if scratch X zero instruction
	!> This is the equivalent of `JMP !X <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp_not_x(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp_not_x(int(addr, c_int32_t))
	end function

	!> Encode a conditional JMP if scratch X non-zero (and post-decrement X) instruction
	!> This is the equivalent of `JMP X-- <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp_x_dec(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp_x_dec(int(addr, c_int32_t))
	end function

	!> Encode a conditional JMP if scratch Y zero instruction
	!> This is the equivalent of `JMP !Y <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp_not_y(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp_not_y(int(addr, c_int32_t))
	end function

	!> Encode a conditional JMP if scratch Y non-zero (and post-decrement Y) instruction
	!> This is the equivalent of `JMP Y-- <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp_y_dec(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp_y_dec(int(addr, c_int32_t))
	end function

	!> Encode a conditional JMP if scratch X not equal scratch Y instruction
	!> This is the equivalent of `JMP X!=Y <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp_x_ne_y(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp_x_ne_y(int(addr, c_int32_t))
	end function

	!> Encode a conditional JMP if input pin high instruction
	!> This is the equivalent of `JMP PIN <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp_pin(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp_pin(int(addr, c_int32_t))
	end function

	!> Encode a conditional JMP if output shift register not empty instruction
	!> This is the equivalent of `JMP !OSRE <addr>`
	!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_jmp_not_osre(addr) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: addr
		r = fpio_encode_jmp_not_osre(int(addr, c_int32_t))
	end function

	!> Encode a WAIT for GPIO pin instruction
	!> This is the equivalent of `WAIT <polarity> GPIO <gpio>`
	!> Note: gpio here refers to the raw instruction encoding, which only supports 32 GPIOs. So, if you had a PIO
	!> program with `WAIT <polarity> GPIO 42` and a GPIO_BASE (see `pio_set_gpio_base`) of 16, then you'd want to do
	!> `pio_encode_wait_gpio(polarity, 42-16)` assuming you are using this function to craft instructions for `pio_sm_exec`.
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param gpio The GPIO number 0-31 relative to the state machine's GPIO_BASE (see `pio_set_gpio_base`)
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_gpio(polarity, gpio) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		integer, intent(in), value :: gpio
		r = fpio_encode_wait_gpio(logical(polarity, c_bool), int(gpio, c_int32_t))
	end function

	!> Encode a WAIT for pin instruction
	!> This is the equivalent of `WAIT <polarity> PIN <pin>`
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param pin The pin number 0-31 relative to the executing SM's input pin mapping
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_pin(polarity, pin) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		integer, intent(in), value :: pin
		r = fpio_encode_wait_pin(logical(polarity, c_bool), int(pin, c_int32_t))
	end function

	!> Encode a WAIT for IRQ instruction
	!> This is the equivalent of `WAIT <polarity> IRQ <irq> <relative>`
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param relative true for a `WAIT IRQ <irq> REL`, false for regular `WAIT IRQ <irq>`
	!> @param irq the irq number 0-7
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_irq(polarity, relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		logical, intent(in), value :: relative
		integer, intent(in), value :: irq
		r = fpio_encode_wait_irq(logical(polarity, c_bool), logical(relative, c_bool), int(irq, c_int32_t))
	end function

	!> Encode a WAIT for jmppin instruction
	!> This is the equivalent of `WAIT <polarity> JMPPIN + <offset>`
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param offset The pin offset 0-3 relative to the executing SM's jmp pin mapping
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_jmppin(polarity, offset) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		integer, intent(in), value :: offset
		r = fpio_encode_wait_jmppin(logical(polarity, c_bool), int(offset, c_int32_t))
	end function

	!> Encode an IN instruction
	!> This is the equivalent of `IN <src>, <count>`
	!> @param src The source to take data from
	!> @param count The number of bits 1-32
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_in(src, count) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: src
		integer, intent(in), value :: count
		r = fpio_encode_in(int(src, c_int32_t), int(count, c_int32_t))
	end function

	!> Encode an OUT instruction
	!> This is the equivalent of `OUT <src>, <count>`
	!> @param dest The destination to write data to
	!> @param count The number of bits 1-32
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_out(dest, count) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: dest
		integer, intent(in), value :: count
		r = fpio_encode_out(int(dest, c_int32_t), int(count, c_int32_t))
	end function

	!> Encode a PUSH instruction
	!> This is the equivalent of `PUSH <if_full>, <block>`
	!> @param if_full true for `PUSH IF_FULL ...`, false for `PUSH ...`
	!> @param block true for `PUSH ... BLOCK`, false for `PUSH ...`
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_push(if_full, block) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: if_full
		logical, intent(in), value :: block
		r = fpio_encode_push(logical(if_full, c_bool), logical(block, c_bool))
	end function

	!> Encode a PULL instruction
	!> This is the equivalent of `PULL <if_empty>, <block>`
	!> @param if_empty true for `PULL IF_EMPTY ...`, false for `PULL ...`
	!> @param block true for `PULL ... BLOCK`, false for `PULL ...`
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_pull(if_empty, block) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: if_empty
		logical, intent(in), value :: block
		r = fpio_encode_pull(logical(if_empty, c_bool), logical(block, c_bool))
	end function

	!> Encode a NOP instruction
	!> This is the equivalent of `NOP` which is itself encoded as `MOV y, y`
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_mov(dest, src) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: dest
		integer, intent(in), value :: src
		r = fpio_encode_mov(int(dest, c_int32_t), int(src, c_int32_t))
	end function

	!> Encode a MOV instruction with bit invert
	!> This is the equivalent of `MOV <dest>, ~<src>`
	!> @param dest The destination to write inverted data to
	!> @param src The source to take data from
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_mov_not(dest, src) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: dest
		integer, intent(in), value :: src
		r = fpio_encode_mov_not(int(dest, c_int32_t), int(src, c_int32_t))
	end function

	!> Encode a MOV instruction with bit reverse
	!> This is the equivalent of `MOV <dest>, ::<src>`
	!> @param dest The destination to write bit reversed data to
	!> @param src The source to take data from
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_mov_reverse(dest, src) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: dest
		integer, intent(in), value :: src
		r = fpio_encode_mov_reverse(int(dest, c_int32_t), int(src, c_int32_t))
	end function

	!> Encode a IRQ SET instruction
	!> This is the equivalent of `IRQ SET <irq> <relative>`
	!> @param relative true for a `IRQ SET <irq> REL`, false for regular `IRQ SET <irq>`
	!> @param irq the irq number 0-7
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_irq_set(relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: relative
		integer, intent(in), value :: irq
		r = fpio_encode_irq_set(logical(relative, c_bool), int(irq, c_int32_t))
	end function

	!> Encode a IRQ WAIT instruction
	!> This is the equivalent of `IRQ WAIT <irq> <relative>`
	!> @param relative true for a `IRQ WAIT <irq> REL`, false for regular `IRQ WAIT <irq>`
	!> @param irq the irq number 0-7
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_irq_wait(relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: relative
		integer, intent(in), value :: irq
		r = fpio_encode_irq_wait(logical(relative, c_bool), int(irq, c_int32_t))
	end function

	!> Encode a IRQ CLEAR instruction
	!> This is the equivalent of `IRQ CLEAR <irq> <relative>`
	!> @param relative true for a `IRQ CLEAR <irq> REL`, false for regular `IRQ CLEAR <irq>`
	!> @param irq the irq number 0-7
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_irq_clear(relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: relative
		integer, intent(in), value :: irq
		r = fpio_encode_irq_clear(logical(relative, c_bool), int(irq, c_int32_t))
	end function

	!> Encode a SET instruction
	!> This is the equivalent of `SET <dest>, <value>`
	!> @param dest The destination to apply the value to
	!> @param value The value 0-31
	!> @return The instruction encoding with 0 delay and no side set value
	!> See pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_set(dest, value) result(r)
		integer(c_int32_t) :: r
		integer, intent(in), value :: dest
		integer, intent(in), value :: value
		r = fpio_encode_set(int(dest, c_int32_t), int(value, c_int32_t))
	end function

	!> pio_encode_nop.
	function pio_encode_nop() result(r)
		integer(c_int32_t) :: r
		r = fpio_encode_nop()
	end function

end module pio_instructions
