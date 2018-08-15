const kiteConnector = require("./kiteConnecter.js");
var KiteConnect = require("kiteconnect").KiteConnect;
const helper = require("./helper.js");
const moment = require("moment");
/*
var api_key = "excnq4xt82prtikf",
  secret = "97stthsig18m51d933sq3ft7de78wq8l",
  request_token = "ZH9N4SR89aL32oY3sULtnsDHF1yT7NXV",
  access_token = "wrsLosRhpXkyyBPPGS5Fpxr3uIaifnmq";

var options = {
  api_key: api_key,
  debug: true
};*/

kc = kiteConnector.getKiteConnector();
init();

//tryContinouslyOrderPlace(1000 * 2, 50, "NSE", "VAKRANGEE", 20);
//tryContinouslyOrderPlace(1000 * 2, 40, "NSE", "MTEDUCARE", 20);
//tryContinouslyOrderPlace(1000 * 2, 20, "NSE", "SBIN", 5);
module.exports.getTradeDay = function() {
  var d = new Date();
  return moment(d).format("DD-MMM-YYYY");
};

module.exports.getLTPForSymbolsMap = function(inputsymbols, callback) {
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
  console.log("symbolInstrumentMap", symbolInstrumentMap);

  exports.getLTP(instrumentIds, function(resp) {
    console.log("LTP Response", resp);
    for (var i = 0; i < inputsymbols.length; i++) {
      symbolLtpMap[inputsymbols[i]] =
        resp[symbolInstrumentMap[inputsymbols[i]]].last_price;
    }
    callback(symbolLtpMap);
    console.log(symbolLtpMap);
  });
};

