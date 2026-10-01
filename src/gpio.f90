module gpio
	use, intrinsic :: iso_c_binding

	!> Select HSTX as GPIO pin function.
	integer, parameter :: gpio_func_hstx = 0
	!> Select SPI as GPIO pin function.
	integer, parameter :: gpio_func_spi = 1
	!> Select UART as GPIO pin function.
	integer, parameter :: gpio_func_uart = 2
	!> Select I2C as GPIO pin function.
	integer, parameter :: gpio_func_i2c = 3
	!> Select PWM as GPIO pin function.
	integer, parameter :: gpio_func_pwm = 4
	!> Select SIO as GPIO pin function.
	integer, parameter :: gpio_func_sio = 5
	!> Select PIO0 as GPIO pin function.
	integer, parameter :: gpio_func_pio0 = 6
	!> Select PIO1 as GPIO pin function.
	integer, parameter :: gpio_func_pio1 = 7
	!> Select PIO2 as GPIO pin function.
	integer, parameter :: gpio_func_pio2 = 8
	!> Select GPCK as GPIO pin function.
	integer, parameter :: gpio_func_gpck = 9
	!> Select XIP CS1 as GPIO pin function.
	integer, parameter :: gpio_func_xip_cs1 = 9
	!> Select CORESIGHT TRACE as GPIO pin function.
	integer, parameter :: gpio_func_coresight_trace = 9
	!> Select USB as GPIO pin function.
	integer, parameter :: gpio_func_usb = 10
	!> Select UART_AUX as GPIO pin function.
	integer, parameter :: gpio_func_uart_aux = 11
	!> Select NULL as GPIO pin function.
	integer, parameter :: gpio_func_null = int(z'1f')

    !> Input value for GPIO0 \
    !> 0xffffffff [31:0]  GPIO_IN      (0x00000000)
	integer, parameter :: gpio_in = 0
    !> GPIO0 \
    !> 0xffffffff [31:0]  GPIO_OUT     (0x00000000) Set output level (1/0 -> high/low) for GPIO0	
	integer, parameter :: gpio_out = 1

	!> IRQ when the GPIO pin is a logical 0.
	integer, parameter :: gpio_irq_level_low = int(z'01')
	!> IRQ when the GPIO pin is a logical 1.
	integer, parameter :: gpio_irq_level_high = int(z'02')
	!> IRQ when the GPIO has transitioned from a logical 1 to a logical 0.
	integer, parameter :: gpio_irq_edge_fall = int(z'04')
	!> IRQ when the GPIO has transitioned from a logical 0 to a logical 1.
	integer, parameter :: gpio_irq_edge_rise = int(z'08')

	!> peripheral signal selected via `gpio_set_function`.
	integer, parameter :: gpio_override_normal = 0
	!> invert peripheral signal selected via `gpio_set_function`.
	integer, parameter :: gpio_override_invert = 1
	!> drive low/disable output.
	integer, parameter :: gpio_override_low = 2
	!> drive high/enable output.
	integer, parameter :: gpio_override_high = 3

	!> Slew rate limiting enabled.
	integer, parameter :: gpio_slew_rate_slow = 0
	!> Slew rate limiting disabled.
	integer, parameter :: gpio_slew_rate_fast = 1

	!> 2 mA nominal drive strength.
	integer, parameter :: gpio_drive_strength_2ma = 0
	!> 4 mA nominal drive strength.
	integer, parameter :: gpio_drive_strength_4ma = 1
	!> 8 mA nominal drive strength.
	integer, parameter :: gpio_drive_strength_8ma = 2
	!> 12 mA nominal drive strength.
	integer, parameter :: gpio_drive_strength_12ma = 3

	abstract interface
		subroutine gpio_irq_callback(gpio, event_mask) bind(C)
			import c_int, c_int32_t
			integer(c_int), value :: gpio
			integer(c_int32_t), value :: event_mask
		end subroutine

		subroutine gpio_irq_handler() bind(C)
		end subroutine
	end interface

	interface
		subroutine fgpio_set_function(gpio, fn) bind(C, name="gpio_set_function")
			import c_int
			integer(c_int), intent(in), value :: gpio, fn
		end subroutine

		subroutine fgpio_set_function_masked(gpio_mask, fn) bind(C, name="gpio_set_function_masked")
			import c_int, c_int32_t
			integer(c_int32_t), intent(in), value :: gpio_mask
			integer(c_int), intent(in), value :: fn
		end subroutine

		subroutine fgpio_set_function_masked64(gpio_mask, fn) bind(C, name="fgpio_set_function_masked64")
			import c_int, c_int64_t
			integer(c_int64_t), intent(in), value :: gpio_mask
			integer(c_int), intent(in), value :: fn
		end subroutine

		integer(c_int) function fgpio_get_function(gpio) bind(C, name="gpio_get_function")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_set_pulls(gpio, up, down) bind(C, name="gpio_set_pulls")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
			logical(c_bool), intent(in), value :: up, down
		end subroutine

		subroutine fgpio_pull_up(gpio) bind(C, name="fgpio_pull_up")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end subroutine

		logical(c_bool) function fgpio_is_pulled_up(gpio) bind(C, name="fgpio_is_pulled_up")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_pull_down(gpio) bind(C, name="fgpio_pull_down")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end subroutine

		logical(c_bool) function fgpio_is_pulled_down(gpio) bind(C, name="fgpio_is_pulled_down")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_disable_pulls(gpio) bind(C, name="fgpio_disable_pulls")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end subroutine

		subroutine fgpio_set_irqover(gpio, value) bind(C, name="gpio_set_irqover")
			import c_int
			integer(c_int), intent(in), value :: gpio, value
		end subroutine

		subroutine fgpio_set_outover(gpio, value) bind(C, name="gpio_set_outover")
			import c_int
			integer(c_int), intent(in), value :: gpio, value
		end subroutine

		subroutine fgpio_set_inover(gpio, value) bind(C, name="gpio_set_inover")
			import c_int
			integer(c_int), intent(in), value :: gpio, value
		end subroutine

		subroutine fgpio_set_oeover(gpio, value) bind(C, name="gpio_set_oeover")
			import c_int
			integer(c_int), intent(in), value :: gpio, value
		end subroutine

		subroutine fgpio_set_input_enabled(gpio, enabled) bind(C, name="gpio_set_input_enabled")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fgpio_set_input_hysteresis_enabled(gpio, enabled) bind(C, name="gpio_set_input_hysteresis_enabled")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		logical(c_bool) function fgpio_is_input_hysteresis_enabled(gpio) bind(C, name="gpio_is_input_hysteresis_enabled")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_set_slew_rate(gpio, slew) bind(C, name="gpio_set_slew_rate")
			import c_int
			integer(c_int), intent(in), value :: gpio, slew
		end subroutine

		integer(c_int) function fgpio_get_slew_rate(gpio) bind(C, name="gpio_get_slew_rate")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_set_drive_strength(gpio, drive) bind(C, name="gpio_set_drive_strength")
			import c_int
			integer(c_int), intent(in), value :: gpio, drive
		end subroutine

		integer(c_int) function fgpio_get_drive_strength(gpio) bind(C, name="gpio_get_drive_strength")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_set_irq_enabled(gpio, event_mask, enabled) bind(C, name="gpio_set_irq_enabled")
			import c_int, c_int32_t, c_bool
			integer(c_int), intent(in), value :: gpio
			integer(c_int32_t), intent(in), value :: event_mask
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		subroutine fgpio_set_irq_callback(callback) bind(C, name="fgpio_set_irq_callback")
			import c_funptr
			type(c_funptr), value :: callback
		end subroutine

		subroutine fgpio_set_irq_enabled_with_callback(gpio, event_mask, enabled, callback) &
			bind(C, name="fgpio_set_irq_enabled_with_callback")
			import c_int, c_int32_t, c_bool, c_funptr
			integer(c_int), intent(in), value :: gpio
			integer(c_int32_t), intent(in), value :: event_mask
			logical(c_bool), intent(in), value :: enabled
			type(c_funptr), value :: callback
		end subroutine

		subroutine fgpio_set_dormant_irq_enabled(gpio, event_mask, enabled) bind(C, name="gpio_set_dormant_irq_enabled")
			import c_int, c_int32_t, c_bool
			integer(c_int), intent(in), value :: gpio
			integer(c_int32_t), intent(in), value :: event_mask
			logical(c_bool), intent(in), value :: enabled
		end subroutine

		integer(c_int32_t) function fgpio_get_irq_event_mask(gpio) bind(C, name="fgpio_get_irq_event_mask")
			import c_int, c_int32_t
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_acknowledge_irq(gpio, event_mask) bind(C, name="fgpio_acknowledge_irq")
			import c_int, c_int32_t
			integer(c_int), intent(in), value :: gpio
			integer(c_int32_t), intent(in), value :: event_mask
		end subroutine

		subroutine fgpio_add_raw_irq_handler_with_order_priority_masked(gpio_mask, handler, order_priority) &
			bind(C, name="gpio_add_raw_irq_handler_with_order_priority_masked")
			import c_int32_t, c_int8_t, c_funptr
			integer(c_int32_t), intent(in), value :: gpio_mask
			type(c_funptr), value :: handler
			integer(c_int8_t), intent(in), value :: order_priority
		end subroutine

		subroutine fgpio_add_raw_irq_handler_with_order_priority_masked64(gpio_mask, handler, order_priority) &
			bind(C, name="gpio_add_raw_irq_handler_with_order_priority_masked64")
			import c_int64_t, c_int8_t, c_funptr
			integer(c_int64_t), intent(in), value :: gpio_mask
			type(c_funptr), value :: handler
			integer(c_int8_t), intent(in), value :: order_priority
		end subroutine

		subroutine fgpio_add_raw_irq_handler_masked(gpio_mask, handler) &
			bind(C, name="gpio_add_raw_irq_handler_masked")
			import c_int32_t, c_funptr
			integer(c_int32_t), intent(in), value :: gpio_mask
			type(c_funptr), value :: handler
		end subroutine

		subroutine fgpio_add_raw_irq_handler_masked64(gpio_mask, handler) &
			bind(C, name="gpio_add_raw_irq_handler_masked64")
			import c_int64_t, c_funptr
			integer(c_int64_t), intent(in), value :: gpio_mask
			type(c_funptr), value :: handler
		end subroutine

		subroutine fgpio_remove_raw_irq_handler_masked(gpio_mask, handler) &
			bind(C, name="gpio_remove_raw_irq_handler_masked")
			import c_int32_t, c_funptr
			integer(c_int32_t), intent(in), value :: gpio_mask
			type(c_funptr), value :: handler
		end subroutine

		subroutine fgpio_remove_raw_irq_handler_masked64(gpio_mask, handler) &
			bind(C, name="gpio_remove_raw_irq_handler_masked64")
			import c_int64_t, c_funptr
			integer(c_int64_t), intent(in), value :: gpio_mask
			type(c_funptr), value :: handler
		end subroutine

		subroutine fgpio_add_raw_irq_handler_with_order_priority(gpio, handler, order_priority) &
			bind(C, name="fgpio_add_raw_irq_handler_with_order_priority")
			import c_int, c_int8_t, c_funptr
			integer(c_int), intent(in), value :: gpio
			type(c_funptr), value :: handler
			integer(c_int8_t), intent(in), value :: order_priority
		end subroutine

		subroutine fgpio_add_raw_irq_handler(gpio, handler) bind(C, name="fgpio_add_raw_irq_handler")
			import c_int, c_funptr
			integer(c_int), intent(in), value :: gpio
			type(c_funptr), value :: handler
		end subroutine

		subroutine fgpio_remove_raw_irq_handler(gpio, handler) bind(C, name="fgpio_remove_raw_irq_handler")
			import c_int, c_funptr
			integer(c_int), intent(in), value :: gpio
			type(c_funptr), value :: handler
		end subroutine

		subroutine fgpio_init(gpio) bind(C, name="gpio_init")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end subroutine

		subroutine fgpio_deinit(gpio) bind(C, name="gpio_deinit")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end subroutine

		subroutine fgpio_init_mask(gpio_mask) bind(C, name="gpio_init_mask")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: gpio_mask
		end subroutine

		subroutine fgpio_init_mask64(gpio_mask) bind(C, name="fgpio_init_mask64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: gpio_mask
		end subroutine

		logical(c_bool) function fgpio_get(gpio) bind(C, name="fgpio_get")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
		end function

		integer(c_int32_t) function fgpio_get_all() bind(C, name="fgpio_get_all")
			import c_int32_t
		end function

		integer(c_int64_t) function fgpio_get_all64() bind(C, name="fgpio_get_all64")
			import c_int64_t
		end function

		subroutine fgpio_set_mask(mask) bind(C, name="fgpio_set_mask")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_set_mask64(mask) bind(C, name="fgpio_set_mask64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_set_mask_n(n, mask) bind(C, name="fgpio_set_mask_n")
			import c_int, c_int32_t
			integer(c_int), intent(in), value :: n
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_clr_mask(mask) bind(C, name="fgpio_clr_mask")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_clr_mask64(mask) bind(C, name="fgpio_clr_mask64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_clr_mask_n(n, mask) bind(C, name="fgpio_clr_mask_n")
			import c_int, c_int32_t
			integer(c_int), intent(in), value :: n
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_xor_mask(mask) bind(C, name="fgpio_xor_mask")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_xor_mask64(mask) bind(C, name="fgpio_xor_mask64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_xor_mask_n(n, mask) bind(C, name="fgpio_xor_mask_n")
			import c_int, c_int32_t
			integer(c_int), intent(in), value :: n
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_put_masked(mask, value) bind(C, name="fgpio_put_masked")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: mask, value
		end subroutine

		subroutine fgpio_put_masked64(mask, value) bind(C, name="fgpio_put_masked64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: mask, value
		end subroutine

		subroutine fgpio_put_masked_n(n, mask, value) bind(C, name="fgpio_put_masked_n")
			import c_int, c_int32_t
			integer(c_int), intent(in), value :: n
			integer(c_int32_t), intent(in), value :: mask, value
		end subroutine

		subroutine fgpio_put_all(value) bind(C, name="fgpio_put_all")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: value
		end subroutine

		subroutine fgpio_put_all64(value) bind(C, name="fgpio_put_all64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: value
		end subroutine

		subroutine fgpio_put(gpio, value) bind(C, name="fgpio_put")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
			logical(c_bool), intent(in), value :: value
		end subroutine

		logical(c_bool) function fgpio_get_out_level(gpio) bind(C, name="fgpio_get_out_level")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_set_dir_out_masked(mask) bind(C, name="fgpio_set_dir_out_masked")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_set_dir_out_masked64(mask) bind(C, name="fgpio_set_dir_out_masked64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_set_dir_in_masked(mask) bind(C, name="fgpio_set_dir_in_masked")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_set_dir_in_masked64(mask) bind(C, name="fgpio_set_dir_in_masked64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: mask
		end subroutine

		subroutine fgpio_set_dir_masked(mask, value) bind(C, name="fgpio_set_dir_masked")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: mask, value
		end subroutine

		subroutine fgpio_set_dir_masked64(mask, value) bind(C, name="fgpio_set_dir_masked64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: mask, value
		end subroutine

		subroutine fgpio_set_dir_all_bits(value) bind(C, name="fgpio_set_dir_all_bits")
			import c_int32_t
			integer(c_int32_t), intent(in), value :: value
		end subroutine

		subroutine fgpio_set_dir_all_bits64(value) bind(C, name="fgpio_set_dir_all_bits64")
			import c_int64_t
			integer(c_int64_t), intent(in), value :: value
		end subroutine

		subroutine fgpio_set_dir(gpio, out) bind(C, name="fgpio_set_dir")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
			logical(c_bool), intent(in), value :: out
		end subroutine

		logical(c_bool) function fgpio_is_dir_out(gpio) bind(C, name="fgpio_is_dir_out")
			import c_int, c_bool
			integer(c_int), intent(in), value :: gpio
		end function

		integer(c_int) function fgpio_get_dir(gpio) bind(C, name="fgpio_get_dir")
			import c_int
			integer(c_int), intent(in), value :: gpio
		end function

		subroutine fgpio_debug_pins_init() bind(C, name="gpio_debug_pins_init")
		end subroutine
	end interface

	public :: gpio_func_hstx, gpio_func_spi, gpio_func_uart, gpio_func_i2c
	public :: gpio_func_pwm, gpio_func_sio, gpio_func_pio0, gpio_func_pio1
	public :: gpio_func_pio2, gpio_func_gpck, gpio_func_xip_cs1
	public :: gpio_func_coresight_trace, gpio_func_usb, gpio_func_uart_aux
	public :: gpio_func_null
	public :: gpio_out, gpio_in
	public :: gpio_irq_level_low, gpio_irq_level_high
	public :: gpio_irq_edge_fall, gpio_irq_edge_rise
	public :: gpio_override_normal, gpio_override_invert
	public :: gpio_override_low, gpio_override_high
	public :: gpio_slew_rate_slow, gpio_slew_rate_fast
	public :: gpio_drive_strength_2ma, gpio_drive_strength_4ma
	public :: gpio_drive_strength_8ma, gpio_drive_strength_12ma
	public :: gpio_init, gpio_deinit, gpio_init_mask, gpio_init_mask64
	public :: gpio_set_function, gpio_set_function_masked, gpio_set_function_masked64, gpio_get_function
	public :: gpio_set_pulls, gpio_pull_up, gpio_is_pulled_up, gpio_pull_down
	public :: gpio_is_pulled_down, gpio_disable_pulls
	public :: gpio_set_irqover, gpio_set_outover, gpio_set_inover, gpio_set_oeover
	public :: gpio_set_input_enabled, gpio_set_input_hysteresis_enabled
	public :: gpio_is_input_hysteresis_enabled
	public :: gpio_set_slew_rate, gpio_get_slew_rate
	public :: gpio_set_drive_strength, gpio_get_drive_strength
	public :: gpio_set_irq_enabled, gpio_set_irq_callback
	public :: gpio_set_irq_enabled_with_callback, gpio_set_dormant_irq_enabled
	public :: gpio_get_irq_event_mask, gpio_acknowledge_irq
	public :: gpio_add_raw_irq_handler_with_order_priority_masked
	public :: gpio_add_raw_irq_handler_with_order_priority_masked64
	public :: gpio_add_raw_irq_handler_with_order_priority
	public :: gpio_add_raw_irq_handler_masked, gpio_add_raw_irq_handler_masked64
	public :: gpio_add_raw_irq_handler
	public :: gpio_remove_raw_irq_handler_masked, gpio_remove_raw_irq_handler_masked64
	public :: gpio_remove_raw_irq_handler
	public :: gpio_get, gpio_get_all, gpio_get_all64
	public :: gpio_set_mask, gpio_set_mask64, gpio_set_mask_n
	public :: gpio_clr_mask, gpio_clr_mask64, gpio_clr_mask_n
	public :: gpio_xor_mask, gpio_xor_mask64, gpio_xor_mask_n
	public :: gpio_put_masked, gpio_put_masked64, gpio_put_masked_n
	public :: gpio_put_all, gpio_put_all64, gpio_put, gpio_get_out_level
	public :: gpio_set_dir_out_masked, gpio_set_dir_out_masked64
	public :: gpio_set_dir_in_masked, gpio_set_dir_in_masked64
	public :: gpio_set_dir_masked, gpio_set_dir_masked64
	public :: gpio_set_dir_all_bits, gpio_set_dir_all_bits64
	public :: gpio_set_dir, gpio_is_dir_out, gpio_get_dir, gpio_debug_pins_init

contains

	!> Set the function for a GPIO.
	!> @param gpio GPIO number.
	!> @param fn Function selected for the GPIO.
	subroutine gpio_set_function(gpio, fn)
		integer, intent(in), value :: gpio
		integer, intent(in), value :: fn
		call fgpio_set_function(int(gpio, c_int), int(fn, c_int))
	end subroutine

	!> Set the function for GPIOs selected by a mask.
	!> @param gpio_mask GPIO mask.
	!> @param fn Function selected for the GPIOs.
	subroutine gpio_set_function_masked(gpio_mask, fn)
		integer, intent(in), value :: gpio_mask
		integer, intent(in), value :: fn
		call fgpio_set_function_masked(int(gpio_mask, c_int32_t), int(fn, c_int))
	end subroutine

	!> Set the function for GPIOs selected by a 64-bit mask.
	!> @param gpio_mask GPIO mask.
	!> @param fn Function selected for the GPIOs.
	subroutine gpio_set_function_masked64(gpio_mask, fn)
		integer(c_int64_t), intent(in), value :: gpio_mask
		integer, intent(in), value :: fn
		call fgpio_set_function_masked64(gpio_mask, int(fn, c_int))
	end subroutine

	!> Get the function selected for a GPIO.
	!> @param gpio GPIO number.
	integer function gpio_get_function(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_get_function(int(gpio, c_int))
	end function

	!> Set the pull-up and pull-down state of a GPIO.
	!> @param gpio GPIO number.
	!> @param up True to enable the pull-up.
	!> @param down True to enable the pull-down.
	subroutine gpio_set_pulls(gpio, up, down)
		integer, intent(in), value :: gpio
		logical, intent(in) :: up, down
		call fgpio_set_pulls(int(gpio, c_int), logical(up, c_bool), logical(down, c_bool))
	end subroutine

	!> Pull a GPIO up.
	!> @param gpio GPIO number.
	subroutine gpio_pull_up(gpio)
		integer, intent(in), value :: gpio
		call fgpio_pull_up(int(gpio, c_int))
	end subroutine

	!> Determine whether a GPIO is pulled up.
	!> @param gpio GPIO number.
	logical function gpio_is_pulled_up(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_is_pulled_up(int(gpio, c_int))
	end function

	!> Pull a GPIO down.
	!> @param gpio GPIO number.
	subroutine gpio_pull_down(gpio)
		integer, intent(in), value :: gpio
		call fgpio_pull_down(int(gpio, c_int))
	end subroutine

	!> Determine whether a GPIO is pulled down.
	!> @param gpio GPIO number.
	logical function gpio_is_pulled_down(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_is_pulled_down(int(gpio, c_int))
	end function

	!> Disable the pull-up and pull-down on a GPIO.
	!> @param gpio GPIO number.
	subroutine gpio_disable_pulls(gpio)
		integer, intent(in), value :: gpio
		call fgpio_disable_pulls(int(gpio, c_int))
	end subroutine

	!> Set the IRQ override for a GPIO.
	!> @param gpio GPIO number.
	!> @param value Override value.
	subroutine gpio_set_irqover(gpio, value)
		integer, intent(in), value :: gpio, value
		call fgpio_set_irqover(int(gpio, c_int), int(value, c_int))
	end subroutine

	!> Set the output override for a GPIO.
	!> @param gpio GPIO number.
	!> @param value Override value.
	subroutine gpio_set_outover(gpio, value)
		integer, intent(in), value :: gpio, value
		call fgpio_set_outover(int(gpio, c_int), int(value, c_int))
	end subroutine

	!> Set the input override for a GPIO.
	!> @param gpio GPIO number.
	!> @param value Override value.
	subroutine gpio_set_inover(gpio, value)
		integer, intent(in), value :: gpio, value
		call fgpio_set_inover(int(gpio, c_int), int(value, c_int))
	end subroutine

	!> Set the output-enable override for a GPIO.
	!> @param gpio GPIO number.
	!> @param value Override value.
	subroutine gpio_set_oeover(gpio, value)
		integer, intent(in), value :: gpio, value
		call fgpio_set_oeover(int(gpio, c_int), int(value, c_int))
	end subroutine

	!> Enable or disable GPIO input.
	!> @param gpio GPIO number.
	!> @param enabled True to enable GPIO input.
	subroutine gpio_set_input_enabled(gpio, enabled)
		integer, intent(in), value :: gpio
		logical, intent(in) :: enabled
		call fgpio_set_input_enabled(int(gpio, c_int), logical(enabled, c_bool))
	end subroutine

	!> Enable or disable input hysteresis on a GPIO.
	!> @param gpio GPIO number.
	!> @param enabled True to enable input hysteresis.
	subroutine gpio_set_input_hysteresis_enabled(gpio, enabled)
		integer, intent(in), value :: gpio
		logical, intent(in) :: enabled
		call fgpio_set_input_hysteresis_enabled(int(gpio, c_int), logical(enabled, c_bool))
	end subroutine

	!> Determine whether input hysteresis is enabled on a GPIO.
	!> @param gpio GPIO number.
	logical function gpio_is_input_hysteresis_enabled(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_is_input_hysteresis_enabled(int(gpio, c_int))
	end function

	!> Set the slew rate of a GPIO.
	!> @param gpio GPIO number.
	!> @param slew Slew rate.
	subroutine gpio_set_slew_rate(gpio, slew)
		integer, intent(in), value :: gpio, slew
		call fgpio_set_slew_rate(int(gpio, c_int), int(slew, c_int))
	end subroutine

	!> Get the slew rate of a GPIO.
	!> @param gpio GPIO number.
	integer function gpio_get_slew_rate(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_get_slew_rate(int(gpio, c_int))
	end function

	!> Set the drive strength of a GPIO.
	!> @param gpio GPIO number.
	!> @param drive Drive strength.
	subroutine gpio_set_drive_strength(gpio, drive)
		integer, intent(in), value :: gpio, drive
		call fgpio_set_drive_strength(int(gpio, c_int), int(drive, c_int))
	end subroutine

	!> Get the drive strength of a GPIO.
	!> @param gpio GPIO number.
	integer function gpio_get_drive_strength(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_get_drive_strength(int(gpio, c_int))
	end function

	!> Enable or disable a GPIO IRQ event.
	!> @param gpio GPIO number.
	!> @param event_mask IRQ event mask.
	!> @param enabled True to enable the specified IRQ event.
	subroutine gpio_set_irq_enabled(gpio, event_mask, enabled)
		integer, intent(in), value :: gpio, event_mask
		logical, intent(in) :: enabled
		call fgpio_set_irq_enabled(int(gpio, c_int), int(event_mask, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Set the callback used for GPIO IRQ events.
	!> @param callback Callback function.
	subroutine gpio_set_irq_callback(callback)
		procedure(gpio_irq_callback) :: callback
		call fgpio_set_irq_callback(c_funloc(callback))
	end subroutine

	!> Enable or disable a GPIO IRQ event and set the callback.
	!> @param gpio GPIO number.
	!> @param event_mask IRQ event mask.
	!> @param enabled True to enable the specified IRQ event.
	!> @param callback Callback function.
	subroutine gpio_set_irq_enabled_with_callback(gpio, event_mask, enabled, callback)
		integer, intent(in), value :: gpio, event_mask
		logical, intent(in) :: enabled
		procedure(gpio_irq_callback) :: callback
		call fgpio_set_irq_enabled_with_callback(int(gpio, c_int), int(event_mask, c_int32_t), &
			logical(enabled, c_bool), c_funloc(callback))
	end subroutine

	!> Enable or disable GPIO IRQ events during dormant mode.
	!> @param gpio GPIO number.
	!> @param event_mask IRQ event mask.
	!> @param enabled True to enable the specified IRQ event.
	subroutine gpio_set_dormant_irq_enabled(gpio, event_mask, enabled)
		integer, intent(in), value :: gpio, event_mask
		logical, intent(in) :: enabled
		call fgpio_set_dormant_irq_enabled(int(gpio, c_int), int(event_mask, c_int32_t), logical(enabled, c_bool))
	end subroutine

	!> Get the GPIO IRQ event mask.
	!> @param gpio GPIO number.
	integer function gpio_get_irq_event_mask(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_get_irq_event_mask(int(gpio, c_int))
	end function

	!> Acknowledge GPIO IRQ events.
	!> @param gpio GPIO number.
	!> @param event_mask IRQ event mask.
	subroutine gpio_acknowledge_irq(gpio, event_mask)
		integer, intent(in), value :: gpio, event_mask
		call fgpio_acknowledge_irq(int(gpio, c_int), int(event_mask, c_int32_t))
	end subroutine

	!> Add a raw IRQ handler for GPIOs selected by a mask, with an order priority.
	!> @param gpio_mask GPIO mask.
	!> @param handler IRQ handler.
	!> @param order_priority Order priority.
	subroutine gpio_add_raw_irq_handler_with_order_priority_masked(gpio_mask, handler, order_priority)
		integer, intent(in), value :: gpio_mask
		procedure(gpio_irq_handler) :: handler
		integer, intent(in), value :: order_priority
		call fgpio_add_raw_irq_handler_with_order_priority_masked(int(gpio_mask, c_int32_t), &
			c_funloc(handler), int(order_priority, c_int8_t))
	end subroutine

	!> Add a raw IRQ handler for GPIOs selected by a 64-bit mask, with an order priority.
	!> @param gpio_mask GPIO mask.
	!> @param handler IRQ handler.
	!> @param order_priority Order priority.
	subroutine gpio_add_raw_irq_handler_with_order_priority_masked64(gpio_mask, handler, order_priority)
		integer(c_int64_t), intent(in), value :: gpio_mask
		procedure(gpio_irq_handler) :: handler
		integer, intent(in), value :: order_priority
		call fgpio_add_raw_irq_handler_with_order_priority_masked64(gpio_mask, c_funloc(handler), &
			int(order_priority, c_int8_t))
	end subroutine

	!> Add a raw IRQ handler for a GPIO with an order priority.
	!> @param gpio GPIO number.
	!> @param handler IRQ handler.
	!> @param order_priority Order priority.
	subroutine gpio_add_raw_irq_handler_with_order_priority(gpio, handler, order_priority)
		integer, intent(in), value :: gpio
		procedure(gpio_irq_handler) :: handler
		integer, intent(in), value :: order_priority
		call fgpio_add_raw_irq_handler_with_order_priority(int(gpio, c_int), c_funloc(handler), &
			int(order_priority, c_int8_t))
	end subroutine

	!> Add a raw IRQ handler for GPIOs selected by a mask.
	!> @param gpio_mask GPIO mask.
	!> @param handler IRQ handler.
	subroutine gpio_add_raw_irq_handler_masked(gpio_mask, handler)
		integer, intent(in), value :: gpio_mask
		procedure(gpio_irq_handler) :: handler
		call fgpio_add_raw_irq_handler_masked(int(gpio_mask, c_int32_t), c_funloc(handler))
	end subroutine

	!> Add a raw IRQ handler for GPIOs selected by a 64-bit mask.
	!> @param gpio_mask GPIO mask.
	!> @param handler IRQ handler.
	subroutine gpio_add_raw_irq_handler_masked64(gpio_mask, handler)
		integer(c_int64_t), intent(in), value :: gpio_mask
		procedure(gpio_irq_handler) :: handler
		call fgpio_add_raw_irq_handler_masked64(gpio_mask, c_funloc(handler))
	end subroutine

	!> Add a raw IRQ handler for a GPIO.
	!> @param gpio GPIO number.
	!> @param handler IRQ handler.
	subroutine gpio_add_raw_irq_handler(gpio, handler)
		integer, intent(in), value :: gpio
		procedure(gpio_irq_handler) :: handler
		call fgpio_add_raw_irq_handler(int(gpio, c_int), c_funloc(handler))
	end subroutine

	!> Remove a raw IRQ handler for GPIOs selected by a mask.
	!> @param gpio_mask GPIO mask.
	!> @param handler IRQ handler.
	subroutine gpio_remove_raw_irq_handler_masked(gpio_mask, handler)
		integer, intent(in), value :: gpio_mask
		procedure(gpio_irq_handler) :: handler
		call fgpio_remove_raw_irq_handler_masked(int(gpio_mask, c_int32_t), c_funloc(handler))
	end subroutine

	!> Remove a raw IRQ handler for GPIOs selected by a 64-bit mask.
	!> @param gpio_mask GPIO mask.
	!> @param handler IRQ handler.
	subroutine gpio_remove_raw_irq_handler_masked64(gpio_mask, handler)
		integer(c_int64_t), intent(in), value :: gpio_mask
		procedure(gpio_irq_handler) :: handler
		call fgpio_remove_raw_irq_handler_masked64(gpio_mask, c_funloc(handler))
	end subroutine

	!> Remove a raw IRQ handler for a GPIO.
	!> @param gpio GPIO number.
	!> @param handler IRQ handler.
	subroutine gpio_remove_raw_irq_handler(gpio, handler)
		integer, intent(in), value :: gpio
		procedure(gpio_irq_handler) :: handler
		call fgpio_remove_raw_irq_handler(int(gpio, c_int), c_funloc(handler))
	end subroutine

	!> Configure a GPIO for direct input/output from software.
	!> @param gpio GPIO number.
	subroutine gpio_init(gpio)
		integer, intent(in), value :: gpio
		call fgpio_init(int(gpio, c_int))
	end subroutine

	!> Resets a GPIO back to the NULL function, i.e. disables it.
	!> @param gpio GPIO number.
	subroutine gpio_deinit(gpio)
		integer, intent(in), value :: gpio
		call fgpio_deinit(int(gpio, c_int))
	end subroutine

	!> Initialise a set of GPIOs selected by a mask.
	!> @param gpio_mask GPIO mask.
	subroutine gpio_init_mask(gpio_mask)
		integer, intent(in), value :: gpio_mask
		call fgpio_init_mask(int(gpio_mask, c_int32_t))
	end subroutine

	!> Initialise a set of GPIOs selected by a 64-bit mask.
	!> @param gpio_mask GPIO mask.
	subroutine gpio_init_mask64(gpio_mask)
		integer(c_int64_t), intent(in), value :: gpio_mask
		call fgpio_init_mask64(gpio_mask)
	end subroutine

	!> Get the value of a single GPIO.
	!> @param gpio GPIO number.
	logical function gpio_get(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_get(int(gpio, c_int))
	end function

	!> Get raw value of all GPIOs.
	integer function gpio_get_all() result(ret)
		ret = fgpio_get_all()
	end function

	!> Get raw value of all GPIOs.
	integer(c_int64_t) function gpio_get_all64() result(ret)
		ret = fgpio_get_all64()
	end function

	!> Drive high every GPIO appearing in mask.
	!> @param mask GPIO mask.
	subroutine gpio_set_mask(mask)
		integer, intent(in), value :: mask
		call fgpio_set_mask(int(mask, c_int32_t))
	end subroutine

	!> Drive high every GPIO appearing in a 64-bit mask.
	!> @param mask GPIO mask.
	subroutine gpio_set_mask64(mask)
		integer(c_int64_t), intent(in), value :: mask
		call fgpio_set_mask64(mask)
	end subroutine

	!> Drive high every GPIO appearing in mask for the selected GPIO bank.
	!> @param n GPIO bank number.
	!> @param mask GPIO mask.
	subroutine gpio_set_mask_n(n, mask)
		integer, intent(in), value :: n, mask
		call fgpio_set_mask_n(int(n, c_int), int(mask, c_int32_t))
	end subroutine

	!> Clear every GPIO appearing in mask.
	!> @param mask GPIO mask.
	subroutine gpio_clr_mask(mask)
		integer, intent(in), value :: mask
		call fgpio_clr_mask(int(mask, c_int32_t))
	end subroutine

	!> Clear every GPIO appearing in a 64-bit mask.
	!> @param mask GPIO mask.
	subroutine gpio_clr_mask64(mask)
		integer(c_int64_t), intent(in), value :: mask
		call fgpio_clr_mask64(mask)
	end subroutine

	!> Clear every GPIO appearing in mask for the selected GPIO bank.
	!> @param n GPIO bank number.
	!> @param mask GPIO mask.
	subroutine gpio_clr_mask_n(n, mask)
		integer, intent(in), value :: n, mask
		call fgpio_clr_mask_n(int(n, c_int), int(mask, c_int32_t))
	end subroutine

	!> Toggle every GPIO appearing in mask.
	!> @param mask GPIO mask.
	subroutine gpio_xor_mask(mask)
		integer, intent(in), value :: mask
		call fgpio_xor_mask(int(mask, c_int32_t))
	end subroutine

	!> Toggle every GPIO appearing in a 64-bit mask.
	!> @param mask GPIO mask.
	subroutine gpio_xor_mask64(mask)
		integer(c_int64_t), intent(in), value :: mask
		call fgpio_xor_mask64(mask)
	end subroutine

	!> Toggle every GPIO appearing in mask for the selected GPIO bank.
	!> @param n GPIO bank number.
	!> @param mask GPIO mask.
	subroutine gpio_xor_mask_n(n, mask)
		integer, intent(in), value :: n, mask
		call fgpio_xor_mask_n(int(n, c_int), int(mask, c_int32_t))
	end subroutine

	!> For each 1 bit in mask, drive that pin to the value given by
	!> corresponding bit in value, leaving other pins unchanged.
	!>
	!> Since this uses the TOGL alias, it is concurrency-safe with e.g. an IRQ
	!> bashing different pins from the same core.
	!> @param mask GPIO mask.
	!> @param value GPIO values.
	subroutine gpio_put_masked(mask, value)
		integer, intent(in), value :: mask, value
		call fgpio_put_masked(int(mask, c_int32_t), int(value, c_int32_t))
	end subroutine

	!> For each 1 bit in mask, drive that pin to the value given by
	!> corresponding bit in value, leaving other pins unchanged.
	!>
	!> Since this uses the TOGL alias, it is concurrency-safe with e.g. an IRQ
	!> bashing different pins from the same core.
	!> @param mask GPIO mask.
	!> @param value GPIO values.
	subroutine gpio_put_masked64(mask, value)
		integer(c_int64_t), intent(in), value :: mask, value
		call fgpio_put_masked64(mask, value)
	end subroutine

	!> For each 1 bit in mask, drive that pin to the value given by
	!> corresponding bit in value, leaving other pins unchanged.
	!> @param n GPIO bank number.
	!> @param mask GPIO mask.
	!> @param value GPIO values.
	subroutine gpio_put_masked_n(n, mask, value)
		integer, intent(in), value :: n, mask, value
		call fgpio_put_masked_n(int(n, c_int), int(mask, c_int32_t), int(value, c_int32_t))
	end subroutine

	!> Drive all pins simultaneously.
	!> @param value GPIO values.
	subroutine gpio_put_all(value)
		integer, intent(in), value :: value
		call fgpio_put_all(int(value, c_int32_t))
	end subroutine

	!> Drive all pins simultaneously.
	!> @param value GPIO values.
	subroutine gpio_put_all64(value)
		integer(c_int64_t), intent(in), value :: value
		call fgpio_put_all64(value)
	end subroutine

	!> Drive a single GPIO high/low.
	!> @param gpio GPIO number.
	!> @param value True to drive high, false to drive low.
	subroutine gpio_put(gpio, value)
		integer, intent(in), value :: gpio
		logical, intent(in) :: value
		call fgpio_put(int(gpio, c_int), logical(value, c_bool))
	end subroutine

	!> Determine whether a GPIO is currently driven high or low.
	!> @param gpio GPIO number.
	logical function gpio_get_out_level(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_get_out_level(int(gpio, c_int))
	end function

	!> Switch all GPIOs in mask to output.
	!> @param mask GPIO mask.
	subroutine gpio_set_dir_out_masked(mask)
		integer, intent(in), value :: mask
		call fgpio_set_dir_out_masked(int(mask, c_int32_t))
	end subroutine

	!> Switch all GPIOs in mask to output.
	!> @param mask GPIO mask.
	subroutine gpio_set_dir_out_masked64(mask)
		integer(c_int64_t), intent(in), value :: mask
		call fgpio_set_dir_out_masked64(mask)
	end subroutine

	!> Switch all GPIOs in mask to input.
	!> @param mask GPIO mask.
	subroutine gpio_set_dir_in_masked(mask)
		integer, intent(in), value :: mask
		call fgpio_set_dir_in_masked(int(mask, c_int32_t))
	end subroutine

	!> Switch all GPIOs in mask to input.
	!> @param mask GPIO mask.
	subroutine gpio_set_dir_in_masked64(mask)
		integer(c_int64_t), intent(in), value :: mask
		call fgpio_set_dir_in_masked64(mask)
	end subroutine

	!> For each 1 bit in mask, switch that pin to the direction given by
	!> corresponding bit in value, leaving other pins unchanged.
	!>
	!> E.g. gpio_set_dir_masked(0x3, 0x2) sets pin 0 to input and pin 1 to
	!> output simultaneously.
	!> @param mask GPIO mask.
	!> @param value GPIO direction values.
	subroutine gpio_set_dir_masked(mask, value)
		integer, intent(in), value :: mask, value
		call fgpio_set_dir_masked(int(mask, c_int32_t), int(value, c_int32_t))
	end subroutine

	!> For each 1 bit in mask, switch that pin to the direction given by
	!> corresponding bit in value, leaving other pins unchanged.
	!> @param mask GPIO mask.
	!> @param value GPIO direction values.
	subroutine gpio_set_dir_masked64(mask, value)
		integer(c_int64_t), intent(in), value :: mask, value
		call fgpio_set_dir_masked64(mask, value)
	end subroutine

	!> Set direction of all pins simultaneously.
	!>
	!> For each bit in value, 1 = out and 0 = in.
	!> @param value GPIO direction values.
	subroutine gpio_set_dir_all_bits(value)
		integer, intent(in), value :: value
		call fgpio_set_dir_all_bits(int(value, c_int32_t))
	end subroutine

	!> Set direction of all pins simultaneously.
	!>
	!> For each bit in value, 1 = out and 0 = in.
	!> @param value GPIO direction values.
	subroutine gpio_set_dir_all_bits64(value)
		integer(c_int64_t), intent(in), value :: value
		call fgpio_set_dir_all_bits64(value)
	end subroutine

	!> Set a single GPIO to input/output.
	!>
	!> true = out, 0 = in.
	!> @param gpio GPIO number.
	!> @param out True to set output, false to set input.
	subroutine gpio_set_dir(gpio, out)
		integer, intent(in), value :: gpio
		logical, intent(in) :: out
		call fgpio_set_dir(int(gpio, c_int), logical(out, c_bool))
	end subroutine

	!> Check if a specific GPIO direction is OUT.
	!> @param gpio GPIO number.
	logical function gpio_is_dir_out(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_is_dir_out(int(gpio, c_int))
	end function

	!> Get a specific GPIO direction.
	!>
	!> 1 = out, 0 = in.
	!> @param gpio GPIO number.
	integer function gpio_get_dir(gpio) result(ret)
		integer, intent(in), value :: gpio
		ret = fgpio_get_dir(int(gpio, c_int))
	end function

	!> Initialise the GPIO debug pins.
	subroutine gpio_debug_pins_init()
		call fgpio_debug_pins_init()
	end subroutine

end module gpio
