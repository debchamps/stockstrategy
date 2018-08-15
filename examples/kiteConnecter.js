var KiteConnect = require("kiteconnect").KiteConnect;
const keys = require("../config/key.js");

console.log(keys);

var api_key = keys.api_key,
  secret = keys.api_secret,
  request_token = keys.request_token,
  access_token = keys.access_token;

var options = {
  api_key: api_key,
  debug: true
};

module.exports.getKiteConnector = function() {
  kc = new KiteConnect(options);
  kc.setSessionExpiryHook(sessionHook);

  if (!access_token) {
    kc.generateSession(request_token, secret)
      .then(function(response) {
        console.log("Response", response);
      })
      .catch(function(err) {
        console.log("Unable to generateSession", err);
      });
  } else {
    kc.setAccessToken(access_token);
    console.log("Access token " + access_token);
  }
  return kc;
  // body...
};

function sessionHook() {
  console.log("User loggedout");
}

//module.exports.getKiteConnector();
