var CsvReadableStream = require("csv-reader");
var fs = require("fs");

var allData = {};
loadInstrumentMapping();
function loadInstrumentMapping() {
  var inputStream = fs.createReadStream("./one_year_data.csv", "utf8");

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
      //SYMBOL,SERIES,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN,increaseDaily,increase,Max Increase,Max Decrease

      //console.log(row);
      allData[row[0]] = allData[row[0]] || [];

      allData[row[0]].push({
        symbol: row[0],
        open: row[2],
        high: row[3],
        close: row[4],
        tradeQuantity: row[7],
        tradeValue: row[8],
        timestamp: row[9]
      });

      //console.log(row);
      //console.log("A row arrived: ", row);
    })
    .on("end", function(data) {
      executeAnalysis(allData);
      //console.log("No more rows! size :: ", INSTRUMENT_TO_SYMBOL_MAPPING);
    });
}

function executeAnalysis(allData) {
  console.log(allData["SBIN"]);
}

function getIntradayVolatility(data) {
  highPercent = ((data.high - data.open) / data.open) * 100;
  lowPercent = ((data.open - data.low) / data.open) * 100;
}
