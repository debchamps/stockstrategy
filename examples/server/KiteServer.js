// Every 5 minutestarting from 9 o clock get the stock data.

//Stocks to look  for
const keys = require("../../config/key.js");
const niftyDao = require("../dao/niftyDao.js");
const helper = require("../helper.js");

var api_key = keys.api_key,
  secret = keys.api_secret,
  request_token = keys.request_token,
  access_token = keys.access_token;

var KiteTicker = require("kiteconnect").KiteTicker;
var ticker = new KiteTicker({
  api_key: api_key,
  access_token: access_token
});
var items = [];

setTimeout(function() {
  start();
}, 3000);

function start() {
  console.log("Starting");
  ticker.connect();
  ticker.on("ticks", onTicks);
  ticker.on("connect", subscribe);
  ticker.on("order_update", orderUpdate);
  ticker.on();
}

function onTicks(ticks) {
  console.log("Ticks", ticks);
  //tickDao.createTickRecord(ticks);
  //console.log("Ticks", ticks);
}

function subscribe() {
  getInstruments(function(instruments) {
    ticker.subscribe(items);
    ticker.setMode(ticker.modeFull, items);
  });
}

function getInstruments(callback) {
  var instrumentIds = [];
  niftyDao.getNifty100(function(symbols) {
    console.log(symbols);
    for (var i = 0; i < symbols.length; i++) {
      var instrumentId = helper.getInstrumentByTradingSymbol("NSE", symbols[i]);
      instrumentIds.push(instrumentId);
    }
    callback(instrumentIds);
  });
}

function orderUpdate(orderUpdate) {
  console.log("OrderUpdate", orderUpdate);
}
