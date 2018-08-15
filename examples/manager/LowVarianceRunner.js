/**

RUN PENDING_STOPLOSS
HIGHEST_VOLUME_COMPARED_TO_YESTERDAY

**/

//Download google file, minute level.
//Run query to get the recommendations.
//Make a sell and a buy with day high and day low as the limits.

//day high
//day low.

//Divide stocks when they go high in the morning whether they come down or not.
const uuidv1 = require("uuid/v1");
//const GoogleDownload = require("../GoogleDownload.js");
const strategyDao = require("../dao/strategyDao.js");
const intradayDao = require("../dao/intradayDao.js");
const stockHelper = require("../stockHelper.js");
const multipleCaller = require("../multipleCaller.js");

var MOCK = false;
var time = 15;
//GoogleDownload.fetchData();
var symbols = [];
var instruments = [];

var WORTH = 200000;
var NUM_TRADE = 6;

var day = stockHelper.getTradeDay();
var profit = 0.5;
var loss = 0.2;

var priceDiff = 0.15;

var profitLossTimeMap = {
  330: {
    profit: 1,
    loss: 0.5
  },
  300: {
    profit: 0.9,
    loss: 0.45
  },
  240: {
    profit: 0.8,
    loss: 0.4
  },
  180: {
    profit: 0.7,
    loss: 0.35
  },
  120: {
    profit: 0.5,
    loss: 0.25
  },
  60: {
    profit: 0.2,
    loss: 0.1
  }
};

//5

//5

//5 1 lakh each

//Extreme Orders.
// Place 5 orders unlikely to be executed. But if they are executed you are likely to get very high profit.
//Place at a stop loss or high limit price.  like 3%. If it goes to 3 chances are it will go to 4
// than come back.
exports.execute = function() {
  multipleCaller.callNTimes(3, 1000 * 31 * 60, function() {
    YahooDownload.loadData();
    setTimeout(function() {
      if (!MOCK) {
        strategyDao.getLowVarianceStocks(day, function(response) {
          console.log("LowVariance", response);
          for (var i = 0; i < Math.min(response.length, NUM_TRADE); i++) {
            executeStock(response[i]);
          }
        });
      } else {
        strategyDao.getLowVarianceAtSpecificTimeStocks(day, time, function(
          response
        ) {
          for (var i = 0; i < NUM_TRADE; i++) {
            executeStock(response[i]);
          }
        });
      }
    }, 20000);
  });
};

