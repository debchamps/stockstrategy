//Check if their is an already an open order of today from DAO. If it is their leave it.

//Check if they meet buying criteria.
//Put a record in DB 'stating' BUYING
//Place order.
//Incase order is placed. DO, bought.
//Strategy

// Get all the orders placed using strategy1.
// Sell incase we have profit as prescibed.

//Incase we have sold off the share

var stopLossEnabled = false;

var stopLossPercentage = 3;

var DEFAULT_AMOUNT_PER_SHARE = 10000;

var DEFAULT_AMOUNT_ALL_SHARE = 100000;
/**
var orderContext = {
  symbol: instrumentMap[val.instrument_token],
  close: val.ohlc.clos,
  open: val.ohlc.open,
  high: val.ohlc.high,
  ltp: val.last_price,
  instrument: val.instrument_token
};
*/
function placeBuyOrder(orderContext) {
  var ltp = orderContext.ltp,
    open = orderContext.open,
    close = orderContext.close,
    high = orderContext.high,
    symbol = orderContext.symbol,
    instrument = orderContext.instrument;

  if (ltp < open && ltp < close && high > open && high > close) {
    if ((open - ltp) / open < 2 && (close - ltp) / ltp < 2) {
      console.log(
        "IMPORTANT STRATEGY3 BUY AT LESS PRICE LTP :: ",
        ltp,
        "CLOSE: ",
        close,
        "OPEN",
        open,
        "SYMBOL: ",
        "SYMBOL: ",
        symbol,
        "DIFF OPEN: ",
        (100 * (open - ltp)) / open
      );

      stockHelper.placeLimitOrder(
        "NSE",
        symbol,
        quantity,
        transactionType,
        orderType,
        limitPrice
      );
      //Criteria for buy met. Buy with immediate effect.
      //place a buy order with stopLoss in -2%
    }
  }

  stockHelper.isStokBoughtToday(symbol, function(isBought) {
    if (isBought) return; //Stock is already traded. No more trade.
    console.log("");

    //Check for pending orders for the symbol today. If their is no pending order as well go ahead and place it.
  });
}

// tradeId, tradingdate, tradingtime, state,  symbol, quantity, averageBuyPrice,
// strategy,strategyContext, stoploss, buyOrderIds,
// sellOrderIds, sellQuantity, sellPrice , profit

function sellOrder() {}

//Check sell order with exact stop loss.
//If their is sell order with the stop loss update it.

//Just buy and sell. Update the DAO later. From. Do the stop loss part later. End of day job.
