var dbConn = require("./dbConn.js");

//TRADE LIFE CYCLE

//BUY -> SELL/NEXTDAY   NEXTDAY->SELL

//End of day job responsibility to move everything to Sell if they are not converted.

var con = dbConn.createConnection();

exports.updateBuyRequest = function(
  symbol,
  quantity,
  buyPrice,
  day,
  date,
  stopLoss
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

var SELECT_OPEN_TRADE_SYMBOL_QUERY =
  "SELECT * FROM DAILY_TRADE WHERE STATUS = 'BUY' and symbol = ?";

var SELECT_OPEN_TRADE_QUERY = "SELECT * FROM DAILY_TRADE WHERE STATUS = 'BUY'";

var EXPIRE_TRADE_QUERY =
  "UPDATE DAILY_TRADE SET STATUS = 'EXPIRED' WHERE TRADEID = ?";

var UPDATE_SELL_QUERY =
  "UPDATE DAILY_TRADE SET STATUS = ?, SELLORDERID = ?, SELLPRICE = ?, SELLTIMESTAMP = ?, SELLSTRATEGY = ?";

var INSERT_TRADE_QUERY =
  "INSERT INTO DAILY_TRADE" +
  "(TRADEID, TXNTYPE, SYMBOL, SERIES, STRATEGY, STRATEGYCONTEXT ,QUANTITY,BUYPRICE,STOPLOSS, LIMITPRICE,DAY, TIMESTAMP, BUYORDERID, STATUS)" +
  " VALUES (?,?,?,?,?,?,?,?, ? , ?, ?, ?,?,?)";

exports.getBuyRequest = function(symbol, dateStart, dateEnd) {};
exports.updateBuyComplete = function() {};
