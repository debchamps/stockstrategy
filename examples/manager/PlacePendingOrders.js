var fs = require("fs");
const helper = require("../helper.js");
const stockHelper = require("../stockHelper.js");
const trailingStopLossManager = require("./trailingStopLossManager.js");
function fetchPendingOrders() {}
var WORTH = 100000;
var TXN_ENABLED = true;

var marketStartPriceMap = {};
//loadOrderSugestions();

//console.log(openTime.getTime());
function loadOrderSugestions(callback) {
  fs.readFile("../trade/trade_suggestion.csv", "utf8", function(error, body) {
    //console.log(response);
    //console.log(body);
    var lines = body.split("\n");
    var orderDetails = [];
    for (var i = 1; i < lines.length; i++) {
      var tradeText = lines[i];
      console.log(tradeText);
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
    console.log(orderDetails);
    var openTime = new Date();
    openTime.setHours(9, 15, 5, 0);
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
        execute();
      }, 1000);
      return;
    }

    for (var i = 0; i < 50; i++) {
      stockHelper.regularOrderPlace(
        "NSE",
        "VAKRANGEE",
        "SELL",
        "CNC",
        500,
        function(response) {}
      );
    }

    /*
    var allsymbols = [];
    for (var i = 0; i < orderDetails.length; i++) {
      allsymbols.push(orderDetails[i].symbol);
    }

    stockHelper.getLTPForSymbolsMap(allsymbols, function(symbolLtpMapResp) {
      marketStartPriceMap = symbolLtpMapResp;
    });

    setTimeout(function() {
      {
        var allsymbols = [];
        for (var i = 0; i < orderDetails.length; i++) {
          allsymbols.push(orderDetails[i].symbol);
        }

        stockHelper.getLTPForSymbolsMap(allsymbols, function(symbolLtpMapResp) {
          for (var i = 0; i < orderDetails.length; i++) {
            orderDetails[i].ltp = symbolLtpMapResp[orderDetails[i].symbol];
          }
          console.log(orderDetails);

          for (var i = 0; i < orderDetails.length; i++) {
            executeMarketTrend(orderDetails[i]);
          }
        });
      }
    }, 20000);
    */
  }, 40000);

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
  stockHelper.getLTP(instrumentIds, function(resp) {
    console.log("LTP", resp, "XXX", symbolInstrumentMap);
    for (var i = 0; i < inputsymbols.length; i++) {
      symbolLtpMap[inputsymbols[i]] =
        resp[symbolInstrumentMap[inputsymbols[i]]].last_price;
    }
    callback(symbolLtpMap);
    console.log(symbolLtpMap);
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
  console.log(
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
        console.log("IMPORTANT response is ", response);
        if (response.order_id === "undefined") {
          console.log("IMPORTANT order id is not defined");

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
      console.log("IMPORTANT response is ", response);
      if (response.order_id === "undefined") {
        console.log("IMPORTANT order id is not defined");

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
