var fs = require("fs");
const helper = require("../helper.js");
const stockHelper = require("../stockHelper.js");
function fetchPendingOrders() {}
var WORTH = 200000;
var TXN_ENABLED = true;
var DEFAULT_QUANTITY = 50;

var UPPER_CICUIT_SYMBOLS = ["KWALITY", "MANPASAND"];
//loadOrderSugestions();
setTimeout(function() {
  execute();
  //  getLTP(["SUNTV", "HAVELLS", "DLF"], function(resp) {});
}, 2000);
//console.log(openTime.getTime());
function execute() {
  loadOrderSugestions(function(orderDetails) {
    console.log(orderDetails);
    var openTime = new Date();
    openTime.setHours(9, 15, 0, 0);
    var currentTime = new Date();
    var placeOrder = false;
    if (currentTime.getTime() > openTime.getTime()) {
      placeOrder = true;
    }
    if (!placeOrder) {
      console.log(
        "Waiting ",
        Math.ceil((currentTime.getTime() - openTime.getTime()) / 1000),
        " more second to place order "
      );
      setTimeout(function() {
        executePendingOrder();
      }, 100);
    } else {
      continouslyPlaceOrder();
    }
  });
  //If order type is bracket order. just create a new order.
}

function continouslyPlaceOrder() {
  for (var j = 0; j < 1000; j++) {
    for (var i = 0; i < UPPER_CICUIT_SYMBOLS.length; i++) {
      var symbol = UPPER_CICUIT_SYMBOLS[i];
      stockHelper.regularOrderPlace(
        "NSE",
        symbol,
        txnType,
        "CNC",
        DEFAULT_QUANTITY,
        function(resp) {
          console.log("Order placed", resp);
        }
      );
    }
  }
}

function loadOrderSugestions(callback) {
  fs.readFile("../trade/trade_suggestion.csv", "utf8", function(error, body) {
    //console.log(response);
    //console.log(body);
    var lines = body.split("\n");
    var orderDetails = [];
    for (var i = 1; i < lines.length; i++) {
      var tradeText = lines[i];
      var records = tradeText.split("\t");
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

function executePendingOrder() {
  loadOrderSugestions(function(orderDetails) {
    console.log(orderDetails);
    var openTime = new Date();
    openTime.setHours(9, 15, 20, 0);
    var currentTime = new Date();
    var placeOrder = false;
    if (currentTime.getTime() > openTime.getTime()) {
      placeOrder = true;
    }
    if (!placeOrder) {
      console.log(
        "Waiting ",
        Math.ceil((currentTime.getTime() - openTime.getTime()) / 1000),
        " more second to place order "
      );
      setTimeout(function() {
        executePendingOrder();
      }, 1000);
    } else {
      var allsymbols = [];
      for (var i = 0; i < orderDetails.length; i++) {
        allsymbols.push(orderDetails[i].symbol);
      }
      console.log(allsymbols);
      getLTP(allsymbols, function(symbolLtpMapResp) {
        for (var i = 0; i < orderDetails.length; i++) {
          orderDetails[i].ltp = symbolLtpMapResp[orderDetails[i].symbol];
        }
        console.log(orderDetails);

        for (var i = 0; i < orderDetails.length; i++) {
          executeMarketTrend(orderDetails[i]);
        }
      });
    }
  });
  //If order type is bracket order. just create a new order.
}

function getLTP(inputsymbols, callback) {
  console.log("YYYY SYMBOLS", inputsymbols);
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
  console.log(instrumentIds);
  stockHelper.getLTP(instrumentIds, function(resp) {
    for (var i = 0; i < inputsymbols.length; i++) {
      console.log(
        "YYYY",
        resp,
        "GGG",
        symbolInstrumentMap,
        symbolInstrumentMap[inputsymbols[i]]
      );
      //console.log("YYYY", resp[symbolInstrumentMap[inputsymbols[i]]]);

      symbolLtpMap[inputsymbols[i]] =
        resp[symbolInstrumentMap[inputsymbols[i]]].last_price;
    }
    callback(symbolLtpMap);
    console.log(symbolLtpMap);
  });
}

function executeMarketTrend(orderDetail) {
  //getLTP and then if LTP is greater than marketClose place a market BUY order, else place market sell order.
  if (orderDetail.ltp > orderDetail.prevClose) {
    txnType = "BUY";
  } else {
    txnType = "SELL";
  }

  var quantity = Math.ceil(WORTH / orderDetail.price);
  console.log("NSE", orderDetail.symbol, txnType, "MIS", quantity);
  if (TXN_ENABLED) {
    stockHelper.regularOrderPlace(
      "NSE",
      orderDetail.symbol,
      txnType,
      "CNC",
      quantity,
      function(resp) {
        console.log("Order placed", resp);
      }
    );
  }
}

function executeContinuously() {}

function executeOrderSuggestion(orderDetail) {
  //By default assume everything as limit order.

  var quantity = Math.ceil(WORTH / orderDetail.price);
  console.log(
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
      console.log(response);
    }
  );
}
