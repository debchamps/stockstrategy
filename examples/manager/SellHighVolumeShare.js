var fs = require("fs");
const helper = require("../helper.js");
const stockHelper = require("../stockHelper.js");
const strategyDao = require("../dao/strategyDao.js");
const trailingStopLossManager = require("./trailingStopLossManager.js");
const YahooDownload = require("../YahooDownload.js");
function fetchPendingOrders() {}
var GLOBAL_COUNTER = 0;
var WORTH = 200000;
var TXN_ENABLED = true;

const logger = require("../logger.js");

var marketStartPriceMap = {};
var day = stockHelper.getTradeDay();
//var day = "08-Aug-2018";

execute();
function execute() {
  logger.info("Starting Logging in SellHighVolume");
  var openTime = new Date();
  openTime.setHours(9, 25, 5, 0);
  var currentTime = new Date();
  var placeOrder = false;
  if (currentTime.getTime() > openTime.getTime()) {
    placeOrder = true;
  }

  if (!placeOrder) {
    logger.log.info(
      "Waiting ",
      Math.ceil((currentTime.getTime() - openTime.getTime()) / 1000),
      " more second to place order "
    );
    setTimeout(function() {
      execute();
      return;
    }, 1000);
  } else {
    YahooDownload.loadData();
    setTimeout(function() {
      strategyDao.getHighVolumeSellStocks(day, function(response) {
        logger.info(response);
        for (var i = 0; i < response.length; i++) {
          placeOrder2(response[i]);
        }
      });
      strategyDao.getLowVolumeSellStocks(day, function(response) {
        logger.info("LOW", response);
        for (var i = 0; i < response.length; i++) {
          placeOrder2(response[i]);
        }
      });
    }, 40000);
  }
}

function placeOrder2(resp) {
  var quantity = Math.ceil(WORTH / resp.open);
  logger.info("Placing order for ", resp, "quanityy", quantity);
  GLOBAL_COUNTER = GLOBAL_COUNTER + 1;
  if (TXN_ENABLED) {
    stockHelper.regularOrderPlace(
      "NSE",
      resp.symbol,
      "SELL",
      "MIS",
      quantity,
      function(response) {
        if (response.order_id === "undefined") return;

        if (GLOBAL_COUNTER % 2 == 0)
          trailingStopLossManager.createBracketOrderFromRegularOrder(
            response.order_id,
            "NSE",
            "MIS",
            resp.symbol,
            txnType,
            0.75,
            1.0,
            "greedy_intraday"
          );
      }
    );

    //Also Place a buy stop loss order incase value reaches 1% above the value.
  }
}

//loadOrderSugestions();

//(openTime.getTime());

