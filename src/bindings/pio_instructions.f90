module pio_instructions
	use, intrinsic :: iso_c_binding

	integer(c_int32_t), parameter :: pio_instr_bits_jmp = 0
	integer(c_int32_t), parameter :: pio_instr_bits_wait = 8192
	integer(c_int32_t), parameter :: pio_instr_bits_in = 16384
	integer(c_int32_t), parameter :: pio_instr_bits_out = 24576
	integer(c_int32_t), parameter :: pio_instr_bits_push = 32768
	integer(c_int32_t), parameter :: pio_instr_bits_pull = 32896
	integer(c_int32_t), parameter :: pio_instr_bits_mov = 40960
	integer(c_int32_t), parameter :: pio_instr_bits_irq = 49152
	integer(c_int32_t), parameter :: pio_instr_bits_set = 57344
	integer(c_int32_t), parameter :: pio_pins = 0
	integer(c_int32_t), parameter :: pio_x = 1
	integer(c_int32_t), parameter :: pio_y = 2
	integer(c_int32_t), parameter :: pio_null = 163
	integer(c_int32_t), parameter :: pio_pindirs_mov = 75
	integer(c_int32_t), parameter :: pio_pindirs = 332
	integer(c_int32_t), parameter :: pio_pindirs_out = 204
	integer(c_int32_t), parameter :: pio_exec_mov = 124
	integer(c_int32_t), parameter :: pio_status = 189
	integer(c_int32_t), parameter :: pio_pc = 109
	integer(c_int32_t), parameter :: pio_isr = 38
	integer(c_int32_t), parameter :: pio_osr = 55
	integer(c_int32_t), parameter :: pio_exec_out = 239
	integer(c_int32_t), parameter :: pio_exec = 367

	interface
		!> @brief Encode just the delay slot bits of an instruction
		!>  
		!>
		!> @note This function does not return a valid instruction encoding; instead it returns an encoding of the delay
		!> slot suitable for `OR`ing with the result of an encoding function for an actual instruction. Care should be taken when
		!> combining the results of this function with the results of pio_encode_sideset and pio_encode_sideset_opt
		!> as they share the same bits within the instruction encoding.
		!>
		!> @param cycles the number of cycles 0-31 (or less if side set is being used)
		!>
		!> @returns the delay slot bits to be ORed with an instruction encoding
		integer(c_int32_t) function pio_encode_delay(cycles) bind(C, name="fpio_pio_encode_delay") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: cycles
		end function
		!> @brief Encode just the side set bits of an instruction (in non optional side set mode)
		!>  
		!>
		!> @note This function does not return a valid instruction encoding; instead it returns an encoding of the side set bits
		!> suitable for `OR`ing with the result of an encoding function for an actual instruction. Care should be taken when
		!> combining the results of this function with the results of pio_encode_delay as they share the same bits
		!> within the instruction encoding.
		!>
		!> @param sideset_bit_count number of side set bits as would be specified via `.sideset` in pioasm
		!> @param value the value to sideset on the pins
		!>
		!> @returns the side set bits to be ORed with an instruction encoding
		integer(c_int32_t) function pio_encode_sideset(sideset_bit_count, value) bind(C, name="fpio_pio_encode_sideset") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: sideset_bit_count
			integer(c_int32_t), intent(in), value :: value
		end function
		!> @brief Encode just the side set bits of an instruction (in optional -`opt` side set mode)
		!>  
		!>
		!> @note This function does not return a valid instruction encoding; instead it returns an encoding of the side set bits
		!> suitable for `OR`ing with the result of an encoding function for an actual instruction. Care should be taken when
		!> combining the results of this function with the results of pio_encode_delay as they share the same bits
		!> within the instruction encoding.
		!>
		!> @param sideset_bit_count number of side set bits as would be specified via `.sideset <n> opt` in pioasm
		!> @param value the value to sideset on the pins
		!>
		!> @returns the side set bits to be ORed with an instruction encoding
		integer(c_int32_t) function pio_encode_sideset_opt(sideset_bit_count, value) bind(C, name="fpio_pio_encode_sideset_opt") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: sideset_bit_count
			integer(c_int32_t), intent(in), value :: value
		end function
		!> @brief Encode an unconditional JMP instruction
		!>  
		!>
		!> This is the equivalent of `JMP <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp(addr) bind(C, name="fpio_pio_encode_jmp") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a conditional JMP if scratch X zero instruction
		!>  
		!>
		!> This is the equivalent of `JMP !X <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp_not_x(addr) bind(C, name="fpio_pio_encode_jmp_not_x") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a conditional JMP if scratch X non-zero (and post-decrement X) instruction
		!>  
		!>
		!> This is the equivalent of `JMP X-- <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp_x_dec(addr) bind(C, name="fpio_pio_encode_jmp_x_dec") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a conditional JMP if scratch Y zero instruction
		!>  
		!>
		!> This is the equivalent of `JMP !Y <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp_not_y(addr) bind(C, name="fpio_pio_encode_jmp_not_y") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a conditional JMP if scratch Y non-zero (and post-decrement Y) instruction
		!>  
		!>
		!> This is the equivalent of `JMP Y-- <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp_y_dec(addr) bind(C, name="fpio_pio_encode_jmp_y_dec") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a conditional JMP if scratch X not equal scratch Y instruction
		!>  
		!>
		!> This is the equivalent of `JMP X!=Y <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp_x_ne_y(addr) bind(C, name="fpio_pio_encode_jmp_x_ne_y") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a conditional JMP if input pin high instruction
		!>  
		!>
		!> This is the equivalent of `JMP PIN <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp_pin(addr) bind(C, name="fpio_pio_encode_jmp_pin") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a conditional JMP if output shift register not empty instruction
		!>  
		!>
		!> This is the equivalent of `JMP !OSRE <addr>`
		!>
		!> @param addr The target address 0-31 (an absolute address within the PIO instruction memory)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_jmp_not_osre(addr) bind(C, name="fpio_pio_encode_jmp_not_osre") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: addr
		end function
		!> @brief Encode a WAIT for GPIO pin instruction
		!>  
		!>
		!> This is the equivalent of `WAIT <polarity> GPIO <gpio>`
		!>
		!> @note gpio here refers to the raw instruction encoding, which only supports 32 GPIOs. So, if you had a PIO
		!> program with `WAIT <polarity> GPIO 42` and a GPIO_BASE (see pio_set_gpio_base) of 16, then you'd want to do
		!> `pio_encode_wait_gpio(polarity, 42-16)` assuming you are using this function to craft instructions for pio_sm_exec.
		!>
		!> @param polarity true for `WAIT 1`, false for `WAIT 0`
		!> @param gpio The GPIO number 0-31 relative to the state machine's GPIO_BASE (see pio_set_gpio_base)
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_wait_gpio(polarity, gpio) bind(C, name="fpio_pio_encode_wait_gpio") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: polarity
			integer(c_int32_t), intent(in), value :: gpio
		end function
		!> @brief Encode a WAIT for pin instruction
		!>  
		!>
		!> This is the equivalent of `WAIT <polarity> PIN <pin>`
		!>
		!> @param polarity true for `WAIT 1`, false for `WAIT 0`
		!> @param pin The pin number 0-31 relative to the executing SM's input pin mapping
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_wait_pin(polarity, pin) bind(C, name="fpio_pio_encode_wait_pin") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: polarity
			integer(c_int32_t), intent(in), value :: pin
		end function
		!> @brief Encode a WAIT for IRQ instruction
		!>  
		!>
		!> This is the equivalent of `WAIT <polarity> IRQ <irq> <relative>`
		!>
		!> @param polarity true for `WAIT 1`, false for `WAIT 0`
		!> @param relative true for a `WAIT IRQ <irq> REL`, false for regular `WAIT IRQ <irq>`
		!> @param irq the irq number 0-7
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_wait_irq(polarity, relative, irq) bind(C, name="fpio_pio_encode_wait_irq") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: polarity
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function
		!> @brief Encode a WAIT for jmppin instruction
		!>  
		!>
		!> This is the equivalent of `WAIT <polarity> JMPPIN + <offset>`
		!>
		!> @param polarity true for `WAIT 1`, false for `WAIT 0`
		!> @param offset The pin offset 0-3 relative to the executing SM's jmp pin mapping
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_wait_jmppin(polarity, offset) bind(C, name="fpio_pio_encode_wait_jmppin") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: polarity
			integer(c_int32_t), intent(in), value :: offset
		end function
		!> @brief Encode an IN instruction
		!>  
		!>
		!> This is the equivalent of `IN <src>, <count>`
		!>
		!> @param src The source to take data from
		!> @param count The number of bits 1-32
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_in(src, count) bind(C, name="fpio_pio_encode_in") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: src
			integer(c_int32_t), intent(in), value :: count
		end function
		!> @brief Encode an OUT instruction
		!>  
		!>
		!> This is the equivalent of `OUT <src>, <count>`
		!>
		!> @param dest The destination to write data to
		!> @param count The number of bits 1-32
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_out(dest, count) bind(C, name="fpio_pio_encode_out") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: count
		end function
		!> @brief Encode a PUSH instruction
		!>  
		!>
		!> This is the equivalent of `PUSH <if_full>, <block>`
		!>
		!> @param if_full true for `PUSH IF_FULL ...`, false for `PUSH ...`
		!> @param block true for `PUSH ... BLOCK`, false for `PUSH ...`
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_push(if_full, block) bind(C, name="fpio_pio_encode_push") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: if_full
			logical(c_bool), intent(in), value :: block
		end function
		!> @brief Encode a PULL instruction
		!>  
		!>
		!> This is the equivalent of `PULL <if_empty>, <block>`
		!>
		!> @param if_empty true for `PULL IF_EMPTY ...`, false for `PULL ...`
		!> @param block true for `PULL ... BLOCK`, false for `PULL ...`
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_pull(if_empty, block) bind(C, name="fpio_pio_encode_pull") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: if_empty
			logical(c_bool), intent(in), value :: block
		end function
		!> @brief Encode a MOV instruction
		!>  
		!>
		!> This is the equivalent of `MOV <dest>, <src>`
		!>
		!> @param dest The destination to write data to
		!> @param src The source to take data from
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_mov(dest, src) bind(C, name="fpio_pio_encode_mov") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: src
		end function
		!> @brief Encode a MOV instruction with bit invert
		!>  
		!>
		!> This is the equivalent of `MOV <dest>, ~<src>`
		!>
		!> @param dest The destination to write inverted data to
		!> @param src The source to take data from
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_mov_not(dest, src) bind(C, name="fpio_pio_encode_mov_not") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: src
		end function
		!> @brief Encode a MOV instruction with bit reverse
		!>  
		!>
		!> This is the equivalent of `MOV <dest>, ::<src>`
		!>
		!> @param dest The destination to write bit reversed data to
		!> @param src The source to take data from
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_mov_reverse(dest, src) bind(C, name="fpio_pio_encode_mov_reverse") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: src
		end function
		!> @brief Encode a IRQ SET instruction
		!>  
		!>
		!> This is the equivalent of `IRQ SET <irq> <relative>`
		!>
		!> @param relative true for a `IRQ SET <irq> REL`, false for regular `IRQ SET <irq>`
		!> @param irq the irq number 0-7
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_irq_set(relative, irq) bind(C, name="fpio_pio_encode_irq_set") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function
		!> @brief Encode a IRQ WAIT instruction
		!>  
		!>
		!> This is the equivalent of `IRQ WAIT <irq> <relative>`
		!>
		!> @param relative true for a `IRQ WAIT <irq> REL`, false for regular `IRQ WAIT <irq>`
		!> @param irq the irq number 0-7
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_irq_wait(relative, irq) bind(C, name="fpio_pio_encode_irq_wait") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function
		!> @brief Encode a IRQ CLEAR instruction
		!>  
		!>
		!> This is the equivalent of `IRQ CLEAR <irq> <relative>`
		!>
		!> @param relative true for a `IRQ CLEAR <irq> REL`, false for regular `IRQ CLEAR <irq>`
		!> @param irq the irq number 0-7
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function c_pio_encode_irq_clear(relative, irq) bind(C, name="fpio_pio_encode_irq_clear") result(r)
			import c_bool, c_int32_t
			logical(c_bool), intent(in), value :: relative
			integer(c_int32_t), intent(in), value :: irq
		end function
		!> @brief Encode a SET instruction
		!>  
		!>
		!> This is the equivalent of `SET <dest>, <value>`
		!>
		!> @param dest The destination to apply the value to
		!> @param value The value 0-31
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_set(dest, value) bind(C, name="fpio_pio_encode_set") result(r)
			import c_bool, c_int32_t
			integer(c_int32_t), intent(in), value :: dest
			integer(c_int32_t), intent(in), value :: value
		end function
		!> @brief Encode a NOP instruction
		!>  
		!>
		!> This is the equivalent of `NOP` which is itself encoded as `MOV y, y`
		!>
		!> @returns The instruction encoding with 0 delay and no side set value
		!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
		integer(c_int32_t) function pio_encode_nop() bind(C, name="fpio_pio_encode_nop") result(r)
			import c_bool, c_int32_t
		end function
	end interface

	public :: pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt, pio_encode_jmp, pio_encode_jmp_not_x, pio_encode_jmp_x_dec
	public :: pio_encode_jmp_not_y, pio_encode_jmp_y_dec, pio_encode_jmp_x_ne_y, pio_encode_jmp_pin, pio_encode_jmp_not_osre, pio_encode_wait_gpio
	public :: pio_encode_wait_pin, pio_encode_wait_irq, pio_encode_wait_jmppin, pio_encode_in, pio_encode_out, pio_encode_push
	public :: pio_encode_pull, pio_encode_mov, pio_encode_mov_not, pio_encode_mov_reverse, pio_encode_irq_set, pio_encode_irq_wait
	public :: pio_encode_irq_clear, pio_encode_set, pio_encode_nop

contains

	!> @brief Encode a WAIT for GPIO pin instruction
	!>  
	!>
	!> This is the equivalent of `WAIT <polarity> GPIO <gpio>`
	!>
	!> @note gpio here refers to the raw instruction encoding, which only supports 32 GPIOs. So, if you had a PIO
	!> program with `WAIT <polarity> GPIO 42` and a GPIO_BASE (see pio_set_gpio_base) of 16, then you'd want to do
	!> `pio_encode_wait_gpio(polarity, 42-16)` assuming you are using this function to craft instructions for pio_sm_exec.
	!>
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param gpio The GPIO number 0-31 relative to the state machine's GPIO_BASE (see pio_set_gpio_base)
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_gpio(polarity, gpio) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		integer(c_int32_t), intent(in), value :: gpio
		logical(c_bool) :: polarity_c
		polarity_c = polarity
		r = c_pio_encode_wait_gpio(polarity_c, gpio)
	end function

	!> @brief Encode a WAIT for pin instruction
	!>  
	!>
	!> This is the equivalent of `WAIT <polarity> PIN <pin>`
	!>
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param pin The pin number 0-31 relative to the executing SM's input pin mapping
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_pin(polarity, pin) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		integer(c_int32_t), intent(in), value :: pin
		logical(c_bool) :: polarity_c
		polarity_c = polarity
		r = c_pio_encode_wait_pin(polarity_c, pin)
	end function

	!> @brief Encode a WAIT for IRQ instruction
	!>  
	!>
	!> This is the equivalent of `WAIT <polarity> IRQ <irq> <relative>`
	!>
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param relative true for a `WAIT IRQ <irq> REL`, false for regular `WAIT IRQ <irq>`
	!> @param irq the irq number 0-7
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_irq(polarity, relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		logical, intent(in), value :: relative
		integer(c_int32_t), intent(in), value :: irq
		logical(c_bool) :: polarity_c
		logical(c_bool) :: relative_c
		polarity_c = polarity
		relative_c = relative
		r = c_pio_encode_wait_irq(polarity_c, relative_c, irq)
	end function

	!> @brief Encode a WAIT for jmppin instruction
	!>  
	!>
	!> This is the equivalent of `WAIT <polarity> JMPPIN + <offset>`
	!>
	!> @param polarity true for `WAIT 1`, false for `WAIT 0`
	!> @param offset The pin offset 0-3 relative to the executing SM's jmp pin mapping
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_wait_jmppin(polarity, offset) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: polarity
		integer(c_int32_t), intent(in), value :: offset
		logical(c_bool) :: polarity_c
		polarity_c = polarity
		r = c_pio_encode_wait_jmppin(polarity_c, offset)
	end function

	!> @brief Encode a PUSH instruction
	!>  
	!>
	!> This is the equivalent of `PUSH <if_full>, <block>`
	!>
	!> @param if_full true for `PUSH IF_FULL ...`, false for `PUSH ...`
	!> @param block true for `PUSH ... BLOCK`, false for `PUSH ...`
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_push(if_full, block) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: if_full
		logical, intent(in), value :: block
		logical(c_bool) :: if_full_c
		logical(c_bool) :: block_c
		if_full_c = if_full
		block_c = block
		r = c_pio_encode_push(if_full_c, block_c)
	end function

	!> @brief Encode a PULL instruction
	!>  
	!>
	!> This is the equivalent of `PULL <if_empty>, <block>`
	!>
	!> @param if_empty true for `PULL IF_EMPTY ...`, false for `PULL ...`
	!> @param block true for `PULL ... BLOCK`, false for `PULL ...`
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_pull(if_empty, block) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: if_empty
		logical, intent(in), value :: block
		logical(c_bool) :: if_empty_c
		logical(c_bool) :: block_c
		if_empty_c = if_empty
		block_c = block
		r = c_pio_encode_pull(if_empty_c, block_c)
	end function

	!> @brief Encode a IRQ SET instruction
	!>  
	!>
	!> This is the equivalent of `IRQ SET <irq> <relative>`
	!>
	!> @param relative true for a `IRQ SET <irq> REL`, false for regular `IRQ SET <irq>`
	!> @param irq the irq number 0-7
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_irq_set(relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: relative
		integer(c_int32_t), intent(in), value :: irq
		logical(c_bool) :: relative_c
		relative_c = relative
		r = c_pio_encode_irq_set(relative_c, irq)
	end function

	!> @brief Encode a IRQ WAIT instruction
	!>  
	!>
	!> This is the equivalent of `IRQ WAIT <irq> <relative>`
	!>
	!> @param relative true for a `IRQ WAIT <irq> REL`, false for regular `IRQ WAIT <irq>`
	!> @param irq the irq number 0-7
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_irq_wait(relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: relative
		integer(c_int32_t), intent(in), value :: irq
		logical(c_bool) :: relative_c
		relative_c = relative
		r = c_pio_encode_irq_wait(relative_c, irq)
	end function

	!> @brief Encode a IRQ CLEAR instruction
	!>  
	!>
	!> This is the equivalent of `IRQ CLEAR <irq> <relative>`
	!>
	!> @param relative true for a `IRQ CLEAR <irq> REL`, false for regular `IRQ CLEAR <irq>`
	!> @param irq the irq number 0-7
	!>
	!> @returns The instruction encoding with 0 delay and no side set value
	!> @see pio_encode_delay, pio_encode_sideset, pio_encode_sideset_opt
	function pio_encode_irq_clear(relative, irq) result(r)
		integer(c_int32_t) :: r
		logical, intent(in), value :: relative
		integer(c_int32_t), intent(in), value :: irq
		logical(c_bool) :: relative_c
		relative_c = relative
		r = c_pio_encode_irq_clear(relative_c, irq)
	end function

end module pio_instructions
