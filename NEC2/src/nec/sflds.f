      SUBROUTINE SFLDS (T,E)
C
C     SFLDX RETURNS THE FIELD DUE TO GROUND FOR A CURRENT ELEMENT ON
C     THE SOURCE SEGMENT AT T RELATIVE TO THE SEGMENT CENTER.
C
      COMPLEX E,ERV,EZV,ERH,EZH,EPH,T1,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,E
     1ZC,XX1,XX2,U,U2,ZRATI,ZRATI2,FRATI,ER,ET,HRV,HZV,HRH
      COMMON /DATAJ/ S,B,XJ,YJ,ZJ,CABJ,SABJ,SALPJ,EXK,EYK,EZK,EXS,EYS,EZ
     1S,EXC,EYC,EZC,RKH,IND1,INDD1,IND2,INDD2,IEXK,IPGND
      COMMON /INCOM/ XO,YO,ZO,SN,XSN,YSN,ISNOR
      COMMON /GWAV/ U,U2,XX1,XX2,R1,R2,ZMH,ZPH
      COMMON /GND/ZRATI,ZRATI2,FRATI,CL,CH,SCRWL,SCRWR,NRADL,KSYMP,IFAR,
     1IPERF,T1,T2
      DIMENSION E(9)
      DATA PI/3.141592654/,TP/6.283185308/,POT/1.570796327/
      XT=XJ+T*CABJ
      YT=YJ+T*SABJ
      ZT=ZJ+T*SALPJ
      RHX=XO-XT
      RHY=YO-YT
      RHS=RHX*RHX+RHY*RHY
      RHO=SQRT(RHS)
      IF (RHO.GT.0.) GO TO 1
      RHX=1.
      RHY=0.
      PHX=0.
      PHY=1.
      GO TO 2
1     RHX=RHX/RHO
      RHY=RHY/RHO
      PHX=-RHY
      PHY=RHX
2     CPH=RHX*XSN+RHY*YSN
      SPH=RHY*XSN-RHX*YSN
      IF (ABS(CPH).LT.1.E-10) CPH=0.
      IF (ABS(SPH).LT.1.E-10) SPH=0.
      ZPH=ZO+ZT
      ZPHS=ZPH*ZPH
      R2S=RHS+ZPHS
      R2=SQRT(R2S)
      RK=R2*TP
      XX2=CMPLX(COS(RK),-SIN(RK))
      IF (ISNOR.EQ.1) GO TO 3
C
C     USE NORTON APPROXIMATION FOR FIELD DUE TO GROUND.  CURRENT IS
C     LUMPED AT SEGMENT CENTER WITH CURRENT MOMENT FOR CONSTANT, SINE,
C     OR COSINE DISTRIBUTION.
C
      ZMH=1.
      R1=1.
      XX1=0.
      CALL GWAVE (ERV,EZV,ERH,EZH,EPH)
      ET=-(0.,4.77134)*FRATI*XX2/(R2S*R2)
      ER=2.*ET*CMPLX(1.,RK)
      ET=ET*CMPLX(1.-RK*RK,RK)
      HRV=(ER+ET)*RHO*ZPH/R2S
      HZV=(ZPHS*ER-RHS*ET)/R2S
      HRH=(RHS*ER-ZPHS*ET)/R2S
      ERV=ERV-HRV
      EZV=EZV-HZV
      ERH=ERH+HRH
      EZH=EZH+HRV
      EPH=EPH+ET
      ERV=ERV*SALPJ
      EZV=EZV*SALPJ
      ERH=ERH*SN*CPH
      EZH=EZH*SN*CPH
      EPH=EPH*SN*SPH
      ERH=ERV+ERH
      E(1)=(ERH*RHX+EPH*PHX)*S
      E(2)=(ERH*RHY+EPH*PHY)*S
      E(3)=(EZV+EZH)*S
      E(4)=0.
      E(5)=0.
      E(6)=0.
      SFAC=PI*S
      SFAC=SIN(SFAC)/SFAC
      E(7)=E(1)*SFAC
      E(8)=E(2)*SFAC
      E(9)=E(3)*SFAC
      RETURN
C
C     INTERPOLATE IN SOMMERFELD FIELD TABLES
C
3     IF (RHO.LT.1.E-12) GO TO 4
      THET=ATAN(ZPH/RHO)
      GO TO 5
4     THET=POT
5     CALL INTRP (R2,THET,ERV,EZV,ERH,EPH)
C     COMBINE VERTICAL AND HORIZONTAL COMPONENTS AND CONVERT TO X,Y,Z
C     COMPONENTS.  MULTIPLY BY EXP(-JKR)/R.
      XX2=XX2/R2
      SFAC=SN*CPH
      ERH=XX2*(SALPJ*ERV+SFAC*ERH)
      EZH=XX2*(SALPJ*EZV-SFAC*ERV)
      EPH=SN*SPH*XX2*EPH
C     X,Y,Z FIELDS FOR CONSTANT CURRENT
      E(1)=ERH*RHX+EPH*PHX
      E(2)=ERH*RHY+EPH*PHY
      E(3)=EZH
      RK=TP*T
C     X,Y,Z FIELDS FOR SINE CURRENT
      SFAC=SIN(RK)
      E(4)=E(1)*SFAC
      E(5)=E(2)*SFAC
      E(6)=E(3)*SFAC
C     X,Y,Z FIELDS FOR COSINE CURRENT
      SFAC=COS(RK)
      E(7)=E(1)*SFAC
      E(8)=E(2)*SFAC
      E(9)=E(3)*SFAC
      RETURN
      END