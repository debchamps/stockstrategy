var stockHelper = require("./stockhelper.js");
const multipleCaller = require("./multipleCaller.js");
const helper = require("./helper.js");
const niftyDao = require("./dao/niftyDao.js");
const uuidv1 = require("uuid/v1");
const moment = require("moment");
const intradayDao = require("./dao/intradayDao.js");
var shuffle = require("shuffle-array");

var MIN_CHANGE = 100;

var TXN_EANBLED = false;
var SPECIAL_TXN_EANBLED = true;
var DIFF_LOSS = 250;
var DEFAULT_WORTH = 40000;

var MAX_PROFIT_LIMIT = 3; //Lets take th ep90 of the stocks if possible.

var STOPLOSS_UPDATE_DIFF = 0.3;
var MAX_NEGATIVE_STOPLOSS = -1.0;
var MARKET_CLOSE_HOUR = 15;
var MARKET_CLOSE_MINUTE = 30;

var NEW_STRATEGY_COUNT = 0;
var MAX_ALLOWED_NEW_STRATEGY_COUNT = 4;
//SELL WITH STOP LOSS WHEN WE ARE BREAKING EVERYTHING.
//BUY WITH CAUTION, WHEN IT HAVE SHOWN PROMISE BUT GOT DOWN (LIKELY TO BE CONVERTED)

var INTRADAY_SHARES_TO_BUY = [
  "BHEL",
  "SBIN",
  "TATAMTRDVR",
  "JSWSTEEL",
  "TCS",
  "DHFL"
];

var INTRA_DAY_AUTO_ORDER_CUTOFF_HIGH_MIN = 375;
var INTRA_DAY_AUTO_ORDER_CUTOFF_LOW_MIN = 150;

/*
Every ‘x’ minute  wake up
Buy if it is x% lower than the last day close buy And place a Stop loss with y% loss
If price bracket changes cancel the order
*/
const SHARES_TO_LOOK = [];

SELL_BRACKET = {
  2: 1.75,
  1.5: 1.25,
  1: 0.75,
  0.5: 0.25
};

const SELL_BRACKET_TIME = {
  60: 0.3,
  120: 0.4,
  180: 0.5, //1000 Rs on 1 lakh
  210: 0.65, //2000 Rs on 1 lakh
  240: 0.75, //2000 Rs on 1 lakh
  300: 1.0,
  360: 1.25
};

const SELL_BRACKET_TIME_GOOD = {
  60: 0.1,
  120: 0.3,
  180: 0.75, //1000 Rs on 1 lakh
  240: 1, //2000 Rs on 1 lakh
  300: 1.75,
  360: 2.5
};

function intradayPlaceOrderExecute() {
  var exchange = "NSE";
  var timeRemainingNow = getTimeRemainingFromMarketStop();
  if (
    timeRemainingNow > INTRA_DAY_AUTO_ORDER_CUTOFF_HIGH_MIN ||
    timeRemainingNow < INTRA_DAY_AUTO_ORDER_CUTOFF_LOW_MIN
  ) {
    //    return;
  }
  console.log("IMPORTANT: Fetching nifty 100 stocks 1");

  niftyDao.getNifty500(function(symbols) {
    console.log("IMPORTANT:Fetching nifty 100 stocks 2");

    symbols = shuffle(symbols);
    intradayPlaceOrder(exchange, symbols);
  });
}

function intradayPlaceOrder(exchange, tradeSymbols) {
  console.log("IN intradayPlaceOrder", tradeSymbols);
  var instruments = [];
  var instrumentMap = {};
  for (var i = 0; i < tradeSymbols.length; i++) {
    instrumentToken = helper.getInstrumentByTradingSymbol(
      exchange,
      tradeSymbols[i]
    );

    instruments.push(instrumentToken);
    instrumentMap[instrumentToken] = tradeSymbols[i];
  }
  console.log("IN intradayPlaceOrder", instrumentMap);

  function scalperTechnique() {
    //Fetch top n gainers.
    //fetch Top n losers.
    // Determine trend.  (Take 5 minute data points). Check
  }

  stockHelper.getOHLC(instruments, function(response) {
    console.log("KET", response);
    Object.keys(response).forEach(function(key) {
      //await new Promise(done => setTimeout(done, 5000));
      var val = response[key];
      console.log("Response :: ", val);

      var orderContext = {
        symbol: instrumentMap[val.instrument_token],
        close: val.ohlc.close,
        open: val.ohlc.open,
        high: val.ohlc.high,
        ltp: val.last_price,
        instrument: val.instrument_token
      };
      //newStrategyBuy(orderContext);
      buyEvenIfSLightlyUpAndStartedTheDayLate(orderContext);
    });
  });
}

