const MorningFirstBreakout = require("./MorningFirstBreakout.js");
const RangeTrading = require("./RangeTrading.js");
const PlacePendingOrder = require("./PlacePendingOrders.js");
const LowVarianceRunner = require("./LowVarianceRunner.js");
const LowVarianceRunnerWithNifty = require("./LowVarianceRunnerWithNifty.js");
execute();

function execute() {
  RangeTrading.execute();

  /*
  var current = new Date();
  var morningBreakOutDate = new Date();
  morningBreakOutDate.setHours(9, 25, 0, 0);

  var rangeTradingDate = new Date();
  rangeTradingDate.setHours(12, 15, 40, 0);

  var lowVarianceRunnerDate = new Date();
  lowVarianceRunnerDate.setHours(10, 45, 0, 0);

  var placePendingOrderDate = new Date();
  placePendingOrderDate.setHours(9, 15, 0, 0);

  if (current.getTime() < placePendingOrderDate.getTime()) {
    console.log(
      "Market opens in ",
      (placePendingOrderDate.getTime() - current.getTime()) / 1000,
      " seconds"
    );
    setTimeout(function() {
      execute();
    }, 1000);
    return;
  }

  if (current.getTime() < morningBreakOutDate.getTime())
    setTimeout(function() {
      MorningFirstBreakout.execute();
    }, morningBreakOutDate.getTime() - current.getTime());

  if (current.getTime() < rangeTradingDate.getTime())
    setTimeout(function() {
      RangeTrading.execute();
    }, rangeTradingDate.getTime() - current.getTime());

  if (current.getTime() < placePendingOrderDate.getTime())
    setTimeout(function() {
      PlacePendingOrder.execute();
    }, placePendingOrderDate.getTime() - current.getTime());

  if (current.getTime() < lowVarianceRunnerDate.getTime())
    setTimeout(function() {
      LowVarianceRunnerWithNifty.execute();
      LowVarianceRunner.execute();
    }, lowVarianceRunnerDate.getTime() - current.getTime());
    */
}
