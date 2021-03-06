    Program dsbevx_example

!     DSBEVX Example Program Text

!     Copyright (c) 2018, Numerical Algorithms Group (NAG Ltd.)
!     For licence see
!       https://github.com/numericalalgorithmsgroup/LAPACK_Examples/blob/master/LICENCE.md

!     .. Use Statements ..
      Use lapack_example_aux, Only: nagf_file_print_matrix_real_gen
      Use lapack_interfaces, Only: dsbevx
      Use lapack_precision, Only: dp
!     .. Implicit None Statement ..
      Implicit None
!     .. Parameters ..
      Real (Kind=dp), Parameter :: zero = 0.0E+0_dp
      Integer, Parameter :: nin = 5, nout = 6
      Character (1), Parameter :: uplo = 'U'
!     .. Local Scalars ..
      Real (Kind=dp) :: abstol, vl, vu
      Integer :: i, ifail, il, info, iu, j, kd, ldab, ldq, ldz, m, n
!     .. Local Arrays ..
      Real (Kind=dp), Allocatable :: ab(:, :), q(:, :), w(:), work(:), z(:, :)
      Integer, Allocatable :: iwork(:), jfail(:)
!     .. Intrinsic Procedures ..
      Intrinsic :: max, min
!     .. Executable Statements ..
      Write (nout, *) 'DSBEVX Example Program Results'
      Write (nout, *)
!     Skip heading in data file
      Read (nin, *)
      Read (nin, *) n, kd
      ldab = kd + 1
      ldq = n
      ldz = n
      m = n
      Allocate (ab(ldab,n), q(ldq,n), w(n), work(7*n), z(ldz,m), iwork(5*n), &
        jfail(n))

!     Read the lower and upper bounds of the interval to be searched,
!     and read the upper or lower triangular part of the matrix A
!     from data file

      Read (nin, *) vl, vu
      If (uplo=='U') Then
        Read (nin, *)((ab(kd+1+i-j,j),j=i,min(n,i+kd)), i=1, n)
      Else If (uplo=='L') Then
        Read (nin, *)((ab(1+i-j,j),j=max(1,i-kd),i), i=1, n)
      End If

!     Set the absolute error tolerance for eigenvalues.  With ABSTOL
!     set to zero, the default value is used instead

      abstol = zero

!     Solve the band symmetric eigenvalue problem
      Call dsbevx('Vectors', 'Values in range', uplo, n, kd, ab, ldab, q, ldq, &
        vl, vu, il, iu, abstol, m, w, z, ldz, work, iwork, jfail, info)

      If (info>=0) Then

!       Print solution

        Write (nout, 100) 'Number of eigenvalues found =', m
        Write (nout, *)
        Write (nout, *) 'Eigenvalues'
        Write (nout, 110) w(1:m)
        Flush (nout)

!       ifail: behaviour on error exit
!              =0 for hard exit, =1 for quiet-soft, =-1 for noisy-soft
        ifail = 0
        Call nagf_file_print_matrix_real_gen('General', ' ', n, m, z, ldz, &
          'Selected eigenvectors', ifail)

        If (info>0) Then
          Write (nout, 100) 'INFO eigenvectors failed to converge, INFO =', &
            info
          Write (nout, *) 'Indices of eigenvectors that did not converge'
          Write (nout, 120) jfail(1:m)
        End If
      Else
        Write (nout, 100) 'Failure in DSBEVX. INFO =', info
      End If

100   Format (1X, A, I5)
110   Format (3X, (8F8.4))
120   Format (3X, (8I8))
    End Program
