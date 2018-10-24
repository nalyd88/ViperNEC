      SUBROUTINE GFLD (RHO,PHI,RZ,ETH,EPI,ERD,UX,KSYMP)
C
C     GFLD COMPUTES THE RADIATED FIELD INCLUDING GROUND WAVE.
C
      COMPLEX CUR,EPI,CIX,CIY,CIZ,EXA,XX1,XX2,U,U2,ERV,EZV,ERH,EPH
      COMPLEX EZH,EX,EY,ETH,UX,ERD
      COMMON /DATA/ LD,N1,N2,N,NP,M1,M2,M,MP,X(300),Y(300),Z(300),SI(300
     1),BI(300),ALP(300),BET(300),ICON1(300),ICON2(300),ITAG(300),ICONX(
     2300),WLAM,IPSYM
      COMMON /ANGL/ SALP(300)
      COMMON /CRNT/ AIR(300),AII(300),BIR(300),BII(300),CIR(300),CII(300
     1),CUR(900)
      COMMON /GWAV/ U,U2,XX1,XX2,R1,R2,ZMH,ZPH
      DIMENSION CAB(1), SAB(1)
      EQUIVALENCE (CAB(1),ALP(1)), (SAB(1),BET(1))
      DATA PI,TP/3.141592654,6.283185308/
      R=SQRT(RHO*RHO+RZ*RZ)
      IF (KSYMP.EQ.1) GO TO 1
      IF (ABS(UX).GT..5) GO TO 1
      IF (R.GT.1.E5) GO TO 1
      GO TO 4
C
C     COMPUTATION OF SPACE WAVE ONLY
C
1     IF (RZ.LT.1.E-20) GO TO 2
      THET=ATAN(RHO/RZ)
      GO TO 3
2     THET=PI*.5
3     CALL FFLD (THET,PHI,ETH,EPI)
      ARG=-TP*R
      EXA=CMPLX(COS(ARG),SIN(ARG))/R
      ETH=ETH*EXA
      EPI=EPI*EXA
      ERD=(0.,0.)
      RETURN
C
C     COMPUTATION OF SPACE AND GROUND WAVES.
C
4     U=UX
      U2=U*U
      PHX=-SIN(PHI)
      PHY=COS(PHI)
      RX=RHO*PHY
      RY=-RHO*PHX
      CIX=(0.,0.)
      CIY=(0.,0.)
      CIZ=(0.,0.)
C
C     SUMMATION OF FIELD FROM INDIVIDUAL SEGMENTS
C
      DO 17 I=1,N
      DX=CAB(I)
      DY=SAB(I)
      DZ=SALP(I)
      RIX=RX-X(I)
      RIY=RY-Y(I)
      RHS=RIX*RIX+RIY*RIY
      RHP=SQRT(RHS)
      IF (RHP.LT.1.E-6) GO TO 5
      RHX=RIX/RHP
      RHY=RIY/RHP
      GO TO 6
5     RHX=1.
      RHY=0.
6     CALP=1.-DZ*DZ
      IF (CALP.LT.1.D-6) GO TO 7
      CALP=SQRT(CALP)
      CBET=DX/CALP
      SBET=DY/CALP
      CPH=RHX*CBET+RHY*SBET
      SPH=RHY*CBET-RHX*SBET
      GO TO 8
7     CPH=RHX
      SPH=RHY
8     EL=PI*SI(I)
      RFL=-1.
C
C     INTEGRATION OF (CURRENT)*(PHASE FACTOR) OVER SEGMENT AND IMAGE FOR
C     CONSTANT, SINE, AND COSINE CURRENT DISTRIBUTIONS
C
      DO 16 K=1,2
      RFL=-RFL
      RIZ=RZ-Z(I)*RFL
      RXYZ=SQRT(RIX*RIX+RIY*RIY+RIZ*RIZ)
      RNX=RIX/RXYZ
      RNY=RIY/RXYZ
      RNZ=RIZ/RXYZ
      OMEGA=-(RNX*DX+RNY*DY+RNZ*DZ*RFL)
      SILL=OMEGA*EL
      TOP=EL+SILL
      BOT=EL-SILL
      IF (ABS(OMEGA).LT.1.E-7) GO TO 9
      A=2.*SIN(SILL)/OMEGA
      GO TO 10
9     A=(2.-OMEGA*OMEGA*EL*EL/3.)*EL
10    IF (ABS(TOP).LT.1.E-7) GO TO 11
      TOO=SIN(TOP)/TOP
      GO TO 12
11    TOO=1.-TOP*TOP/6.
12    IF (ABS(BOT).LT.1.E-7) GO TO 13
      BOO=SIN(BOT)/BOT
      GO TO 14
13    BOO=1.-BOT*BOT/6.
14    B=EL*(BOO-TOO)
      C=EL*(BOO+TOO)
      RR=A*AIR(I)+B*BII(I)+C*CIR(I)
      RI=A*AII(I)-B*BIR(I)+C*CII(I)
      ARG=TP*(X(I)*RNX+Y(I)*RNY+Z(I)*RNZ*RFL)
      EXA=CMPLX(COS(ARG),SIN(ARG))*CMPLX(RR,RI)/TP
      IF (K.EQ.2) GO TO 15
      XX1=EXA
      R1=RXYZ
      ZMH=RIZ
      GO TO 16
15    XX2=EXA
      R2=RXYZ
      ZPH=RIZ
16    CONTINUE
C
C     CALL SUBROUTINE TO COMPUTE THE FIELD OF SEGMENT INCLUDING GROUND
C     WAVE.
C
      CALL GWAVE (ERV,EZV,ERH,EZH,EPH)
      ERH=ERH*CPH*CALP+ERV*DZ
      EPH=EPH*SPH*CALP
      EZH=EZH*CPH*CALP+EZV*DZ
      EX=ERH*RHX-EPH*RHY
      EY=ERH*RHY+EPH*RHX
      CIX=CIX+EX
      CIY=CIY+EY
17    CIZ=CIZ+EZH
      ARG=-TP*R
      EXA=CMPLX(COS(ARG),SIN(ARG))
      CIX=CIX*EXA
      CIY=CIY*EXA
      CIZ=CIZ*EXA
      RNX=RX/R
      RNY=RY/R
      RNZ=RZ/R
      THX=RNZ*PHY
      THY=-RNZ*PHX
      THZ=-RHO/R
      ETH=CIX*THX+CIY*THY+CIZ*THZ
      EPI=CIX*PHX+CIY*PHY
      ERD=CIX*RNX+CIY*RNY+CIZ*RNZ
      RETURN
      END