//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+





//+------------------------------------------------------------------+
//| expert OS function                                               |
//+------------------------------------------------------------------+
bool OS()
  {

   bool OverSold = false;
   if(iStochastic(NULL,015,5,3,3,MODE_SMA,0,MODE_MAIN,0) < 20 &&
      iStochastic(NULL,060,5,3,3,MODE_SMA,0,MODE_MAIN,0) < 20 &&
      iStochastic(NULL,240,5,3,3,MODE_SMA,0,MODE_MAIN,0) < 20)
     {
      OverSold = true;
     }
   return(OverSold);
  }

//+------------------------------------------------------------------+
//| expert OB function                                               |
//+------------------------------------------------------------------+
bool OB()
  {
   bool OverBought = false;
   if(iStochastic(NULL,015,5,3,3,MODE_SMA,0,MODE_MAIN,0) > 80 &&
      iStochastic(NULL,060,5,3,3,MODE_SMA,0,MODE_MAIN,0) > 80 &&
      iStochastic(NULL,240,5,3,3,MODE_SMA,0,MODE_MAIN,0) > 80)
     {
      OverBought = true;
     }
   return(OverBought);
  }



//+------------------------------------------------------------------+
//| PIVOT FILTER                                                     |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void subGETPIVOTS()
  {

   int period = 10080;

   double LastHigh  = iHigh(NULL,period,1);
   double LastLow   = iLow(NULL,period,1);
   double LastClose = iOpen(NULL,period,0);
   P         = (LastHigh + LastLow+ LastClose)/3;
   R1        = (2*P)-LastLow;
   S1        = (2*P)-LastHigh;
   R2        = P+(LastHigh - LastLow);
   S2        = P-(LastHigh - LastLow);
   R3        = P+(2*(LastHigh - LastLow));
   S3        = P-(2*(LastHigh - LastLow));
   return;

  }



// -----------------------------------------------------------------------------------------------------------
//   onbalance volume ma
// -----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double subOBV(int fBARS)
  {

   if(fBARS > Bars)
      fBARS = Bars -1;

   double myOBV_AV=0;
   double myOBV1 = iOBV(NULL,0,PRICE_CLOSE,1);



//  int myarray[100];

   for(int counter=0; counter<fBARS; counter++)
     {

      myOBV_AV = myOBV_AV + iOBV(NULL,0,PRICE_CLOSE,counter);

     }

   myOBV_AV = myOBV_AV / fBARS;

//if (myOBV1 > myOBV_AV ) myRESULT = UP;
//if (myOBV1 < myOBV_AV ) myRESULT = DOWN;


   subDISPLAYADD("OBV 1, AV" + " (" + fBARS + ") ", myOBV1 + SPC + myOBV_AV);
   subDISPLAYADD(LINE, 0);

   return(myOBV_AV);
  }






// ------------------------------------------------------------------
// get stoch cross signal
// ------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string subSTOCHCROSS(int fSTOCH_VALUE)
  {

   string fSTOCH_CROSS = "";

   int stoch0, stoch0s, stoch1, stoch1s, stoch2, stoch2s =0;

   stoch0 = iStochastic(NULL,0,fSTOCH_VALUE,3,3,MODE_SMA,0,MODE_MAIN,0);
   stoch0s = iStochastic(NULL,0,fSTOCH_VALUE,3,3,MODE_SMA,0,MODE_SIGNAL,0);

   stoch1 = iStochastic(NULL,0,fSTOCH_VALUE,3,3,MODE_SMA,0,MODE_MAIN,1);
   stoch1s = iStochastic(NULL,0,fSTOCH_VALUE,3,3,MODE_SMA,0,MODE_SIGNAL,1);

   stoch2 = iStochastic(NULL,0,fSTOCH_VALUE,3,3,MODE_SMA,0,MODE_MAIN,2);
   stoch2s = iStochastic(NULL,0,fSTOCH_VALUE,3,3,MODE_SMA,0,MODE_SIGNAL,2);


// UP means signal is BUY
// DOWN means signal is SELL
   fSTOCH_CROSS = NONE;
   if(stoch0 > stoch0s && stoch0 > 20 && stoch1 > 20 && stoch1 > stoch1s && stoch2 < 20)
      fSTOCH_CROSS = UP;
   if(stoch0 < stoch0s && stoch0 < 80 && stoch1 < 80 && stoch1 < stoch1s && stoch2 > 80)
      fSTOCH_CROSS = DOWN;

   subDISPLAYADD("Stoch 0, 0s", stoch0 + SPC + stoch0s);
   subDISPLAYADD("Stoch 1, 1s", stoch1 + SPC + stoch1s);
   subDISPLAYADD("Stoch Cross", fSTOCH_CROSS);
   subDISPLAYADD(LINE, 0);

   return(fSTOCH_CROSS);

  }







