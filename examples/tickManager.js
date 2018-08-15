const tickDao = require("./tickDao.js");
function updateTicks(ticks) {
  tickDao.save(ticks);
}

function saveTickCSV(ticks) {
  //for each tick groupo by
  //Open
}

//Algorithm.

//Currenly at this point of time take the mean of last 7 days. If we are abpve the mean by a lot.
//Look at whether it is buy or sell . If more are buy, we shiould also buy (INTRADAY/GLBAL)
