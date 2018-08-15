var MIN_DIFF_LIMIT = 0.1;
var MIN_PROFIT_LIMIT = 6;

var MIN_PROFIT_INTRADAY_VOLUME_LIMIT = 15;

var MIN_DIFF_QUICK_CNC_LIMIT = 0.3;
var MIN_DIFF_CNC_LIMIT = 0.75;
const bracketOrderTrailingDao = require("../dao/bracketOrderTrailingDao.js");
const stockHelper = require("../stockHelper.js");
var TXN_ENABLED = true;

var PENDING_VALUESET = "PENDING_V";

module.exports.createIntradayTrailingStopLossOrder = function(
  symbol,
  quantity
) {
  // Create the regular or limit order.
  // Persist the order with status.
};

module.exports.createCNCStopLoss = function(symbol) {};

function executeCNCStopLoss() {
  //Chech if their is any
  //Get me the stop loss.
  //Get me the current price.
}

/*
{ tradingsymbol: 'JSLHISAR',
  exchange: 'NSE',
  instrument_token: 3149825,
  product: 'MIS',
  quantity: 0,
  overnight_quantity: 0,
  multiplier: 1,
  average_price: 0,
  close_price: 0,
  last_price: 138.1,
  value: 71.25,
  pnl: 71.25,
  m2m: 71.25,
  unrealised: 71.25,
  realised: 0,
  buy_quantity: 75,
  buy_price: 132.5,
  buy_value: 9937.5,
  buy_m2m: 9937.5,
  sell_quantity: 75,
  sell_price: 133.45,
  sell_value: 10008.75,
  sell_m2m: 10008.75,
  day_buy_quantity: 75,
  day_buy_price: 132.5,
  day_buy_value: 9937.5,
  day_sell_quantity: 75,
  day_sell_price: 133.45,
  day_sell_value: 10008.75 } */

module.exports.createMISBracketOrder = function(position) {
  console.log("IMPORTANT:  In ", position, "  and response ");
  bracketOrderTrailingDao.getBracketOrderWithStopLoss(
    position.exchange,
    position.product,
    position.tradingsymbol,
    function(response) {
      console.log("IMPORTANT:  In ", position, "  and response " + response);
      if (response.length == 0 && position.quantity == 0) {
        return;
      }

      if (response.length == 0) {
        console.log("IMPORTANT:  Response size is 0");
        //Create a bracket stop loss order. Return.
        //createAndPersistBracketOrderWithStopLoss(position);
        //Wait for orders to be completed.
        return;
      }

      var bracketOrderResponse = response[0];
      var status = bracketOrderResponse.status;
      if (position.quantity == 0 && status == "LIVE") {
        expireBracketOrderWithTrailingStopLoss(position, bracketOrderResponse);
        return;
      } else if (status == "EXPIRED") {
        return;
      } else if (status == "PENDING") {
        //The order was pendig till now. So the stoploss order and the limit order was not placed.
        executePendingBracketOrderWithTrailngStopLoss(
          position,
          bracketOrderResponse
        );
        console.log("HERE5");
        return;

        //Find the limit and stoploss value.
        //Place a limit order and another stoploss order. Now
        //Fillup the and update the order.
      } else if ((status = "LIVE")) {
        //Use the strategy to find the new Limit and new Stop Loss.
        //If either of the value have changed modify order.
        //Update the datastore on the limit and stop loss value.
        //Modify the stopLoss order and the limit order.
        var lastFetchedLTP = position.last_price;
        updateStopLossAndTriggerOnExecution(
          lastFetchedLTP,
          bracketOrderResponse
        );
      }
    }
  );
  //bracketOrderTrailingDao.createBracketOrderWithStopLossForPosition();
};