// ------------------------------------------------------------------
// get average fractal range of x bars
// ------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double subAV_FRACTAL_RANGE(int fRANGE)
  {

   if(fRANGE > Bars)
      fRANGE = Bars -1;

   int counter=0;
   int found_fractals=0;

   double fUPF;
   double fDNF;

   double fUPF_ARRAY[];
   double fDNF_ARRAY[];

   ArrayResize(fUPF_ARRAY,fRANGE,1);
   ArrayResize(fDNF_ARRAY,fRANGE,1);

// find x up fractals
   counter=3;

   while(found_fractals < fRANGE)
     {
      fUPF = 0;
      fUPF =  iFractals(NULL,0,MODE_UPPER,counter);
      if(fUPF > 0)
        {
         fUPF_ARRAY[found_fractals] = fUPF;
         found_fractals++;
        }
      counter++;
     }

// reset for finding down fractals
   counter=3;
   found_fractals=0;

   while(found_fractals < fRANGE)
     {
      fDNF = 0;
      fDNF =  iFractals(NULL,0,MODE_LOWER,counter);
      if(fDNF > 0)
        {
         fDNF_ARRAY[found_fractals] = fDNF;
         found_fractals++;
        }
      counter++;
     }






// we've found x up & dn fractals. Now we need the range of each and average them

   double fTOTAL_RANGE=0;
   double fAV_RANGE = 0;

   for(counter=0; counter<fRANGE; counter++)
     {

      fTOTAL_RANGE =  fTOTAL_RANGE + (fUPF_ARRAY[counter] - fDNF_ARRAY[counter]);

     }

   fAV_RANGE = fTOTAL_RANGE / fRANGE;


   return(fAV_RANGE);
  }





// ------------------------------------------------------------------
// get average price of up & down fractals fractal range of x bars
// ------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void subAV_FRACTAL_PRICE(int fRANGE)
  {

   if(fRANGE > Bars)
      fRANGE = Bars -1;

   int counter=0;
   int found_fractals=0;

   double fUPF;
   double fDNF;

   double fUPF_ARRAY[];
   double fDNF_ARRAY[];

   ArrayResize(fUPF_ARRAY,fRANGE,1);
   ArrayResize(fDNF_ARRAY,fRANGE,1);

// find x up fractals
   counter=3;

   while(found_fractals < fRANGE)
     {
      fUPF = 0;
      fUPF =  iFractals(NULL,0,MODE_UPPER,counter);
      if(fUPF > 0)
        {
         fUPF_ARRAY[found_fractals] = fUPF;
         found_fractals++;
        }
      counter++;
     }

// reset for finding down fractals
   counter=3;
   found_fractals=0;

   while(found_fractals < fRANGE)
     {
      fDNF = 0;
      fDNF =  iFractals(NULL,0,MODE_LOWER,counter);
      if(fDNF > 0)
        {
         fDNF_ARRAY[found_fractals] = fDNF;
         found_fractals++;
        }
      counter++;
     }


   double fUPF_PRICE=0;
   double fDNF_PRICE=0;
   double fAVF_PRICE=0;


// we've found x up & dn fractals. Now we need the price of each and average them

   double fTOTAL_RANGE=0;

   for(counter=0; counter<fRANGE; counter++)
     {

      fUPF_PRICE =  fUPF_PRICE + fUPF_ARRAY[counter];
      fDNF_PRICE =  fDNF_PRICE + fDNF_ARRAY[counter];
      fAVF_PRICE =  fAVF_PRICE + ((fUPF_ARRAY[counter] + fDNF_ARRAY[counter]) /2);

     }

   fUPF_PRICE = fUPF_PRICE / fRANGE;
   fDNF_PRICE = fDNF_PRICE / fRANGE;
   fAVF_PRICE = fAVF_PRICE / fRANGE;

   double fHIGHLOWDIFF = fUPF_PRICE - fDNF_PRICE;

   subDISPLAYADD("UPF Av. Price", fUPF_PRICE);
   subDISPLAYADD("DNF Av. Price", fDNF_PRICE);
   subDISPLAYADD("AVF Av. Price", fAVF_PRICE);
   subDISPLAYADD("Bars for Av. Price", fRANGE);
   subDISPLAYADD("High/Low Diff", fHIGHLOWDIFF/gPOINT_VALUE);
   subDISPLAYADD(LINE, 0);



   return;
  }