exports.getLTP = function(instruments, callback) {
  kc.getLTP(instruments)
    .then(function(response) {
      //console.log(response);
      callback(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

/*
kc.setSessionExpiryHook(sessionHook);

if (!access_token) {
  kc.generateSession(request_token, secret)
    .then(function(response) {
      console.log("Response", response);
      init();
    })
    .catch(function(err) {
      console.log("Unable to generateSession", err);
    });
} else {
  kc.setAccessToken(access_token);
  console.log("Access token " + access_token);
  init();
}
*/

function init() {
  console.log(kc.getLoginURL());
  /*
  getProfile();
  getMargins();
  getMargins("equity");
  getPositions();
  getHoldings();
  getOrders();
  getOrderHistory();
  getTrades();
  getOrderTrades();
  getInstruments();
  getInstruments("NFO");
  getQuote(["NSE:RELIANCE"]);
  getOHLC(["NSE:RELIANCE"]);
	*/
  //getLTP(["NSE:RELIANCE"]);
  /*
  getHistoricalData(
    779521,
    "day",
    new Date("2018-01-01 18:05:00"),
    new Date("2018-01-10 18:05:37")
  );
  getHistoricalData(
    779521,
    "day",
    "2018-01-01 18:05:00",
    "2018-01-10 18:05:37"
  );
  getMFInstruments();
  getMFOrders();
  getMFSIPS();
	*/
  //tryContinouslyOrderPlace(1000 * 2, 20, "NSE", "VAKRANGEE", 20);
  //tryContinouslyOrderPlace(1000 * 2, 4, "NSE", "MTEDUCARE", 20);
  //tryContinouslyOrderPlace(1000 * 2, 2, "NSE", "SBIN", 5);

  //regularOrderPlace("regular");
  /*
  bracketOrderPlace();
  modifyOrder("regular");
  cancelOrder("regular");

  invalidateAccessToken();
	*/
}

var getProfile = function(callback) {
  kc.getProfile()
    .then(function(response) {
      //console.log(response);
      callback(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

function getMargins(segment) {
  kc.getMargins(segment)
    .then(function(response) {
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
}

exports.getPositions = function(callback) {
  kc.getPositions()
    .then(function(response) {
      //console.log(response);
      callback(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

module.exports.getDailyAllPositions = function(callback) {
  kc.getPositions()
    .then(function(response) {
      txns = response["day"];
      activeTxns = [];
      for (var i = 0; i < txns.length; i++) {
        quantity = txns[i].quantity;
        if (txns[i].product == "MIS") {
          activeTxns.push(txns[i]);
        }
      }
      //console.log("DAILY", activeTxns);
      callback(activeTxns);
    })
    .catch(function(err) {
      console.log(err);
    });
};

exports.getDailyActivePositions = function(callback) {
  kc.getPositions()
    .then(function(response) {
      txns = response["day"];
      activeTxns = [];
      for (var i = 0; i < txns.length; i++) {
        quantity = txns[i].quantity;
        if (quantity > 0 && txns[i].product == "MIS") {
          activeTxns.push(txns[i]);
        }
      }
      //console.log("DAILY", activeTxns);
      callback(activeTxns);
    })
    .catch(function(err) {
      console.log(err);
    });
};

exports.getHoldings = function(callback) {
  kc.getHoldings()
    .then(function(response) {
      callback(response);
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err.response);
    });
};

exports.getOrders = function() {
  kc.getOrders()
    .then(function(response) {
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

module.exports.isStokBoughtToday = function(stockSymbol, callback) {
  module.exports.getDailyAllPositions(function(result) {
    if (result.length > 0) {
      for (var i = 0; i < result.length; i++) {
        pos = result[i];
        if (pos.tradingsymbol == stockSymbol) {
          callback(true);
          return;
        }
      }
    }
    callback(false);
  });
  //Stock not bought
};

module.exports.isStokCurrentlyInPositionToday = function(
  stockSymbol,
  callback
) {
  module.exports.getDailyAllPositions(function(result) {
    if (result.length > 0) {
      for (var i = 0; i < result.length; i++) {
        pos = result[i];
        if (pos.tradingsymbol == stockSymbol && pos.quantity > 0) {
          callback(true);
          return;
        }
      }
    }
    callback(false);
  });
  //Stock not bought
};

exports.getIntradayPendingSellOrdersBySymbol = function(symbol, callback) {
  kc.getOrders()
    .then(function(response) {
      symbolOrders = [];
      for (var i = 0; i < response.length; i++) {
        if (
          response[i].tradingsymbol == symbol &&
          response[i].status == "TRIGGER PENDING" &&
          response[i].validity == "DAY" &&
          response[i].transaction_type == "SELL"
        ) {
          symbolOrders.push(response[i]);
        }
      }
      callback(symbolOrders);
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

exports.getIntradayPendingBuyOrdersBySymbol = function(symbol, callback) {
  kc.getOrders()
    .then(function(response) {
      symbolOrders = [];
      for (var i = 0; i < response.length; i++) {
        if (
          response[i].tradingsymbol == symbol &&
          response[i].status == "TRIGGER PENDING" &&
          response[i].validity == "DAY" &&
          response[i].transaction_type == "BUY"
        ) {
          symbolOrders.push(response[i]);
        }
      }
      callback(symbolOrders);
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

exports.getOrderHistory = function(orderId, callback) {
  kc.getOrderHistory(orderId)
    .then(function(response) {
      //console.log(response);
      callback(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

exports.getTrades = function(callback) {
  kc.getTrades()
    .then(function(response) {
      callback(response);
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

function getOrderTrades() {
  kc.getOrders()
    .then(function(response) {
      var completedOrdersID;
      for (var order of response) {
        if (order.status === kc.STATUS_COMPLETE) {
          completedOrdersID = order.order_id;
          break;
        }
      }

      if (!completedOrdersID) {
        console.log("No completed orders.");
        return;
      }

      kc.getOrderTrades(completedOrdersID)
        .then(function(response) {
          //console.log(response);
        })
        .catch(function(err) {
          console.log(err);
        });
    })
    .catch(function(err) {
      console.log(err);
    });
}

function getInstruments(exchange) {
  kc.getInstruments(exchange)
    .then(function(response) {
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
}

function getQuote(instruments) {
  kc.getQuote(instruments)
    .then(function(response) {
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
}

exports.getOHLC = function(instruments, callback) {
  kc.getOHLC(instruments)
    .then(function(response) {
      //console.log(response);
      callback(response);
    })
    .catch(function(err) {
      console.log(err);
    });
};

function getHistoricalData(
  instrument_token,
  interval,
  from_date,
  to_date,
  continuous
) {
  kc.getHistoricalData(
    instrument_token,
    interval,
    from_date,
    to_date,
    continuous
  )
    .then(function(response) {
      //  console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
}

function getMFInstruments() {
  kc.getMFInstruments()
    .then(function(response) {
      //  console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
}

function getMFOrders() {
  kc.getMFOrders()
    .then(function(response) {
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
}

function getMFSIPS() {
  kc.getMFSIPS()
    .then(function(response) {
      //console.log(response);
    })
    .catch(function(err) {
      console.log(err);
    });
}

function invalidateAccessToken(access_token) {
  kc.invalidateAccessToken(access_token)
    .then(function(response) {
      //  console.log(response);
      testOrders();
    })
    .catch(function(err) {
      console.log(err.response);
    });
}

function tryContinouslyOrderPlace(
  interval,
  count,
  exchange,
  tradingsymbol,
  quantity
) {
  for (var x = 0; x < count; x++)
    setTimeout(function() {
      regularOrderPlace(exchange, tradingsymbol, quantity);
    }, interval * x);
}

exports.placeLimitOrder = function(
  exchange,
  tradingsymbol,
  quantity,
  transactionType,
  orderType,
  limitPrice,
  callback
) {
  kc.placeOrder("regular", {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: transactionType,
    quantity: quantity,
    product: orderType,
    order_type: "LIMIT",
    price: limitPrice
  })
    .then(function(resp) {
      //console.log("Order placed", resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log("Order placed failed", err);
    });
};

exports.placeStopLossOrder = function(
  exchange,
  tradingsymbol,
  quantity,
  transactionType,
  orderType,
  limitPrice,
  triggerPrice,
  callback
) {
  kc.placeOrder("regular", {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: transactionType,
    quantity: quantity,
    product: orderType,
    order_type: "SL",
    price: limitPrice,
    trigger_price: triggerPrice
  })
    .then(function(resp) {
      //console.log("Order placed", resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log("Order placed failed", err);
    });
};

module.exports.regularLimitOrderSell = function(
  exchange,
  tradingsymbol,
  price,
  orderType,
  quantity,
  callback
) {
  kc.placeOrder(variety, {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: "SELL",
    quantity: quantity,
    product: orderType,
    order_type: "LIMIT",
    price: price
  });
};

module.exports.regularOrderSell = function(
  exchange,
  tradingsymbol,
  orderType,
  quantity,
  callback
) {
  kc.placeOrder("regular", {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: "SELL",
    quantity: quantity,
    product: orderType,
    order_type: "MARKET"
  })
    .then(function(resp) {
      //console.log("SELL: Order placed", resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log(
        "SELL: Order placed failed for tradingsymbol",
        tradingsymbol,
        err
      );
    });
};

module.exports.regularOrderPlace = function(
  exchange,
  tradingsymbol,
  txnType,
  orderType,
  quantity,
  callback
) {
  kc.placeOrder("regular", {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: txnType,
    quantity: quantity,
    product: orderType,
    order_type: "MARKET"
  })
    .then(function(resp) {
      callback(resp);
      //console.log("Order placed", resp);
    })
    .catch(function(err) {
      console.log("Order placed failed", err);
    });
};

exports.myBracketOrdeTrailingStoploss = function(
  exchange,
  txnType,
  tradingsymbol,
  quantity,
  price,
  targetDiff,
  stopLossDiff,
  trailingStoploss,
  callback
) {
  //Place a BUY order.
  //Place a LIMIT SELL order.
  //Place a STOPLOSS SELL order.
  //Every 10 second modify the limit and stop loss using strategy.

  kc.placeOrder(kc.VARIETY_BO, {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: txnType,
    order_type: "LIMIT",
    quantity: quantity,
    price: price,
    squareoff: targetDiff,
    stoploss: stopLossDiff,
    trailing_stoploss: trailingStoploss,
    validity: "DAY"
  })
    .then(function(resp) {
      //console.log(resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log(err);
    });
};

exports.placeStopLossMarketOrder = function(
  exchange,
  tradingsymbol,
  quantity,
  transactionType,
  orderType,
  triggerPrice,
  callback
) {
  kc.placeOrder("regular", {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: transactionType,
    quantity: quantity,
    product: orderType,
    order_type: "SL-M",
    trigger_price: triggerPrice
  })
    .then(function(resp) {
      //console.log("Order placed", resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log("Order placed failed", err);
    });
};

exports.bracketOrdeTrailingStoploss = function(
  exchange,
  tradingsymbol,
  quantity,
  price,
  targetDiff,
  stopLossDiff,
  trailingStoploss
) {
  kc.placeOrder(kc.VARIETY_BO, {
    exchange: exchange,
    tradingsymbol: tradingsymbol,
    transaction_type: "BUY",
    order_type: "LIMIT",
    quantity: quantity,
    price: price,
    squareoff: targetDiff,
    stoploss: stopLossDiff,
    trailing_stoploss: trailingStoploss,
    validity: "DAY"
  })
    .then(function(resp) {
      //console.log(resp);
    })
    .catch(function(err) {
      console.log(err);
    });
};

exports.bracketOrderPlace = function(
  exchange,
  txnType,
  tradingsymbol,
  quantity,
  price,
  squareOff,
  stopLoss
) {
  kc.placeOrder(kc.VARIETY_BO, {
    exchange: exchange,
    tradingsymbol: symbol,
    transaction_type: txnType,
    order_type: "LIMIT",
    quantity: quantity,
    price: price,
    squareoff: squareOff,
    stoploss: stopLoss,
    validity: "DAY"
  })
    .then(function(resp) {
      //console.log(resp);
    })
    .catch(function(err) {
      console.log(err);
    });
};

module.exports.modifyRegularOrder = function(
  variety,
  orderId,
  quantity,
  price,
  triggerPrice,
  disclosedQuantity,
  validity,
  callback
) {
  const optionalArgs = {
    ...(quantity != null ? { quantity: quantity } : {}),
    ...(price != null ? { price: price } : {}),
    ...(triggerPrice != null ? { trigger_price: triggerPrice } : {}),
    ...(disclosedQuantity != null
      ? { disclosed_quantity: disclosedQuantity }
      : {}),
    ...(validity != null ? { validity: validity } : {})
  };

  console.log(
    "M<odifying order for req ",
    optionalArgs,
    " and order ",
    orderId
  );

  kc.modifyOrder(variety, orderId, optionalArgs)
    .then(function(resp) {
      //console.log(resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log(err);
    });
};

module.exports.cancelOrder = function(variety, order_id, callback) {
  //var tradingsymbol = "RELIANCE";
  //var exchange = "NSE";
  //var instrument = exchange + ":" + tradingsymbol;
  //console.log("cancelorder start", order_id);

  kc.cancelOrder(variety, order_id)
    .then(function(resp) {
      //console.log("cancelorder succeded", resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log("cancelorder failed", err);
    });

  /*
  kc.getLTP([instrument])
    .then(function(resp) {
      kc.placeOrder(variety, {
        exchange: exchange,
        tradingsymbol: tradingsymbol,
        transaction_type: "BUY",
        quantity: 1,
        product: "MIS",
        order_type: "LIMIT",
        price: resp[instrument].last_price - 5
      })
        .then(function(resp) {
          cancel(variety, resp.order_id);
        })
        .catch(function(err) {
          console.log("Order place error", err);
        });
    })
    .catch(function(err) {
      console.log(err);
    });*/
};

/*
* @param {Object} params params.
* @param {string} params.exchange Exchange in which instrument is listed (NSE, BSE, NFO, BFO, CDS, MCX).
* @param {string} params.tradingsymbol Tradingsymbol of the instrument  (ex. RELIANCE, INFY).
* @param {string} params.transaction_type Transaction type (BUY or SELL).
* @param {string} params.position_type Position type (overnight, day).
* @param {string} params.quantity Position quantity
* @param {string} params.old_product Current product code (NRML, MIS, CNC).
* @param {string} params.new_product New Product code (NRML, MIS, CNC)
*/

exports.convertOrder = function(
  exchange,
  symbol,
  txnType,
  positionType,
  quantity,
  oldProduct,
  newProduct,
  callback
) {
  var req = {
    exchange: exchange,
    tradingsymbol: symbol,
    transaction_type: txnType,
    position_type: positionType,
    quantity: quantity,
    old_product: oldProduct,
    new_product: newProduct
  };
  console.log("Request to convertOrder is ", req);
  kc.convertPosition(req)
    .then(function(resp) {
      //console.log("convertOrder succeded", resp);
      callback(resp);
    })
    .catch(function(err) {
      console.log("convertOrder failed", err);
    });
};

exports.exchangeRoundOff = function(price) {
  return Math.round(price * 20) / 20;
};