module.exports.createMISBracketOrderV2 = function(position) {
  console.log("IMPORTANT:  In ", position, "  and response ");
  bracketOrderTrailingDao.getBracketOrderWithStopLoss(
    position.exchange,
    position.product,
    position.tradingsymbol,
    function(response) {
      console.log("IMPORTANT:  In ", position, "  and response " + response);
      if (response.length == 0 && position.quantity == 0) {
        return;
      }

      if (response.length == 0) {
        console.log("IMPORTANT:  Response size is 0");
        //Create a bracket stop loss order. Return.
        //createAndPersistBracketOrderWithStopLoss(position);
        return;
      }

      //var bracketOrderResponse = response[0];
      for (var i = 0; i < response.length; i++) {
        var bracketOrderResponse = response[i];
        var status = bracketOrderResponse.status;
        if (position.quantity == 0 && status == "LIVE") {
          expireBracketOrderWithTrailingStopLoss(
            position,
            bracketOrderResponse
          );
          return;
        } else if (status == "EXPIRED") {
          return;
        } else if (status == "PENDING") {
          //The order was pendig till now. So the stoploss order and the limit order was not placed.
          executePendingBracketOrderWithTrailngStopLoss(
            position,
            bracketOrderResponse
          );
          console.log("HERE5");
          return;

          //Find the limit and stoploss value.
          //Place a limit order and another stoploss order. Now
          //Fillup the and update the order.
        } else if ((status = "LIVE")) {
          //Use the strategy to find the new Limit and new Stop Loss.
          //If either of the value have changed modify order.
          //Update the datastore on the limit and stop loss value.
          //Modify the stopLoss order and the limit order.
          var lastFetchedLTP = position.last_price;
          updateStopLossAndTriggerOnExecution(
            lastFetchedLTP,
            bracketOrderResponse
          );
        }
      }
    }
  );
  //bracketOrderTrailingDao.createBracketOrderWithStopLossForPosition();
};

function updateStopLossAndTriggerOnExecution(
  lastFetchedLTP,
  bracketOrderResponse
) {
  console.log("current LTP: ", lastFetchedLTP, "order: ", bracketOrderResponse);
  var newPrice = executeStrategy(
    bracketOrderResponse.limitStrategy,
    lastFetchedLTP,
    bracketOrderResponse
  );
  console.log("Updated price is ", newPrice);
  if (newPrice.limitPrice != bracketOrderResponse.currentLimit) {
    if (TXN_ENABLED)
      stockHelper.modifyRegularOrder(
        "regular",
        bracketOrderResponse.limitOrderId,
        null,
        newPrice.limitPrice,
        null,
        null,
        null,
        function(resp) {
          bracketOrderTrailingDao.updateLimit(
            bracketOrderResponse.bracketId,
            position.last_price,
            newPrice.limitPrice,
            resp.order_id
          );
        }
      );
    //Update the limit price
  }

  if (newPrice.stopLossPrice != bracketOrderResponse.currentStopLoss) {
    if (TXN_ENABLED)
      stockHelper.modifyRegularOrder(
        "regular",
        bracketOrderResponse.stopLossOrderId,
        null,
        newPrice.stopLossPrice,
        newPrice.stopLossPrice,
        null,
        null,
        function(resp) {
          bracketOrderTrailingDao.updateStoploss(
            bracketOrderResponse.bracketId,
            lastFetchedLTP,
            newPrice.stopLossPrice,
            resp.order_id
          );
        }
      );
    //Update the stop loss.
  }
}

exports.updatePendingValueSetOrders = function() {
  console.log("IMPORTANT : In updatePendingValueSetOrders");
  bracketOrderTrailingDao.getBracketOrderWithStatus(PENDING_VALUESET, function(
    bracketOrders
  ) {
    console.log("IMPORTANT : In updatePendingValueSetOrders", bracketOrders);
    //Get Order History
    //If complete.
    //I expired
    if (bracketOrders.length == 0) return;
    for (var i = 0; i < bracketOrders.length; i++) {
      updateOnOrderUpdate(bracketOrders[i]);
    }
  });
};

