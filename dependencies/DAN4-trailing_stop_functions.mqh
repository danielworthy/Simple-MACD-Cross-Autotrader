


// -----------------------------------------------------------------------------------------------
// TRAILING STOP SECTION - ADJUSTS TRAILING STOP
// -----------------------------------------------------------------------------------------------
void subCHECK_TRAILING_STOP()
{
      int x=0;
      if (gTRAILINGSTOP == 0 ) return;
      int total = OrdersTotal();
      for(int counter=0;counter<total;counter++)
      {
         x = OrderSelect(counter, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() )
         { subTrailingStop(OrderType()); }
      }
	  return;
}



// ------------------------------------------------------------------
// TRAILING STOP FUNCTION
// ------------------------------------------------------------------

void subTrailingStop(int Type)
{
   
   int x=0;
   if(Type==OP_BUY)   // buy position is opened   
   {  
         if(Bid-OrderOpenPrice() > gPOINT_VALUE*gTRAILINGSTOP && ( OrderStopLoss() < Bid-gPOINT_VALUE*gTRAILINGSTOP  || OrderStopLoss()==0 ) ) 
             {  x = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-gPOINT_VALUE*gTRAILINGSTOP,OrderTakeProfit(),0,Green);  return; }  
         
         if (cBREAKEVENPIPS > 0 ) 
            { if (  Bid > ( OrderOpenPrice()+(cBREAKEVENPIPS*gPOINT_VALUE)) && OrderProfit() > 0  &&   OrderStopLoss() < OrderOpenPrice()  ) x =  OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Green);  return; }  
    }


   if(Type==OP_SELL)   // sell position is opened   
      {
      if (   (OrderOpenPrice()-Ask > gPOINT_VALUE*gTRAILINGSTOP)  &&   (OrderStopLoss() > Ask+gPOINT_VALUE*gTRAILINGSTOP || OrderStopLoss()==0)  )
               {  x = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+gPOINT_VALUE*gTRAILINGSTOP,OrderTakeProfit(),0,Red);  return; }
               
      if (cBREAKEVENPIPS > 0 ) 
         { if ( Ask < OrderOpenPrice()-cBREAKEVENPIPS*gPOINT_VALUE && OrderProfit() > 0  && OrderStopLoss() > OrderOpenPrice() ) x = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Green);  return; }  
                     
       }
	   return;
}




// -----------------------------------------------------------------------------------------------
// TRAILING STOP SET? 
// -----------------------------------------------------------------------------------------------
bool subISTRAILINGSTOPSET()
{

      // we set it to true, then try to disprove it, in case we have multiple orders open. 
      bool TS_SET = true;
      
      int x=0;
      int total = OrdersTotal();
      
      for(int counter=0;counter<total;counter++)
      {
         x = OrderSelect(counter, SELECT_BY_POS, MODE_TRADES);
         if ( OrderSymbol()==Symbol()) 
            {
               if( OrderType()==OP_BUY  &&  OrderStopLoss() < OrderOpenPrice() ) TS_SET = false; 
               if( OrderType()==OP_SELL &&  OrderStopLoss() > OrderOpenPrice() ) TS_SET = false; 
            }
       }
return(TS_SET);
         
 }
      
	  


