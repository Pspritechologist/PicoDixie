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
			integer(c_int), intent(in), value :: gpio
			logical(c_bool), intent(in), value :: state
		end subroutine

		logical(c_bool) function fgpio_get(gpio) bind(C)
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_set_dir(gpio, out) bind(C)
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
			logical(c_bool), intent(in), value :: out
		end subroutine
	end interface

	public gpio_init, gpio_deinit, gpio_put, gpio_get, gpio_set_dir
contains

	!> Initialise a GPIO for (enabled I/O and set func to GPIO_FUNC_SIO)
	!>
	!> Clear the output enable (i.e. set to input).\
	!> Clear any output value.
	subroutine gpio_init(gpio)
		integer, intent(in), value :: gpio !> GPIO number.
		call fgpio_init(int(gpio, c_int))
	end subroutine

	!> Resets a GPIO back to the NULL function, i.e. disables it.
	subroutine gpio_deinit(gpio)
		integer, intent(in), value :: gpio !> GPIO number.
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
	end function

	!> Set a single GPIO direction.
	subroutine gpio_set_dir(gpio, out)
		integer, intent(in) :: gpio !> GPIO number.
		logical, intent(in) :: out !> True for out, false for in.
		call fgpio_set_dir(int(gpio, c_int), logical(out, c_bool))
	end subroutine

end module gpio