/*
{ placed_by: 'XT7895',
    order_id: '180802001401507',
    exchange_order_id: '1000000004031536',
    parent_order_id: null,
    status: 'CANCELLED',
    status_message: null,
    order_timestamp: 2018-08-02T07:48:42.000Z,
    exchange_update_timestamp: null,
    exchange_timestamp: 2018-08-02T07:48:42.000Z,
    variety: 'regular',
    exchange: 'NSE',
    tradingsymbol: 'ABB',
    instrument_token: 3329,
    order_type: 'SL-M',
    transaction_type: 'BUY',
    validity: 'DAY',
    product: 'MIS',
    quantity: 81,
    disclosed_quantity: 0,
    price: 0,
    trigger_price: 1233.85,
    average_price: 0,
    filled_quantity: 0,
    pending_quantity: 81,
    cancelled_quantity: 81,
    market_protection: 0,
    tag: null,
    guid: '7788XJEtmv9kbQNtU' }*/

/*  { placed_by: 'XT7895',
    order_id: '180802001406019',
    exchange_order_id: '1200000003538969',
    parent_order_id: null,
    status: 'COMPLETE',
    status_message: null,
    order_timestamp: 2018-08-02T07:45:20.000Z,
    exchange_update_timestamp: null,
    exchange_timestamp: 2018-08-02T07:05:05.000Z,
    variety: 'regular',
    exchange: 'NSE',
    tradingsymbol: 'PCJEWELLER',
    instrument_token: 7455745,
    order_type: 'LIMIT',
    transaction_type: 'BUY',
    validity: 'DAY',
    product: 'MIS',
    quantity: 6000,
    disclosed_quantity: 0,
    price: 91.8,
    trigger_price: 0,
    average_price: 91.8,
    filled_quantity: 6000,
    pending_quantity: 0,
    cancelled_quantity: 0,
    market_protection: 0,
    tag: null,
    guid: '01Xm0Srv9E1HjqT' }*/
function updateBracketOrderOnRegularOrderComplete(order) {}

function getInitialPrices(tradePrice, txnType, strategy) {
  //if strategy is lookup. lookup from the order details.
  //default strategy.

  var stopLossNew =
    txnType == "SELL"
      ? stockHelper.exchangeRoundOff(tradePrice * 1.005)
      : stockHelper.exchangeRoundOff(tradePrice * 0.995);
  var limitNew =
    txnType == "SELL"
      ? stockHelper.exchangeRoundOff(tradePrice * 0.992)
      : stockHelper.exchangeRoundOff(tradePrice * 1.008);

  return {
    stopLossPrice: stopLossNew,
    limitPrice: limitNew
  };
}

function fetchOrderDetailsForCompletedOrder() {
  return {
    price: 112,
    stopLossPrice: 232,
    limitPrice: 223
  };
}

function updateOnOrderUpdate(bracketOrderResponse) {
  console.log("IMPORTANT : In updateOnOrderUpdate", bracketOrderResponse);
  if (
    bracketOrderResponse.orderId == null ||
    bracketOrderResponse.status != PENDING_VALUESET
  ) {
    return;
  }
  stockHelper.getOrderHistory(bracketOrderResponse.orderId, function(
    orderHistory
  ) {
    console.log("IMPORTANT :: orderHistory", orderHistory);
    for (var i = 0; i < orderHistory.length; i++) {
      var order = orderHistory[i];
      if (order.status == "CANCELLED" || order.status == "REJECTED") {
        bracketOrderTrailingDao.expireBracketOrder(
          bracketOrderResponse.bracketId,
          function() {
            console.log("Expired bracket order");
          }
        );
      }
      if (order.status == "COMPLETE") {
        var txnType = order.transaction_type;
        var averagePrice = order.average_price;
        var lastEvaluatedLtp = averagePrice;
        var status = "PENDING";
        var profitPercent =
          bracketOrderResponse.profitPercent != null
            ? bracketOrderResponse.profitPercent
            : 0.6;
        var stopLossPercent =
          bracketOrderResponse.stopLossPercent != null
            ? bracketOrderResponse.stopLossPercent
            : 0.6;
        var stopLossNew =
          txnType == "SELL"
            ? stockHelper.exchangeRoundOff(
                averagePrice * (1 + stopLossPercent / 100)
              )
            : stockHelper.exchangeRoundOff(
                averagePrice * (1 - stopLossPercent / 100)
              );
        var limitNew =
          txnType == "SELL"
            ? stockHelper.exchangeRoundOff(
                averagePrice * (1 - profitPercent / 100)
              )
            : stockHelper.exchangeRoundOff(
                averagePrice * (1 + profitPercent / 100)
              );
        status = "PENDING";

        bracketOrderTrailingDao.updateBracketOrderOnOrderUpdate(
          bracketOrderResponse.orderId,
          order.quantity,
          averagePrice,
          limitNew,
          stopLossNew,
          0.05,
          lastEvaluatedLtp,
          status
        );
      }
    }
  });
}

