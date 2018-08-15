//Set the Stop loss to 2% from day close.
//Sell it if it decreases by more than 2%
//Otherwise next day choose max(newClose, previous stopLoss)

// getAllLongTermShares
// Get the stop loss for all such shares from the DB
// Update the stopLoss incase stopLoss needs to be updated.
// Create email notification incase it is near to sell signal. (Potential rebuy)
// Create an order of Sell.

/*  RESPONSE FROM HOLDING

{ tradingsymbol: 'VAKRANGEE',
   exchange: 'NSE',
   instrument_token: 3415553,
   isin: 'INE051B01021',
   product: 'CNC',
   price: 0,
   quantity: 1960,
   t1_quantity: 2060,
   realised_quantity: 1960,
   collateral_quantity: 0,
   collateral_type: '',
   average_price: 65.31355721393035,
   last_price: 60.7,
   close_price: 57.85,
   pnl: -18546.500000000004,
   day_change: 2.8500000000000014,
   day_change_percentage: 4.926534140017289 }

   */
var stockHelper = require("./stockhelper.js");
const multipleCaller = require("./multipleCaller.js");

var EXCLUDE_SPECIAL_STOCKS = ["VAKRANGEE"];

var MIN_PROFIT_PERCENT = 5;
var STOPLOSS_PERCENT = 2;
stockHelper.getHoldings(function(result) {
  for (var i = 0; i < result.length; i++) {
    console.log(result[i]);

    setStopLoss(result[i]);
  }
});

function setStopLoss(holding) {
  if (EXCLUDE_SPECIAL_STOCKS.indexOf(holding.tradingsymbol) > -1) {
    console.log(
      "LONGTERM " +
        holding.tradingsymbol +
        " is an exlcusion list for LongTerm strategy"
    );
  }

  if (holding.pnl <= 0) {
    //Making a loss. TODO: Still not setting stop loss. Or should we.
    return;
  }

  if (
    holding.average_price <= 0 ||
    holding.last_price == holding.average_price
  ) {
    return;
  }

  var profitPercentage =
    (100 * (holding.last_price - holding.average_price)) /
    holding.average_price;
  if (profitPercentage <= MIN_PROFIT_PERCENT) {
    console.log(
      "LONGTERM " +
        holding.tradingsymbol +
        " is not eligible for stopLoss setting as the profit percentage is less than minimum percent"
    );
    return;
  }

  var newStopLossPercent = profitPercentage - STOPLOSS_PERCENT;
}
