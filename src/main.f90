integer(c_int) function main() bind(C)
	use io
	use, intrinsic :: iso_c_binding, only: c_int32_t, c_int

	call stdio_init_all
	! call gpio_init(2)

	call print("OWO what's this?")
	! print *, "Oh my, what is this?"

	call print('Entering loop!')
	do
	end do

end function
