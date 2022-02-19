#include <dependencies/DAN4-common_def.mqh>
#include <dependencies/DAN4-common1.mqh>
#include <dependencies/DAN4-order_functions.mqh>
#include <dependencies/DAN4-init.mqh>
#include <dependencies/DAN4-setup.mqh>
#include <dependencies/DAN4-order_info.mqh>
#include <dependencies/DAN4-trailing_stop_functions.mqh>
#include <dependencies/DAN4-indicators.mqh>


// --------------------------------------------------------------------------------------------------------------------------------------------------------------
//   dan5 - 1 trade per cross method
// --------------------------------------------------------------------------------------------------------------------------------------------------------------

// last modified 2020-07-20



  
extern string           Expert_Name          = "DAN5 - more simple H4 or D1 macd cross";

// const bool            TRADE = true;
const bool            TRADE = true;
const int            cTOTAL_GLOBAL_ORDERS_OPEN = 5;

const int         cTAKEPROFIT = 0;
const int         cSTOPLOSS = 0;
const int         cTRAILINGSTOP = 0;
const bool        cATR_STOPS = true;
const double      cSTOPLOSSMULT = 3;
const double      cTRAILINGSTOPMULT = 2.5;
const bool        cFRACTAL_STOPLOSS = false;   // should over-rule all other SL settings
const bool        cDYNAMIC_TS = false;   // ajust trailing stop according to win/loss ratio
const bool        cDYNAMIC_SL = false;   // ajust stop loss according to win/loss ratio + trend power
const int         cBREAKEVENPIPS = 0;
const int         cEXPIRATION = 6;
const int         cBUFFER = 10;
const bool        cHTF_MODE = false;
const int         cHTF_RSI_VALUE = 20;
const int         cCCI_VALUE = 100;
const int         cBARCOUNT = 100;
const double      cLOTS = 0;
const int         cLOT_DIVISOR = 10;
const int         cMYTIMER = 10;
const int         cMIN_STOPLOSS = 10;
const int         cMIN_TRAILINGSTOP = 10;
const double      cMAX_SPREAD_SLIP_PERCENT = 0.2;  // 20 percent
const int         cMAXBARCOUNTMULT = 5;
const int         cMYAVERAGE = 10;

const int      cMOVINGAVERAGEVALUE = 100;  
const int      cRSI_VALUE = 20;



int gSPREAD_ARRAY[];


int cMAX_TRADES = 100; 
int cMARGIN = 500;

// ------------------------------------------------------------------------------------------

// most EA's use these
int gBUYTRADES, gSELLTRADES, gBUY_PENDING, gSELL_PENDING, gSELL_LIMIT, gBUY_LIMIT, gPENDING_TRADES, gTOTALOPENORDERS, gGLOBALOPENORDERS=0;
double gBUYPROFIT, gSELLPROFIT, gBASKET, gORDER_TIME, gPOINT_VALUE=0;
int gSPREAD, gSPREAD_COUNTER, gTOTAL_SPREAD, gAVERAGE_SPREAD=0;
double P, R1, R2, R3, S1, S2, S3 =0;
int gTAKEPROFIT, gSTOPLOSS, gTRAILINGSTOP =0;
string globalDISPLAY ="";
double gUPF[][2];
double gDNF[][2];
double gATR, gCLOSE1, gOPEN1, gHIGH, gLOW =0;
double gPROFITHISTORY=0;
double gDAY_HIGH, gDAY_LOW;

double cMA_VALUE=0;
double cSTD_DEV_VALUE=0;

// ------------------------------------------------------------------------------------------

// vars that may be specific to this EA only


string gTREND="";

double gFR_AV_RANGE1, gFR_AV_RANGE2, gFR_AV_RANGE3  =0;
double gUPF1, gUPF2, gUPF3, gDNF1, gDNF2, gDNF3 =0;

int    gUPF1_BAR, gUPF2_BAR, gUPF3_BAR, gDNF1_BAR, gDNF2_BAR, gDNF3_BAR =0;

