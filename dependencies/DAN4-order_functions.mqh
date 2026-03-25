

// ------------------------------------------------------------------------------------------
// Set the orders
// ------------------------------------------------------------------------------------------

void subSETORDERS(string fORDERTYPE, double fVALUE) {


   if (!IsTradeAllowed() || IsTradeContextBusy() ) return;
   if (gSPREAD > subMAXSPREAD() ) return;

   fVALUE = NormalizeDouble(fVALUE,Digits);

   int ticket=0; 
   double sl=0; 
   double tp = 0; 

   gORDER_TIME = 0; 
   if (cEXPIRATION == 1) gORDER_TIME = TimeCurrent()+3600;
   if (cEXPIRATION == 2) gORDER_TIME = TimeCurrent()+7200;
   if (cEXPIRATION == 3) gORDER_TIME = TimeCurrent()+14400;
   if (cEXPIRATION == 4) gORDER_TIME = TimeCurrent()+28800;
   if (cEXPIRATION == 5) gORDER_TIME = TimeCurrent()+86400;
   if (cEXPIRATION == 6) gORDER_TIME = TimeCurrent()+432000;

   
   int CurrentPeriod = Period();    
   if ( CurrentPeriod == PERIOD_M1 ) gORDER_TIME = TimeCurrent()+(3600*2);
   if ( CurrentPeriod == PERIOD_M5 ) gORDER_TIME = TimeCurrent()+(3600*3);
   if ( CurrentPeriod == PERIOD_M15 ) gORDER_TIME = TimeCurrent()+(3600*6);
   if ( CurrentPeriod == PERIOD_M30 ) gORDER_TIME = TimeCurrent()+(3600*6);
   if ( CurrentPeriod == PERIOD_H1 ) gORDER_TIME = TimeCurrent()+(3600*16);
   if ( CurrentPeriod == PERIOD_H4 ) gORDER_TIME = TimeCurrent()+(3600*46);
   if ( CurrentPeriod == PERIOD_D1 ) gORDER_TIME = TimeCurrent()+(3600*24*8);
   if ( CurrentPeriod == PERIOD_W1 ) gORDER_TIME = TimeCurrent()+(3600*24*16);
   if ( CurrentPeriod == PERIOD_MN1 ) gORDER_TIME = TimeCurrent()+(3600*24*560);
   
   
   double fLOTS = subMYLOTS();

   
   // take profit and stop loss need values in human-readable format (eg, 30, 200, 500)
   
      ticket = 0;
      if (fORDERTYPE == BUY  && Ask < fVALUE && gSTOPLOSS >= 0  ) { tp = fVALUE+gTAKEPROFIT*gPOINT_VALUE; sl = fVALUE-gSTOPLOSS*gPOINT_VALUE; ticket=OrderSend(Symbol(),OP_BUYSTOP,fLOTS,fVALUE,5,sl,tp," ",0,gORDER_TIME,Blue);  } 
      
      ticket = 0;
      if (fORDERTYPE == SELL && Bid > fVALUE && gSTOPLOSS >=0  ) { tp = fVALUE-gTAKEPROFIT*gPOINT_VALUE; sl = fVALUE+gSTOPLOSS*gPOINT_VALUE;  ticket=OrderSend(Symbol(),OP_SELLSTOP,fLOTS,fVALUE,5,sl,tp," ",0,gORDER_TIME,Red);  }
      
      
return;
}





// --------------------------------------------------------------------------------
// Delete Pending Orders
// --------------------------------------------------------------------------------

void subDeleteOrders(string fORDERTYPE)
{
   
   int x=0;
      
   subORDERSTATUS();
   
      for(int counter=0;counter<OrdersTotal();counter++)
   {
      if (!IsTradeAllowed() || IsTradeContextBusy() ) return;
      x = OrderSelect(counter,SELECT_BY_POS,MODE_TRADES);
      
      if (OrderSymbol() == Symbol() ) {
      
         if( fORDERTYPE == ALL &&  (OrderType() >= 2 || OrderType() <=5)  ) x = OrderDelete(OrderTicket(),Green);
         if( fORDERTYPE == BUY && (OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT )  ) x = OrderDelete(OrderTicket(),Green);
         if( fORDERTYPE == SELL && (OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT )  ) x = OrderDelete(OrderTicket(),Green);
            
      }
      
   }
      
   return;
}