// ------------------------------------------------------------------------------
// average distance between ma _high and low over x bars, sample every y bars
// ------------------------------------------------------------------------------


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double subAV_MA_DISTANCE(int fNUM_SAMPLES, int fSAMPLE_SIZE)
  {

   int fCOUNTER = 0;
   int fBAR = 0;


   double fHIGH, fLOW, fAV_MA_DISTANCE =0;

   while(fCOUNTER < fNUM_SAMPLES)
     {

      fBAR = fBAR + fSAMPLE_SIZE;

      fHIGH = iMA(NULL,0,cMA_VALUE,0,MODE_EMA,PRICE_HIGH,fBAR);
      fLOW  = iMA(NULL,0,cMA_VALUE,0,MODE_EMA,PRICE_LOW,fBAR);

      fAV_MA_DISTANCE = fAV_MA_DISTANCE + (fHIGH - fLOW);
      if(fCOUNTER >= Bars)
         break;
      fCOUNTER++;

     }

   return(fAV_MA_DISTANCE / fCOUNTER);


  }








// ------------------------------------------------------------------
//  get fractals array
//  fucking beautiful programming
// returns fractal price and which bar it was found at
// so we can finally compute our other checks properly!
// ------------------------------------------------------------------

// second dimension of the array [0] is the fractal price
// second dimension [1] is the bar


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void subFRACTALS_ARRAY(int fNUMBER_OF_FRACTALS)
  {

   ArrayFree(gUPF);
   ArrayFree(gDNF);

   ArrayResize(gUPF, fNUMBER_OF_FRACTALS);
   ArrayResize(gDNF, fNUMBER_OF_FRACTALS);

   int for_counter;
   int while_counter;


// populate up fractals array

   while_counter=3;
   for(for_counter=0; for_counter<fNUMBER_OF_FRACTALS; for_counter++)
     {


      while(gUPF[for_counter][0] == 0)
        {
         gUPF[for_counter][0] = iFractals(NULL,0,MODE_UPPER,while_counter);
         while_counter++;
         if(while_counter >= Bars)
            break;
        }
      gUPF[for_counter][1] = while_counter;
     }


// populate down fractals array

   while_counter=3;
   for(for_counter=0; for_counter<fNUMBER_OF_FRACTALS; for_counter++)
     {


      while(gDNF[for_counter][0] == 0)
        {
         gDNF[for_counter][0] = iFractals(NULL,0,MODE_LOWER,while_counter);
         while_counter++;
         if(while_counter >= Bars)
            break;
        }
      gDNF[for_counter][1] = while_counter;
     }


   subDISPLAYADD("UpFr1, UpFr2", DoubleToStr(gUPF[0][0],Digits) + ", " + gUPF[0][1] + SPC + DoubleToStr(gUPF[1][0],Digits) + ", " + gUPF[1][1]);
   subDISPLAYADD("DnFr1, DnFr2", DoubleToStr(gDNF[0][0],Digits) + ", " + gDNF[0][1] + SPC + DoubleToStr(gDNF[1][0],Digits) + ", " + gDNF[1][1]);
   subDISPLAYADD(LINE, 0);


// these are commonly used

   gUPF1 = gUPF[0][0];
   gUPF2 = gUPF[1][0];
   gUPF3 = gUPF[2][0];

   gUPF1_BAR = gUPF[0][1];
   gUPF2_BAR = gUPF[1][1];
   gUPF3_BAR = gUPF[2][1];


   gDNF1 = gDNF[0][0];
   gDNF2 = gDNF[1][0];
   gDNF3 = gDNF[2][0];

   gDNF1_BAR = gDNF[0][1];
   gDNF2_BAR = gDNF[1][1];
   gDNF3_BAR = gDNF[2][1];



// old stuff
//   string fFRACTALDIR = NONE;
//if ( gDNF1 > gDNF2 ) fFRACTALDIR = UP;
//if ( gUPF1 < gUPF2 ) fFRACTALDIR = DOWN;
//if ( gDNF1 > gDNF2 &&  gUPF1 < gUPF2 ) fFRACTALDIR = NONE;


   return;

  }







