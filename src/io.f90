module io
	use, intrinsic :: iso_c_binding
	public stdio_init_all, sleep_ms

	interface
		subroutine stdio_init_all() bind(c)
		end subroutine

		subroutine c_sleep_ms(ms) bind(C, name="sleep_ms")
			import :: c_int32_t
			integer(c_int32_t), value, intent(in) :: ms
		end subroutine
	end interface
contains
	subroutine sleep_ms(ms)
		integer, intent(in) :: ms
		call c_sleep_ms(int(ms, c_int32_t))
	end subroutine
end module io