function newStrategyMISSell(orderContext) {
  var ltp = orderContext.ltp,
    open = orderContext.open,
    close = orderContext.close,
    high = orderContext.high,
    symbol = orderContext.symbol,
    instrument = orderContext.instrument;

  stockHelper.isStokBoughtToday(symbol, function(response) {
    if (response) return;
    //Stock is not bought today.

    if (ltp > open && ltp > close && open > close) {
    }
  });
}

function buyForSmallGain(orderContext) {
  var ltp = orderContext.ltp;
  if (ltp < open) return;
  if ((ltp - open) / open > 2) return;

  var limitBuyPrice = ltp - (ltp * 0.15) / 100;
  var limitSellPrice = ltp + (ltp * 0.05) / 100;

  //Check if their is no order and current price

  //Place the pending order, worth 30000
  //If limit buy price is executed, place the stopLoss and limit order.
  //If one of stoploss and limit price is executed, cancel the other order.
}

function buyEvenIfSLightlyUpAndStartedTheDayLate(orderContext) {
  var ltp = orderContext.ltp,
    open = orderContext.open,
    close = orderContext.close,
    high = orderContext.high,
    low = orderContext.low,
    symbol = orderContext.symbol,
    instrument = orderContext.instrument;
  //console.log("IMPORTANT: Executing newStrategyBuy", orderContext);
  stockHelper.isStokBoughtToday(symbol, function(response) {
    var HARD_CODED_SYMBOLS = [
      "SBIN",
      "PNB",
      "ACC",
      "ICICIBANK",
      "HDFCBANK",
      "RELIANCE",
      "TCS",
      "WIPRO",
      "ASIANPAINT"
    ];
    if (HARD_CODED_SYMBOLS.indexOf(orderContext.symbol) < 0) return;

    console.log("IMPORTANT : isStokBoughtToday for symbol", symbol, response);
    if (response) return;
    console.log("IMPORTANT : HERE1");

    //Stock is not bought today.
    var approxNumberOfShare = Math.round(DEFAULT_WORTH / ltp);
    if (approxNumberOfShare < 2) return;
    console.log("IMPORTANT : HERE2");

    if (true) {
      console.log("IMPORTANT : HERE3");
      if (true) {
        console.log("IMPORTANT : HERE4");
        console.log(
          "IMPORTANT STRATEGY4 BUY AT LESS PRICE LTP :: ",
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
        var buyPrice = exchangeRoundOff(ltp - (ltp * 0.05) / 100);

        NEW_STRATEGY_COUNT = NEW_STRATEGY_COUNT + 1;
        if (NEW_STRATEGY_COUNT > MAX_ALLOWED_NEW_STRATEGY_COUNT) return;
        //if (!TXN_EANBLED) return;

        stockHelper.placeLimitOrder(
          "NSE",
          symbol,
          approxNumberOfShare,
          "BUY",
          "MIS",
          buyPrice,
          function(placeOrderResponse) {
            // Now also place a stop loss order with 2% of this price.
            var stopLossPrice = exchangeRoundOff(ltp * 0.97);
            //"(TRADEID, SYMBOL, SERIES, STRATEGY, STRATEGYCONTEXT ,QUANTITY,BUYPRICE,STOPLOSS,DAY, TIMESTAMP)" +

            var day = moment().format("MM-DD-YYYY, h:mm:ss a");
            var record = [
              uuidv1(),
              "BUY",
              symbol,
              "NSE",
              "BUY_INTRADAY_PRICE_DROPS2",
              JSON.stringify(orderContext),
              approxNumberOfShare,
              buyPrice,
              stopLossPrice,
              null,
              day,
              new Date().getTime(),
              placeOrderResponse.order_id,
              "ORDER_PLACED"
            ];
            intradayDao.createBuyRequest(record);
            /*
            stockHelper.placeStopLossOrder(
              "NSE",
              symbol,
              approxNumberOfShare,
              "SELL",
              "MIS",
              stopLossPrice,
              stopLossPrice,
              function(data) {
                //console.log("Created stop loss order ", oldOrderId);
              }
            );*/
          }
        );
      }
    } else {
      console.log("IMPORTANT : HERE6");
    }
  });
}

function newStrategyBuy(orderContext) {
  var ltp = orderContext.ltp,
    open = orderContext.open,
    close = orderContext.close,
    high = orderContext.high,
    symbol = orderContext.symbol,
    instrument = orderContext.instrument;
  //console.log("IMPORTANT: Executing newStrategyBuy", orderContext);
  stockHelper.isStokBoughtToday(symbol, function(response) {
    console.log("isStokBoughtToday for symbol", symbol, response);
    if (response) return;
    //Stock is not bought today.
    var approxNumberOfShare = Math.round(DEFAULT_WORTH / ltp);
    if (approxNumberOfShare < 2) return;

    if (
      ltp > open &&
      ltp < close &&
      high > open * 1.005 &&
      high > close * 1.005
    ) {
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

        NEW_STRATEGY_COUNT = NEW_STRATEGY_COUNT + 1;
        if (NEW_STRATEGY_COUNT > MAX_ALLOWED_NEW_STRATEGY_COUNT) return;
        //if (!TXN_EANBLED) return;

        stockHelper.placeLimitOrder(
          "NSE",
          symbol,
          approxNumberOfShare,
          "BUY",
          "MIS",
          ltp,
          function(placeOrderResponse) {
            // Now also place a stop loss order with 2% of this price.
            var stopLossPrice = exchangeRoundOff(ltp * 0.97);
            //"(TRADEID, SYMBOL, SERIES, STRATEGY, STRATEGYCONTEXT ,QUANTITY,BUYPRICE,STOPLOSS,DAY, TIMESTAMP)" +

            var day = moment().format("MM-DD-YYYY, h:mm:ss a");
            var record = [
              uuidv1(),
              "BUY",
              symbol,
              "NSE",
              "BUY_INTRADAY_PRICE_DROPS",
              JSON.stringify(orderContext),
              approxNumberOfShare,
              ltp,
              stopLossPrice,
              null,
              day,
              new Date().getTime(),
              placeOrderResponse.order_id,
              "ORDER_PLACED"
            ];
            intradayDao.createBuyRequest(record);
            stockHelper.placeStopLossOrder(
              "NSE",
              symbol,
              approxNumberOfShare,
              "SELL",
              "MIS",
              stopLossPrice,
              stopLossPrice,
              function(data) {
                //console.log("Created stop loss order ", oldOrderId);
              }
            );
          }
        );
      }
    }
  });
}

