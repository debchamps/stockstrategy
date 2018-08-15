var stocksToMonitor = [];
const bracketOrderTrailingDao = require("../dao/bracketOrderTrailingDao.js");
const trailingStopLossManager = require("./trailingStopLossManager.js");
//Basically if profir percentage > 2%
// Use greedy method which ensures atleast 1.5 % profit and every
//increasing.

//And when the stoploss value is triggered ensure we create an BUY
//order with LIMIT value of .5% greater than than of the stopLoss Price and with a stoploss value of 5%.

//get the Holdings. If proft > X % place the stopLoss

//For current holding. Select the stocks in profit.
//Check if their is already a live bracket order in place. If present exit.
//Else
//Set  stopLoss  = currentPrice - 3%
//Set  Limit = CurrentPrice + 4%

//If limit - .5% reached i.e 3.5% profit.  updated stopLoss,
//Again = currentPtice - 2%
//Set  Limit = CurrentPrice + 4%

//FUTURE
//symbol, trigger, stopLoss, creationDate, orderPlaceDate, newOrderPLaceDate, status

//Everyday morning place the buy orders if the state is in pending.
//If the order is executed, then move the status to PLACED, which inturn will trigger the other CNC

//Incase stopLoss is triggered. Buy again when we reach the limit.
