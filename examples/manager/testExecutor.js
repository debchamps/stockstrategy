const stockHelper = require("../stockhelper.js");
const codeEX = require("./trailingStopLossManager.js");
const multipleCaller = require("../multipleCaller.js");

var symbol = "ICICIBANK";

/*
stockHelper.getTrades(function(response) {
  for (var i = 0; i < response.length; i++) {
    if (response[i].tradingsymbol == symbol) {
      console.log(response[i]);
    }
  }
});
*/

multipleCaller.callNTimes(100 * 60, 1000 * 2, function() {
  codeEX.updatePendingValueSetOrders();
  stockHelper.getPositions(function(response) {
    console.log("IMPORTANT ", response);
    var data = response.day;
    for (var i = 0; i < data.length; i++) {
      //if (data[i].tradingsymbol == symbol)
      {
        console.log("IMPORTANT ", symbol);
        if (symbol != "PIDILITIND") codeEX.createMISBracketOrderV2(data[i]);
      }
    }
  });
});