//LTP result have come.

/*
*/

function getTimeRemainingFromMarketStop() {
  var date = new Date();
  var hours = date.getHours();
  var min = date.getMinutes();
  var minuteRemaining =
    (MARKET_CLOSE_HOUR - hours) * 60 + (MARKET_CLOSE_MINUTE - min);
  //console.log("Time remaining", minuteRemaining);
  return minuteRemaining;
}

/**
Returns the next stoploss which should be set given the current profit level.
*/
function getStopLossPercent(profitPercent) {
  if (profitPercent < 0) {
    return MAX_NEGATIVE_STOPLOSS;
  }

  return (
    Math.round((profitPercent - STOPLOSS_UPDATE_DIFF) / STOPLOSS_UPDATE_DIFF) *
    STOPLOSS_UPDATE_DIFF
  ).toFixed(2);

  //  profitPercent * 100 - STOPLOSS_UPDATE_DIFF*100
  //  return () / 100;
}

exports.execute = function() {
  multipleCaller.callNTimes(6 * 60, 1000 * 10, function() {
    intradayPlaceOrderExecute();
    updateExistingStocks();
  });
};

//updateExistingStocks();

//getTimeRemainingFromMarketStop();

function buyShareWithStopLoss() {
  //Place a stop loss order with 5% of the previous day close of 10000 Rs each.
}

function buyShareForSymbolWithStopLoss(currentPrice) {
  quantityToBuy = DEFAULT_WORTH / currentPrice;
}

/*
stockHelper.getPositions(function(result) {
  console.log(result);
});
*/

//stockHelper.getIntradayPendingSellOrdersBySymbol("PCJEWELLER");

function updateExistingStocks() {
  stockHelper.getDailyActivePositions(function(result) {
    console.log("Results :: ", result);
    if (result.length > 0) {
      for (var i = 0; i < result.length; i++) {
        pos = result[i];
        executeStock(result[i]);
      }
    }
    console.log("getDailyActivePositions", result);
  });
}