function executeStock(res) {
  //Place a buy order.
  stockHelper.isStokCurrentlyInPositionToday(res.symbol, function(isPos) {
    if (isPos) return;
    stockHelper.isStokBoughtToday(res.symbol, function(isBought) {
      if (isBought) return;

      var buyPrice = stockHelper.exchangeRoundOff(
        res.high * (1 + priceDiff / 100)
      );
      var buyStopLoss = stockHelper.exchangeRoundOff(
        buyPrice * (1 - loss / 100)
      );

      //place a sell order.

      var buyQuantity = Math.floor(WORTH / buyPrice);

      var targetBuyProfit = stockHelper.exchangeRoundOff(
        (profit / 100) * buyPrice
      );
      var buyStopLossDiff = buyPrice - buyStopLoss;

      var orderContext = {};
      console.log(
        "IMPORTANT LowVarienceRunner. Symobl: ",
        res.symbol,
        ", buyQuantity: ",
        buyQuantity,
        ", buyPrice: ",
        buyPrice,
        ", buyStopLoss:  ",
        buyStopLoss,
        " , buyLimit: ",
        stockHelper.exchangeRoundOff(buyPrice * (1 + profit / 100))
      );
      if (!MOCK) {
        stockHelper.placeStopLossMarketOrder(
          "NSE",
          res.symbol,
          buyQuantity,
          "BUY",
          "MIS",
          buyPrice,
          function(response) {
            var record = [
              uuidv1(),
              "BUY",
              res.symbol,
              "NSE",
              "LOW_VARIANCE_TRADE",
              JSON.stringify(orderContext),
              quantity,
              buyPrice,
              buyStopLoss,
              stockHelper.exchangeRoundOff(buyPrice * (1 + profit / 100)),
              day,
              new Date().getTime(),
              response.order_id,
              "ORDER_PLACED"
            ];
            intradayDao.createBuyRequest(record);

            if (response.order_id === "undefined") return;
            trailingStopLossManager.createBracketOrderFromRegularOrder(
              response.orderId,
              "NSE",
              "MIS",
              res.symbol,
              "BUY",
              0.5,
              0.5,
              "greedy_intraday"
            );
          }
        );
      }
      /*
      stockHelper.myBracketOrdeTrailingStoploss(
        "NSE",
        "BUY",
        res.symbol,
        quantity,
        buyPrice,
        targetBuyProfit,
        buyStopLossDiff,
        1.0,
        function(response) {
          var record = [
            uuidv1(),
            "BUY",
            response.tradingsymbol,
            "NSE",
            "LOW_VARIANCE_TRADE",
            JSON.stringify(orderContext),
            quantity,
            buyPrice,
            buyStopLoss,
            stockHelper.exchangeRoundOff(buyPrice * 1.01),
            day,
            new Date().getTime(),
            response.order_id,
            "ORDER_PLACED"
          ];
          intradayDao.createBuyRequest(record);
        }
      );

      */
      var sellPrice = stockHelper.exchangeRoundOff(
        res.low * (1 - priceDiff / 100)
      );
      var sellStopLoss = stockHelper.exchangeRoundOff(
        sellPrice * (1 + loss / 100)
      );

      var sellQuantity = Math.floor(WORTH / sellPrice);

      var targetSellProfit = stockHelper.exchangeRoundOff(
        (profit / 100) * buyPrice
      );
      var sellStopLossDiff = sellPrice - sellStopLoss;
      console.log(
        "Symobl: ",
        res.symbol,
        ", sellQuantity: ",
        sellQuantity,
        ", sellPrice: ",
        sellPrice,
        ", sellStopLoss:  ",
        sellStopLoss,
        " , sellTarget: ",
        stockHelper.exchangeRoundOff(buyPrice * (1 - profit / 100))
      );

      if (!MOCK) {
        stockHelper.placeStopLossMarketOrder(
          "NSE",
          res.symbol,
          sellQuantity,
          "SELL",
          "MIS",
          sellPrice,
          function(response) {
            var record = [
              uuidv1(),
              "SELL",
              res.symbol,
              "NSE",
              "LOW_VARIANCE_TRADE",
              JSON.stringify(orderContext),
              sellQuantity,
              sellPrice,
              sellStopLoss,
              stockHelper.exchangeRoundOff(buyPrice * (1 + profit / 100)),
              day,
              new Date().getTime(),
              response.order_id,
              "ORDER_PLACED"
            ];
            intradayDao.createBuyRequest(record);
            if (response.order_id === "undefined") return;
            trailingStopLossManager.createBracketOrderFromRegularOrder(
              response.orderId,
              "NSE",
              "MIS",
              res.symbol,
              "SELL",
              0.5,
              0.5,
              "greedy_intraday"
            );
          }
        );
      }
    });
  });

  /*

  stockHelper.myBracketOrdeTrailingStoploss(
    "NSE",
    "SELL",
    res.symbol,
    quantity,
    buyPrice,
    targetSellProfit,
    sellStopLossDiff,
    1.0,
    function(response) {
      var record = [
        uuidv1(),
        "SELL",
        response.tradingsymbol,
        "NSE",
        "LOW_VARIANCE_TRADE",
        JSON.stringify(orderContext),
        quantity,
        buyPrice,
        stopLossPrice,
        null,
        day,
        new Date().getTime(),
        response.order_id,
        "ORDER_PLACED"
      ];
      intradayDao.createBuyRequest(record);
    }
  ); */
}
