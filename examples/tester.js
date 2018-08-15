const stockHelper = require("./stockhelper.js");
const connector = require("./kiteConnecter.js");
connector.getKiteConnector();
/*
var symbol = "CENTURYPLY";

var test1 = null,
  test2 = null,
  test3 = "abc";

const a = {
  ...(test1 != null ? { test1: test1 } : {}),
  ...(test2 != null ? { test2: test2 } : {}),
  ...(test3 != null ? { test3: test3 } : {}),
  b: 2
};

console.log(a);
*/

/*
stockHelper.getTrades(function(response) {
  for (var i = 0; i < response.length; i++) {
    if (response[i].tradingsymbol == symbol) {
      console.log(response[i]);
    }
  }
});
*/
stockHelper.getHoldings(function(response) {
  for (var i = 0; i < response.length; i++) {
    console.log(response[i]);
  }
});

/*
stockHelper.getPositions(function(response) {
  for (var i = 0; i < response.length; i++) {
    if (response[i].tradingsymbol == symbol) {
      console.log(response[i]);
    }
  }
});
*/
/*

stockHelper.getOrders(function(response) {
  for (var i = 0; i < response.length; i++) {
    if (response[i].tradingsymbol == symbol) {
      console.log(response[i]);
    }
  }
});

*/

//Understand

//CNC SELL STRATEGY.

//If share is improving over time. it is is good.
// PROFIT ZONE.

//DO NOT SELL BEFORE 11.

//SELL WITH STOP LOSS, DO WE AGAIN PLACE ANOTHER ORDER  WITH LIMIT WHEN STOPLOSS IS EXECUTED.
// Say a stock is giving you 8% profit now put a stoploss on 6% and keep updating the stoploss as soon
// as the profit increases.

//stockHelper.getPositions(function(res) {
//Get all the trade dones});
