//Get Ranges
//Buy on  X+-.15%, Limit with X% and stopLoss of Y%
//Sell on Y+-.15%, If
//PNB  80.1   Buy
//PNB  89 SELL

//###BUY_STOPLOSS  Buy_RANGE_START BUY_INPUT  BUY_RANGE_END  BUY_LIMIT  SELL_LIMIT  SELL_LIMIT_START  SELL  SELL_LIMIT_END  SELL_STOPLOSS#####

//profitGainedTillNow =

//profitPercent = 0.3%
const YahooDownload = require("../YahooDownload.js");
const stockHelper = require("../stockHelper.js");
const strategyDao = require("../dao/strategyDao.js");
const multipleCaller = require("../multipleCaller.js");

var WORTH = 100000;
x;
var records = [
  { symbol: "PNB", buyPrice: 82.4, sellPrice: 88.4, profit: 0.5, loss: 0.5 },
  { symbol: "SBIN", buyPrice: 82.4, sellPrice: 88.4, profit: 0.5, loss: 0.5 }
];

//Average + STDDDEV SELL

//Average + STDDEV BUY.

// Select stock whole day till now range is 1.5 % // Take last 15 minutes. Sell if it goes above high + stddev, buy if it goes below high - stddev
//Expected profit .2%, Expected stoploss .15%
var day = stockHelper.getTradeDay();
//var day = "03-Aug-2018";

console.log("DAUY", day);
var TXN_ENABLED = true;
var profitDefault = 0.4;
var lossDefault = 0.4;
var NUM_TRADE = 6;

var worth = 100000;
var orderPlaced = {};

var buyOrderPending = {
  PNB: false,
  SBIN: false
};

var sellOrderPending = {
  PNB: false,
  SBIN: false
};

var outOfRange = {};

var cancelSymbols = [];

function getRangeTradeDetail(symbol) {
  for (var i = 0; i < records.length; i++) {
    if (records[i].symbol == symbol) return records[i];
  }
}

//exports.execute();

//exports.execute = function() {
//Call Yahoo Downloader.

multipleCaller.callNTimes(1, 1, function() {
  YahooDownload.loadData();
  setTimeout(function() {
    strategyDao.getRangeTradingStocks(day, function(responses) {
      //Bracket order for BUY.
      //If it is fitst time also place 3 SD Breakout ones.
      //Bracket order for SELL.
      var symbols = [];
      for (var i = 0; i < Math.min(responses.length, NUM_TRADE); i++) {
        if (responses[i].symbol != "INTELLECT")
          symbols.push(responses[i].symbol);
      }
      stockHelper.getLTPForSymbolsMap(symbols, function(symbolLTPMap) {
        console.log(symbolLTPMap);

        multipleCaller.callNTimes(1, 1000 * 10, function() {
          for (var i = 0; i < Math.min(responses.length, NUM_TRADE); i++) {
            console.log(responses[i]);
            responses[i].ltp = symbolLTPMap[responses[i].symbol];
            handleResponse(responses[i]);
          }
        });
      });
    });
  }, 20000);
});
//};

