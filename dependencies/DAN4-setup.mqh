

// -----------------------------------------------------------------------------------------------
//  max bars
// -----------------------------------------------------------------------------------------------

int subMAXBARS() {

   int CurrentPeriod = Period();
   int MAXBARS=Period();
   
   if ( CurrentPeriod == PERIOD_M1 ) MAXBARS = 120;
   if ( CurrentPeriod == PERIOD_M5 ) MAXBARS = 50;
   if ( CurrentPeriod == PERIOD_M15 ) MAXBARS = 20;
   if ( CurrentPeriod == PERIOD_M30 ) MAXBARS = 15;
   if ( CurrentPeriod == PERIOD_H1 ) MAXBARS = 10;
   if ( CurrentPeriod == PERIOD_H4 ) MAXBARS = 5;
   if ( CurrentPeriod == PERIOD_D1 ) MAXBARS = 5;
   if ( CurrentPeriod == PERIOD_W1 ) MAXBARS = 5; 
   if ( CurrentPeriod == PERIOD_MN1 ) MAXBARS = 5;

   //subDISPLAYADD("HTF", HTF );
   //subDISPLAYADD(LINE, 0);

return(MAXBARS);
}



// -----------------------------------------------------------------------------------------------
//  Higher Time Frame Convert
// -----------------------------------------------------------------------------------------------

// 2019-11-13 - changed them a bit

int subHTF() {

   int CurrentPeriod = Period();
   int HTF=Period();
   
   if ( CurrentPeriod == PERIOD_M1 ) HTF = PERIOD_M30;
   if ( CurrentPeriod == PERIOD_M5 ) HTF = PERIOD_H1;
   if ( CurrentPeriod == PERIOD_M15 ) HTF = PERIOD_H4;
   if ( CurrentPeriod == PERIOD_M30 ) HTF = PERIOD_D1;
   if ( CurrentPeriod == PERIOD_H1 ) HTF = PERIOD_D1;
   if ( CurrentPeriod == PERIOD_H4 ) HTF = PERIOD_W1;
   if ( CurrentPeriod == PERIOD_D1 ) HTF = PERIOD_M1;
   if ( CurrentPeriod == PERIOD_W1 ) HTF = PERIOD_MN1;
   if ( CurrentPeriod == PERIOD_MN1 ) HTF = PERIOD_MN1;

   //subDISPLAYADD("HTF", HTF );
   //subDISPLAYADD(LINE, 0);

return(HTF);
}






// -----------------------------------------------------------------------------------------------
//  max bars
// -----------------------------------------------------------------------------------------------

int subMAXSPREAD() {

   int CurrentPeriod = Period();
   int MAXSPREAD=Period();
   
   if ( CurrentPeriod == PERIOD_M1 ) MAXSPREAD = 5;
   if ( CurrentPeriod == PERIOD_M5 ) MAXSPREAD = 5;
   if ( CurrentPeriod == PERIOD_M15 ) MAXSPREAD = 8;
   if ( CurrentPeriod == PERIOD_M30 ) MAXSPREAD = 8;
   if ( CurrentPeriod == PERIOD_H1 ) MAXSPREAD = 10;
   if ( CurrentPeriod == PERIOD_H4 ) MAXSPREAD = 20;
   if ( CurrentPeriod == PERIOD_D1 ) MAXSPREAD = 30;
   if ( CurrentPeriod == PERIOD_W1 ) MAXSPREAD = 40; 
   if ( CurrentPeriod == PERIOD_MN1 ) MAXSPREAD = 50;

   //subDISPLAYADD("HTF", HTF );
   //subDISPLAYADD(LINE, 0);

return(MAXSPREAD);
}