/*
function loadOrderSugestions(callback) {
  fs.readFile("../trade/trade_suggestion.csv", "utf8", function(error, body) {
    //logger.info(response);
    //logger.info(body);
    var lines = body.split("\n");
    var orderDetails = [];
    for (var i = 1; i < lines.length; i++) {
      var tradeText = lines[i];
      logger.info(tradeText);
      var records = tradeText.split(",");
      var orderDetail = {
        strategy: records[0],
        symbol: records[1],
        price: records[2],
        limit: records[3],
        stopLoss: records[4],
        prevClose: records[5].replace(/(\n|\r)+$/, "")
      };
      orderDetails.push(orderDetail);
    }
    callback(orderDetails);
  });
}

setTimeout(function() {
  execute();
}, 2000);

function execute() {
  loadOrderSugestions(function(orderDetails) {
    logger.info(orderDetails);
    var openTime = new Date();
    openTime.setHours(9, 15, 5, 0);
    var currentTime = new Date();
    var placeOrder = false;
    if (currentTime.getTime() > openTime.getTime()) {
      placeOrder = true;
    }
    var allsymbols = [];
    for (var i = 0; i < orderDetails.length; i++) {
      allsymbols.push(orderDetails[i].symbol);
    }

    stockHelper.getLTPForSymbolsMap(allsymbols, function(symbolLtpMapResp) {
      marketStartPriceMap = symbolLtpMapResp;
    });

    setTimeout(function() {
      if (!placeOrder) {
        logger.info(
          "Waiting ",
          Math.ceil((currentTime.getTime() - openTime.getTime()) / 1000),
          " more second to place order "
        );
        setTimeout(function() {
          execute();
        }, 1000);
      } else {
        var allsymbols = [];
        for (var i = 0; i < orderDetails.length; i++) {
          allsymbols.push(orderDetails[i].symbol);
        }

        stockHelper.getLTPForSymbolsMap(allsymbols, function(symbolLtpMapResp) {
          for (var i = 0; i < orderDetails.length; i++) {
            orderDetails[i].ltp = symbolLtpMapResp[orderDetails[i].symbol];
          }
          logger.info(orderDetails);

          for (var i = 0; i < orderDetails.length; i++) {
            executeMarketTrend(orderDetails[i]);
          }
        });
      }
    }, 20000);
  }, 40000);
  //If order type is bracket order. just create a new order.
}

function getLTP(inputsymbols, callback) {
  logger.info("YYYY SYMBOLS", inputsymbols);
  instrumentIds = [];
  var symbolLtpMap = [];
  var instrumentSymbolMap = [];
  var symbolInstrumentMap = [];
  for (var i = 0; i < inputsymbols.length; i++) {
    var instrumentToken = helper.getInstrumentByTradingSymbol(
      "NSE",
      inputsymbols[i]
    );
    instrumentIds.push(instrumentToken);
    instrumentSymbolMap[instrumentToken] = inputsymbols[i];
    symbolInstrumentMap[inputsymbols[i]] = instrumentToken;
  }
  stockHelper.getLTP(instrumentIds, function(resp) {
    logger.info("LTP", resp, "XXX", symbolInstrumentMap);
    for (var i = 0; i < inputsymbols.length; i++) {
      symbolLtpMap[inputsymbols[i]] =
        resp[symbolInstrumentMap[inputsymbols[i]]].last_price;
    }
    callback(symbolLtpMap);
    logger.info(symbolLtpMap);
  });
}

function executeMarketTrend(orderDetail) {
  //getLTP and then if LTP is greater than marketClose place a market BUY order, else place market sell order.
  if (orderDetail.ltp > marketStartPriceMap[orderDetail.symbol]) {
    txnType = "BUY";
  } else {
    txnType = "SELL";
  }

  var quantity = Math.ceil(WORTH / orderDetail.price);
  logger.info(
    "IMPORTANT PlacePending order NSE",
    orderDetail.symbol,
    txnType,
    "MIS",
    quantity
  );
  if (TXN_ENABLED) {
    stockHelper.regularOrderPlace(
      "NSE",
      orderDetail.symbol,
      txnType,
      "MIS",
      quantity,
      function(response) {
        logger.info("IMPORTANT response is ", response);
        if (response.order_id === "undefined") {
          logger.info("IMPORTANT order id is not defined");

          return;
        }
        trailingStopLossManager.createBracketOrderFromRegularOrder(
          response.order_id,
          "NSE",
          "MIS",
          orderDetail.symbol,
          txnType,
          0.8,
          0.6,
          "greedy_intraday"
        );
      }
    );
  }
}

function executeContinuously() {}

function executeOrderSuggestion(orderDetail) {
  //By default assume everything as limit order.

  var quantity = Math.ceil(WORTH / orderDetail.price);
  logger.info(
    "NSE",
    orderDetail.symbol,
    quantity,
    orderDetail.txnType,
    orderType,
    orderDetail.price
  );
  stockHelper.placeStopLossMarketOrder(
    "NSE",
    orderDetail.symbol,
    quantity,
    orderDetail.txnType,
    orderType,
    orderDetail.price,
    function(response) {
      logger.info("IMPORTANT response is ", response);
      if (response.order_id === "undefined") {
        logger.info("IMPORTANT order id is not defined");

        return;
      }
      trailingStopLossManager.createBracketOrderFromRegularOrder(
        response.orderId,
        "NSE",
        "MIS",
        orderDetail.symbol,
        orderDetail.txnType,
        0.8,
        0.6,
        "greedy_intraday"
      );
    }
  );
}
*/
