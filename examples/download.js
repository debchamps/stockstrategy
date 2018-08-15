var https = require("https");
var fs = require("fs");
var request = require("request");
const moment = require("moment");
const stockDataDao = require("./dao/stockDataDao.js");

var file = fs.createWriteStream("test.dat");

const monthNames = [
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MAY",
  "JUN",
  "JUL",
  "AUG",
  "SEP",
  "OCT",
  "NOV",
  "DEC"
];

var fs = require("fs");
var unzipper = require("unzipper");
/*
var zipFileName =
  "https://nseindia.com/content/historical/EQUITIES/2018/JUN/cm20JUN2018bhav.csv.zip";
request(zipFileName).pipe(
  fs.createWriteStream("abc.zip").on("close", function() {
    unzipFile("abc.zip", "abc.csv");
  })
);
*/

function dumper() {
  var d2 = new Date();

  d2.setDate(d2.getDate());

  for (var i = 0; i < 7; i++) {
    d2.setDate(d2.getDate() - 1);
    dumpOHLCRecords(d2);
    // d.setDate(d.getDate() - i * 7);
  }
}

//dumpOHLCRecords(date);
function dumpOHLCRecords(d) {
  var zipFileLocation = getBhabCopyZipFileName(d);
  var unizippedFileLocation = getBhabCopyUnzippedFileName(d);
  console.log(getBhabCopyFileURL(d));
  request(getBhabCopyFileURL(d)).pipe(
    fs.createWriteStream(zipFileLocation).on("close", function() {
      unzipFile(zipFileLocation, unizippedFileLocation);
      processBhabCopyFile(unizippedFileLocation);
    })
  );
}

function processBhabCopyFile(fileName) {
  var data = [];
  fs.readFile(fileName, "utf8", function(error, body) {
    if (error) {
      return;
    }
    console.log("body : ", body, "error : ", error);
    if (!body.includes("\n")) return;
    var rows = body.split("\n");
    for (var i = 1; i < rows.length; i++) {
      data = rows[i].split(",");
      vals = [];
      for (var j = 0; j < data.length; j++) {
        vals.push(data[j].replace("'", ""));
      }
      console.log(vals);
      if (data.length > 2) {
        //console.log(rows[i].split(","));
        stockDataDao.createDailyStockQuoteRecord(vals);
      }
    }

    //console.log(response);
    //console.log(body);
  });
}

/*
for (var i = 0; i < 365; i++) {
  var d = new Date();
  d.setDate(d.getDate() - i);
  downloadFile(zipFileName, zipFileName, function() {});
}
*/
function getFileName(date) {
  dateFormat =
    date.getUTCFullYear() + "_" + date.getUTCMonth() + "_" + date.getUTCDate();
  fileName = dateFormat + ".csv";
  return fileName;
}
//  "https://nseindia.com/content/historical/EQUITIES/2018/JUN/cm20JUN2018bhav.csv.zip";
//   https://nseindia.com/content/historical/EQUITIES/2018/JUN/cm20JUN2018bhab.csv.zip
//nseindia.com/content/historical/EQUITIES/2018/JUN/cm21JUN2018bhab.csv.zip
function getBhabCopyFileURL(date) {
  var day = date.getUTCDate();
  var dayStr = "";
  if (day < 10) {
    dayStr = "0" + day;
  } else {
    dayStr = day;
  }
  return (
    "https://nseindia.com/content/historical/EQUITIES/" +
    date.getUTCFullYear() +
    "/" +
    monthNames[date.getMonth()] +
    "/" +
    "cm" +
    dayStr +
    monthNames[date.getMonth()] +
    date.getUTCFullYear() +
    "bhav.csv.zip"
  );
}

function getBhabCopyZipFileName(date) {
  dateFormat =
    date.getUTCFullYear() + "_" + date.getUTCMonth() + "_" + date.getUTCDate();
  fileName = "weekly/" + dateFormat + ".zip";
  return fileName;
}

function getBhabCopyUnzippedFileName(date) {
  dateFormat =
    date.getUTCFullYear() + "_" + date.getUTCMonth() + "_" + date.getUTCDate();
  fileName = "weekly/" + dateFormat + ".csv";
  return fileName;
}

function unzipFile(fileLocation, location) {
  fs.createReadStream(fileLocation)
    .pipe(unzipper.Parse())
    .on("entry", function(entry) {
      var fileName = entry.path;
      var type = entry.type; // 'Directory' or 'File'

      console.log();
      if (/\/$/.test(fileName)) {
        console.log("[DIR]", fileName, type);
        return;
      }

      console.log("[FILE]", fileName, type);

      // TODO: probably also needs the security check
      entry.pipe(fs.createWriteStream(location));

      //entry.pipe(process.stdout /*fs.createWriteStream('output/path')*/);
      // NOTE: To ignore use entry.autodrain() instead of entry.pipe()
    })
    .promise()
    .then(() => console.log("done"), e => console.log("error", e));
}

exports.downloadFile = function(fileName, url, callback) {
  var file = fs.createWriteStream(fileName);

  var request = https.get(url, function(response) {
    response.pipe(file);
    callback();
  });
};

exports.processFile = function(symbol, fileName, url, callback) {
  //console.log(url);
  //var file = fs.createWriteStream(fileName);
  fs.readFile(fileName, "utf8", function(error, body) {
    //console.log(response);
    //console.log(body);
    var lines = body.split("\n");
    console.log(
      "Processing records of size ",
      lines.length,
      " for filename ",
      fileName,
      " Lines are ",
      lines
    );
    var offSet = 0;
    for (var i = 0; i < lines.length; i++) {
      var data = lines[i].split(",");
      if (data.length == 7) {
        if (lines[i].startsWith("COLUMNS")) {
        } else if (data[0].startsWith("a")) {
          offSet = data[0].substring(1);
          data[0] = 0;
          data.unshift(offSet);
          data.unshift(moment(offSet * 1000).format("DD-MMM-YYYY")); //          console.log("Header" + offSet);
        } else {
          var num = parseInt(offSet) + parseInt(data[0]);
          //console.log(moment(num * 1000).format("DD-MMM-YYYY"));
          data.unshift(num);
          data.unshift(moment(num * 1000).format("DD-MMM-YYYY"));
        }
        //data.unshift(moment(parseInt(data[1]) * 1000).format("DD-MMM-YYYY"));
        data.unshift(symbol);
        //console.log(data.join(","));
        //        "(SYMBOL, DAY, DATEEPOCH, minuteOffset ,OPEN,HIGH,LOW,CLOSE)" +
        //close, hi, low, open
        var record = [
          data[0],
          data[1],
          data[2],
          data[3],
          data[7],
          data[5],
          data[6],
          data[4]
        ];

        var dbRecord = [];

        for (var j = 0; j < record.length; j++) {
          //dbRecord.push(record[j].replace("'", ""));
        }
        stockDataDao.createMinuteStockQuoteRecord(record);

        //console.log(record);
      } else {
        //console.log(data);
      }
    }
  });

  callback();
  /*

  var request = https.get(url, function(response) {
    response.pipe(file);
    callback();
  });*/
};
