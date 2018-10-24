      SUBROUTINE FACTR (N,A,IP,NDIM)
C
C     SUBROUTINE TO FACTOR A MATRIX INTO A UNIT LOWER TRIANGULAR MATRIX
C     AND AN UPPER TRIANGULAR MATRIX USING THE GAUSS-DOOLITTLE ALGORITHM
C     PRESENTED ON PAGES 411-416 OF A. RALSTON--A FIRST COURSE IN
C     NUMERICAL ANALYSIS.  COMMENTS BELOW REFER TO COMMENTS IN RALSTONS
C     TEXT.    (MATRIX TRANSPOSED.
C
      COMPLEX A,D,ARJ
      DIMENSION A(NDIM,NDIM), IP(NDIM)
      COMMON /SCRATM/ D(600)
      INTEGER R,RM1,RP1,PJ,PR
      IFLG=0
      DO 9 R=1,N
C
C     STEP 1
C
      DO 1 K=1,N
      D(K)=A(K,R)
1     CONTINUE
C
C     STEPS 2 AND 3
C
      RM1=R-1
      IF (RM1.LT.1) GO TO 4
      DO 3 J=1,RM1
      PJ=IP(J)
      ARJ=D(PJ)
      A(J,R)=ARJ
      D(PJ)=D(J)
      JP1=J+1
      DO 2 I=JP1,N
      D(I)=D(I)-A(I,J)*ARJ
2     CONTINUE
3     CONTINUE
4     CONTINUE
C
C     STEP 4
C
      DMAX=REAL(D(R)*CONJG(D(R)))
      IP(R)=R
      RP1=R+1
      IF (RP1.GT.N) GO TO 6
      DO 5 I=RP1,N
      ELMAG=REAL(D(I)*CONJG(D(I)))
      IF (ELMAG.LT.DMAX) GO TO 5
      DMAX=ELMAG
      IP(R)=I
5     CONTINUE
6     CONTINUE
      IF (DMAX.LT.1.E-10) IFLG=1
      PR=IP(R)
      A(R,R)=D(PR)
      D(PR)=D(R)
C
C     STEP 5
C
      IF (RP1.GT.N) GO TO 8
      ARJ=1./A(R,R)
      DO 7 I=RP1,N
      A(I,R)=D(I)*ARJ
7     CONTINUE
8     CONTINUE
      IF (IFLG.EQ.0) GO TO 9
      PRINT 10,  R,DMAX
      IFLG=0
9     CONTINUE
      RETURN
C
10    FORMAT (1H ,6HPIVOT(,I3,2H)=,1P,E16.8)
      END