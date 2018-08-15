var dbConn = require("./dbConn.js");

var con = dbConn.createConnection();

var HIGH_VOLUME_QUERY =
  "select * from" +
  "(" +
  "select symbol, sum(volume) total, count(*) cnt from stock_minute_data" +
  " where volume is not null" +
  " and minuteOffset <= (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)" +
  " and day <> ?" +
  " group by symbol" +
  " order by symbol, sum(volume) desc" +
  " ) as allday," +
  " (select symbol from nifty_500 as n500" +
  "  where not exists ( " +
  "  select  symbol from nifty_100 as n100  where n100.symbol = n500.symbol)" +
  "  ) as nifty_400," +
  " (" +
  " select symbol, sum(volume) total, avg(open) open, count(*) cnt from stock_minute_data" +
  " where volume is not null" +
  " and minuteOffset <= (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)" +
  " and day = ?" +
  " group by symbol" +
  " having sum(volume) > 10000" +
  " order by symbol, sum(volume) desc" +
  " ) as today" +
  " where allday.symbol = today.symbol" +
  " and allday.symbol = nifty_400.symbol" +
  " order by today.total * allday.cnt/allday.total * today.cnt desc" +
  " limit 5";

var LOW_VOLUME_QUERY =
  "select * from" +
  "(" +
  "select symbol, sum(volume) total, count(*) cnt from stock_minute_data" +
  " where volume is not null" +
  " and minuteOffset <= (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)" +
  " and day <> ?" +
  " group by symbol" +
  " order by symbol, sum(volume) desc" +
  " ) as allday," +
  " (select symbol from nifty_500 as n500" +
  "  where not exists ( " +
  "  select  symbol from nifty_100 as n100  where n100.symbol = n500.symbol)" +
  "  ) as nifty_400," +
  " (" +
  " select symbol, sum(volume) total, avg(open) open, count(*) cnt from stock_minute_data" +
  " where volume is not null" +
  " and minuteOffset <= (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)" +
  " and day = ?" +
  " group by symbol" +
  " having sum(volume) > 10000" +
  " order by symbol, sum(volume) desc" +
  " ) as today" +
  " where allday.symbol = today.symbol" +
  " and allday.symbol = nifty_400.symbol" +
  " order by today.total * allday.cnt/allday.total * today.cnt asc" +
  " limit 7";

var RANGE_TRADING_QUERY =
  "select * from " +
  "(" +
  "select symbol, day, stddev(open) / avg(open), avg(open) as average, stddev(open)  as deviation ,  avg(open) +  stddev(open) as hi ,  avg(open)  - stddev(open)  as lo from STOCK_MINUTE_DATA" +
  " where" +
  " minuteOffSet < (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)" + //180
  " and minuteOffSet > (select max(minuteoffset) -33 from STOCK_MINUTE_DATA where day = ?)" +
  " and day = ?" +
  " group by symbol, day" +
  " having 2* (max(high) - max(low))/ (max(high) + max(low)) <  .75/100" +
  " and avg(open) > 100" +
  " order by stddev(open) / avg(open) desc" +
  " ) as selectedval," +
  " (" +
  " select symbol, day, open from STOCK_MINUTE_DATA" +
  " where minuteOffSet = (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)" +
  " and day = ?" +
  " ) as early," +
  " (select symbol, day, open from STOCK_MINUTE_DATA" +
  " where minuteOffSet = (select max(minuteoffset) - 33 from STOCK_MINUTE_DATA where day = ?)" +
  " and day = ?" +
  " ) as currentval" +
  " where early.symbol = selectedval.symbol" +
  " and early.symbol = currentval.symbol" +
  " and early.open > lo and early.open <hi" +
  " and currentval.open > lo and currentval.open <hi";

var LOW_VARIENCE_QUERY =
  "select smd.symbol as symbol, max(high) as high , min(low) as low , avg(open) average, stddev(open) as deviation  from STOCK_MINUTE_DATA as smd, nifty_100 as nifty" +
  " where day = ?" +
  " and nifty.symbol = smd.symbol " +
  " and minuteoffset <  (select max(minuteoffset) from STOCK_MINUTE_DATA where day = ?) " +
  " group by smd.symbol" +
  " having avg(open)  < 2000  and  avg(open)  > 100" +
  " order by stddev(open)/avg(open) asc ";

