program pico
	use io, only: stdio_init_all, sleep_ms
	use gpio, only: gpio_init, gpio_put, gpio_set_dir

	integer :: led_pin = 25
	
	logical state

	call init

	state = .false.
	do
		state = .not. state
		call gpio_put(led_pin, state)
		print '("Pin",1x,i2.0,1x,"is",1x,l)', led_pin, state
		call sleep_ms(1000)
	end do

contains
	subroutine init()
		call stdio_init_all

		call gpio_init(led_pin)
		call gpio_set_dir(led_pin, .true.)
	end subroutine
end program
