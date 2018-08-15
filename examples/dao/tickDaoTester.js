const tickDao = require("./tickDao.js");

testData = [
  {
    tradable: true,
    mode: "full",
    instrument_token: 208947,
    last_price: 3939,
    last_quantity: 1,
    average_price: 3944.77,
    volume: 28940,
    buy_quantity: 4492,
    sell_quantity: 4704,
    ohlc: { open: 3927, high: 3955, low: 3927, close: 3906 },
    change: 0.8448540706605223,
    last_trade_time: "2018-06-25T06:04:43.000Z",
    timestamp: "2018-06-25T06:04:44.000Z",
    oi: 24355,
    oi_day_high: 0,
    oi_day_low: 0,
    depth: 12,
    buy: [
      {
        quantity: 59,
        price: 3223,
        orders: 5
      },
      {
        quantity: 164,
        price: 3222,
        orders: 15
      },
      {
        quantity: 123,
        price: 3221,
        orders: 7
      },
      {
        quantity: 48,
        price: 3220,
        orders: 7
      },
      {
        quantity: 33,
        price: 3219,
        orders: 5
      }
    ],
    sell: [
      {
        quantity: 115,
        price: 3224,
        orders: 15
      },
      {
        quantity: 50,
        price: 3225,
        orders: 5
      },
      {
        quantity: 175,
        price: 3226,
        orders: 14
      },
      {
        quantity: 49,
        price: 3227,
        orders: 10
      },
      {
        quantity: 106,
        price: 3228,
        orders: 13
      }
    ]
  },

  {
    tradable: true,
    mode: "full",
    instrument_token: 308947,
    last_price: 3939,
    last_quantity: 1,
    average_price: 3944.77,
    volume: 28940,
    buy_quantity: 4492,
    sell_quantity: 4704,
    ohlc: { open: 3927, high: 3955, low: 3927, close: 3906 },
    change: 0.8448540706605223,
    last_trade_time: 1515491369,
    timestamp: 1515491373,
    oi: 24355,
    oi_day_high: 0,
    oi_day_low: 0,
    depth: 12,
    buy: [
      {
        quantity: 59,
        price: 3223,
        orders: 5
      },
      {
        quantity: 164,
        price: 3222,
        orders: 15
      },
      {
        quantity: 123,
        price: 3221,
        orders: 7
      },
      {
        quantity: 48,
        price: 3220,
        orders: 7
      },
      {
        quantity: 33,
        price: 3219,
        orders: 5
      }
    ],
    sell: [
      {
        quantity: 115,
        price: 3224,
        orders: 15
      },
      {
        quantity: 50,
        price: 3225,
        orders: 5
      },
      {
        quantity: 175,
        price: 3226,
        orders: 14
      },
      {
        quantity: 49,
        price: 3227,
        orders: 10
      },
      {
        quantity: 106,
        price: 3228,
        orders: 13
      }
    ]
  }
];

//tickDao.createTable();
tickDao.createTickRecord(testData);
