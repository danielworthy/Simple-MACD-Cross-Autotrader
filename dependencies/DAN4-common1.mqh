   
// ------------------------------------------------------------------------------------------
// draw
// ------------------------------------------------------------------------------------------

void subDraw()
{

   //double boxcolor = LightGray;
   //ObjectDelete("Rectangle");
   //ObjectCreate("Rectangle", OBJ_RECTANGLE, 0, iTime(NULL,0,1), gHIGH, iTime(NULL,0,bc), gLOW);
   //ObjectSet("Rectangle", OBJPROP_COLOR, boxcolor); 

 
   subDRAWLINE("High", gHIGH, Orange, 2, 0);
   subDRAWLINE("Low", gLOW, Orange, 2, 0);
 
            
   
return;   
}


// ------------------------------------------------------------------------------------------
// drawline
// ------------------------------------------------------------------------------------------


void subDRAWLINE(string LINE_NAME, double LINE_VALUE, double LINE_COLOR, int LINE_WIDTH, int LINE_STYLE)  
   {

//linetext = "dgHIGHl"; ObjectDelete(linetext);  ObjectCreate(linetext,OBJ_HLINE,0,0,gHIGH); ObjectSet(linetext, OBJPROP_COLOR, Yellow); ObjectSet(linetext, OBJPROP_WIDTH, 1); ObjectSet(linetext, OBJPROP_STYLE, 0);
   ObjectDelete(LINE_NAME);  
   ObjectCreate(LINE_NAME,OBJ_HLINE,0,0,LINE_VALUE); 
   ObjectSet(LINE_NAME, OBJPROP_COLOR, LINE_COLOR); 
   ObjectSet(LINE_NAME, OBJPROP_WIDTH, LINE_WIDTH); 
   ObjectSet(LINE_NAME, OBJPROP_STYLE, LINE_STYLE);   // usually 0 ?

   }



// ------------------------------------------------------------------------------------------
// display
// ------------------------------------------------------------------------------------------

void subDisplay() {

if (IsTesting()) return;

   string sComm   = "";
   
   sComm = LINE;
   
   sComm = StringConcatenate(sComm, "Server -> ", AccountServer(), SPC);
   sComm = StringConcatenate(sComm, "Lots -> ", DoubleToStr(subMYLOTS(),2), SPC);
   
   //sComm = sComm + "Lots -> " + DoubleToStr(Lots,2) + SPC;
   sComm = sComm + "Spread -> " + DoubleToStr(gSPREAD,2) + SPC;
   sComm = sComm + "Leverage -> " + AccountLeverage() + SPC;
   sComm = sComm + "Digits -> " + Digits + SPC;
   sComm = sComm + "Point -> " + Point + SPC;
   sComm = sComm + "Currency -> " + AccountCurrency() + SPC;
   sComm = sComm + "Profit -> " + DoubleToStr(AccountProfit(),2) + SPC;
   sComm = sComm + "Equity -> " + DoubleToStr(AccountEquity(),2) + SPC;
   sComm = sComm + "Margin -> " + DoubleToStr(AccountMargin(),2) + SPC;
   sComm = sComm + "Bars -> " + Bars;
   

   sComm = sComm + NL + LINE;   
   sComm = sComm + subNextBar();
   sComm = sComm + "Basket Profit -> " + DoubleToStr(gBASKET ,2) + NL;
   sComm = sComm + "Margin Check -> " + DoubleToStr(MarginCheck(),2) + NL;

   
   sComm = sComm + LINE; 
   sComm = sComm + "Buffer -> " + cBUFFER + NL; 


   sComm = sComm + LINE; 
   sComm = sComm + "ATR Stops -> " + cATR_STOPS + NL; 


   sComm = sComm + LINE;
   sComm = sComm + "Pending Trades -> " + gPENDING_TRADES + NL; 
   sComm = sComm + "Buy Trades -> " + gBUYTRADES + SPC; 
   sComm = sComm + "Buy Profit -> " + DoubleToStr(gBUYPROFIT,2) + NL; 
   sComm = sComm + "Sell Trades -> " + gSELLTRADES + SPC; 
   sComm = sComm + "Sell Profit -> " + DoubleToStr(gSELLPROFIT,2) + NL; 

   sComm = sComm + LINE;
   sComm = sComm + globalDISPLAY;

Comment(sComm);

globalDISPLAY="";
return;
}




//------------------------------------------------------------------
// time to next bar
//------------------------------------------------------------------

string subNextBar() {
//Code for time to bar-end display from Candle Time by Nick Bilak
   double i;
   int m,s;
   m=Time[0]+Period()*60-CurTime();
   i=m/60.0;
   s=m%60;
   m=(m-m%60)/60;
   
   string TTNB;
   
   TTNB = "Time to Next Bar -> " + m + ":" + s + "\n";
   
   return(TTNB);

}




//-----------------------------------------------------------
//  cMARGIN check
//-----------------------------------------------------------

double MarginCheck()     {
     double am;
     if ( AccountMargin()==0 ) return(cMARGIN+1);
      else if ( AccountMargin() > 0 ) { am = (AccountEquity()/AccountMargin())*100; return(am); }
     return(false);
}