int gHTF_RSI=0;

double gMACD, gMACD_SIGNAL =0;

static datetime Time0;


// ------------------------------------------------------------------------------------------
//  Open Decisions
// ------------------------------------------------------------------------------------------

void subOPENDECISION() {

  RefreshRates();    
  


//   if (Time0 == Time[0]) return; Time0 = Time[0];


   Sleep(5*1000);


  
  subORDERSTATUS();
  
   gCLOSE1 = iClose(NULL,0,1);
   gOPEN1 = iOpen(NULL,0,1);
   
   
   int fATR_BARS = 1000; 
   if ( fATR_BARS  > Bars ) fATR_BARS = Bars -1;
   gATR = iATR(NULL,0,fATR_BARS,1);
   
   
   
   int fBARCOUNT = subMAXBARS();


   // get fractal info! and load the first few into easy to read vars
   subFRACTALS_ARRAY(4);

   // display atr and fractal range for fun
   double atr100 =  iATR(NULL,0,100,1);
   double atr1000 =  iATR(NULL,0,1000,1);
   
   gFR_AV_RANGE1 = (gUPF1 - gDNF1) / gPOINT_VALUE;
   gFR_AV_RANGE2 = subAV_FRACTAL_RANGE(10) / gPOINT_VALUE;
   gFR_AV_RANGE3 = subAV_FRACTAL_RANGE(100) / gPOINT_VALUE;


   double fFRACTAL_UP_RANGE1 = MathAbs(gUPF1 - gUPF2);
   double fFRACTAL_DN_RANGE1 = MathAbs(gDNF1 - gDNF2);

   
   int fHTF = subHTF();
   
   gHTF_RSI = iRSI(NULL,fHTF,cHTF_RSI_VALUE,PRICE_CLOSE,1);


   gMACD = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   gMACD_SIGNAL= iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);

   



// CROSS
   double macd_upf1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,gUPF1_BAR);
   double macd_upf2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,gUPF2_BAR);

   double macd_dnf1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,gDNF1_BAR);
   double macd_dnf2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,gDNF2_BAR);


   string fCROSS = NONE;
   if ( macd_upf1 > macd_upf2 && macd_upf1 > 0 && macd_upf2 < 0 ) fCROSS = UP;
   if ( macd_dnf1 < macd_dnf2 && macd_dnf1 < 0 && macd_dnf2 > 0 ) fCROSS = DOWN;
   


// confirm cross

   bool fADX_BUY_CONFIRM = false;
   bool fADX_SELL_CONFIRM = false;
   
   int fADX = iADX(NULL,0,20,PRICE_CLOSE,MODE_MAIN,1);
   
   double adx_upf1 = iADX(NULL,0,20,PRICE_CLOSE,MODE_MAIN,gUPF1_BAR);
   double adx_upf2 = iADX(NULL,0,20,PRICE_CLOSE,MODE_MAIN,gUPF2_BAR);
   
   double adx_dnf1 = iADX(NULL,0,20,PRICE_CLOSE,MODE_MAIN,gDNF1_BAR);
   double adx_dnf2 = iADX(NULL,0,20,PRICE_CLOSE,MODE_MAIN,gDNF2_BAR);
   
   
   if ( adx_upf1 > adx_upf2 ) fADX_BUY_CONFIRM = true;
   if ( adx_dnf1 > adx_dnf2 ) fADX_SELL_CONFIRM = true;




   // htf accumulation/distribution
   double fHTF_AD_1=iAD(NULL, fHTF, 1);
   double fHTF_AD_2=iAD(NULL, fHTF, 10);
      


// a/d ok
   bool fAD_BUY_OK = false; 
   bool fAD_SELL_OK = false; 
     
   
   double fAD_UPF1 = iAD(NULL,0,gUPF1_BAR);
   double fAD_UPF2 = iAD(NULL,0,gUPF2_BAR);

   double fAD_DNF1 = iAD(NULL,0,gDNF1_BAR);
   double fAD_DNF2 = iAD(NULL,0,gDNF2_BAR);


   if ( fAD_UPF1 > fAD_UPF2 ) fAD_BUY_OK = true;
   if ( fAD_DNF1 < fAD_DNF2 ) fAD_SELL_OK = true;
   




