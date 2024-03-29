      SUBROUTINE CABC (CURX)
C
C     CABC COMPUTES COEFFICIENTS OF THE CONSTANT (A), SINE (B), AND
C     COSINE (C) TERMS IN THE CURRENT INTERPOLATION FUNCTIONS FOR THE
C     CURRENT VECTOR CUR.
C
      COMPLEX CUR,CURX,VQDS,CURD,CCJ,VSANT,VQD,CS1,CS2
      COMMON /DATA/ LD,N1,N2,N,NP,M1,M2,M,MP,X(300),Y(300),Z(300),SI(300
     1),BI(300),ALP(300),BET(300),ICON1(300),ICON2(300),ITAG(300),ICONX(
     2300),WLAM,IPSYM
      COMMON /CRNT/ AIR(300),AII(300),BIR(300),BII(300),CIR(300),CII(300
     1),CUR(900)
      COMMON /SEGJ/ AX(30),BX(30),CX(30),JCO(30),JSNO,ISCON(50),NSCON,IP
     1CON(10),NPCON
      COMMON /VSORC/ VQD(30),VSANT(30),VQDS(30),IVQD(30),ISANT(30),IQDS(
     130),NVQD,NSANT,NQDS
      COMMON /ANGL/ SALP(300)
      DIMENSION T1X(1), T1Y(1), T1Z(1), T2X(1), T2Y(1), T2Z(1)
      DIMENSION CURX(1), CCJX(2)
      EQUIVALENCE (T1X,SI), (T1Y,ALP), (T1Z,BET), (T2X,ICON1), (T2Y,ICON
     12), (T2Z,ITAG)
      EQUIVALENCE (CCJ,CCJX)
      DATA TP/6.283185308/,CCJX/0.,-0.01666666667/
      IF (N.EQ.0) GO TO 6
      DO 1 I=1,N
      AIR(I)=0.
      AII(I)=0.
      BIR(I)=0.
      BII(I)=0.
      CIR(I)=0.
1     CII(I)=0.
      DO 2 I=1,N
      AR=REAL(CURX(I))
      AI=AIMAG(CURX(I))
      CALL TBF (I,1)
      DO 2 JX=1,JSNO
      J=JCO(JX)
      AIR(J)=AIR(J)+AX(JX)*AR
      AII(J)=AII(J)+AX(JX)*AI
      BIR(J)=BIR(J)+BX(JX)*AR
      BII(J)=BII(J)+BX(JX)*AI
      CIR(J)=CIR(J)+CX(JX)*AR
2     CII(J)=CII(J)+CX(JX)*AI
      IF (NQDS.EQ.0) GO TO 4
      DO 3 IS=1,NQDS
      I=IQDS(IS)
      JX=ICON1(I)
      ICON1(I)=0
      CALL TBF (I,0)
      ICON1(I)=JX
      SH=SI(I)*.5
      CURD=CCJ*VQDS(IS)/((LOG(2.*SH/BI(I))-1.)*(BX(JSNO)*COS(TP*SH)+CX(
     1JSNO)*SIN(TP*SH))*WLAM)
      AR=REAL(CURD)
      AI=AIMAG(CURD)
      DO 3 JX=1,JSNO
      J=JCO(JX)
      AIR(J)=AIR(J)+AX(JX)*AR
      AII(J)=AII(J)+AX(JX)*AI
      BIR(J)=BIR(J)+BX(JX)*AR
      BII(J)=BII(J)+BX(JX)*AI
      CIR(J)=CIR(J)+CX(JX)*AR
3     CII(J)=CII(J)+CX(JX)*AI
4     DO 5 I=1,N
5     CURX(I)=DCMPLX(AIR(I)+CIR(I),AII(I)+CII(I))
6     IF (M.EQ.0) RETURN
C     CONVERT SURFACE CURRENTS FROM T1,T2 COMPONENTS TO X,Y,Z COMPONENTS
      K=LD-M
      JCO1=N+2*M+1
      JCO2=JCO1+M
      DO 7 I=1,M
      K=K+1
      JCO1=JCO1-2
      JCO2=JCO2-3
      CS1=CURX(JCO1)
      CS2=CURX(JCO1+1)
      CURX(JCO2)=CS1*T1X(K)+CS2*T2X(K)
      CURX(JCO2+1)=CS1*T1Y(K)+CS2*T2Y(K)
7     CURX(JCO2+2)=CS1*T1Z(K)+CS2*T2Z(K)
      RETURN
      END
