!! Uniform method of printing error/warning messages.  Error messages
!! print a message to the default output unit and then call the PARALLEL_ABORT
!! to the process (or set of processes if parallel)

module bl_error_module

  use bl_types
  use parallel

  implicit none

  !! Print an error message consisting of text followed by an optional
  !! scalar variable of type character(len=*), integer, or real; the
  !! process terminates.
  interface bl_error
     module procedure bl_error0
     module procedure bl_error1_c
     module procedure bl_error1_i
     module procedure bl_error1_d
     module procedure bl_error1_s
  end interface

  !! Print an warning message consisting of text followed by an optional
  !! scalar variable of type character(len=*), integer, or real.
  interface bl_warn
     module procedure bl_warn0
     module procedure bl_warn1_c
     module procedure bl_warn1_i
     module procedure bl_warn1_d
     module procedure bl_warn1_s
  end interface

contains

  subroutine bl_error0(str)
    character(len=*), intent(in), optional :: str
    if ( present(str) ) then
       write(*,*) "BOXLIB ERROR: ", str
    else
       write(*,*) "BOXLIB ERROR"
    end if
    call parallel_abort()
  end subroutine bl_error0

  subroutine bl_error1_c(str, str1)
    character(len=*), intent(in) :: str, str1
    write(*,fmt=*) "BOXLIB ERROR: ", str, str1
    call parallel_abort()
  end subroutine bl_error1_c

  subroutine bl_error1_i(str, val)
    character(len=*), intent(in) :: str
    integer, intent(in) :: val
    write(*,fmt=*) "BOXLIB ERROR: ", str, val
    call parallel_abort()
  end subroutine bl_error1_i

  subroutine bl_error1_d(str, val)
    character(len=*), intent(in) :: str
    real(kind=dp_t), intent(in) :: val
    write(*,fmt=*) "BOXLIB ERROR: ", str, val
    call parallel_abort()
  end subroutine bl_error1_d

  subroutine bl_error1_s(str, val)
    character(len=*), intent(in) :: str
    real(kind=sp_t), intent(in) :: val
    write(*,fmt=*) "BOXLIB ERROR: ", str, val
    call parallel_abort()
  end subroutine bl_error1_s

  subroutine bl_warn0(str)
    character(len=*), intent(in) :: str
    write(*,fmt=*) "BOXLIB WARN: ", str
  end subroutine bl_warn0

  subroutine bl_warn1_c(str, str1)
    character(len=*), intent(in) :: str, str1
    write(*,fmt=*) "BOXLIB WARN: ", str, str1
  end subroutine bl_warn1_c

  subroutine bl_warn1_i(str, val)
    character(len=*), intent(in) :: str
    integer, intent(in) :: val
    write(*,fmt=*) "BOXLIB WARN: ", str, val
  end subroutine bl_warn1_i

  subroutine bl_warn1_d(str, val)
    character(len=*), intent(in) :: str
    real(kind=dp_t), intent(in) :: val
    write(*,fmt=*) "BOXLIB WARN: ", str, val
  end subroutine bl_warn1_d

  subroutine bl_warn1_s(str, val)
    character(len=*), intent(in) :: str
    real(kind=sp_t), intent(in) :: val
    write(*,fmt=*) "BOXLIB WARN: ", str, val
  end subroutine bl_warn1_s

  !! If COND is true, nothing; if COND is false, call BL_ERROR_C, which
  !! terminates the process
  subroutine bl_assert(cond, str)
    logical, intent(in) :: cond
    character(len=*), intent(in) :: str
    if ( .NOT. cond ) then
       call bl_error("ASSERTION FAILED: ", str)
    end if
  end subroutine bl_assert

end module bl_error_module
