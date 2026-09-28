program pico
	use io, only: stdio_init_all, print, sleep_ms
	use gpio, only: gpio_init, gpio_put, gpio_set_dir

	integer :: led_pin = 25

	call init
	
	do
		call gpio_put(led_pin, .true.)
		call sleep_ms(1000)
		call gpio_put(led_pin, .false.)
		call sleep_ms(1000)
	end do

contains
	subroutine init()
		call stdio_init_all

		call gpio_init(led_pin)
		call gpio_set_dir(led_pin, .true.)
	end subroutine
end program