module.exports.createBracketOrderFromRegularOrder = function(
  orderId,
  exchange,
  product,
  symbol,
  txnType,
  profitPercent,
  stopLossPercent,
  strategy
) {
  //create order first.

  var status = PENDING_VALUESET;

  console.log(
    "IMPORTANT : Creating order with details ",
    orderId,
    exchange,
    product,
    symbol,
    txnType,
    profitPercent,
    stopLossPercent,
    strategy
  );

  bracketOrderTrailingDao.createBracketOrderWithStopLossForPosition(
    "abc" + symbol + new Date().getTime(),
    orderId,
    exchange,
    product,
    txnType,
    symbol,
    null,
    null,
    strategy,
    strategy,
    null,
    null,
    null,
    null,
    0.05,
    null,
    status,
    new Date().getTime(),
    profitPercent,
    stopLossPercent
  );
};

function createAndPersistBracketOrderWithStopLoss(position) {
  var txnType = "BUY";
  if (position.quantity < 0) txnType = "SELL";
  var averagePrice =
    txnType == "SELL" ? position.sell_price : position.buy_price;

  var lastEvaluatedLtp =
    txnType == "SELL" ? position.sell_price : position.buy_price;

  var stopLossNew =
    txnType == "SELL"
      ? stockHelper.exchangeRoundOff(position.sell_price * 1.006)
      : stockHelper.exchangeRoundOff(position.buy_price * 0.994);
  var limitNew =
    txnType == "SELL"
      ? stockHelper.exchangeRoundOff(position.sell_price * 0.994)
      : stockHelper.exchangeRoundOff(position.buy_price * 1.006);

  console.log(
    "IMPORTANT : stopLossNew ",
    stopLossNew,
    " limitNew ",
    limitNew,
    " for position",
    position,
    " for txnType ",
    txnType
  );

  bracketOrderTrailingDao.createBracketOrderWithStopLossForPosition(
    "abc" + position.tradingsymbol + new Date().getTime(),
    null,
    position.exchange,
    position.product,
    txnType,
    position.tradingsymbol,
    position.quantity,
    averagePrice,
    "greedy_intraday",
    "greedy_intraday",
    null,
    null,
    stopLossNew,
    limitNew,
    0.05,
    lastEvaluatedLtp,
    "PENDING",
    new Date().getTime(),
    6,
    6
  );
}

function expireBracketOrderWithTrailingStopLoss(
  position,
  bracketOrderResponse
) {
  if (bracketOrderResponse.stopLossOrderId != null)
    if (TXN_ENABLED)
      stockHelper.cancelOrder(
        "regular",
        bracketOrderResponse.stopLossOrderId,
        function(resp) {
          console.log("Cancelled order", resp.order_id);
        }
      );

  if (bracketOrderResponse.limitOrderId != null) {
    if (TXN_ENABLED)
      stockHelper.cancelOrder(
        "regular",
        bracketOrderResponse.limitOrderId,
        function(resp) {
          console.log("Cancelled order", resp.order_id);
        }
      );
  }

  bracketOrderTrailingDao.expireBracketOrder(
    bracketOrderResponse.bracketId,
    function() {
      console.log("Expired bracket order");
    }
  );
}