// -----------------------------------------------------------------------------------------------
//  std Dev filter
// -----------------------------------------------------------------------------------------------


// true if std_Dev is ok, false if it's not
bool subSTD_DEV()
  {


   if(iStdDev(NULL,0,cSTD_DEV_VALUE,0,MODE_EMA,PRICE_CLOSE,1) > iStdDev(NULL,0,cSTD_DEV_VALUE*100,0,MODE_EMA,PRICE_CLOSE,1))
      return(false);

   return(true);

  }




// -----------------------------------------------------------------------------------------------
//  htf macd
// -----------------------------------------------------------------------------------------------

// mode1 = normal, mode2 = power

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string subHTF_MACD(int fMODE)
  {

   int fHTF = subHTF();

   int fMACD1 = iMACD(NULL,fHTF,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   int fMACD1s = iMACD(NULL,fHTF,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   int fMACD2 = iMACD(NULL,fHTF,12,26,9,PRICE_CLOSE,MODE_MAIN,2);

   if(fMODE != 2)
     {
      if(fMACD1 > 0 && fMACD2 > 0 && fMACD1s > 0)
         return(UP);
      if(fMACD1 < 0 && fMACD2 < 0 && fMACD1s < 0)
         return(DOWN);
     }

   if(fMODE == 2)
     {
      if(fMACD1 > 0 && fMACD1 > fMACD1s && fMACD2 > 0)
         return(UP);
      if(fMACD1 < 0 && fMACD1 < fMACD1s && fMACD2 < 0)
         return(DOWN);
     }


   return(NONE);
  }



// -----------------------------------------------------------------------------------------------
//  htf stoch
// -----------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string subHTF_STOCH(int fDSTOCH_VALUE)
  {

// higher time frame trend info

   int fHTF = subHTF();

   int fDSTOCH1 = iStochastic(NULL,fHTF,fDSTOCH_VALUE,3,3,MODE_SMA,0,MODE_MAIN,1);
   int fDSTOCH1s = iStochastic(NULL,fHTF,fDSTOCH_VALUE,3,3,MODE_SMA,0,MODE_SIGNAL,1);
   int fDSTOCH2 = iStochastic(NULL,fHTF,fDSTOCH_VALUE,3,3,MODE_SMA,0,MODE_MAIN,2);



   if(fDSTOCH1 > fDSTOCH1s && fDSTOCH1 > fDSTOCH2)
      return(UP);
   if(fDSTOCH1 < fDSTOCH1s && fDSTOCH1 < fDSTOCH2)
      return(DOWN);

   return(NONE);

  }


// -----------------------------------------------------------------------------------------------
//  htf rsi
// -----------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string subHTF_RSI(int fRSI_VALUE)
  {

// higher time frame trend info

   string fRSI_TREND = NONE;
   int fHTF = subHTF();

   int fRSI1 = iRSI(NULL,fHTF,fRSI_VALUE,PRICE_CLOSE,1);
   int fRSI2 = iRSI(NULL,fHTF,fRSI_VALUE,PRICE_CLOSE,2);


   fRSI_TREND = NONE;
   if(fRSI1 > 55 && fRSI1 > fRSI2)
      fRSI_TREND =UP;
   if(fRSI1 < 45 && fRSI1 < fRSI2)
      fRSI_TREND =DOWN;

   return(fRSI_TREND);

  }




// -----------------------------------------------------------------------------------------------
//  htf rsi
// -----------------------------------------------------------------------------------------------

// returns true if, on the HTF, rsi @ fractal bar 1 agrees in strength with rsi @ fractal bar 2
// returns true by default, so be careful


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool subHTF_RSI_FRACTAL_FILTER(int fHTF, string fTYPE, bool fDEBUG)
  {

// HTF rsi fractal filter
// true if OK to buy/sell


   if(fTYPE == BUY)
     {



      // up fractals

      double UF1 = 0;
      int UFB1 = 3;

      while(UF1 <= 0)
        {
         UF1 =  iFractals(NULL,fHTF,MODE_UPPER,UFB1);
         UFB1++;
        }

      double UF2 = 0;
      int UFB2 = UFB1 +1;


      while(UF2 <= 0)
        {
         UF2 =  iFractals(NULL,fHTF,MODE_UPPER,UFB2);
         UFB2++;
        }


      double RSI_up1 = iRSI(NULL,fHTF,5,PRICE_CLOSE,UFB1);
      double RSI_up2 = iRSI(NULL,fHTF,5,PRICE_CLOSE,UFB2);


      if(fDEBUG)
        {
         subDISPLAYADD("fTYPE", fTYPE);
         subDISPLAYADD("HTF", fHTF);
         subDISPLAYADD("UPF 1/2 ", UF1 + SPC + UF2);
         subDISPLAYADD("RSI up1/up2", RSI_up1  + SPC + RSI_up2);
         subDISPLAYADD("RSI upb1/upb2", UFB1  + SPC + UFB2);
        }

      if(UF1 > UF2  && RSI_up1 <  RSI_up2)
         return(false);
      else
         return(true);



     }



   if(fTYPE == SELL)
     {

      // down fractals

      double DF1 = 0;
      int DFB1 = 3;


      while(DF1 <= 0)
        {
         DF1 =  iFractals(NULL,fHTF,MODE_LOWER,DFB1);
         DFB1++;
        }


      double DF2 = 0;
      int DFB2 = DFB1 +1;



      while(DF2 <= 0)
        {
         DF2 =  iFractals(NULL,fHTF,MODE_LOWER,DFB2);
         DFB2++;
        }



      // now to compute

      double RSI_dn1 = iRSI(NULL,fHTF,5,PRICE_CLOSE,DFB1);
      double RSI_dn2 = iRSI(NULL,fHTF,5,PRICE_CLOSE,DFB2);


      if(DF1 < DF2  && RSI_dn1 > RSI_dn2)
         return(false);
      else
         return(true);


     }

   return(false);

  }





// -----------------------------------------------------------------------------------------------
//  atr OK
// -----------------------------------------------------------------------------------------------



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool subATR_OK()
  {

   double atr_low =0;
   double atr_high=0 ;


   atr_low = iATR(NULL,0,10,1);
   atr_high = iATR(NULL,0,100,1);



   if(atr_low > atr_high)
      return(true);


   return(false);
  }





// ------------------------------------------------------------------------------
//   rsi average
// ------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double subAVERAGE_RSI(int fTIMEFRAME, int fRSI_VALUE, int fBARS)
  {

   if(fBARS > Bars)
      fBARS = Bars -1;


   double fAV_BARS = 0;


   for(int counter=1; counter<=fBARS; counter++)
     {
      fAV_BARS = fAV_BARS + iRSI(NULL,fTIMEFRAME,fRSI_VALUE,PRICE_CLOSE,counter);
     }



   return(fAV_BARS / fBARS);

  }




// ------------------------------------------------------------------------------
// average vol
// ------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double subAV_VOL(int fBARS)
  {

   if(fBARS > Bars)
      fBARS = Bars -1;

   double fAV_BARS = 0;


   for(int counter=1; counter<=fBARS; counter++)
     {
      fAV_BARS = fAV_BARS + iVolume(NULL,0,counter);
     }

   return(fAV_BARS / fBARS);

  }   
//+------------------------------------------------------------------+
