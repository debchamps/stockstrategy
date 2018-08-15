var dbConn = require("./dbConn.js");

//TRADE LIFE CYCLE

//BUY -> SELL/NEXTDAY   NEXTDAY->SELL

//End of day job responsibility to move everything to Sell if they are not converted.

var con = dbConn.createConnection();
/*
    SCHEMA
    var CREATE_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_QUERY =
      "INSERT INTO BRACKET_ORDER_TRAILING" +
      "(BRACKET_ID, ORDER_ID, EXCHANGE, PRODUCT, TXN_TYPE ,SYMBOL,QUANTITY, AVERAGE_PRICE,
      STOPLOSS_STRATEGY,LIMIT_STRATEGY, STOPLOSS_ORDER_ID, LIMIT_ORDER_ID, CURRENT_LIMIT,
      CURRENT_STOPLOSS, TRAILING_STOPLOSS, LAST_EVALUATED_LTP, STATUS, CREATION_TIME)" +
      " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

      CREATE TABLE BRACKET_ORDER_TRAILING (
      BRACKET_ID varchar(50),
      ORDER_ID varchar(32),
      EXCHANGE varchar(10),
      PRODUCT varchar(10),  #MIS/CNC
      TXN_TYPE VARCHAR(10), #SELL/BUY
      SYMBOL varchar(32),
      QUANTITY DECIMAL(20),
      AVERAGE_PRICE DECIMAL(20,4),
      STOPLOSS_STRATEGY VARCHAR(10),
      LIMIT_STRATEGY VARCHAR(10),
      STOPLOSS_ORDER_ID varchar(32),
      LIMIT_ORDER_ID varchar(32),
      CURRENT_STOPLOSS DECIMAL(20,4),
      CURRENT_LIMIT DECIMAL(20,4),
      TRAILING_STOPLOSS DECIMAL(20,4),
      LAST_EVALUATED_LTP DECIMAL(20,4),
      STATUS VARCHAR(10),
      CREATION_TIME DECIMAL(20),
      PRIMARY KEY (BRACKET_ID))
       ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
       */

exports.getBracketOrderWithStatus = function(status, callback) {
  var queryParam = [status];

  con.query(GET_BRACKET_ORDER_BY_STATUS, queryParam, function(
    err,
    result,
    fields
  ) {
    if (err) throw err;
    //console.log(result[0]);
    var bracketOrders = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      bracketOrders.push(transformRow(row));
    });
    callback(bracketOrders);
  });
};

exports.getBracketOrderWithStopLoss = function(
  exchange,
  product,
  symbol,
  callback
) {
  var queryParam = [exchange, product, symbol];

  con.query(
    SELECT_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_QUERY,
    queryParam,
    function(err, result, fields) {
      if (err) throw err;
      //console.log(result[0]);
      var bracketOrders = [];
      Object.keys(result).forEach(function(key) {
        var row = result[key];
        bracketOrders.push(transformRow(row));
      });
      callback(bracketOrders);
    }
  );

  con.query(
    SELECT_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_QUERY,
    queryParam,
    function(err) {
      console.log("Completed");
      if (err) {
        console.log(err);
      }
    }
  );
};
exports.createBracketOrderWithStopLossForPosition = function(
  bracketId,
  orderId,
  exchange,
  product,
  txnType,
  symbol,
  quantity,
  averagePrice,
  stopLossStrategy,
  limitStrategy,
  stoplossOrderId,
  limitOrderId,
  initialStopLoss,
  initalLimit,
  trailingStoploss,
  lastEvaluatedLtp,
  status,
  date,
  profitPercent,
  stopLossPercent
) {
  var record = [
    bracketId,
    orderId,
    exchange,
    product,
    txnType,
    symbol,
    quantity,
    averagePrice,
    stopLossStrategy,
    limitStrategy,
    stoplossOrderId,
    limitOrderId,
    initalLimit,
    initialStopLoss,
    trailingStoploss,
    lastEvaluatedLtp,
    status,
    date,
    profitPercent,
    stopLossPercent
  ];

  con.query(
    CREATE_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_QUERY,
    record,
    function(err) {
      if (err) {
        console.log(err);
      }
      console.log(
        "Created bracket order with trailing stoploss and limit",
        record
      );
    }
  );
};

