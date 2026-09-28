module entry
	use io, only: stdio_init_all, print
	use gpio, only: gpio_init, gpio_put

	public main

	integer :: led_pin = 25

	contains
	subroutine main()

		call stdio_init_all
		call gpio_init(led_pin)

		call print("OWO what's this?")
		
		do
			call gpio_put(led_pin, .true.)
			! call sleep(20)
			call gpio_put(led_pin, .false.)
		end do
	end subroutine
end module