var placeStopLossOrderAndUpdate = function(
  position,
  bracketOrderResponse,
  lastPrice,
  stopLossAmount,
  triggerAmount
) {
  if (bracketOrderResponse.initialStopLoss > 0) {
    var coverTxnType = bracketOrderResponse.txnType == "SELL" ? "BUY" : "SELL";
    if (TXN_ENABLED)
      stockHelper.placeStopLossOrder(
        bracketOrderResponse.exchange,
        bracketOrderResponse.symbol,
        Math.abs(bracketOrderResponse.quantity),
        coverTxnType,
        bracketOrderResponse.product,
        stopLossAmount,
        triggerAmount,
        function(response) {
          console.log("IMPORTANT", response);

          bracketOrderTrailingDao.updateStoploss(
            bracketOrderResponse.bracketId,
            lastPrice,
            triggerAmount,
            response.order_id
          );
        }
      );
  }
};

var placeLimitOrderAndUpdate = function(
  position,
  bracketOrderResponse,
  lastPrice,
  limitPrice
) {
  console.log(
    "IMORTANT : In Limit",
    position,
    bracketOrderResponse,
    lastPrice,
    limitPrice
  );
  if (bracketOrderResponse.initialLimit > 0) {
    var coverTxnType = bracketOrderResponse.txnType == "SELL" ? "BUY" : "SELL";
    if (TXN_ENABLED)
      console.log(
        "IMORTANT : In Limit placeLimitOrder",
        bracketOrderResponse.exchange,
        bracketOrderResponse.symbol,
        Math.abs(bracketOrderResponse.quantity),
        coverTxnType,
        bracketOrderResponse.product,
        limitPrice
      );
    stockHelper.placeLimitOrder(
      bracketOrderResponse.exchange,
      bracketOrderResponse.symbol,
      Math.abs(bracketOrderResponse.quantity),
      coverTxnType,
      bracketOrderResponse.product,
      limitPrice,
      function(response) {
        //Update database with the stoploss orderId.
        bracketOrderTrailingDao.updateLimit(
          bracketOrderResponse.bracketId,
          lastPrice,
          limitPrice,
          response.order_id
        );
      }
    );
  }
};

function executePendingBracketOrderWithTrailngStopLoss(
  position,
  bracketOrderResponse
) {
  var initialLTP = bracketOrderResponse.averagePrice;
  placeStopLossOrderAndUpdate(
    position,
    bracketOrderResponse,
    initialLTP,
    bracketOrderResponse.initialStopLoss,
    bracketOrderResponse.initialStopLoss
  );
  placeLimitOrderAndUpdate(
    position,
    bracketOrderResponse,
    initialLTP,
    bracketOrderResponse.initialLimit
  );
  /*
  if (bracketOrderResponse.initialStopLoss > 0) {
    if (TXN_ENABLED)
      stockHelper.placeStopLossOrder(
        position.exchange,
        position.tradingsymbol,
        position.quantity,
        "SELL",
        position.product,
        bracketOrderResponse.initialStopLoss,
        bracketOrderResponse.initialStopLoss,
        function(response) {
          console.log("IMPORTANT", response);

          bracketOrderTrailingDao.updateStoploss(
            bracketOrderResponse.bracketId,
            position.buy_price,
            bracketOrderResponse.initialStopLoss,
            response.order_id
          );
        }
      );
  }
  */
  /*
  if (bracketOrderResponse.initialLimit > 0) {
    console.log("HERE3");
    if (TXN_ENABLED)
      stockHelper.placeLimitOrder(
        position.exchange,
        position.tradingsymbol,
        position.quantity,
        "SELL",
        position.product,
        bracketOrderResponse.initialLimit,
        function(response) {
          //Update database with the stoploss orderId.
          bracketOrderTrailingDao.updateLimit(
            bracketOrderResponse.bracketId,
            position.buy_price,
            bracketOrderResponse.initialLimit,
            response.order_id
          );
        }
      );
  }*/
}

function addTrailingStopLossToOrder(orderId) {}

function createLimitAndStopLossOrder(trailingStopLossOrder) {
  //Place the limit order.
  //place the stopLoss order.
  //Update the limit and stoploss order details.
}

