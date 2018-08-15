var fs = require("fs");
var CsvReadableStream = require("csv-reader");
const instrumentTokenDao = require("./dao/instrumentTokenDao.js");

var INSTRUMENT_TO_SYMBOL_MAPPING = {
  NSE: {},
  BSE: {}
};
var SYMBOL_TO_INSTRUMENT_MAPPING = {
  NSE: {},
  BSE: {}
};

module.exports.getInstrumentByTradingSymbol = function(exchange, symbol) {
  return SYMBOL_TO_INSTRUMENT_MAPPING[exchange][symbol];
};

module.exports.getTradingSymbolByInstrument = function(exchange, instrumentId) {
  return INSTRUMENT_TO_SYMBOL_MAPPING[exchange][instrumentId];
};

loadInstrumentMapping();

function load() {}
function loadSymbolInstrumentTokenMapFromDB() {
  instrumentTokenDao.loadInstrumentTokens(function(responses) {
    for (var i = 0; i < responses.length; i++) {
      INSTRUMENT_TO_SYMBOL_MAPPING[responses[i].exchange][
        responses[i].instrumentToken
      ] =
        responses[i].symbol;

      SYMBOL_TO_INSTRUMENT_MAPPING[responses[i].exchange][responses[i].symbol] =
        responses[i].instrumentToken;
    }
  });
}

function loadInstrumentMapping() {
  var inputStream = fs.createReadStream(
    "../../data/instrument_tokens.csv",
    "utf8"
  );

  inputStream
    .pipe(
      CsvReadableStream({
        parseNumbers: true,
        parseBooleans: true,
        trim: true,
        skipHeader: true
      })
    )
    .on("data", function(row) {
      //console.log(row);
      var exchange = row[5];
      //console.log(exchange);
      if (exchange != "NSE" && exchange != "BSE") return;
      //console.log(row);
      INSTRUMENT_TO_SYMBOL_MAPPING[exchange][row[0]] = row[2];
      SYMBOL_TO_INSTRUMENT_MAPPING[exchange][row[2]] = row[0];
      //console.log("A row arrived: ", row);
    })
    .on("end", function(data) {
      console.log("No more rows! size :: ");
    });
}
