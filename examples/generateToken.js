const keys = require("../config/key.js");
const querystring = require("querystring");

var crypto = require("crypto");
var hash = crypto.createHash("sha256");
data = keys.api_key + keys.request_token + keys.api_secret;
//console.log("data :: ", data);

//console.log("checksum", data);
hash_update = hash.update(data).digest("hex");
//console.log("checksum", hash_update);
//console.log("");

curlCommand =
  'curl https://api.kite.trade/session/token -d "api_key=excnq4xt82prtikf" -d "request_token=' +
  keys.request_token +
  '" -d "checksum=' +
  hash_update +
  '"';

console.log(curlCommand);
url =
  'https://api.kite.trade/session/token -d "api_key=excnq4xt82prtikf" -d "request_token=' +
  keys.request_token +
  '" -d "checksum=' +
  hash_update +
  '"';

var https = require("https");

// form data
var postData = querystring.stringify({
  api_key: "excnq4xt82prtikf",
  request_token: keys.request_token,
  checksum: hash_update
});

// request option
var options = {
  host: "api.kite.trade",
  port: 443,
  method: "POST",
  path: "/session/token",
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    "Content-Length": postData.length
  }
};
// request object
var req = https.request(options, function(res) {
  var result = "";
  res.on("data", function(chunk) {
    result += chunk;
  });
  res.on("end", function() {
    console.log(result);
  });
  res.on("error", function(err) {
    console.log(err);
  });
});

// req error
req.on("error", function(err) {
  console.log(err);
});

//send request witht the postData form
req.write(postData);
req.end();