function createBracketOrderWithTrailingStopLossAndLimitForOrder(
  bracketId,
  exchange,
  product,
  orderId,
  txnType,
  symbol,
  quantity,
  stopLossStrategy,
  limitStrategy
) {
  var record = [
    bracketId,
    exchange,
    product,
    orderId,
    txnType,
    symbol,
    quantity,
    stopLossStrategy,
    limitStrategy,
    "CREATED",
    new Date().getTime()
  ];

  con.query(
    CREATE_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_FOR_ORDER_QUERY,
    record,
    function(err) {
      if (err) {
        console.log(err);
      }
      console.log(
        "Created bracket order with trailing stoploss and limit",
        record
      );
    }
  );
}

/**
UPDATES THE STOPLOSS AND LIMIT OF THE BRACKET_ORDER.
*/
module.exports.updateLimitAndStoploss = function(
  bracketId,
  lastEvaluatedLtp,
  currentStopLoss,
  currentLimit,
  stoplossOrderId,
  limitOrderId
) {
  var record = [
    lastEvaluatedLtp,
    currentStopLoss,
    currentLimit,
    stoplossOrderId,
    limitOrderId,
    "LIVE",
    bracketId
  ];
  console.log("IMPORTANT In updateLimitAndStoploss");
  con.query(UPDATE_STOPLOSS_AND_LIMIT_QUERY, record, function(err) {
    if (err) {
      console.log(err);
    }
    console.log("IMPORTANT : Updated stoploss and limit", record);
  });
};

module.exports.updateLimit = function(
  bracketId,
  lastEvaluatedLtp,
  currentLimit,
  limitOrderId
) {
  var record = [
    lastEvaluatedLtp,
    currentLimit,
    limitOrderId,
    "LIVE",
    bracketId
  ];
  console.log("IMPORTANT In updateLimit");
  con.query(UPDATE_LIMIT_QUERY, record, function(err) {
    if (err) {
      console.log(err);
    }
    console.log("IMPORTANT : Updated limit", record);
  });
};

module.exports.updateStoploss = function(
  bracketId,
  lastEvaluatedLtp,
  currentStopLoss,
  stopLossOrderId
) {
  var record = [
    lastEvaluatedLtp,
    currentStopLoss,
    stopLossOrderId,
    "LIVE",
    bracketId
  ];
  console.log("IMPORTANT In updateLimitAndStoploss");
  con.query(UPDATE_STOPLOSS_QUERY, record, function(err) {
    if (err) {
      console.log(err);
    }
    console.log("IMPORTANT : Updated stoploss", record);
  });
};

module.exports.expireBracketOrder = function(bracketId) {
  var record = ["EXPIRED", bracketId];
  con.query(UPDATE_BRACKET_ORDER_STATUS, record, function(err) {
    if (err) {
      console.log(err);
    }
    console.log("Expiring bracket order ", record);
  });
};

module.exports.updateBracketOrderStatus = function(bracketId, newStatus) {
  var record = [newStatus, bracketId];
  con.query(UPDATE_BRACKET_ORDER_STATUS, record, function(err) {
    if (err) {
      console.log(err);
    }
    console.log("Updated bracket order: ", record);
  });
};

exports.createBracketOrderWithStopLoss = function(
  bracketId,
  exchange,
  product,
  orderId,
  txnType,
  symbol,
  quantity,
  stopLossStrategy,
  limitStrategy,
  //  stoplossOrderId,
  //  limitOrderId,
  //  currentStopLoss,
  //  currentLimit,
  //  trailingStoplossAmount,
  //lastEvaluatedLtp,
  status,
  date,
  creationTime
) {};

function getOpenTrades(callback) {
  con.query(SELECT_OPEN_TRADE_QUERY, records, function(err) {
    console.log("Completed");
    if (err) {
      console.log(err);
    }
  });
}

function getOpenTradesBySymbol(symbol) {}

