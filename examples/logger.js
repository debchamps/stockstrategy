/**
 * Configurations of logger.
 */
const moment = require("moment");
const { transports, createLogger, format } = require("winston");
const tsFormat = () =>
  new Date().toLocaleDateString() + " - " + new Date().toLocaleTimeString();

const winston = require("winston");
const winstonRotator = require("winston-daily-rotate-file");

const logger = winston.createLogger({
  format: format.combine(format.timestamp(), format.json()),
  level: "info",
  timestamp: function() {
    return new Date();
  },
  transports: [
    new winston.transports.Console({
      timestamp: tsFormat
    }),
    new winston.transports.DailyRotateFile({
      timestamp: tsFormat,
      filename: "/Users/debarghy/stocklogs/application-%DATE%.log",
      datePattern: "YYYY-MM-DD-HH",
      zippedArchive: true,
      maxSize: "20m",
      maxFiles: "14d"
    })
    /*

    new winston.transports.File({
      filename: "/Users/debarghy/stocklogs/combined.log"
    })*/
  ]
});

process.on("uncaughtException", function(err) {
  logger.info("XXXXXXXX");
  logger.error("uncaughtException", { message: err.message, stack: err.stack }); // logging with MetaData
  setTimeout(function() {
    process.exit(1); // exit with failure
  }, 1000);
});

//
// Replaces the previous transports with those in the
// new configuration wholesale.
//
/*
const DailyRotateFile = require("winston-daily-rotate-file");

var transport = new winston.transports.DailyRotateFile({
  filename: "application-%DATE%.log",
  datePattern: "YYYY-MM-DD-HH",
  zippedArchive: true,
  maxSize: "20m",
  maxFiles: "14d"
});


logger.configure({
  level: "verbose",
  transports: [
    new DailyRotateFile({
      filename: "/Users/debarghy/stocklogs/combined-%DATE%.log",
      datePattern: "YYYY-MM-DD-HH",
      zippedArchive: true,
      maxSize: "20m",
      maxFiles: "14d"
    })
  ]
});
*/

module.exports = logger;
