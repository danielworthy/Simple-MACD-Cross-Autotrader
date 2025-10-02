


// --------------------------------------------------------------------------------
// Order Status
// --------------------------------------------------------------------------------

void subORDERSTATUS()
{
   gBUYTRADES = 0; gSELLTRADES = 0; gBUYPROFIT = 0; gSELLPROFIT = 0; gBASKET = 0; gBUY_PENDING =0; gSELL_PENDING = 0; gPENDING_TRADES =0; gSELL_LIMIT = 0; gBUY_LIMIT=0; 
   int x=0;
   
   gGLOBALOPENORDERS =0;
   
   for(int counter=0;counter<OrdersTotal();counter++)
   {
      x = OrderSelect(counter,SELECT_BY_POS,MODE_TRADES);
      
      int orderType = OrderType();
      if (
            orderType == OP_BUY ||
            orderType == OP_SELL
#ifdef ORDER_TYPE_BUY
            || orderType == ORDER_TYPE_BUY ||
            orderType == ORDER_TYPE_SELL
#endif
         )
      {
         gGLOBALOPENORDERS++;
      }
      if(OrderSymbol()==Symbol()  )
      {
         if(OrderType()==OP_BUY ) { gBUYTRADES++; gBUYPROFIT = gBUYPROFIT + OrderProfit();  }
         if(OrderType()==OP_SELL) { gSELLTRADES++; gSELLPROFIT = gSELLPROFIT + OrderProfit(); } 
         
         if(OrderType()==OP_BUYSTOP ) { gBUY_PENDING++;  }
         if(OrderType()==OP_SELLSTOP) { gSELL_PENDING++; } 
         
         if(OrderType()==OP_BUYLIMIT ) { gBUY_LIMIT++;  }
         if(OrderType()==OP_SELLLIMIT) { gSELL_LIMIT++; }
      }         
   }
   gPENDING_TRADES = gBUY_PENDING+gSELL_PENDING;
   gTOTALOPENORDERS = gBUYTRADES + gSELLTRADES;
   gBASKET = gBUYPROFIT+gSELLPROFIT;         
   
   return;
}




      
	  



// -----------------------------------------------------------------------------------------------
//  Order history stats
// -----------------------------------------------------------------------------------------------


double subORDERHISTORYSTATS(bool fDISPLAY)
{

      int x=0;
      int total = OrdersHistoryTotal();

      double TotalOrders=0;
      double Wins=0;
      double Losses =0;
      
      
      for(int counter=0;counter<total;counter++)
      {
         x = OrderSelect(counter, SELECT_BY_POS, MODE_HISTORY);
         if ( OrderSymbol()==Symbol() && ( OrderType() == OP_BUY || OrderType() == OP_SELL ) ) 
            {
               TotalOrders++;
               if( OrderProfit() > 0 ) Wins++; 
               if ( OrderProfit() < 0 ) Losses++;  
               
            }
       }

            double PercentageWins = 0;
            //PercentageLoss = Losses/TotalOrders;
            if ( TotalOrders > 0 ) PercentageWins = Wins/TotalOrders;
            
   if (fDISPLAY) {
            subDISPLAYADD("Order Stats Total/Wins/Losses/% Loss", TotalOrders + " / " + Wins + " / " + Losses + " / " + DoubleToStr(PercentageWins,2) );   
            subDISPLAYADD(LINE, 0);   
            }

         if (PercentageWins == 0 ) PercentageWins = 1;
return(PercentageWins);
         
 }
      


// -----------------------------------------------------------------------------------------------
//  Order profit stats
// -----------------------------------------------------------------------------------------------


double subORDERPROFITSTATS(bool fDISPLAY)
{

      int x=0;
      int total = OrdersHistoryTotal();
      double fPROFIT = 0;

      for(int counter=0;counter<total;counter++)
      {
         x = OrderSelect(counter, SELECT_BY_POS, MODE_HISTORY);
         if ( OrderSymbol()==Symbol() && ( OrderType() == OP_BUY || OrderType() == OP_SELL ) ) 
            {
               fPROFIT = fPROFIT + OrderProfit(); 
             }
       }

   if (fDISPLAY) {
            subDISPLAYADD("Order Profit $", fPROFIT);
            subDISPLAYADD(LINE, 0);   
   }

return(fPROFIT);
         
 }

	  

   