function expireTrade(tradeId) {}

exports.updateSell = function(
  sellStrategy,
  sellOrderId,
  sellPrice,
  sellTimeStamp
) {
  con.query(
    UPDATE_SELL_QUERY,
    ["SOLD", sellOrderId, sellPrice, sellTimeStamp, sellStrategy],
    function(err) {
      if (err) {
        console.log(err);
      }
      console.log("1 record inserted");

      //con.end();
    }
  );
};

function transformRow(row) {
  return {
    bracketId: row.BRACKET_ID,
    orderId: row.ORDER_ID,
    exchange: row.EXCHANGE,
    product: row.PRODUCT,
    txnType: row.TXN_TYPE,
    symbol: row.SYMBOL,
    quantity: row.QUANTITY,
    averagePrice: row.AVERAGE_PRICE,
    stoplossStrategy: row.STOPLOSS_STRATEGY,
    limitStrategy: row.LIMIT_STRATEGY,
    stopLossOrderId: row.STOPLOSS_ORDER_ID,
    limitOrderId: row.LIMIT_ORDER_ID,
    initialStopLoss: row.INITIAL_STOPLOSS,
    initialLimit: row.INITIAL_LIMIT,
    currentStopLoss: row.CURRENT_STOPLOSS,
    currentLimit: row.CURRENT_LIMIT,
    trailingStopLoss: row.TRAILING_STOPLOSS,
    lastEvaluatedLTP: row.LAST_EVALUATED_LTP,
    status: row.STATUS,
    creationTime: row.CREATION_TIME,
    profitPercent: row.PROFIT_PERCENT,
    stopLossPercent: row.STOPLOSS_PERCENT
  };
}
exports.createBuyRequest = function(records) {
  con.query(INSERT_TRADE_QUERY, records, function(err) {
    console.log("Completed");
    if (err) {
      console.log(err);
    }
    console.log("1 record inserted");

    //con.end();
  });
};

exports.updateBracketOrderOnOrderUpdate = function(
  orderId,
  quantity,
  averagePrice,
  limitNew,
  stopLossNew,
  trailingStopLoss,
  lastEvaluatedLtp,
  status
) {
  var record = [
    quantity,
    averagePrice,
    limitNew,
    stopLossNew,
    trailingStopLoss,
    lastEvaluatedLtp,
    status,
    orderId
  ];
  con.query(UPDATE_BRACKET_ORDER_FOR_ORDER_UPDATE, record, function(err) {
    if (err) {
      console.log(err);
    }
    console.log("Expiring bracket order ", record);
  });
};

var UPDATE_BRACKET_ORDER_FOR_ORDER_UPDATE =
  "UPDATE BRACKET_ORDER_TRAILING " +
  " SET QUANTITY = ? , AVERAGE_PRICE = ? , INITIAL_LIMIT = ? , INITIAL_STOPLOSS = ?, " +
  "TRAILING_STOPLOSS = ?, LAST_EVALUATED_LTP = ?, STATUS = ? " +
  "WHERE ORDER_ID = ?";

var GET_BRACKET_ORDER_BY_STATUS =
  "SELECT * FROM BRACKET_ORDER_TRAILING WHERE STATUS = ?";

var SELECT_OPEN_TRADE_SYMBOL_QUERY =
  "SELECT * FROM DAILY_TRADE WHERE STATUS = 'BUY' and symbol = ?";

var SELECT_OPEN_TRADE_QUERY = "SELECT * FROM DAILY_TRADE WHERE STATUS = 'BUY'";

var EXPIRE_TRADE_QUERY =
  "UPDATE DAILY_TRADE SET STATUS = 'EXPIRED' WHERE TRADEID = ?";

var SELECT_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_QUERY =
  "SELECT * FROM BRACKET_ORDER_TRAILING " +
  " WHERE EXCHANGE = ? and PRODUCT = ? and  SYMBOL = ? AND STATUS <> 'EXPIRED'";

