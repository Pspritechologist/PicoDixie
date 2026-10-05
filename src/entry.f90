program pico
	use iso_c_binding, only: c_ptr
	use io, only: stdio_init_all, sleep_ms, sleep_us
	use gpio, only: gpio_init, gpio_put, gpio_set_dir
	use pio
	use pio_instructions

	use dbg

	integer sm
	type(c_ptr) pio_inst

	integer :: led_pin = 25
	! Pins must be consecutive from clk for PIO.
	integer :: clk_pin = 17
	integer :: dout_pin = 18
	integer :: le_pin = 19
	integer :: bl_pin = 20

	call init
	print *, '- Princeton'

	do
		call sleep_ms(5000)
		print *, 'I am thriving'
	end do

contains
	subroutine init()
		call stdio_init_all
		call sleep_ms(500) ! Wait a small time to allow ttys to connect.

		! call gpio_init(led_pin)
		! call gpio_set_dir(led_pin, .true.)

		call generate_pio()
	end subroutine

	subroutine generate_pio()
		integer pio_asm(32)
		integer offset
		type(pio_program_t) pio_prog
		type(pio_sm_config) cfg

		pio_asm(:) = pio_encode_nop()
		pio_asm(:3) = [ &
			ior(pio_encode_set(pio_pins, 1), pio_encode_delay(31)), &
			ior(pio_encode_set(pio_pins, 0), pio_encode_delay(30)), &
			pio_encode_jmp(0) &
		]

		call make_program(pio_asm(:3), pio_prog)

		call assert(pio_claim_free_sm_and_add_program_for_gpio_range(pio_prog, pio_inst, sm, offset, clk_pin, 4, .true.))

		cfg = pio_get_default_sm_config()
		call sm_config_set_set_pins(cfg, clk_pin, 1)
		call pio_gpio_init(pio_inst, clk_pin)
		call assert(pio_sm_set_consecutive_pindirs(pio_inst, sm, clk_pin, 1, .true.), 'failed to set pin directions')
		call assert(pio_sm_init(pio_inst, sm, offset, cfg), 'failed to init state machine')
		! call pio_sm_set_wrap(pio_inst, sm, offset + 1, offset + 2)
		call pio_sm_set_enabled(pio_inst, sm, .true.)

	end subroutine

	! Creates a PIO program from instructions
	subroutine make_program(instructions, pio_program)
		use iso_c_binding, only: c_null_ptr, c_int8_t, c_int32_t, c_loc
		use pio, only: pio_program_t, pio0, pio_add_program

		integer(c_int32_t), target, intent(in) :: instructions(:)
		type(pio_program_t), intent(out) :: pio_program

		pio_program = pio_program_t(instructions=c_loc(instructions), length=size(instructions, kind=c_int8_t), origin=-1, pio_version=0, used_gpio_ranges=0)
	end subroutine
end program
