var mysql = require("mysql");
var moment = require("moment");

exports.createConnection = function() {
  var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "bittu.28",
    database: "stocks",
    connectTimeout: 30000
  });
  return con;
};