var CREATE_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_QUERY =
  "INSERT INTO BRACKET_ORDER_TRAILING" +
  "(BRACKET_ID, ORDER_ID, EXCHANGE, PRODUCT, TXN_TYPE ,SYMBOL,QUANTITY, AVERAGE_PRICE," +
  "STOPLOSS_STRATEGY,LIMIT_STRATEGY, STOPLOSS_ORDER_ID, LIMIT_ORDER_ID, INITIAL_LIMIT," +
  "INITIAL_STOPLOSS, TRAILING_STOPLOSS, LAST_EVALUATED_LTP, STATUS, CREATION_TIME, PROFIT_PERCENT, STOPLOSS_PERCENT)" +
  " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?)";

var CREATE_BRACKET_ORDER_WITH_TRAILING_STOPLOSS_LIMIT_FOR_ORDER_QUERY =
  "INSERT INTO BRACKET_ORDER_TRAILING" +
  "(BRACKET_ID, EXCHANGE, PRODUCT, ORDER_ID, TXN_TYPE ,SYMBOL,QUANTITY,STOPLOSS_STRATEGY,LIMIT_STRATEGY, STATUS, CREATION_TIME)" +
  " VALUES (?,?,?,?,?,?,?,?,?,?,?)";

var UPDATE_LIMIT_ORDER_ID_QUERY =
  "UPDATE BRACKET_ORDER_TRAILING SET LIMIT_ORDER_ID = ?, CURRENT_LIMIT = ? WHERE BRACKET_ID = ?";

var UPDATE_STOPLOSS_ORDER_ID_QUERY =
  "UPDATE BRACKET_ORDER_TRAILING SET STOPLOSS_ORDER_ID = ?, CURRENT_STOPLOSS = ? WHERE BRACKET_ID = ?";

var UPDATE_STOPLOSS_QUERY =
  "UPDATE BRACKET_ORDER_TRAILING SET LAST_EVALUATED_LTP = COALESCE(?, LAST_EVALUATED_LTP), " +
  "  CURRENT_STOPLOSS = COALESCE(?,CURRENT_STOPLOSS) , " +
  "  STOPLOSS_ORDER_ID = COALESCE(?, STOPLOSS_ORDER_ID), " +
  "  STATUS = ? " +
  " WHERE BRACKET_ID = ?";

var UPDATE_LIMIT_QUERY =
  "UPDATE BRACKET_ORDER_TRAILING SET LAST_EVALUATED_LTP = COALESCE(?, LAST_EVALUATED_LTP), " +
  "  CURRENT_LIMIT = COALESCE(?,CURRENT_LIMIT) , " +
  "  LIMIT_ORDER_ID = COALESCE(?, LIMIT_ORDER_ID)," +
  "  STATUS = ? " +
  " WHERE BRACKET_ID = ?";

var UPDATE_STOPLOSS_AND_LIMIT_QUERY =
  "UPDATE BRACKET_ORDER_TRAILING SET LAST_EVALUATED_LTP = COALESCE(?, LAST_EVALUATED_LTP), " +
  "  CURRENT_LIMIT = COALESCE(?, CURRENT_LIMIT), CURRENT_STOPLOSS = COALESCE(?,CURRENT_STOPLOSS) , " +
  "  STOPLOSS_ORDER_ID = COALESCE(?, STOPLOSS_ORDER_ID), LIMIT_ORDER_ID = COALESCE(?,LIMIT_ORDER_ID), " +
  "  STATUS = ? " +
  " WHERE BRACKET_ID = ?";
var UPDATE_BRACKET_ORDER_STATUS =
  "UPDATE BRACKET_ORDER_TRAILING SET STATUS = ? WHERE BRACKET_ID = ?";

var INSERT_TRADE_QUERY =
  "INSERT INTO DAILY_TRADE" +
  "(TRADEID, SYMBOL, SERIES, STRATEGY, STRATEGYCONTEXT ,QUANTITY,BUYPRICE,STOPLOSS,DAY, TIMESTAMP, BUYORDERID, STATUS)" +
  " VALUES (?,?,?,?,?,?,?,?, ? , ?, ?, ?)";

exports.getBuyRequest = function(symbol, dateStart, dateEnd) {};
exports.updateBuyComplete = function() {};
