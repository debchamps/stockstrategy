var mysql = require("mysql");
var moment = require("moment");
var dbConn = require("./dbConn.js");

var con = dbConn.createConnection();

exports.createTable = function() {
  con.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
    con.query(CREATE_QUOTES_QUERY, function(err, result) {
      if (err) throw err;
      console.log("Created table successfully");
    });
  });
};

/**
Write multiple tick records to DB.
**/
exports.createTickRecord = function(ticks) {
  rowList = [];
  for (var i = 0; i < ticks.length; i++) {
    rowList.push(tickToRow(ticks[i]));
  }

  con.query(INSERT_QUERY, [rowList], function(err) {
    if (err) {
      console.log(err);
    }
    console.log("1 record inserted");

    //con.end();
  });
};

function tickToRow(tick) {
  row = [];

  var timeEpoch = new Date(tick.timestamp).getTime();
  var utc = 1502212611;
  var timeStr = moment
    .unix(timeEpoch / 1000)
    .utc()
    .format("YYYY-MM-DD HH:mm:ss");

  row.push(timeEpoch);
  row.push(tick.instrument_token);
  row.push(tick.instrument_token);
  row.push(timeStr);

  row.push(tick.last_price);
  row.push(tick.last_quantity);
  row.push(tick.average_price);
  row.push(tick.volume);
  row.push(tick.buy_quantity);
  row.push(tick.sell_quantity);
  row.push(tick.ohlc.open);
  row.push(tick.ohlc.high);
  row.push(tick.ohlc.low);
  row.push(tick.ohlc.close);
  console.log(row);
  return row;
}

INSERT_QUERY =
  "INSERT INTO QUOTES(Time, InstrumentToken, TradeSymbol, TimeIST, LastTradedPrice, LastTradedQty, AvgTradedPrice, Volume ,BuyQty, SellQty, OpenPrice, HighPrice, LowPrice, ClosePrice) VALUES ?";

CREATE_QUOTES_QUERY =
  "CREATE TABLE " +
  "QUOTES" +
  " " +
  "(Time BIGINT NOT NULL, " +
  " InstrumentToken varchar(32) NOT NULL, " +
  " TradeSymbol varchar(32) , " +
  " TimeIST varchar(32), " +
  " LastTradedPrice DECIMAL(20,4) NOT NULL, " +
  " LastTradedQty BIGINT NOT NULL, " +
  " AvgTradedPrice DECIMAL(20,4) NOT NULL, " +
  " Volume BIGINT NOT NULL, " +
  " BuyQty BIGINT NOT NULL, " +
  " SellQty BIGINT NOT NULL, " +
  " OpenPrice DECIMAL(20,4) NOT NULL, " +
  " HighPrice DECIMAL(20,4) NOT NULL, " +
  " LowPrice DECIMAL(20,4) NOT NULL, " +
  " ClosePrice DECIMAL(20,4) NOT NULL, " +
  " PRIMARY KEY (InstrumentToken, Time)) " +
  " ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;";
