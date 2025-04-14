program randlen
    use, intrinsic :: iso_fortran_env
    use, intrinsic :: iso_c_binding
    implicit none

    real(kind=real64), parameter :: twopi = 8. * atan(1.)
    integer, parameter :: n = 100

    integer :: i, j, k
    real(kind=real64), allocatable :: points(:, :, :, :)
    real(kind=real64), allocatable :: lengths(:, :, :)
    real(kind=real64) :: avg_length = 0.d0
    
    allocate(points(3, n, n, n))
    allocate(lengths(n, n, n))

    call box_muller(points)

    !$omp parallel do private(i, j, k) shared(points, lengths) reduction(+:avg_length) collapse(3)
    do k = 1, n
        do j = 1, n
            do i = 1, n
                #:if defined('manual-sum')
                lengths(i, j, k) = sqrt(points(1, i, j, k)**2 + &
                & points(2, i, j, k)**2 + points(3, i, j, k)**2)
                #:else
                lengths(i, j, k) = sqrt(sum(points(:, i, j, k)**2))
                #:endif

                avg_length = avg_length + lengths(i, j, k)
            end do
        end do
    end do
    !$omp end parallel do

    print *, "average length:", avg_length / n**3

contains

    subroutine box_muller(out)
        integer :: n, i
        real(kind=real64), target, intent(inout) :: out(..)
        real(kind=real64), pointer :: out_2d(:, :)
        real(kind=real64) :: u(2), r

        n = size(out) / 2
        ! really ugly way to create [2, n] view of array `out`
        call c_f_pointer(c_loc(out), out_2d, [2, n])

        !$omp parallel do private(u, r) shared(n) reduction(+:avg_length)
        do i = 1, n
            call random_number(u)
            r = sqrt(-2.d0 * log(u(1)))
            out_2d(1, i) = r * cos(twopi * u(2))
            out_2d(2, i) = r * sin(twopi * u(2))
        end do
        !$omp end parallel do
    end subroutine

end program
!vim:sw=4:ts=4