//Called from ohlc currently
function updateTrailingStopLossOrder(currentLTP, mybracketOrder) {
  if (currentLTP > trailingStopLossOrder.ltp) {
    //Price have increased.
  }
  //Check if we value is now higher than oldValue.
  //Find the new stopLoss.
  //Find the new Limit.
  //modify the limit order and stopLoss order if applicable.
}

function executeStrategy(strategy, currentLTP, mybracketOrder) {
  console.log("In execute strategy");
  return greedyIntraday(currentLTP, mybracketOrder);
  /*
  if (strategy == "default12") {
    return defaultStrategy(currentLTP, mybracketOrder);
  } else if (strategy == "greedy_intraday12") {
    return greedyIntraday(currentLTP, mybracketOrder);
  }
  return defaultStrategy(currentLTP, mybracketOrder);
  */
}

function defaultStrategy(currentLTP, mybracketOrder) {
  console.log("In default strategy", mybracketOrder);
  if (currentLTP > mybracketOrder.lastEvaluatedLTP) {
    var diffInLTP = currentLTP - mybracketOrder.lastEvaluatedLTP;
    console.log("In default strategy Difference is", diffInLTP);
    if (diffInLTP > mybracketOrder.trailingStopLoss) {
      var newStopLoss = mybracketOrder.currentStopLoss + diffInLTP;
      return {
        stopLossPrice: newStopLoss,
        limitPrice: mybracketOrder.currentLimit
      };
    }
  }
  return {
    stopLossPrice: mybracketOrder.currentStopLoss,
    limitPrice: mybracketOrder.currentLimit
  };
}

function greedyIntraday(currentLTP, mybracketOrder) {
  var timeRemainingNow = 10;
  console.log(mybracketOrder, " and currentLTP", currentLTP);
  var profitAcheived = 0;
  var targetProfit = Math.abs(
    (mybracketOrder.initialLimit - mybracketOrder.averagePrice) *
      Math.abs(mybracketOrder.quantity)
  );

  if (mybracketOrder.txnType == "BUY") {
    profitAcheived =
      (currentLTP - mybracketOrder.averagePrice) *
      Math.abs(mybracketOrder.quantity);
  } else {
    profitAcheived =
      (mybracketOrder.averagePrice - currentLTP) *
      Math.abs(mybracketOrder.quantity);
  }

  console.log(
    "profitAcheived : ",
    profitAcheived,
    " targetProfit: ",
    targetProfit
  );

  var profitRemainingPercent =
    (100 * (targetProfit - profitAcheived)) / targetProfit;
  /*
  var diffToLimitPrice =
    (100 * (mybracketOrder.currentLimit - currentLTP)) /
    mybracketOrder.currentLimit;
  console.log(
    "diffToLimitPrice is : ",
    diffToLimitPrice + " for " + mybracketOrder.symbol
  ); */

  console.log(
    "profitRemainingPercent is : ",
    profitRemainingPercent + " for " + mybracketOrder.symbol
  );

  //Depending on slot. Decrement the amount.
  if (profitRemainingPercent <= MIN_PROFIT_LIMIT) {
    var newLimitPrice = 0,
      newStopLossPrice = 0;
    if (mybracketOrder.txnType == "SELL") {
      var newLimitPrice = mybracketOrder.currentLimit * (1 - 0.2 / 100);
      var newStopLossPrice = mybracketOrder.currentStopLoss * (1 + 0.2 / 100);
    } else {
      var newLimitPrice = mybracketOrder.currentLimit * (1 + 0.2 / 100);
      var newStopLossPrice = mybracketOrder.currentStopLoss * (1 - 0.2 / 100);
    }
    return {
      stopLossPrice: newStopLossPrice,
      limitPrice: newLimitPrice
    };
    //updateLimit
    //updateStopLoss
  } else {
    return {
      stopLossPrice: mybracketOrder.currentStopLoss,
      limitPrice: mybracketOrder.currentLimit
    };
  }
}

function dayeEndCNC(currentLTP, mybracketOrder) {}