/*
*/
function previousDayUpperCircuitExecution() {
  //If it reducing,
}

//stockHelper.bracketOrderPlace("", "", 100);

/**
SELL OF ALL INTRADAY SHARES WHERE WE HAVE ACHIEVED A GIVEN PERCENTAGE OF PROFIT AT A GIVEN POINT
OF TIME. THIS ENSURES, WE DO NOT MAKE A LOSS LATER IF THE SHARE VALUE DECREASES OVER TIME AND
NEVER REACHES THIS HEIGHT AGAIN.

ONE RISK OF THIS SELLING IS THE SHARE VALUE CAN INCREASE FURTHER OVER TIME AND WE MAY LOSS OPPORTUNITY
TO MAKE MORE PROFIT. WE HAVE HIGHER EXPECTANCY OF PROFIT AT START OF DAY, (AS STOCK VALUES CAN IMPROVE
LATER) AND LOWER EXPECTANCY OF PROFIT AT END OF DAY (AS STOCK VALUE IS UNLIKELY TO CHANGE MUCH AND SELL
WITH WHATEVER PROFIT YOU GET)

*/
function executeProfitAcheivedWithTime(
  exchange,
  symbol,
  currentProfitPercent,
  quantity
) {
  var minuteRemaining = getTimeRemainingFromMarketStop();
  var percentageProfitCurrentTime = 0;
  var slotFound = false;
  var minDiff = 9999999;

  for (var key in SELL_BRACKET_TIME) {
    // check if the property/key is defined in the object itself, not in parent
    if (SELL_BRACKET_TIME.hasOwnProperty(key)) {
      //minuteRemainingSlot = SELL_BRACKET_TIME[key];
      if (minuteRemaining < key && key - minuteRemaining < minDiff) {
        slotFound = true;
        percentageProfitCurrentTime = SELL_BRACKET_TIME[key];
        minDiff = key - minuteRemaining;
      }
    }
  }

  if (!slotFound) return;
  console.log(
    "SELL: Selling order " +
      symbol +
      " at marketprice. currentProfitPercent : " +
      percentageProfitCurrentTime
  );

  if (currentProfitPercent >= percentageProfitCurrentTime) {
    console.log(
      "IMPORTANT SELL: Selling order " +
        symbol +
        " at marketprice. currentProfitPercent : " +
        percentageProfitCurrentTime
    );
    //if (TXN_EANBLED)
    {
      stockHelper.regularOrderSell(exchange, symbol, "MIS", quantity, function(
        data
      ) {
        console.log(
          "IMPORTANT: Succesfully sold order " + symbol + " with " + data
        );
      });
    }
    //SELL IT IMMEDIATELY, I have achieved desired profit.
  }

  console.log("KET Keys", key);
}

function executeStock(position) {
  console.log("Executing stock", position);

  var netRealization = position.unrealised;
  var symbol = position.tradingsymbol;
  var exchange = position.exchange;
  var quantity = position.quantity;
  var totalBuyPrice = position.average_price * quantity;
  var profitPercent = (netRealization / totalBuyPrice) * 100;
  var average_price = position.average_price;
  console.log(
    "Stock : ",
    symbol,
    "profit% : ",
    profitPercent,
    "profit : ",
    netRealization
  );

  modifyOrderToCNC(position);
  executeProfitAcheivedWithTime(exchange, symbol, profitPercent, quantity);
  //updateTriggerPriceOfStopLoss(position);

  //netRealization = position.average_price * position.average_price.
}

function exchangeRoundOff(price) {
  return Math.round((price * 20) / 20).toFixed(2);
}

/**
THIS METHODS CREATES A STOP LOSS INCASE THEIR IS PROFIT, AND ENSURES WE DO NOT LOSE MONEY, LATER.
 */
