      SUBROUTINE NFPAT
C     COMPUTE NEAR E OR H FIELDS OVER A RANGE OF POINTS
      COMPLEX EX,EY,EZ
      COMMON /DATA/ LD,N1,N2,N,NP,M1,M2,M,MP,X(300),Y(300),Z(300),SI(300
     1),BI(300),ALP(300),BET(300),ICON1(300),ICON2(300),ITAG(300),ICONX(
     2300),WLAM,IPSYM
      COMMON /FPAT/ NTH,NPH,IPD,IAVP,INOR,IAX,THETS,PHIS,DTH,DPH,RFLD,GN
     1OR,CLT,CHT,EPSR2,SIG2,IXTYP,XPR6,PINR,PNLR,PLOSS,NEAR,NFEH,NRX,NRY
     2,NRZ,XNR,YNR,ZNR,DXNR,DYNR,DZNR
      DATA TA/1.745329252E-02/
      IF (NFEH.EQ.1) GO TO 1
      PRINT 10
      GO TO 2
1     PRINT 12
2     ZNRT=ZNR-DZNR
      DO 9 I=1,NRZ
      ZNRT=ZNRT+DZNR
      IF (NEAR.EQ.0) GO TO 3
      CTH=COS(TA*ZNRT)
      STH=SIN(TA*ZNRT)
3     YNRT=YNR-DYNR
      DO 9 J=1,NRY
      YNRT=YNRT+DYNR
      IF (NEAR.EQ.0) GO TO 4
      CPH=COS(TA*YNRT)
      SPH=SIN(TA*YNRT)
4     XNRT=XNR-DXNR
      DO 9 KK=1,NRX
      XNRT=XNRT+DXNR
      IF (NEAR.EQ.0) GO TO 5
      XOB=XNRT*STH*CPH
      YOB=XNRT*STH*SPH
      ZOB=XNRT*CTH
      GO TO 6
5     XOB=XNRT
      YOB=YNRT
      ZOB=ZNRT
6     TMP1=XOB/WLAM
      TMP2=YOB/WLAM
      TMP3=ZOB/WLAM
      IF (NFEH.EQ.1) GO TO 7
      CALL NEFLD (TMP1,TMP2,TMP3,EX,EY,EZ)
      GO TO 8
7     CALL NHFLD (TMP1,TMP2,TMP3,EX,EY,EZ)
8     TMP1=ABS(EX)
      TMP2=CANG(EX)
      TMP3=ABS(EY)
      TMP4=CANG(EY)
      TMP5=ABS(EZ)
      TMP6=CANG(EZ)
      PRINT 11, XOB,YOB,ZOB,TMP1,TMP2,TMP3,TMP4,TMP5,TMP6
9     CONTINUE
      RETURN
C
10    FORMAT (///,35X,32H- - - NEAR ELECTRIC FIELDS - - -,//,12X,14H-  L
     1OCATION  -,21X,8H-  EX  -,15X,8H-  EY  -,15X,8H-  EZ  -,/,8X,1HX,1
     20X,1HY,10X,1HZ,10X,9HMAGNITUDE,3X,5HPHASE,6X,9HMAGNITUDE,3X,5HPHAS
     3E,6X,9HMAGNITUDE,3X,5HPHASE,/,6X,6HMETERS,5X,6HMETERS,5X,6HMETERS,
     48X,7HVOLTS/M,3X,7HDEGREES,6X,7HVOLTS/M,3X,7HDEGREES,6X,7HVOLTS/M,3
     5X,7HDEGREES)
11    FORMAT (2X,3(2X,F9.4),1X,3(3X,1P,E11.4,2X,0P,F7.2))
12    FORMAT (///,35X,32H- - - NEAR MAGNETIC FIELDS - - -,//,12X,14H-  L
     1OCATION  -,21X,8H-  HX  -,15X,8H-  HY  -,15X,8H-  HZ  -,/,8X,1HX,1
     20X,1HY,10X,1HZ,10X,9HMAGNITUDE,3X,5HPHASE,6X,9HMAGNITUDE,3X,5HPHAS
     3E,6X,9HMAGNITUDE,3X,5HPHASE,/,6X,6HMETERS,5X,6HMETERS,5X,6HMETERS,
     49X,6HAMPS/M,3X,7HDEGREES,7X,6HAMPS/M,3X,7HDEGREES,7X,6HAMPS/M,3X,7
     5HDEGREES)
      END