var MACD = require("technicalindicators").MACD;
var macdInput = {
  values: [
    127.75,
    129.02,
    132.75,
    145.4,
    148.98,
    137.52,
    147.38,
    139.05,
    137.23,
    149.3,
    162.45,
    178.95,
    200.35,
    221.9,
    243.23,
    243.52,
    286.42,
    280.27
  ],
  fastPeriod: 5,
  slowPeriod: 8,
  signalPeriod: 3,
  SimpleMAOscillator: false,
  SimpleMASignal: false
};

console.log(MACD.calculate(macdInput));