// vol ok
   bool fVOL_BUY_OK = false; 
   bool fVOL_SELL_OK = false; 
   
   double fVOL_UPF1 = iVolume(NULL,0,gUPF1_BAR);
   double fVOL_UPF2 = iVolume(NULL,0,gUPF2_BAR);

   double fVOL_DNF1 = iVolume(NULL,0,gDNF1_BAR);
   double fVOL_DNF2 = iVolume(NULL,0,gDNF2_BAR);


   if ( fVOL_UPF1 > fVOL_UPF2 ) fVOL_BUY_OK = true;
   if ( fVOL_DNF1 > fVOL_DNF2 ) fVOL_SELL_OK = true;
   
   


   

// get values before comparisons!!   

      
   gHIGH = High[iHighest(NULL,0,MODE_HIGH,fBARCOUNT,1)];
   gLOW = Low[iLowest(NULL,0,MODE_LOW,fBARCOUNT,1)];


   double fHIGH_AT_UPF2_BAR = High[iHighest(NULL,0,MODE_HIGH,fBARCOUNT,gUPF2_BAR)];
   double fLOW_AT_DNF2_BAR =   Low[iLowest(NULL,0,MODE_LOW,fBARCOUNT,gDNF2_BAR)];


   
   
   // sets gSTOPLOSS and so forth, depending on values of ATR if ATR stops is set
   if (!cATR_STOPS) { subStops(500, (gFR_AV_RANGE2*cSTOPLOSSMULT)/gPOINT_VALUE, (gFR_AV_RANGE2*cTRAILINGSTOPMULT)/gPOINT_VALUE); }  
      else if (cATR_STOPS) 
         { subStops(500, (gATR*cSTOPLOSSMULT)/gPOINT_VALUE, (gATR*cTRAILINGSTOPMULT)/gPOINT_VALUE); }
      
   
   int fSPREAD = gSPREAD;
   if ( fSPREAD > subMAXSPREAD() ) fSPREAD = subMAXSPREAD();
   
   double fBUY_STOPLOSS  =  fFRACTAL_UP_RANGE1 + ( fSPREAD * gPOINT_VALUE);
   double fSELL_STOPLOSS =  fFRACTAL_DN_RANGE1 + ( fSPREAD * gPOINT_VALUE); 
   if (fBUY_STOPLOSS  < gATR*cSTOPLOSSMULT ) fBUY_STOPLOSS  = gATR*cSTOPLOSSMULT;  
   if (fSELL_STOPLOSS < gATR*cSTOPLOSSMULT ) fSELL_STOPLOSS = gATR*cSTOPLOSSMULT;  
      
      
   

