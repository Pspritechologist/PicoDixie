module gpio
	use, intrinsic :: iso_c_binding

	interface
		subroutine fgpio_init(gpio) bind(C, name="gpio_init")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end subroutine

		subroutine fgpio_deinit(gpio) bind(C, name="gpio_deinit")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end subroutine

		subroutine fgpio_put(gpio, state) bind(C)
			import c_int, c_bool
			integer(c_int), value, intent(in) :: gpio
			logical(c_bool), value, intent(in) :: state
		end subroutine

		logical(c_bool) function fgpio_get(gpio) bind(C)
			import c_int, c_bool
			integer(c_int), value, intent(in) :: gpio
		end function
	end interface

	public
contains

	!> Initialise a GPIO for (enabled I/O and set func to GPIO_FUNC_SIO)
	!>
	!> Clear the output enable (i.e. set to input).\
	!> Clear any output value.
	subroutine gpio_init(gpio)
		integer(c_int), intent(in), value :: gpio !> GPIO number.
		call fgpio_init(int(gpio, c_int))
	end subroutine

	!> Resets a GPIO back to the NULL function, i.e. disables it.
	subroutine gpio_deinit(gpio)
		integer(c_int), intent(in), value :: gpio !> GPIO number.
		call fgpio_deinit(int(gpio, c_int))
	end subroutine

	!> Drive a single GPIO high/low.
	subroutine gpio_put(gpio, state)
		integer gpio !> GPIO number.
		logical state !> If false, clear the GPIO, otherwise set it.
		call fgpio_put(gpio, logical(state, c_bool))
	end subroutine

	!> Get state of a single specified GPIO.
	function gpio_get(gpio) result(state)
		logical state !> Current state of the GPIO.
		integer, intent(in) :: gpio !> GPIO number.
		state = fgpio_get(int(gpio, c_int))
	end function gpio_get

end module gpio