function handleResponse(response) {
  console.log("IMPORTANT Checking for", response, " handleResponse");

  if (cancelSymbols.indexOf(response.symbol) > -1) return;
  var ltp = response.ltp;
  if (ltp > response.lo && ltp < response.hi) {
    //Check if bu order is there or not.
    console.log("IMPORTANT Checking for", response, " if in position today");
    stockHelper.isStokCurrentlyInPositionToday(response.symbol, function(
      isPos
    ) {
      if (isPos) return;
      console.log("IMPORTANT Checking for", response, " if in pending sell");
      stockHelper.getIntradayPendingSellOrdersBySymbol(
        response.symbol,
        function(sellOrders) {
          if (sellOrders.length > 0) return;
          var sellPrice = stockHelper.exchangeRoundOff(response.hi);
          if (TXN_ENABLED) {
            console.log(
              "IMPORTANT RangeTrading",
              "NSE",
              "SELL",
              response.symbol,
              Math.ceil(WORTH / sellPrice),
              stockHelper.exchangeRoundOff(response.hi),
              stockHelper.exchangeRoundOff(response.deviation * 2),
              stockHelper.exchangeRoundOff(response.deviation * 2),
              1
            );
            stockHelper.myBracketOrdeTrailingStoploss(
              "NSE",
              "SELL",
              response.symbol,
              Math.ceil(WORTH / sellPrice),
              stockHelper.exchangeRoundOff(response.hi),
              stockHelper.exchangeRoundOff(response.deviation * 2),
              stockHelper.exchangeRoundOff(response.deviation * 2),
              1,
              function(resp) {}
            );
          }
        }
      );

      stockHelper.getIntradayPendingBuyOrdersBySymbol(response.symbol, function(
        isBuyOrderPresent
      ) {
        if (isBuyOrderPresent) return;
        var buyPrice = stockHelper.exchangeRoundOff(reponse.lo);
        console.log(
          "NSE",
          "BUY",
          response.symbol,
          Math.ceil(WORTH / buyPrice),
          stockHelper.exchangeRoundOff(reponse.lo),
          stockHelper.exchangeRoundOff(response.deviation * 2),
          stockHelper.exchangeRoundOff(response.deviation * 2),
          1
        );
        if (TXN_ENABLED) {
          stockHelper.myBracketOrdeTrailingStoploss(
            "NSE",
            "BUY",
            response.symbol,
            Math.ceil(WORTH / buyPrice),
            stockHelper.exchangeRoundOff(response.lo),
            stockHelper.exchangeRoundOff(response.deviation * 2),
            stockHelper.exchangeRoundOff(response.deviation * 2),
            1,
            function(resp) {}
          );
        }
      });
    });
  } else if (ltp > response.hi + 3 * response.deviation) {
    console.log("TOO HIGH VALUE", response);
    cancelSymbols.push(response.symbol);
  } else if (ltp < response.lo - 3 * response.deviation) {
    cancelSymbols.push(response.symbol);
    console.log("TOO LOW VALUE", response);
    //Cancel the
  } else {
    console.log("NOT IN RANGE VALUE", response);
  }
}

function onLTP(orderContext) {
  if (outOfRange[orderContext.symbol]) return;
  var rangeTrade = getRangeTradeDetail(orderContext.symbol);
  if (rangeTrade === undefined) return;

  //If their any open position.

  stockHelper.isStokCurrentlyInPositionToday(symbol, function(response) {
    if (response) {
      return;
    }

    var rangeTrade = getRangeTradeDetail(orderContext.symbol);

    var lowerBuy = rangeTrade.buyPrice * 0.998;
    var upperBuy = rangeTrade.buyPrice * 1.002;

    var lowerSell = rangeTrade.sellPrice * 0.998;
    var upperSell = rangeTrade.sellPrice * 1.002;

    if (ltp < lowerBuy * 0.998 || ltp > upperSell * 1.002) {
      outOfRange[symbol] = true;
      return;
    }

    var txnType = "";
    if (ltp >= lowerBuy && ltp <= upperBuy) {
      if (buyOrderPending[symbol]) return;
      txnType = "BUY";
    } else if (ltp >= lowerSell && ltp <= upperSell) {
      if (sellOrderPending[symbol]) return;
      txnType = "SELL";
    } else {
      return;
    }

    if (txnType == "BUY") {
      price = ltp * (100 - 0.1 / 100);
    } else {
      price = ltp * (100 + 0.1 / 100);
    }
    var squareOff = (price * profit) / 100;
    var stopLoss = (price * loss) / 100;
    stockHelper.bracketOrderPlace(
      exchange,
      txnType,
      tradingsymbol,
      Math.ceil(WORTH / sellPrice),
      actualBuyPrice,
      squareOff,
      stopLoss
    );
    if (txnType == "BUY") {
      buyOrderPending[symbol] = true;
    } else {
      sellOrderPending[symbol] = true;
    }
  });
  //If open position is their skip.
}

function onBuyComplete(orderId) {
  //If stop loss order. Cancel the limit order.
  //If limit order, cancel the stoploss order.
}

function onSellComplete(orderId) {}

function onSellComplete() {}

function buy(symbol, exchange, stopLoss, limit) {
  //If i simply place a buy on limit.
  //When order executes place the stoploss and limit sell.
}

function sell(symbol, exchange, stopLoss, limit) {}

function updateOnStopLoss() {}

//Buy with special trailing stopLoss.
