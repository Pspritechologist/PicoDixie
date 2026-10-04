module io
	use, intrinsic :: iso_c_binding
	public stdio_init_all, sleep_ms, sleep_us

	interface
		subroutine stdio_init_all() bind(c)
		end subroutine

		subroutine c_sleep_ms(ms) bind(C, name="sleep_ms")
			import :: c_int32_t
			integer(c_int32_t), value, intent(in) :: ms
		end subroutine
		
		subroutine c_sleep_us(us) bind(C, name="sleep_us")
			import :: c_int64_t
			integer(c_int64_t), value, intent(in) :: us
		end subroutine
		
	end interface
contains
	subroutine sleep_ms(ms)
		integer, intent(in) :: ms
		call c_sleep_ms(int(ms, c_int32_t))
	end subroutine

	subroutine sleep_us(us)
		integer(8), intent(in) :: us
		call c_sleep_us(int(us, c_int64_t))
	end subroutine
end module io
