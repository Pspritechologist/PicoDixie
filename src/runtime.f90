integer(c_int) function c_runtime_entry() bind(C, name="main")
	use, intrinsic :: iso_c_binding, only: c_int
	use io, only: print
	use entry, only: main

	call main

	call print('Entering loop!')
	c_runtime_entry = 1
	do
	end do

end function c_runtime_entry
