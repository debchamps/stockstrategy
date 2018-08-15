var hardCodedStrategy = function() {
  return [
    {
      strategyName: "HARD_CODED",
      stockSymbol: "VAKRANGEE",
      quantity: 10
    }
  ];
};

var placeOrders = function(orders) {
  kc.placeOrder(variety, {
    exchange: "NSE",
    tradingsymbol: order.stockSymbol,
    transaction_type: "BUY",
    quantity: order.quantity,
    product: "CNC",
    order_type: "MARKET"
  })
    .then(function(resp) {
      console.log(resp);
    })
    .catch(function(err) {
      console.log(err);
    });
};
