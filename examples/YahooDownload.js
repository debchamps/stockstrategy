const download = require("./download.js");
const niftyDao = require("./dao/niftyDao.js");
const stockDataDao = require("./dao/stockDataDao.js");
var moment = require("moment");
var NUM_DAYS = 7;
var BATCH_SIZE = 1;
var request = require("request");

const https = require("https");
/*
var request = https.get(generateMinuteUrl("VAKRANGEE"), function(response) {
  console.log("XXXXXXX", response);
});
*/

function generateMinuteUrl(symbol) {
  var URL =
    "https://query1.finance.yahoo.com/v8/finance/chart/" +
    symbol +
    ".NS?range=" +
    NUM_DAYS +
    "d&includePrePost=false&interval=1m&corsDomain=finance.yahoo.com&.tsrc=finance";
  return URL;
}

const testFolder = "./data/minutelevel";
const fs = require("fs");

function extractSymbol(response) {
  return response.chart.result[0].meta.symbol
    .substring(0, response.chart.result[0].meta.symbol.length - 3)
    .trim();
}

function extractTradingWindows(response) {
  return response.chart.result[0].meta.tradingPeriods;
}

function extractTimePeriods(response) {
  return response.chart.result[0].timestamp;
}

function extractHighs(response) {
  //console.log(response.chart.result[0].indicators.quote[0].high);
  var highs = response.chart.result[0].indicators.quote[0].high;
  return fillNullValues(highs, 0);
}

function fillNullValues(vals, passNumber) {
  var passRequired = false;
  if (vals === undefined || vals.length == 0) return vals;
  if (vals[0] == null && vals[1] != null) {
    passRequired = true;
    vals[0] = vals[1];
  }

  if (vals[vals.length - 1] == null && vals[vals.length - 2] != null) {
    passRequired = true;
    vals[vals.length - 1] = vals[vals.length - 2];
  }

  for (var i = 1; i < vals.length - 1; i++) {
    if (vals[i] == null) {
      if (vals[i + 1] == null && vals[i - 1] == null) {
        passRequired = true;
        //WIll be handled in next pass.
      } else if (vals[i + 1] == null) {
        vals[i] = vals[i - 1];
      } else if (vals[i - 1] == null) {
        vals[i] = vals[i + 1];
      } else {
        vals[i] = (vals[i + 1] + vals[i - 1]) / 2;
      }
    }
  }
  if (passRequired) {
    return fillNullValues(vals, passNumber + 1);
  } else {
    return vals;
  }
}

function extractLows(response) {
  var lows = response.chart.result[0].indicators.quote[0].low;
  return fillNullValues(lows, 0);
}

function extractOpens(response) {
  var opens = response.chart.result[0].indicators.quote[0].open;
  return fillNullValues(opens, 0);
}

function extractCloses(response) {
  var closes = response.chart.result[0].indicators.quote[0].close;
  return fillNullValues(closes, 0);
}

function extractVolumes(response) {
  var volumes = response.chart.result[0].indicators.quote[0].volume;
  return fillNullValues(volumes, 0);
}

function extractDay(time) {
  return moment(time).format("DD-MMM-YYYY");
}

function getOffSet(tradingWindows, tradeTime) {
  for (var i = 0; i < tradingWindows.length; i++) {
    if (
      tradingWindows[i][0].start <= tradeTime &&
      tradeTime <= tradingWindows[i][0].end
    ) {
      return (tradeTime - tradingWindows[i][0].start) / 60;
    }
  }
}
/*
"INSERT INTO STOCK_MINUTE_DATA" +
"(SYMBOL, DAY, DATEEPOCH, minuteOffset ,OPEN,HIGH,LOW,CLOSE)" +
" VALUES (?,?,?,?,?,?,?,?)"; */

