const download = require("./download.js");
const niftyDao = require("./dao/niftyDao.js");
var moment = require("moment");
var NUM_DAYS = 1;
var BATCH_SIZE = 1;

function generateMinuteUrl(symbol) {
  var URL =
    /*
    "https://www.google.com/finance/getprices?i=60&p=" +
    NUM_DAYS +
    "d&f=d,o,h,l,c,v&df=cpct&q=" +
    symbol +
    "&x=NSE"; */
    "https://www.google.com/finance/getprices?auto=0&df=cpct&ei=Ef6XUYDfCqSTiAKEMg&f=d%2Cc%2Cv%2Ck%2Co%2Ch%2Cl&i=60&p=" +
    NUM_DAYS +
    "d&q=" +
    symbol +
    "&x=NSE";
  return URL;
}

const testFolder = "./data/minutelevel";
const fs = require("fs");
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

niftyDao.getNifty100(function(response) {
  //processFileOneByOne(response, 0);
  //response = [];
  //response.push("SUZLON");

  downloadFileOneByOne(response, 0, function() {
    console.log("Download of all file complete.");
    processFileOneByOne(response, 0);
  });
});

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