function volumeBasedInraday(currentLTP, mybracketOrder) {
  var timeRemainingNow = 10;
  console.log(mybracketOrder, " and currentLTP", currentLTP);
  var profitAcheived = 0;
  var targetProfit = Math.abs(
    (mybracketOrder.initialLimit - mybracketOrder.averagePrice) *
      Math.abs(mybracketOrder.quantity)
  );

  if (mybracketOrder.txnType == "BUY") {
    profitAcheived =
      (currentLTP - mybracketOrder.averagePrice) *
      Math.abs(mybracketOrder.quantity);
  } else {
    profitAcheived =
      (mybracketOrder.averagePrice - currentLTP) *
      Math.abs(mybracketOrder.quantity);
  }

  console.log(
    "profitAcheived : ",
    profitAcheived,
    " targetProfit: ",
    targetProfit
  );

  var profitRemainingPercent =
    (100 * (targetProfit - profitAcheived)) / targetProfit;
  /*
  var diffToLimitPrice =
    (100 * (mybracketOrder.currentLimit - currentLTP)) /
    mybracketOrder.currentLimit;
  console.log(
    "diffToLimitPrice is : ",
    diffToLimitPrice + " for " + mybracketOrder.symbol
  ); */

  console.log(
    "profitRemainingPercent is : ",
    profitRemainingPercent + " for " + mybracketOrder.symbol
  );

  //Depending on slot. Decrement the amount.
  if (profitRemainingPercent <= MIN_PROFIT_INTRADAY_VOLUME_LIMIT) {
    var newLimitPrice = 0,
      newStopLossPrice = 0;
    if (mybracketOrder.txnType == "SELL") {
      var newLimitPrice = mybracketOrder.currentLimit * (1 - 0.5 / 100);
      var newStopLossPrice = mybracketOrder.currentStopLoss * (1 + 0.5 / 100);
    } else {
      var newLimitPrice = mybracketOrder.currentLimit * (1 + 0.5 / 100);
      var newStopLossPrice = mybracketOrder.currentStopLoss * (1 - 0.5 / 100);
    }
    return {
      stopLossPrice: newStopLossPrice,
      limitPrice: newLimitPrice
    };
    //updateLimit
    //updateStopLoss
  } else {
    return {
      stopLossPrice: mybracketOrder.currentStopLoss,
      limitPrice: mybracketOrder.currentLimit
    };
  }
}

function noChangeInStopLoss(currentLTP, mybracketOrder) {
  return {
    stopLossPrice: mybracketOrder.currentStopLoss,
    limitPrice: mybracketOrder.currentLimit
  };
}

function quickCNC(currentLTP, mybracketOrder) {
  var diffToLimitPrice =
    (100 * (mybracketOrder.limitPrice - currentLTP)) /
    mybracketOrder.limitPrice;
  console.log("diffToLimitPrice is : ", diffToLimitPrice);
  //Depending on slot. Decrement the amount.
  if (diffToLimitPrice <= MIN_DIFF_QUICK_CNC_LIMIT) {
    var newLimitPrice = mybracketOrder.limitPrice * (1 + 1 / 100);
    var newStopLossPrice = mybracketOrder.limitPrice * (1 - 2 / 100);
    return {
      stopLossPrice: newStopLossPrice,
      limitPrice: newLimitPrice
    };
    //updateLimit
    //updateStopLoss
  } else {
    return {
      stopLossPrice: mybracketOrder.currentStopLoss,
      limitPrice: mybracketOrder.currentLimit
    };
  }
}

function greedyCNC(currentLTP, mybracketOrder) {
  var diffToLimitPrice =
    (100 * (mybracketOrder.limitPrice - currentLTP)) /
    mybracketOrder.limitPrice;
  console.log("diffToLimitPrice is : ", diffToLimitPrice);
  //Depending on slot. Decrement the amount.
  if (diffToLimitPrice <= MIN_DIFF_CNC_LIMIT) {
    var newLimitPrice = mybracketOrder.limitPrice * (1 + 3 / 100);
    var newStopLossPrice = mybracketOrder.limitPrice * (1 - 2 / 100);
    return {
      stopLossPrice: newStopLossPrice,
      limitPrice: newLimitPrice
    };
    //updateLimit
    //updateStopLoss
  } else {
    return {
      stopLossPrice: mybracketOrder.currentStopLoss,
      limitPrice: mybracketOrder.currentLimit
    };
  }
}

