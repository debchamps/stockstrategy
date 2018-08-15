const stockHelper = require("../stockhelper.js");
const codeEX = require("./trailingStopLossManager.js");
const multipleCaller = require("../multipleCaller.js");

var symbol = "IDEA";

//stockHelper.getOrders();

stockHelper.getOrderHistory("180808000739030", function(resp) {
  console.log(resp);
});

/*
console.log(exchangeRoundOff(307.0 * 0.991));
function exchangeRoundOff(price) {
  //return Math.round((price * 20) / 20);

  return Math.round(price * 20) / 20;
  //return Math.round(((price * 20) / 20) * 100) / 100;
  //return Math.round((price * 20) / 20).toFixed(2);
}
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

/*

multipleCaller.callNTimes(6 * 60, 1000 * 5, function() {
  stockHelper.getPositions(function(response) {
    console.log("IMPORTANT ", response);
    var data = response.day;
    for (var i = 0; i < data.length; i++) {
      if (data[i].tradingsymbol == symbol) {
        console.log("IMPORTANT ", data[i]);
        //codeEX.createMISBracketOrder(data[i]);
      }
    }
  });
});
*/