var LOW_VARIENCE_TIME_QUERY =
  "select smd.symbol, max(high) as high , min(low) as low , avg(open) average, stddev(open) as deviation  from STOCK_MINUTE_DATA as smd, nifty_100 as nifty" +
  " where smd.symbol = nifty.symbol and day = ?" +
  " and minuteoffset <  ? " +
  " group by smd.symbol" +
  " having avg(open)  < 2000  and  avg(open)  > 100" +
  " order by stddev(open)/avg(open) desc ";

var HIGH_VARIENCE_QUERY =
  "select smd.symbol, max(high) as high , min(low) as low , avg(open) average, stddev(open) as deviation  from STOCK_MINUTE_DATA as smd, nifty_100 as nifty " +
  " where day = ?" +
  " and smd.symbol = nifty.symbol " +
  " and minuteoffset <= (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)  " +
  //" and minuteoffset <= 10  " +
  //" and minuteoffset <= (select max(minuteoffset) -3 from STOCK_MINUTE_DATA where day = ?)  " +
  " group by smd.symbol" +
  " having avg(open) < 2000  and  avg(open)  > 100" +
  " order by stddev(open)/avg(open) desc ";

module.exports.getHighVolumeSellStocks = function(day, callback) {
  console.log(HIGH_VOLUME_QUERY);
  con.query(HIGH_VOLUME_QUERY, [day, day, day, day], function(
    err,
    result,
    fields
  ) {
    if (err) throw err;
    //console.log(result[0]);
    var responses = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      responses.push({
        symbol: row.symbol,
        open: row.open
      });
    });
    callback(responses);
  });
};

module.exports.getLowVolumeSellStocks = function(day, callback) {
  console.log(LOW_VOLUME_QUERY);
  con.query(LOW_VOLUME_QUERY, [day, day, day, day], function(
    err,
    result,
    fields
  ) {
    if (err) throw err;
    //console.log(result[0]);
    var responses = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      responses.push({
        symbol: row.symbol,
        open: row.open
      });
    });
    callback(responses);
  });
};
module.exports.getRangeTradingStocks = function(day, callback) {
  console.log(RANGE_TRADING_QUERY);
  con.query(RANGE_TRADING_QUERY, [day, day, day, day, day, day, day], function(
    err,
    result,
    fields
  ) {
    if (err) throw err;
    //console.log(result[0]);
    var responses = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      responses.push({
        symbol: row.symbol,
        hi: row.hi,
        lo: row.lo,
        average: row.average,
        deviation: row.deviation
      });
    });
    callback(responses);
  });
};

module.exports.getHighVarianceStocks = function(day, callback) {
  //console.log(HIGH_VARIENCE_QUERY);
  con.query(HIGH_VARIENCE_QUERY, [day, day], function(err, result, fields) {
    if (err) throw err;
    //console.log(result[0]);
    var responses = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      responses.push({
        symbol: row.symbol,
        high: row.high,
        low: row.low,
        average: row.average,
        deviation: row.deviation
      });
    });
    callback(responses);
  });
};

module.exports.getLowVarianceAtSpecificTimeStocks = function(
  day,
  time,
  callback
) {
  con.query(LOW_VARIENCE_TIME_QUERY, [day, time], function(
    err,
    result,
    fields
  ) {
    if (err) throw err;
    //console.log(result[0]);
    var responses = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      responses.push({
        symbol: row.symbol,
        high: row.high,
        low: row.low,
        average: row.average,
        deviation: row.deviation
      });
    });
    callback(responses);
  });
};

module.exports.getLowVarianceStocks = function(day, callback) {
  console.log(LOW_VARIENCE_QUERY);
  con.query(LOW_VARIENCE_QUERY, [day, day], function(err, result, fields) {
    if (err) throw err;
    //console.log(result[0]);
    var responses = [];
    Object.keys(result).forEach(function(key) {
      var row = result[key];
      responses.push({
        symbol: row.symbol,
        high: row.high,
        low: row.low,
        average: row.average,
        deviation: row.deviation
      });
    });
    callback(responses);
  });
};
