module dbg
	public assert

	interface assert
		module procedure assert_logical_msg
		module procedure assert_logical
		module procedure assert_pico_ok_msg
		module procedure assert_pico_ok
	end interface
contains

	subroutine assert_logical_msg(cond, msg)
		logical, intent(in) :: cond
		character(*), intent(in) :: msg
		if (.not. cond) error stop msg
	end subroutine
	subroutine assert_logical(cond)
		logical, intent(in) :: cond
		if (.not. cond) error stop 'Assertion failed'
	end subroutine

	subroutine assert_pico_ok_msg(ok, msg)
		integer, intent(in) :: ok
		character(*), intent(in) :: msg
		character(:), allocatable :: buffer

		if (ok .ne. 0) then
			allocate(character(32 + len(trim(msg))) :: buffer)
			write (buffer,'(A,1x,I2,": ",A)') 'Expected OK, got', ok, msg
			error stop msg
		end if
	end subroutine
	subroutine assert_pico_ok(ok)
		integer, intent(in) :: ok
		character(32) msg

		if (ok .ne. 0) then
			write (msg,'(A,1x,I2)') 'Expected OK, got', ok
			error stop trim(msg)
		end if
	end subroutine

end module
