var dbConn = require("./dbConn.js");

var con = dbConn.createConnection();

getNifty101(function(result) {
  console.log(result);
});

function getNifty101(callback) {
  executeGetNiftySymbolQuery("NIFTY_100", callback);
}

exports.getNifty50 = function(callback) {
  executeGetNiftySymbolQuery("NIFTY_50", callback);
};

exports.getNifty100 = function(callback) {
  executeGetNiftySymbolQuery("NIFTY_100", callback);
};

exports.getNifty500 = function(callback) {
  executeGetNiftySymbolQuery("NIFTY_500", callback);
};

exports.getNiftySmallCap100 = function(callback) {
  executeGetNiftySymbolQuery("NIFTY_SMALLCAP_100", callback);
};

exports.getNiftyMidCap100 = function(callback) {
  executeGetNiftySymbolQuery("NIFTY_MIDCAP_100", callback);
};

function executeGetNiftySymbolQuery(tableName, callback) {
  con.query("SELECT symbol FROM " + tableName, function(err, result, fields) {
    if (err) throw err;
    //console.log(result[0]);
    var symbols = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      symbols.push(row.symbol);
    });
    callback(symbols);
  });
}
