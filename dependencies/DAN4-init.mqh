
// ------------------------------------------------------------------------------------------

int OnInit()
  {
   
   MathSrand( GetTickCount() + TimeLocal() );
//   int fTIMER_RAND = 1 + 5*MathRand()/32768;   // 1-5
   int fTIMER_RAND = 1;
   int fMYTIMER = cMYTIMER + fTIMER_RAND;

   if ( PERIOD_CURRENT == PERIOD_M1 && fMYTIMER > 5 ) fMYTIMER = 5;
   if ( PERIOD_CURRENT == PERIOD_M5 && fMYTIMER > 5 ) fMYTIMER = 15;

   EventSetTimer(fMYTIMER);
   
   
   if(Digits==4 || Digits==2) gPOINT_VALUE=Point;  else if(Digits==5 || Digits==3) gPOINT_VALUE=10.0*Point;
   
   
return(INIT_SUCCEEDED);

  }


// ------------------------------------------------------------------------------------------

void OnTick() { }

// ------------------------------------------------------------------------------------------

void OnDeinit(const int reason) {   
   EventKillTimer();  
   // ObjectsDeleteAll();   
   
   ObjectDelete("High");
   ObjectDelete("Low");
   
   return; }
   
// ------------------------------------------------------------------------------------------


void OnTimer()
  {
      subAV_SPREAD();
      subOPENDECISION(); 
      subORDERSTATUS();

      gSPREAD =   MarketInfo(Symbol(),MODE_SPREAD);

      if (gBUYTRADES > 0 || gSELLTRADES > 0 ) {  subCHECK_TRAILING_STOP(); subORDERSTATUS(); subCLOSEDECISION(); }
   
      subDisplay();

      MathSrand( GetTickCount() + TimeLocal() );
      int fTIMER_RAND = 1 + 10*MathRand()/32768;   // 1-10
      //Sleep(fTIMER_RAND*100);
      Sleep(1000);
   
   return; // end of program

  }