function updateTriggerPriceOfStopLoss(position) {
  var netRealization = position.unrealised;
  var symbol = position.tradingsymbol;
  var exchange = position.exchange;
  var quantity = position.quantity;
  var totalBuyPrice = position.average_price * quantity;
  var profitPercent = (netRealization / totalBuyPrice) * 100;
  var average_price = position.average_price;

  stockHelper.getIntradayPendingSellOrdersBySymbol(
    position.tradingsymbol,
    function(data) {
      console.log("Updating stock", data, ". netRealization: ", netRealization);

      var pendingSellTransaction = true;
      if (data.length == 0) {
        pendingSellTransaction = false;
      }
      var sellTransaction = data[0];
      var currentTriggerPrice = sellTransaction.trigger_price;
      console.log("Updating stock currentTriggerPrice", currentTriggerPrice);

      if (netRealization > MIN_CHANGE && profitPercent > STOPLOSS_UPDATE_DIFF) {
        console.log("netRealization ", netRealization);

        optimalStopLossPercentage = getStopLossPercent(profitPercent);

        optimalTriggerPrice =
          average_price + (average_price * optimalStopLossPercentage) / 100;

        //optimalTriggerPrice = (last_price * quantity - DIFF_LOSS) / quantity;
        /*
        if (
          optimalTriggerPrice == currentTriggerPrice ||
          Math.abs(optimalTriggerPrice - currentTriggerPrice) < 0.001
        ) {
          console.log(
            "Nothing to do for stock  ",
            symbol,
            " as the trigger price have not chabged"
          );
          return;
        } */

        console.log(
          "SYmbol : ",
          position.tradingsymbol,
          "New optimalTriggerPrice. Updating the trigger for stop loss ",
          optimalTriggerPrice,
          " Estimated profit",
          (optimalTriggerPrice - average_price) * quantity
        );
        var optimalTriggerPrice = (
          Math.round(optimalTriggerPrice * 20) / 20
        ).toFixed(2);

        console.log(
          "SYmbol : ",
          position.tradingsymbol,
          "New optimalTriggerPrice. Updating the trigger for stop loss ",
          optimalTriggerPrice,
          " Estimated profit",
          (optimalTriggerPrice - average_price) * quantity
        );

        updateTriggerPrice(
          exchange,
          sellTransaction.order_id,
          symbol,
          quantity,
          optimalTriggerPrice,
          optimalTriggerPrice,
          function(data) {
            console.log("IMPORTANT Updated trigger", data);
          }
        );
      } else {
        // Check the existing stop loss order.
      }
    }
  );
}

function updateTriggerPrice(
  exchange,
  oldOrderId,
  tradingSymbol,
  quantity,
  newTriggerPrice,
  newLimitPrice,
  callback
) {
  var triggerEnabled = false;
  if (!triggerEnabled) return;
  console.log("updateTriggerPrice", tradingSymbol);

  stockHelper.cancelOrder("regular", oldOrderId, function(data) {
    console.log("cancel result", data);
    stockHelper.placeStopLossOrder(
      exchange,
      tradingSymbol,
      quantity,
      "SELL",
      "MIS",
      newLimitPrice,
      newTriggerPrice,
      function(data) {
        console.log("Canceled order ", oldOrderId);
        callback(data);
      }
    );
  });
}

/**
This method automatically convers the stock to a CNC stock from intraday as
we are lossing money even at market close.
*/
function modifyOrderToCNC(position) {
  var minuteRemaining = getTimeRemainingFromMarketStop();
  if (minuteRemaining > 30) return;

  if (position.unrealised > 0) return;

  console.log("IMPORTANT modifyOrderToCNC", position);

  /*
  Executing stock { tradingsymbol: 'JSWSTEEL',
  exchange: 'NSE',
  instrument_token: 3001089,
  product: 'MIS',
  quantity: 60,
  overnight_quantity: 0,
  multiplier: 1,
  average_price: 324.45,
  close_price: 0,
  last_price: 318.4,
  value: -19467,
  pnl: -363,
  m2m: -363,
  unrealised: -363,
  realised: 0,
  buy_quantity: 60,
  buy_price: 324.45,
  buy_value: 19467,
  buy_m2m: 19467,
  sell_quantity: 0,
  sell_price: 0,
  sell_value: 0,
  sell_m2m: 0,
  day_buy_quantity: 60,
  day_buy_price: 324.45,
  day_buy_value: 19467,
  day_sell_quantity: 0,
  day_sell_price: 0,
  day_sell_value: 0 }
  */
  stockHelper.convertOrder(
    position.exchange,
    position.tradingsymbol,
    "BUY",
    "day",
    position.quantity,
    position.product,
    "CNC",
    function(data) {
      console.log(
        "IMPORTANT: Chaged position to for ",
        position.exchange,
        " with  ",
        data
      );
    }
  );
}
//Check the
