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

function getClosingPrices(symbol, numOfPoint) {}

/**
Write multiple tick records to DB.
**/
exports.createDailyStockQuoteRecord = function(records) {
  con.query(INSERT_QUERY2, records, function(err) {
    if (err) {
      console.log(err);
    }
    //console.log("1 record inserted");

    //con.end();
  });
};

exports.createMinuteStockQuoteRecord = function(records) {
  //var con1 = dbConn.createConnection();
  var modifyParams = records.slice(-5);
  var params = records.concat(modifyParams);

  con.query(INSERT_MINUTE_QUERY, [records], function(err) {
    //console.log("Completed");
    if (err) {
      console.log(err);
    }
    //con1.destroy();
    //console.log("1 record inserted");

    //con.end();
  });
};

var GET_DAILY_CLOSING_POS_QUERY =
  "SELECT CLOSE FROM daily_quotes WHERE SYMBOL = ? ORDER BY  STR_TO_DATE('01-DEC-2017','%d-%m-%Y');" +
  "(SYMBOL, DAY, DATEEPOCH, minuteOffset ,OPEN,HIGH,LOW,CLOSE)" +
  " VALUES (?,?,?,?,?,?,?,?)";

var INSERT_MINUTE_QUERY =
  "INSERT INTO STOCK_MINUTE_DATA" +
  "(SYMBOL, DAY, DATEEPOCH, minuteOffset ,OPEN,HIGH,LOW,CLOSE, VOLUME)" +
  " VALUES ? " +
  " ON DUPLICATE KEY " +
  " UPDATE OPEN = VALUES(OPEN), HIGH = VALUES(HIGH), LOW=VALUES(LOW), CLOSE = VALUES(CLOSE), VOLUME = VALUES(VOLUME) ";

INSERT_QUERY2 =
  "INSERT INTO DAILY_QUOTES" +
  "(SYMBOL,SERIES,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN)" +
  " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";

INSERT_QUERY =
  "INSERT INTO DAILY_QUOTES" +
  "(SYMBOL,SERIES,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN)" +
  " VALUES ?";

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