// ------------------------------------------------------------------
// set stop values
// ------------------------------------------------------------------

void subStops(int fTP, int fSL, int fTS) {

// 0 means autoset
   if ( cTAKEPROFIT == 0 )   gTAKEPROFIT = fTP;   else gTAKEPROFIT = cTAKEPROFIT;
   if ( cSTOPLOSS == 0 )     gSTOPLOSS = fSL;     else gSTOPLOSS = cSTOPLOSS;
   if ( cTRAILINGSTOP == 0 ) gTRAILINGSTOP = fTS; else gTRAILINGSTOP = cTRAILINGSTOP;

   double fPERCENTWINS =   subORDERHISTORYSTATS(0);


   // if we've lost a lot, then reduce Trailing stop by a bit
   if ( cDYNAMIC_TS ) {
      if ( gPROFITHISTORY  < 0 ) gTRAILINGSTOP = gTRAILINGSTOP * 0.90;
      if (fPERCENTWINS > 0.66 ) gTRAILINGSTOP = gTRAILINGSTOP;
      if (fPERCENTWINS <= 0.66 && fPERCENTWINS > 0.33 ) gTRAILINGSTOP = gTRAILINGSTOP * 0.90;
      if (fPERCENTWINS <= 0.33 ) gTRAILINGSTOP = gTRAILINGSTOP * 0.70;
   }
   



   if ( cFRACTAL_STOPLOSS ) gSTOPLOSS = gFR_AV_RANGE3+ (gFR_AV_RANGE3* 0.2);



   if ( gTAKEPROFIT < 10 ) gTAKEPROFIT = 10;
   if ( gSTOPLOSS < cMIN_STOPLOSS ) gSTOPLOSS  = cMIN_STOPLOSS;
   if ( gTRAILINGSTOP < cMIN_TRAILINGSTOP ) gTRAILINGSTOP = cMIN_TRAILINGSTOP;

   

   subDISPLAYADD("TakeProfit, StopLoss, TrailingStop", gTAKEPROFIT + SPC + gSTOPLOSS + SPC + gTRAILINGSTOP);   
   subDISPLAYADD(LINE,0);

return;

}












// --------------------------------------------------------------------------------
// add to display variable
// --------------------------------------------------------------------------------

void subDISPLAYADD(string label, string value) {

   if (label == LINE ) { globalDISPLAY = StringConcatenate(globalDISPLAY, LINE); } else    
   globalDISPLAY = StringConcatenate(globalDISPLAY, label, " -> ", value, NL);
}


// --------------------------------------------------------------------------------
// calculate lot size
// --------------------------------------------------------------------------------

double subMYLOTS() {

   double fMYLOTS =0;

   if (cLOTS == 0) fMYLOTS = (AccountEquity()/10000)/cLOT_DIVISOR; else fMYLOTS = cLOTS; fMYLOTS = NormalizeDouble(fMYLOTS,2);

   double fPERCENTWINS =   subORDERHISTORYSTATS(0);
   
   if ( fPERCENTWINS  < 0.66 && fPERCENTWINS > 0.5  )  fMYLOTS = fMYLOTS * 0.80;
   if ( fPERCENTWINS  <= 0.5 && fPERCENTWINS > 0.33  ) fMYLOTS = fMYLOTS * 0.60;
   if ( fPERCENTWINS  <= 0.33 && fPERCENTWINS > 0.0 )  fMYLOTS = fMYLOTS * 0.40;
   
   
   if ( fMYLOTS < 0.01 ) fMYLOTS = 0.01;


   return(fMYLOTS);

}





// -----------------------------------------------------------------------------------------------
//  Set Spread and calc av. spread
// -----------------------------------------------------------------------------------------------


int subAV_SPREAD() {


   //if ( ! IsTradeAllowed() ) ; return(5);

   
   int fSPREAD = MarketInfo(Symbol(),MODE_SPREAD);
   

   // sanitize the spread
   if ( fSPREAD < 1 ) fSPREAD = 1;
   if ( fSPREAD > 20 ) fSPREAD = 20;


   // get items in array
   int fITEMS = ArrayRange(gSPREAD_ARRAY,0);


   // add extra storage to array
   ArrayResize(gSPREAD_ARRAY,fITEMS+1);



   // add spread to array
   gSPREAD_ARRAY[fITEMS] = fSPREAD;


   int fINT=0;
   int fTOTAL=0;
   int fCOUNT = ArrayRange(gSPREAD_ARRAY,0);


   for(fINT=0;fINT<fCOUNT;fINT++)  {
      fTOTAL = fTOTAL + gSPREAD_ARRAY[fINT];
      }


   int fAV_SPREAD = fTOTAL / fCOUNT ;
   
   
   
   
   if ( fAV_SPREAD < 1 ) fAV_SPREAD = 1;
   if ( fAV_SPREAD > 20 ) fAV_SPREAD = 20;
  
  
   return(fAV_SPREAD);
   
   
}



   