// --------------------------------------------------------------------------------------------
//  CLOSE ORDER FUNCTION
// --------------------------------------------------------------------------------------------

void subCLOSE(string fORDERTYPE)  // takes BUY SELL or ALL
{
   int x= 0;
   int ticket = 0; 
   int err = 0;   
   
   for(int counter=0;counter<OrdersTotal();counter++)
      {
         x = OrderSelect(counter,SELECT_BY_POS,MODE_TRADES);
         
         if ( gSPREAD  > 50   ) { Print("Spread too high, not closing"); return; }
         if ( gSPREAD  > 50   ) { Print("Max spread exceeded, not closing"); return; }

         if ( IsTradeContextBusy() || !IsTradeAllowed() ) return;   // try again next time around
         
         if(fORDERTYPE == ALL  && OrderSymbol()==Symbol() )  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10,Violet);
         if(fORDERTYPE == BUY  && OrderSymbol()==Symbol() && OrderType() == OP_BUY  )  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10,Violet);
         if(fORDERTYPE == SELL && OrderSymbol()==Symbol() && OrderType() == OP_SELL )  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10,Violet);
         err=GetLastError(); if (err != 0) Print("Last error while closing = " + err);
      }
     
      return;
}




// --------------------------------------------------------------------------------------------
//  FORCE CLOSE ALL ORDERS FUNCTION
// --------------------------------------------------------------------------------------------

void subCLOSEALL()
{

   int counter=0;
   int tries=0;
   subORDERSTATUS();
   while(gBUYTRADES > 0) { 
      for(counter=0;counter<OrdersTotal();counter++) { subCLOSE(BUY); }
      subORDERSTATUS();
      if (tries > 10) break;
      tries++;
      }
   
   tries=0;
   subORDERSTATUS();
   while(gSELLTRADES > 0) {
      for(counter=0;counter<OrdersTotal();counter++) { subCLOSE(SELL); }
      subORDERSTATUS();
      if (tries > 10) break;
      tries++;
      }
   
   return;
   }








// --------------------------------------------------------------------------------
// open market order
// --------------------------------------------------------------------------------

void subINSTAORDER( string fORDERTYPE, double fSTOPLOSS ) {

   int ticket = 0;
   int err = 0;
   double sl2, tp2 =0;

   double fLOTS = subMYLOTS();

   
   if ( gSPREAD > subMAXSPREAD() ) { Print("Max Spread Exceeded, Not Opening");  return; }

   if (MarginCheck() < cMARGIN) { Print("Margin too low");  return; }

   subORDERSTATUS();

   if ( fORDERTYPE != BUY && fORDERTYPE != SELL ) { Print("Neither buy nor sell passed!");  return; }
   if ( fORDERTYPE == BUY && gBUYTRADES >= 1 ) { Print("Buy trade already active");  return; }
   if ( fORDERTYPE == SELL && gSELLTRADES >= 1 ) { Print("Sell trade already active"); return; }



   RefreshRates();

   if ( fORDERTYPE == BUY )   { 
                               sl2 = NormalizeDouble(Bid-(fSTOPLOSS*gPOINT_VALUE),Digits); 
                               tp2 = NormalizeDouble(Ask+(gTAKEPROFIT*gPOINT_VALUE),Digits);
                              ticket=OrderSend(Symbol(),OP_BUY,fLOTS,Ask,3,sl2,tp2,"",0,0,Blue);  
                          }


   if ( fORDERTYPE == SELL )  { 
                              sl2 = NormalizeDouble(Ask+fSTOPLOSS*gPOINT_VALUE,Digits); 
                              tp2 = NormalizeDouble(Bid-gTAKEPROFIT*gPOINT_VALUE,Digits); 
                              ticket=OrderSend(Symbol(),OP_SELL,fLOTS,Bid,3,sl2,tp2,"",0,0,Red);  
                             }


   err= GetLastError(); if (err !=0) Print("Last open error = " + err);
   

   return;
      }
 





