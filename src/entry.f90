program pico
	use io, only: stdio_init_all, sleep_ms, sleep_us
	use gpio, only: gpio_init, gpio_put, gpio_set_dir
	use pio
	use pio_instructions

	integer :: led_pin = 25
	integer :: clk_pin = 17
	integer :: dout_pin = 18
	integer :: le_pin = 19
	integer :: bl_pin = 20

	integer pio_asm(32)
	integer offset
	integer sm
	type(pio_program_t) pio_prog
	type(pio_sm_config) pio_cfg

	call init
	call sleep_ms(5000)
	print *, '- Princeton'

	! pio assembly
	pio_asm(:) = pio_encode_nop()
	pio_asm(:3) = [ &
		ior(pio_encode_set(pio_pins, 1), pio_encode_delay(31)), &
		ior(pio_encode_set(pio_pins, 0), pio_encode_delay(30)), &
		pio_encode_jmp(0) &
	]

	call make_program(pio_prog, pio_asm(:3))
	print *, 'made program'

	sm = pio_claim_unused_sm(pio0(), .true.)
	print *, 'claim sm'
	offset = pio_add_program(pio0(), pio_prog)
	print *, 'add program'
	pio_cfg = pio_get_default_sm_config()
	print *, 'configured sm'

	call sm_config_set_set_pins(pio_cfg, clk_pin, 1)
	! call

	call pio_gpio_init(pio0(), clk_pin)
	call assert(pio_sm_set_consecutive_pindirs(pio0(), sm, clk_pin, 1, .true.), 'failed to set cons_dirs')
	call assert(pio_sm_init(pio0(), sm, offset, pio_cfg), 'failed to init state machine')
	! call pio_sm_set_wrap(pio0(), sm, offset + 1, offset + 2)
	print *, 'set pins'
	call pio_sm_set_enabled(pio0(), sm, .true.)

	! runtime loop
	do
		call sleep_ms(5000)
		print *, 'I am thriving'
		! call run_clock
	end do

contains
	! Creates a PIO program from instructions
	subroutine make_program(pio_program, instructions)
		use iso_c_binding, only: c_null_ptr, c_int8_t, c_int32_t, c_loc
		use pio, only: pio_program_t, pio0, pio_add_program

		type(pio_program_t), intent(out) :: pio_program
		integer(c_int32_t), target, intent(in) :: instructions(:)

		pio_program = pio_program_t(instructions=c_loc(instructions), length=size(instructions, kind=c_int8_t), origin=-1, pio_version=0, used_gpio_ranges=0)
	end subroutine

	! error handling
	subroutine assert(ok, msg)
		integer, intent(in) :: ok
		character(*), intent(in) :: msg
		if (ok .ne. 0) error stop msg
	end subroutine

	! ! 0.5 Mhz clock
	! subroutine run_clock()
	! 	logical :: led_state = .false.

	! 	call gpio_put(led_pin, state)
	! 	led_state = .not. state
	! 	call sleep_us(1_8)
	! 	call gpio_put(clk_pin, .true.)
	! 	call sleep_us(1_8)
	! 	call gpio_put(clk_pin, .false.)
	! end subroutine

	subroutine init()
		call stdio_init_all

		call gpio_init(led_pin)
		call gpio_set_dir(led_pin, .true.)

		call gpio_init(clk_pin)
		call gpio_set_dir(clk_pin, .true.)

		call gpio_init(dout_pin)
		call gpio_set_dir(dout_pin, .true.)

		call gpio_init(le_pin)
		call gpio_set_dir(le_pin, .true.)

		call gpio_init(bl_pin)
		call gpio_set_dir(bl_pin, .true.)
	end subroutine
end program
