module io
	use, intrinsic :: iso_c_binding
	public print, stdio_init_all, sleep_ms

	interface
		subroutine stdio_init_all() bind(c)
		end subroutine

		function c_printf_str(format, msg) result(printed) bind(C, name="printf")
			import :: c_char, c_int
			integer(c_int) :: printed
			character(kind=c_char), intent(in) :: format(*)
			character(kind=c_char), intent(in) :: msg(*)
		end function

		subroutine c_sleep_ms(ms) bind(C, name="sleep_ms")
			import :: c_int32_t
			integer(c_int32_t), value, intent(in) :: ms
		end subroutine
	end interface
contains
	subroutine print(msg)
		character(len=*), intent(in) :: msg
		integer :: num_printed
		num_printed = c_printf_str("%s"//c_null_char, msg//c_new_line//c_null_char)
		print "(A)", num_printed
	end subroutine

	subroutine sleep_ms(ms)
		integer, intent(in) :: ms
		call c_sleep_ms(int(ms, c_int32_t))
	end subroutine
end module io