// this defines roughly the shape the prices should be taking
// current tf - fractal shape - break into own code
   bool fFRACTAL_BUY_SHAPE = false;   
   bool fFRACTAL_SELL_SHAPE = false;   
   
   
   if (  gCLOSE1 < gUPF1  && gCLOSE1 > gDNF2    && gUPF1 > gUPF2  && gUPF1 > gDNF1    && gUPF1_BAR < gDNF1_BAR  ) fFRACTAL_BUY_SHAPE = true;
   if (  gCLOSE1 > gDNF1  && gCLOSE1 < gUPF2    && gDNF1 < gDNF2  && gDNF1 < gUPF1    && gDNF1_BAR < gUPF1_BAR  )   fFRACTAL_SELL_SHAPE = true;

   
   string fCONDITION = NONE;
      
      if (  fCROSS == UP    &&  fADX_BUY_CONFIRM     && fFRACTAL_BUY_SHAPE  && fVOL_BUY_OK && fAD_BUY_OK )  fCONDITION = BUY; 
    if (  fCROSS == DOWN  &&  fADX_SELL_CONFIRM   && fFRACTAL_SELL_SHAPE    && fVOL_SELL_OK && fAD_SELL_OK )   fCONDITION = SELL; 

      
   

   subDISPLAYADD("TRADING ENABLED", TRADE);  
   subDISPLAYADD("Point Value", Point);
   subDISPLAYADD("HTF", fHTF);
   subDISPLAYADD("Stoploss Set", subISTRAILINGSTOPSET() );
   subDISPLAYADD("ATR 100/1000 ", (atr100 / gPOINT_VALUE) + SPC + (atr1000/ gPOINT_VALUE) );  
   subDISPLAYADD("Fractal Range 1/10/100", gFR_AV_RANGE1 + SPC + gFR_AV_RANGE2 + SPC + gFR_AV_RANGE3);   
   subDISPLAYADD("Fractal Up/Dn Range 1", fFRACTAL_UP_RANGE1/gPOINT_VALUE + SPC + fFRACTAL_DN_RANGE1/gPOINT_VALUE);
   subDISPLAYADD("MACD - upf1/2, dnf1/2", macd_upf1 + SPC + macd_upf2 + SPC + macd_dnf1 + SPC + macd_dnf2 );
   subDISPLAYADD("ADX  - upf1/2, dnf1/2", adx_upf1 + SPC + adx_upf2 + SPC + adx_dnf1 + SPC + adx_dnf2 );
   subDISPLAYADD("MACD, Signal", gMACD + SPC + gMACD_SIGNAL );
   subDISPLAYADD("HTF RSI", gHTF_RSI);
   subDISPLAYADD("ADX Confirm", fADX_BUY_CONFIRM + SPC + fADX_SELL_CONFIRM );
   subDISPLAYADD("ATR SUB OK",  subATR_OK() );
   subDISPLAYADD("Fractal Shape", fFRACTAL_BUY_SHAPE + SPC + fFRACTAL_SELL_SHAPE);
   subDISPLAYADD("Cross", fCROSS);
   subDISPLAYADD(LINE, 0);   

   subORDERSTATUS();
   
   
   if ( TRADE  ) {   
      if ( gBUYTRADES == 0  && gBUY_PENDING == 0  && fCONDITION == BUY  && Bid > gDNF1 && Ask < gUPF1  )  {  subStops(500, fBUY_STOPLOSS/gPOINT_VALUE,  (gATR*cTRAILINGSTOPMULT)/gPOINT_VALUE);  subSETORDERS(BUY, gUPF1); }
      if ( gSELLTRADES == 0 && gSELL_PENDING == 0 && fCONDITION == SELL && Ask < gUPF1 && Bid > gDNF1  )  {  subStops(500, fSELL_STOPLOSS/gPOINT_VALUE, (gATR*cTRAILINGSTOPMULT)/gPOINT_VALUE);  subSETORDERS(SELL, gDNF1); }
       }

   subDraw();

return;      
}





// ------------------------------------------------------------------------------------------
// Close Decision
// ------------------------------------------------------------------------------------------

void subCLOSEDECISION() {

subORDERSTATUS();
if ( gSELLTRADES > 0 && gBUYTRADES > 0 && gBASKET > 1 )   { subCLOSEALL(); }

  

if ( ! subISTRAILINGSTOPSET() ) {

   
   if ( gBUYPROFIT > 0 ) {
      if (  gMACD  < 0  ){ subCLOSE(BUY); subDeleteOrders(BUY); }
   
   }


   if ( gSELLPROFIT > 0 ) {
      if ( gMACD > 0   ){ subCLOSE(SELL); subDeleteOrders(SELL); }
   
   }


}

   // kills off trades forcably if cMARGIN is low or too many trades only if the gBASKETs are making money
   if (MarginCheck() < cMARGIN      && gBASKET  > 1 ) { subCLOSEALL(); }
   if (gTOTALOPENORDERS > cMAX_TRADES && gBASKET  > 1 ) { subCLOSEALL();  }
   if (MarginCheck() < cMARGIN && AccountProfit() > 1  ) { subCLOSE(EVERYTHING); }

return;

}





//