var STOCKS_TO_AVOID = ["VAKRANGEE"];
var MINIMUM_PROFIT_PERCENT = 5;
/*
{ tradingsymbol: 'TITAN',
   exchange: 'NSE',
   instrument_token: 897537,
   isin: 'INE280A01028',
   product: 'CNC',
   price: 0,
   quantity: 6,
   t1_quantity: 0,
   realised_quantity: 6,
   collateral_quantity: 0,
   collateral_type: '',
   average_price: 837.15,
   last_price: 818.9,
   close_price: 809.5,
   pnl: -109.5,
   day_change: 9.399999999999977,
   day_change_percentage: 1.161210623841875 },
   */
function createCNCBracketOrderFromPosition(holding, ltp) {
  var currentProftPercent =
    (100 * (holding.last_price - holding.average_price)) /
    holding.average_price;
  if (currentProftPercent < MINIMUM_PROFIT_PERCENT) {
    console.log(
      "IMPORTANT: Returning as profit is less than min percent ",
      holding.tradingsymbol
    );
    return;
  }
  console.log(
    "IMPORTANT: HAHA profit GREATER  than min percent ",
    holding.tradingsymbol
  );

  //check if their is a bracket order there, If already present return.

  var initialLimit = holding.last_price(1 + 3 / 100);
  var initialStopLoss = holding.last_price(1 - 2 / 100);
  //set
}

function updateStopLossAndLimitOnEvening(holding, bracketOrderDetails) {
  //If time
  var timeRemaining = -1;
  if (timeRemaining < 0 && bracketOrderDetails.status == "LIVE") {
    bracketOrderTrailingDao.updateBracketOrderStatus(
      bracketOrderDetails.bracketId,
      "LIVE_MARKET_CLOSE"
    );
  }
  //Update and set this the status to
}
//PENDING, LIVE, LIVE_MARKET_CLOSE, EXPIRED.

function updateStopLossAndLimitOnMorning(holding, bracketOrderDetails) {
  if (bracketOrderDetails.status != "LIVE_MARKET_CLOSE") return;

  var limitPrice = bracketOrderDetails.currentLimit;
  var stopLossPrice = bracketOrderDetails.currentLimit;
  if (holding.last_price > bracketOrderDetails.currentLimit) {
    limitPrice = holding.last_price(1 + 2 / 100);
    //Place a limit order.
  }

  if (holding.last_price < bracketOrderDetails.currentStopLoss) {
    stopLossPrice = holding.last_price(1 - 1 / 100);
  }

  placeStopLossOrderAndUpdate(
    holding,
    bracketOrderDetails,
    holding.last_price,
    stopLossPrice,
    stopLossPrice
  );

  placeLimitOrderAndUpdate(
    holding,
    bracketOrderDetails,
    holding.last_price,
    limitPrice
  );

  //After this normal flow will resume.

  //Not updating the stopLossFor Now.
}
//Next day the stock might well fall below the stoploss or above the limit.
//If it is above the limit. Recreate from LTP. incase it is allowed.

function createFirstStopLoss(holding) {
  var initialLimit = holding.last_price(1 + 4 / 100);
  var initialStopLoss = holding.last_price(1 - 3 / 100);

  bracketOrderTrailingDao.createBracketOrderWithStopLossForPosition(
    "abc" + position.tradingsymbol,
    null,
    holding.exchange,
    holding.product,
    "BUY",
    holding.tradingsymbol,
    holding.quantity,
    holding.average_price,
    "greedy_cnc",
    "greedy_cnc",
    null,
    null,
    stopLossNew,
    limitNew,
    0.05,
    holding.last_price,
    "PENDING",
    new Date().getTime()
  );
}
