      COMPLEX FUNCTION FBAR(P)
C
C     FBAR IS SOMMERFELD ATTENUATION FUNCTION FOR NUMERICAL DISTANCE P
C
      COMPLEX Z,ZS,SUM,POW,TERM,P,FJ
      DIMENSION FJX(2)
      EQUIVALENCE (FJ,FJX)
      DATA TOSP/1.128379167/,ACCS/1.E-12/,SP/1.772453851/,FJX/0.,1./
      Z=FJ*CSQRT(P)
      IF (CABS(Z).GT.3.) GO TO 3
C
C     SERIES EXPANSION
C
      ZS=Z*Z
      SUM=Z
      POW=Z
      DO 1 I=1,100
      POW=-POW*ZS/FLOAT(I)
      TERM=POW/(2.*I+1.)
      SUM=SUM+TERM
      TMS=REAL(TERM*CONJG(TERM))
      SMS=REAL(SUM*CONJG(SUM))
      IF (TMS/SMS.LT.ACCS) GO TO 2
1     CONTINUE
2     FBAR=1.-(1.-SUM*TOSP)*Z*CEXP(ZS)*SP
      RETURN
C
C     ASYMPTOTIC EXPANSION
C
3     IF (REAL(Z).GE.0.) GO TO 4
      MINUS=1
      Z=-Z
      GO TO 5
4     MINUS=0
5     ZS=.5/(Z*Z)
      SUM=(0.,0.)
      TERM=(1.,0.)
      DO 6 I=1,6
      TERM=-TERM*(2.*I-1.)*ZS
6     SUM=SUM+TERM
      IF (MINUS.EQ.1) SUM=SUM-2.*SP*Z*CEXP(Z*Z)
      FBAR=-SUM
      RETURN
      END