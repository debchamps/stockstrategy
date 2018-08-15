var dbConn = require("./dbConn.js");

var con = dbConn.createConnection();
exports.getInstrumentTokens = function(symbols) {};

exports.loadInstrumentTokens = function(callback) {
  con.query(LOAD_INSTRUMENT_QUERY, function(err, result, fields) {
    if (err) throw err;
    //console.log(result[0]);
    var responses = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      responses.push({
        symbol: row.symbol,
        instrumentToken: row.instrument_token,
        exchange: row.exchange
      });
    });
    callback(responses);
  });
};

var LOAD_INSTRUMENT_QUERY =
  "SELECT * FROM INSTRUMENT_TOKENS WHERE EXCHANGE = 'NSE' AND SEGMENT = 'NSE'";