function processResponse(response) {
  var opens = extractOpens(response);
  var lows = extractLows(response);
  var highs = extractHighs(response);
  var closes = extractCloses(response);

  var volumes = extractVolumes(response);
  var symbol = extractSymbol(response);

  var records = [];
  var tradingWindows = extractTradingWindows(response);
  var timeStamps = extractTimePeriods(response);
  var highs = extractHighs(response);
  if (timeStamps === undefined || timeStamps.length == 0) return;
  //console.log(tradingWindows);
  for (var i = 0; i < timeStamps.length; i++) {
    var record = [
      symbol.trim(),
      extractDay(timeStamps[i] * 1000).trim(),
      timeStamps[i],
      getOffSet(tradingWindows, timeStamps[i]),
      opens[i],
      highs[i],
      lows[i],
      closes[i],
      volumes[i]
    ];
    records.push(record);
    //console.log(record);
  }
  stockDataDao.createMinuteStockQuoteRecord(records);
  console.log("Completed for ", symbol);
}
/*
fs.readdir(testFolder, (err, files) => {
  files.forEach(file => {
    console.log(file);
  });

  processFileOneByOne2(files, 0);
});


/*
  Intraday if LTP < Avaerage - SD AND low > LTP BUY
  Buy if price drops further.
*/
/*
niftyDao.getNifty500(function(response) {
  for (var i = 0; i < response.length; i++) {
    request(generateMinuteUrl(response[i]), function(error, response, body) {
      if (!error && response.statusCode == 200) {
        processResponse(JSON.parse(body));
        //console.log(body);
      }
    });
  }
});*/

module.exports.loadData = function() {
  niftyDao.getNifty500(function(response) {
    for (var i = 0; i < response.length; i++) {
      request(generateMinuteUrl(response[i]), function(error, response, body) {
        if (!error && response.statusCode == 200) {
          processResponse(JSON.parse(body));
          //console.log(body);
        }
      });
    }
  });
};

module.exports.fetchData = function() {
  niftyDao.getNifty100(function(response) {
    //processFileOneByOne(response, 0);
    //response = [];
    //response.push("SUZLON");
    downloadFileOneByOne(response, 0, function() {
      console.log("Download of all file complete.");
      processFileOneByOne(response, 0);
    });
  });
};

function downloadFileOneByOne(response, startIndex, callback) {
  if (startIndex >= response.length) {
    callback();
    return;
  }
  for (var i = 0; i < Math.min(BATCH_SIZE, response.length); i++) {
    var symbol = response[startIndex + i];
    var day = moment().format("MMDDYYYY");
    var filePath = "data/minutelevel/" + symbol + day + ".csv";
    console.log(
      "Downloading file for symbol ",
      symbol,
      generateMinuteUrl(symbol)
    );
    if (i == BATCH_SIZE - 1) {
      download.downloadFile(filePath, generateMinuteUrl(symbol), function() {
        //console.log("Download complete for symbol ", symbol);
        downloadFileOneByOne(response, startIndex + BATCH_SIZE, callback);
      });
    } else {
      download.downloadFile(filePath, generateMinuteUrl(symbol), function() {
        //console.log("Download complete for symbol ", symbol);
      });
    }
  }
}

function processFileOneByOne(response, startIndex) {
  if (startIndex >= response.length) return;

  for (var i = 0; i < Math.min(BATCH_SIZE, response.length); i++) {
    var symbol = response[startIndex + i];
    var day = moment().format("MMDDYYYY");
    var filePath = "data/minutelevel/" + symbol + day + ".csv";
    console.log("Starting process for symbol ", symbol);
    if (i == BATCH_SIZE - 1) {
      download.processFile(
        symbol,
        filePath,
        generateMinuteUrl(symbol),
        function() {
          console.log("Completed process for symbol" + symbol);
          processFileOneByOne(response, startIndex + BATCH_SIZE);
        }
      );
    } else {
      download.processFile(
        symbol,
        filePath,
        generateMinuteUrl(symbol),
        function() {
          console.log("Completed process for symbol" + symbol);
        }
      );
    }
  }
}

function processFileOneByOne2(files, startIndex) {
  //console.log("processFileOneByOne2", files);
  if (startIndex >= files.length) return;
  var file = files[startIndex];
  console.log("Processing file ", file);
  if (!file) return;
  if (file.length < 12) {
    processFileOneByOne2(files, startIndex + 1);
    return;
  }
  //var day = moment().format("MMDDYYYY");
  var filePath = "data/minutelevel/" + file;
  var symbol = file.substr(0, file.length - 12);
  console.log("Starting process for file ", file, " symbol ", symbol);
  download.processFile(symbol, filePath, generateMinuteUrl(symbol), function() {
    console.log("Completed process for symbol" + symbol);
    setTimeout(function() {
      processFileOneByOne2(files, startIndex + 1);
    }, 2000);
  });
}

function processLater(symbol, timeout) {
  setTimeout(function() {
    download.processFile(
      symbol,
      "data/minutelevel/" + symbol + ".csv",
      generateMinuteUrl(symbol),
      function() {
        console.log("Completed download for symbol" + symbol);
      }
    );
  }, timeout);
}
