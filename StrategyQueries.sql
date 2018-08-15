use stocks;

show tables;


delete from DAILY_TRADE
where strategy = 'LOW_VARIANCE_TRADE'

update DAILY_TRADE
set  strategy = 'MORNING_HIGH_VARIENCE'
where strategy = 'LOW_VARIANCE_TRADE'

select * from DAILY_TRADE order by timestamp desc
select * from DAILY_TRADE where symbol like 'ABB' 

select * from STOCK_MINUTE_DATA
order by dateepoch, minuteOffset, () desc

select symbol, max(high) , min(low)  from STOCK_MINUTE_DATA
where minuteoffset <=15
and day = '06-Jul-2018'
group by symbol

select *  from 
(
select symbol, max(high) 15_hi , min(low) 15_lo  from STOCK_MINUTE_DATA
where minuteoffset <=15
and day = '06-Jul-2018'
group by symbol
) as fifteen, 
(
select symbol, max(high) rest_hi , min(low) rest_lo  from STOCK_MINUTE_DATA
where minuteoffset > 18
and day = '06-Jul-2018'
group by symbol
) as rest
where rest.symbol = fifteen.symbol


########## First 15 minute GAINER  ###########
select symbol, SUM(X), avg(eopen) as dayend , avg(tradeval) as tradeval, COUNT(*) from (
select dayend.symbol , dayend.open eopen, trade.open tradeval,
CASE
when dayend.open > trade.open then 1
else -1
END AS X
from 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 15
and day <> "02-Aug-2018"
) dayend, 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 1
and day <> "02-Aug-2018"
) trade
where dayend.symbol = trade.symbol
and dayend.day = trade.day
) AS Y
GROUP BY symbol
order by   SUM(X) desc , (avg(eopen) - avg(tradeval) )/avg(eopen)  desc 

##########################################

########## LAST 15 minute GAINER  ###########

select symbol, SUM(X), avg(eopen) as dayend , avg(tradeval) as tradeval, COUNT(*) from (
select dayend.symbol , dayend.open eopen, trade.open tradeval,
CASE
when dayend.open > trade.open then 1
else -1
END AS X
from 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 365
and day <> "02-Aug-2018"
) dayend, 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 315
and day <> "02-Aug-2018"
) trade
where dayend.symbol = trade.symbol
and dayend.day = trade.day
) AS Y
GROUP BY symbol
order by (avg(eopen) - avg(tradeval) )/avg(eopen)  desc ,  SUM(X)  desc


where minute


select symbol, sum(quantity * buyprice)/sum(quantity) from DAILY_TRADE
group by symbol
order by timestamp desc

select * from daily_trade

ALTER TABLE daily_trade ADD   SELLSTRATEGY VARCHAR(20);

 VARCHAR(30);
ADD  COLUMN STATUS VARCHAR(20),
ADD COLUMN SELLTIMESTAMP NUMBER(20);




select * from daily_trade
where symbol = 'ACC'
 order by timestamp desc


############ BEST NIFTY 50 STOCK OF LAST MONTH #############

select count(*) from daily_quotes
select * from daily_quotes
where symbol = 'SBIN'
and timestamp like '%MAY%'




select * from daily_quotes where 
timestamp = '03-MAY-2018'

select UPPER(DATE_FORMAT(CURDATE() - 5 , "%d-%b-%Y")) from dual;

select june.symbol, june.open, july.open , now.open , 100* (july.open - june.open)/june.open  from
(
select * from daily_quotes  where  timestamp = UPPER(DATE_FORMAT(DATE_SUB(CURDATE(), interval 30 day) , "%d-%b-%Y"))
) as july, 
(
select * from daily_quotes  where  timestamp = UPPER(DATE_FORMAT(DATE_SUB(CURDATE() , INTERVAL 90 DAY)  , "%d-%b-%Y")) 
) as june,
(
select * from daily_quotes  where  timestamp = UPPER(DATE_FORMAT(DATE_SUB(CURDATE() , INTERVAL 1 DAY)  , "%d-%b-%Y")) 
) as now,
 nifty_50 as nifty
where june.symbol = july.symbol
and nifty.symbol = july.symbol
and now.symbol = july.symbol
order by (now.open - july.open)/july.open desc
order by (july.open - june.open)/june.open asc


############ BEST NIFTY 50 STOCK OF LAST MONTH #############

select current.symbol, (current.high + current.low)/2 , (hourago.high + hourago.low)/2
, 100*((current.high + current.low)/2 - (hourago.high + hourago.low)/2)  /(hourago.high + hourago.low)/2 
from 
(
select * from STOCK_MINUTE_DATA
where day = "05-Jul-2018" 
and (minuteOffset = 30)
) as current, 
(
select * from STOCK_MINUTE_DATA
where day = "05-Jul-2018" 
and ( minuteOffset = 30 -15)
) hourago
where current.symbol = hourago.symbol
order by ((current.high + current.low)/2 - (hourago.high + hourago.low)/2 ) /(hourago.high + hourago.low)/2  asc



select * from daily_quotes limit 10;

########################### BUY @ START OF MORNING  STARTS############################

select 
smd.symbol, day, dateepoch, minuteoffset, smd.open as smdopen, smd.high as smdhigh , smd.close as smdclose,
dq.open as dqopen, dq.close as dqclose, dq.high as dqhigh, dq.low as dqlow, 100* (smd.high - dq.open)/dq.open
from STOCK_MINUTE_DATA smd, daily_quotes dq
where smd.symbol = dq.symbol
and ucase(day) = ucase(timestamp)
and minuteoffset < 15
#and day = "26-Jun-2018"
and series = 'EQ'
order by 100*(smd.high - dq.open)/dq.open desc
#limit 10



########################### BUY @ START OF MORNING ENDS  ############################

## STRATEGY ##
select june.symbol, june.open, july.open  from
(select * from daily_quotes  where  timestamp = '04-JUL-2018' ) as july, 
(select * from daily_quotes  where  timestamp = '27-JUN-2018' ) as june, nifty_100 as nifty
where june.symbol = july.symbol
and nifty.symbol = july.symbol
order by (july.open - june.open)/june.open desc


timestamp = '04-JUL-2018'
(Best stocks over last 2 month buy them at the end of day incase it has gone lower that day. )
## ##




########################### STOCKS FLUCTUATING DAILY START############################




########################### STOCKS FLUCTUATING DAILY END ############################




show tables;


select &
delete from daily_quotes where open < 10

SYMBOL,SERIES,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN,


delete from daily_quotes


select * from stock_minute_data
order by dateepoch desc


select * from QUOTES limit 10;

select * from daily_quotes
limit 10

select symbol, count(*) from daily_quotes
group by symbol
order by count(*) desc

select * from quotes


select instrumenttoken, ROUND(time/60* 1000), count(*) from quotes
group by instrumenttoken, ROUND(time/60* 1000)
order by count(*) desc




select symbol, count(*) from daily_quotes 
group by symbol
order by count(*) desc
where symbol = '20MICRONS';

//hi-score

select ((high -open)/open), ((open - low)/open) , symbol from daily_quotes

###### NIFTY  HIGH VARIANCE STOCKS
select * from 
(
select symbol, sum(tottrdqty) total,  avg(prevclose) prevclose,  count(*), 100 * sum((high -open)/open) allhi, 100 * sum((open - low)/open)  alllow from daily_quotes
group by symbol
order by count(*) desc
) as temp , NIFTY_100 nifty
where temp.symbol = nifty.symbol
order by     allhi - alllow desc


select * from nifty_100 where 
symbol = 'TECHM'


select * from INSTRUMENT_TOKENS


select * from daily_quotes
order by timestamp desc

select count(*) from daily_quotes
where timestamp is  null

commit
delete from DAILY_TRADE
where timestamp <=1530767339438


select SUM(BUYPRICE * QUANTITY) from DAILY_TRADE
order by timestamp desc
use stocks
select *  from BRACKET_ORDER_TRAILING
order by creation_time desc

delete from BRACKET_ORDER_TRAILING
where symbol = 'MOTHERSUMI'
select * from BRACKET_ORDER_TRAILING
order by creation_time desc

drop table BRACKET_ORDER_TRAILING

select * from BRACKET_ORDER_TRAILING
CREATE TABLE BRACKET_ORDER_TRAILING (
BRACKET_ID varchar(50),
ORDER_ID varchar(32),
EXCHANGE varchar(10),
PRODUCT varchar(10),  #MIS/CNC
TXN_TYPE VARCHAR(10), #SELL/BUY
SYMBOL varchar(32),
QUANTITY DECIMAL(20),
AVERAGE_PRICE DECIMAL(20,4),
STOPLOSS_STRATEGY VARCHAR(20),
LIMIT_STRATEGY VARCHAR(20),
STOPLOSS_ORDER_ID varchar(32),
LIMIT_ORDER_ID varchar(32),
INITIAL_STOPLOSS DECIMAL(20,4),
INITIAL_LIMIT DECIMAL(20,4),
CURRENT_STOPLOSS DECIMAL(20,4),
CURRENT_LIMIT DECIMAL(20,4),
TRAILING_STOPLOSS DECIMAL(20,4),
LAST_EVALUATED_LTP DECIMAL(20,4),
STATUS VARCHAR(10),
CREATION_TIME DECIMAL(20),
PRIMARY KEY (BRACKET_ID))
 ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


commit
delete from BRACKET_ORDER_TRAILING


select * from BRACKET_ORDER_TRAILING


delete from BRACKET_ORDER_TRAILING

update BRACKET_ORDER_TRAILING
set LAST_EVALUATED_LTP = AVERAGE_PRICE
where bracket_id = 'abcICICIBANK'

commit

delete from BRACKET_ORDER_TRAILING 
update BRACKET_ORDER_TRAILING
set  LIMIT_ORDER_ID = COALESCE("ABC", LIMIT_ORDER_ID), 
 STOPLOSS_ORDER_ID = COALESCE("ABC", STOPLOSS_ORDER_ID)
where 
BRACKET_ID =  'abcORIENTCEM'



DESCRIBE  STOCK_MINUTE_DATA

ALTER TABLE BRACKET_ORDER_TRAILING
ADD  PROFIT_PERCENT  DECIMAL(20,4),
ADD  STOPLOSS_PERCENT  DECIMAL(20,4)


SELECT * FROM STOCK_MINUTE_DATA

select * from daily_trade 
where symbol = 'PTC'

drop table DAILY_TRADE
Create table DAILY_TRADE (
TRADEID varchar(50),
SYMBOL varchar(32),
SERIES varchar(32),
STRATEGY  varchar(32),
STRATEGYCONTEXT  varchar(320),
QUANTITY DECIMAL(20,4),
BUYPRICE DECIMAL(20,4),
STOPLOSS DECIMAL(20,4),
TOTALTRADES DECIMAL(20,4),
DAY varchar(32),
TIMESTAMP DECIMAL(20),
PRIMARY KEY (TRADEID))
 ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



show tables 

select * from daily_trade
where symbol = 'GRANULES'


## GET ME THE TOP 5 STOCKS AT 9 45 PM ### 
select * from 
(
select (high + low)/2 mid,  symbol   from STOCK_MINUTE_DATA
where day = '10-Jul-2018'
and minuteoffset = 0
) as early,
(
select (high + low)/2 mid, symbol  from STOCK_MINUTE_DATA
where day = '10-Jul-2018'
and minuteoffset = 5
) as later
where early.symbol = later.symbol
order by (later.mid - early.mid) / early.mid asc

select  max(minuteOffset)    from STOCK_MINUTE_DATA
where day = '10-Jul-2018'

## BUY AUTOMATIC CNC SHARE AT END OF DAY ###

select avg(100 * (rmid - lmid) / lmid) from (
select early.day, early.symbol, early.mid emid, later.mid lmid, result.mid rmid , 100 * (result.mid - later.mid) / later.mid from 
(
select day, (high + low)/2 mid,  symbol   from STOCK_MINUTE_DATA
where minuteoffset = 345

) as early,
(
select day, (high + low)/2 mid, symbol  from STOCK_MINUTE_DATA
where minuteoffset = 360
) as later,
(
select day, (high + low)/2 mid, symbol  , 
CASE WEEKDAY(FROM_UNIXTIME(dateepoch)) 
                             WHEN 0 THEN DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),3) , '%d-%b-%Y')
                             WHEN 6 THEN DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),2) , '%d-%b-%Y') 
                             WHEN 5 THEN DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),1) , '%d-%b-%Y')
                             ELSE DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),1)  , '%d-%b-%Y')
                        END as prevDay
from STOCK_MINUTE_DATA
where minuteoffset = 45

) as result,
nifty_100 as nifty
where early.symbol = later.symbol and early.day = later.day 
and result.symbol = early.symbol and early.day = result.prevDay 
and early.symbol = nifty.symbol
order by day desc, (later.mid - early.mid) / early.mid desc

INTO OUTFILE '/tmp/all_late_data.csv'

limit 10
) as X


select  FROM_UNIXTIME(dateepoch)   from STOCK_MINUTE_DATA
where minuteoffset = 45


select count(*) from STOCK_MINUTE_DATA
select 
CASE WEEKDAY(FROM_UNIXTIME(dateepoch)) 
                             WHEN 0 THEN DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),3) , '%d-%b-%Y')
                             WHEN 6 THEN DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),2) , '%d-%b-%Y') 
                             WHEN 5 THEN DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),1) , '%d-%b-%Y')
                             ELSE DATE_FORMAT(SUBDATE(FROM_UNIXTIME(dateepoch),1)  , '%d-%b-%Y')
                        END as PREV_DAY
                        from STOCK_MINUTE_DATA


select count(*) from STOCK_MINUTE_DATA
where day = '09-Jul-2018'


select * from STOCK_MINUTE_DATA
where minuteoffset = 100
and symbol = 'SBIN'


select * from daily_quotes
show tables;


order by dateepoch desc


select symbol, max(high) as high , min(low) as low , avg(open) average, stddev(open) as deviation  from STOCK_MINUTE_DATA
where day = '25-Jul-2018'
and minuteoffset < 90
group by symbol
having avg(open)  < 2000
order by stddev(open)/avg(open) asc


select symbol, max(high) as high , min(low) as low , avg(open) average, stddev(open) as deviation  from STOCK_MINUTE_DATA
where day = '26-Jul-2018'
and minuteoffset <  (select max(minuteoffset) from STOCK_MINUTE_DATA where day = '26-Jul-2018')
group by symbol
having avg(open)  < 2000
order by stddev(open)/avg(open) asc


 
select symbol, max(high) as high , min(low) as low , avg(open) average, stddev(open) as deviation  from STOCK_MINUTE_DATA
where day = '26-Jul-2018'
and minuteoffset <=  10
group by symbol
having avg(open)  < 2000
order by stddev(open)/avg(open) desc


use stocks



select * from DAILY_TRADE
order by timestamp desc



delete from DAILY_TRADE
where strategy = 'LOW_VARIANCE_TRADE'

commit 
alter table DAILY_TRADE
ADD TXNTYPE VARCHAR(10)


commit
select * from
(
select day, (high + low)/2 mid,  symbol   from STOCK_MINUTE_DATA
where minuteoffset = 245

) as early,
(
select day, (high + low)/2 mid, symbol  from STOCK_MINUTE_DATA
where minuteoffset = 260
) as later,
nifty_100 as nifty
where early.symbol = later.symbol and early.day = later.day 
and early.symbol = nifty.symbol
and later.day = "19-Jul-2018"
order by later.day desc, (later.mid - early.mid) / early.mid asc
limit 5

use stocks

select * from STOCK_MINUTE_DATA
where day = '27-Jul-2018'

order by minuteOffset asc



where symbol = 'SUZLON'
and day = '25-Jul-2018'
order by minuteOffset desc





############ 15 MINUTE SHORT SELL THE START ONE  ############

d

select early.day, early.symbol, early.mid emid, later.mid lmid, result.mid rmid , 100 * (result.mid - later.mid) / later.mid from 
(
select day, (high + low)/2 mid,  symbol   from STOCK_MINUTE_DATA
where minuteoffset = 85

) as early,
(
select day, (high + low)/2 mid, symbol  from STOCK_MINUTE_DATA
where minuteoffset = 90
) as later,
(
select day, (high + low)/2 mid, symbol  from STOCK_MINUTE_DATA
where minuteoffset = 300
) as result,
nifty_100 as nifty
where early.symbol = later.symbol and early.day = later.day 
and result.symbol = early.symbol and early.day = result.day 
and result.day = '27-Jul-2018'
and early.symbol = nifty.symbol
order by day desc, (later.mid - early.mid) / early.mid desc

select max(minuteoffset) from STOCK_MINUTE_DATA
where day = '31-Jul-2018'



select symbol, max(high) as high , min(low) as low , avg(open) average, stddev(open) as deviation  from STOCK_MINUTE_DATA 
where day = '31-Jul-2018' and minuteoffset <= (select max(minuteoffset) from STOCK_MINUTE_DATA where day = '31-Jul-2018') 
  group by symbol having avg(open)  < 2000  order by stddev(open)/avg(open) desc

select * from BRACKET_ORDER_TRAILING
order by creation_time descnifty



select * from stock_minute_data 
where day = '02-Aug-2018'
and symbol = 'SHREECEM'
and minuteoffset = 374
order by dateepoch desc



############## TREND AT X MINUTE FROM MARKET START #######

select symbol, SUM(X), avg(eopen) as dayend , avg(tradeval) as tradeval, COUNT(*) from (
select dayend.symbol , dayend.open eopen, trade.open tradeval,
CASE
when trade.open > daystart.open &&  dayend.open > trade.open then 1
when trade.open > daystart.open &&  dayend.open < trade.open then -1
when trade.open < daystart.open &&  dayend.open < trade.open then 1
when trade.open < daystart.open &&  dayend.open > trade.open then -1
else -1
END AS X
from 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 345
and day <> "03-Aug-2018"
) dayend, 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 90
and day <> "03-Aug-2018"
) trade,
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 0
and day <> "03-Aug-2018"
) daystart

where dayend.symbol = trade.symbol
and dayend.symbol = daystart.symbol
and dayend.day = trade.day
and dayend.day = daystart.day
) AS Y
GROUP BY symbol
order by    (avg(eopen) - avg(tradeval) )/avg(eopen)  desc ,  SUM(X) desc  


############## TREND AT X MINUTE FROM MARKET START  SELL OF BY 9:30 QUICK BUCK #######

select symbol, SUM(X), avg(eopen) as dayend , avg(tradeval) as tradeval, COUNT(*) from (
select dayend.symbol , dayend.open eopen, trade.open tradeval,
CASE
when trade.open > daystart.open &&  dayend.open > trade.open then 1
when trade.open > daystart.open &&  dayend.open < trade.open then -1
when trade.open < daystart.open &&  dayend.open < trade.open then 1
when trade.open < daystart.open &&  dayend.open > trade.open then -1
else -1
END AS X
from 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 15
and day <> "03-Aug-2018"
) dayend, 
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 5
and day <> "03-Aug-2018"
) trade,
(
select  * from STOCK_MINUTE_DATA
where minuteoffset = 0
and day <> "03-Aug-2018"
) daystart

where dayend.symbol = trade.symbol
and dayend.symbol = daystart.symbol
and dayend.day = trade.day
and dayend.day = daystart.day
) AS Y
GROUP BY symbol
order by   SUM(X) desc,  (avg(eopen) - avg(tradeval) )/avg(eopen)  desc   







### TIME OF DAY INCREASE ###



### HIGH VOLUME THAN AVERAGE IN FIRT 5 MINUTE ###
select * from 
(
select symbol, minuteoffset, day, avg(volume) avgvol   from STOCK_MINUTE_DATA
where volume is not null
group by symbol, day, minuteoffset
) as eachday,
(
select symbol,minuteoffset,  avg(volume)  avgvol from STOCK_MINUTE_DATA
where volume is not null
group by symbol, minuteoffset
) as alldayavg
where 
alldayavg.symbol = eachday.symbol
and alldayavg.minuteoffset = eachday.minuteoffset
and eachday.minuteoffset = 1
and day = '03-Aug-2018'
and alldayavg.avgvol > 10000
order by (eachday.avgvol  -alldayavg.avgvol)/alldayavg.avgvol desc



### HIGHEST INCESE IN LAST 1 MINUTE ##########

select * from 
(
select symbol, minuteoffset, day, avg(open) price   from STOCK_MINUTE_DATA
where volume is not null
group by symbol, day, minuteoffset
) as after,
(
select symbol, minuteoffset, day, avg(open) price   from STOCK_MINUTE_DATA
where volume is not null
group by symbol, day, minuteoffset
) as later, nifty_100 as nifty
where after.day = later.day
and after.minuteoffset - 1 = later.minuteoffset
and after.symbol = later.symbol
and nifty.symbol =  later.symbol
and after.minuteoffset = 1
and later.day = '03-Aug-2018'
order by (after.price - later.price)/later.price desc



############ WHERE DEVIATION IS LESS THAN  2%  AND CURRENTLY TRADING NEAR MEAN OF THE DAY ############
#### CAN BE  USED FOR RANGE TRADING #############




### HIGHEST_VARIENCE BETWEEN #) MINUTES  ###################

select * from 
(
select symbol, day, stddev(open) / avg(open), avg(open) as avgopen, stddev(open)  as deviation ,  avg(open) +  stddev(open) as hi ,  avg(open)  - stddev(open)  as lo from STOCK_MINUTE_DATA
where
minuteOffSet < 180
and minuteOffSet > 150
and day = '03-Aug-2018'
group by symbol, day
having 2* (max(high) - max(low))/ (max(high) + max(low)) <  .75/100
and avg(open) > 100
order by stddev(open) / avg(open) desc
) as selectedval,
(
select symbol, day, open from STOCK_MINUTE_DATA
where minuteOffSet = 180
and day = '03-Aug-2018'
) as early,
(select symbol, day, open from STOCK_MINUTE_DATA
where minuteOffSet = 150
and day = '03-Aug-2018'
) as currentval
where early.symbol = selectedval.symbol
and early.symbol = currentval.symbol
and early.day = selectedval.day
and early.day = currentval.day
and early.day = '03-Aug-2018'
and early.open > lo and early.open <hi
and currentval.open > lo and currentval.open <hi




commit

use stocks;


select * from STOCK_MINUTE_DATA
where symbol = 'IRB'
order by DATEEPOCH desc







select * from 
(
select symbol, day, stddev(open) / avg(open), avg(open) as avgopen, stddev(open)  as deviation ,  avg(open) +  stddev(open) as hi ,  avg(open)  - stddev(open)  as lo from STOCK_MINUTE_DATA 
where minuteOffSet < (select max(minuteoffset) from STOCK_MINUTE_DATA where day = '03-Aug-2018') 
and minuteOffSet > (select max(minuteoffset) -30 from STOCK_MINUTE_DATA where day = '03-Aug-2018') 
and day = '03-Aug-2018' 
group by symbol, day 
having 2* (max(high) - max(low))/ (max(high) + max(low)) <  .75/100 and avg(open) > 100 
order by stddev(open) / avg(open) desc ) as selectedval, 
(
 select symbol, day, open 
 from STOCK_MINUTE_DATA 
 where minuteOffSet = (select max(minuteoffset) from STOCK_MINUTE_DATA where day = '03-Aug-2018') 
 and day = '03-Aug-2018' ) as early, 
 (
 select symbol, day, open from STOCK_MINUTE_DATA 
 where minuteOffSet = (select max(minuteoffset) - 30 from STOCK_MINUTE_DATA where day = '03-Aug-2018') 
 and day = '03-Aug-2018' ) as currentval 
 where early.symbol = selectedval.symbol 
 and early.symbol = currentval.symbol
 and early.open > lo 
 and early.open <hi 
 and currentval.open > lo 
 and currentval.open <hi




delete from STOCK_MINUTE_DATA
where day = '03-Aug-2018'

###################


select * from bra

INSERT INTO STOCK_MINUTE_DATA(SYMBOL, DAY, DATEEPOCH, minuteOffset ,OPEN,HIGH,LOW,CLOSE, VOLUME) VALUES ((\'IDFCBANK\', \'02-Aug-2018\', 1533181500, 0, 39.400001525878906, 39.400001525878906, 39.349998474121094, 39.349998474121094, 0, 39.400001525878906, 39.400001525878906, 39.349998474121094, 39.349998474121094, 0), (\'IDFCBANK\', \'02-Aug-2018\', 1533181560, 1, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 29278, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 29278), (\'IDFCBANK\', \'02-Aug-2018\', 1533181620, 2, 39.29999923706055, 39.29999923706055, 39.150001525878906, 39.150001525878906, 42224, 39.29999923706055, 39.29999923706055, 39.150001525878906, 39.150001525878906, 42224), (\'IDFCBANK\', \'02-Aug-2018\', 1533181680, 3, 39.29999923706055, 39.349998474121094, 39.25, 39.29999923706055, 51984, 39.29999923706055, 39.349998474121094, 39.25, 39.29999923706055, 51984), (\'IDFCBANK\', \'02-Aug-2018\', 1533181740, 4, 39.349998474121094, 39.349998474121094, 39.25, 39.29999923706055, 13485, 39.349998474121094, 39.349998474121094, 39.25, 39.29999923706055, 13485), (\'IDFCBANK\', \'02-Aug-2018\', 1533181800, 5, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 10455, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 10455), (\'IDFCBANK\', \'02-Aug-2018\', 1533181860, 6, 39.25, 39.25, 39.25, 39.25, 17694, 39.25, 39.25, 39.25, 39.25, 17694), (\'IDFCBANK\', \'02-Aug-2018\', 1533181920, 7, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 13807, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 13807), (\'IDFCBANK\', \'02-Aug-2018\', 1533181980, 8, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 21592, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 21592), (\'IDFCBANK\', \'02-Aug-2018\', 1533182040, 9, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 27003, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 27003), (\'IDFCBANK\', \'02-Aug-2018\', 1533182100, 10, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 4780, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 4780), (\'IDFCBANK\', \'02-Aug-2018\', 1533182160, 11, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 2335, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 2335), (\'IDFCBANK\', \'02-Aug-2018\', 1533182220, 12, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3073, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3073), (\'IDFCBANK\', \'02-Aug-2018\', 1533182280, 13, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 5293, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 5293), (\'IDFCBANK\', \'02-Aug-2018\', 1533182340, 14, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 22135, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 22135), (\'IDFCBANK\', \'02-Aug-2018\', 1533182400, 15, 39.400001525878906, 39.400001525878906, 39.20000076293945, 39.20000076293945, 139679, 39.400001525878906, 39.400001525878906, 39.20000076293945, 39.20000076293945, 139679), (\'IDFCBANK\', \'02-Aug-2018\', 1533182460, 16, 39.25, 39.25, 39.25, 39.25, 7394, 39.25, 39.25, 39.25, 39.25, 7394), (\'IDFCBANK\', \'02-Aug-2018\', 1533182520, 17, 39.20000076293945, 39.20000076293945, 39.099998474121094, 39.099998474121094, 63767, 39.20000076293945, 39.20000076293945, 39.099998474121094, 39.099998474121094, 63767), (\'IDFCBANK\', \'02-Aug-2018\', 1533182580, 18, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 77782, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 77782), (\'IDFCBANK\', \'02-Aug-2018\', 1533182640, 19, 39.04999923706055, 39.099998474121094, 39.04999923706055, 39.099998474121094, 15295, 39.04999923706055, 39.099998474121094, 39.04999923706055, 39.099998474121094, 15295), (\'IDFCBANK\', \'02-Aug-2018\', 1533182700, 20, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 41073, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 41073), (\'IDFCBANK\', \'02-Aug-2018\', 1533182760, 21, 39.04999923706055, 39.099998474121094, 39, 39.099998474121094, 56676, 39.04999923706055, 39.099998474121094, 39, 39.099998474121094, 56676), (\'IDFCBANK\', \'02-Aug-2018\', 1533182820, 22, 39.099998474121094, 39.099998474121094, 38.900001525878906, 38.900001525878906, 85495, 39.099998474121094, 39.099998474121094, 38.900001525878906, 38.900001525878906, 85495), (\'IDFCBANK\', \'02-Aug-2018\', 1533182880, 23, 38.900001525878906, 39, 38.900001525878906, 38.95000076293945, 99968, 38.900001525878906, 39, 38.900001525878906, 38.95000076293945, 99968), (\'IDFCBANK\', \'02-Aug-2018\', 1533182940, 24, 38.900001525878906, 38.900001525878906, 38.849998474121094, 38.849998474121094, 69413, 38.900001525878906, 38.900001525878906, 38.849998474121094, 38.849998474121094, 69413), (\'IDFCBANK\', \'02-Aug-2018\', 1533183000, 25, 38.849998474121094, 38.900001525878906, 38.849998474121094, 38.900001525878906, 24525, 38.849998474121094, 38.900001525878906, 38.849998474121094, 38.900001525878906, 24525), (\'IDFCBANK\', \'02-Aug-2018\', 1533183060, 26, 38.95000076293945, 38.95000076293945, 38.900001525878906, 38.900001525878906, 33572, 38.95000076293945, 38.95000076293945, 38.900001525878906, 38.900001525878906, 33572), (\'IDFCBANK\', \'02-Aug-2018\', 1533183120, 27, 38.900001525878906, 38.900001525878906, 38.79999923706055, 38.849998474121094, 43545, 38.900001525878906, 38.900001525878906, 38.79999923706055, 38.849998474121094, 43545), (\'IDFCBANK\', \'02-Aug-2018\', 1533183180, 28, 38.849998474121094, 38.900001525878906, 38.849998474121094, 38.849998474121094, 26154, 38.849998474121094, 38.900001525878906, 38.849998474121094, 38.849998474121094, 26154), (\'IDFCBANK\', \'02-Aug-2018\', 1533183240, 29, 38.849998474121094, 38.849998474121094, 38.849998474121094, 38.849998474121094, 83477, 38.849998474121094, 38.849998474121094, 38.849998474121094, 38.849998474121094, 83477), (\'IDFCBANK\', \'02-Aug-2018\', 1533183300, 30, 38.900001525878906, 38.900001525878906, 38.849998474121094, 38.900001525878906, 34335, 38.900001525878906, 38.900001525878906, 38.849998474121094, 38.900001525878906, 34335), (\'IDFCBANK\', \'02-Aug-2018\', 1533183360, 31, 38.900001525878906, 38.900001525878906, 38.900001525878906, 38.900001525878906, 5498, 38.900001525878906, 38.900001525878906, 38.900001525878906, 38.900001525878906, 5498), (\'IDFCBANK\', \'02-Aug-2018\', 1533183420, 32, 38.900001525878906, 38.95000076293945, 38.900001525878906, 38.95000076293945, 19121, 38.900001525878906, 38.95000076293945, 38.900001525878906, 38.95000076293945, 19121), (\'IDFCBANK\', \'02-Aug-2018\', 1533183480, 33, 38.95000076293945, 39, 38.95000076293945, 39, 10616, 38.95000076293945, 39, 38.95000076293945, 39, 10616), (\'IDFCBANK\', \'02-Aug-2018\', 1533183540, 34, 39, 39, 39, 39, 15894, 39, 39, 39, 39, 15894), (\'IDFCBANK\', \'02-Aug-2018\', 1533183600, 35, 38.95000076293945, 39, 38.95000076293945, 39, 27481, 38.95000076293945, 39, 38.95000076293945, 39, 27481), (\'IDFCBANK\', \'02-Aug-2018\', 1533183660, 36, 39, 39, 39, 39, 51644, 39, 39, 39, 39, 51644), (\'IDFCBANK\', \'02-Aug-2018\', 1533183720, 37, 39, 39, 39, 39, 30341, 39, 39, 39, 39, 30341), (\'IDFCBANK\', \'02-Aug-2018\', 1533183780, 38, 39, 39, 39, 39, 2218, 39, 39, 39, 39, 2218), (\'IDFCBANK\', \'02-Aug-2018\', 1533183840, 39, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 4609, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 4609), (\'IDFCBANK\', \'02-Aug-2018\', 1533183900, 40, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 4610, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 4610), (\'IDFCBANK\', \'02-Aug-2018\', 1533183960, 41, 39, 39, 39, 39, 18515, 39, 39, 39, 39, 18515), (\'IDFCBANK\', \'02-Aug-2018\', 1533184020, 42, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 29820, 39.04999923706055, 39.04999923706055, 39.04999923706055, 39.04999923706055, 29820), (\'IDFCBANK\', \'02-Aug-2018\', 1533184080, 43, 39, 39, 39, 39, 6364, 39, 39, 39, 39, 6364), (\'IDFCBANK\', \'02-Aug-2018\', 1533184140, 44, 39.04999923706055, 39.04999923706055, 39, 39, 3200, 39.04999923706055, 39.04999923706055, 39, 39, 3200), (\'IDFCBANK\', \'02-Aug-2018\', 1533184200, 45, 39.04999923706055, 39.099998474121094, 39.04999923706055, 39.099998474121094, 16385, 39.04999923706055, 39.099998474121094, 39.04999923706055, 39.099998474121094, 16385), (\'IDFCBANK\', \'02-Aug-2018\', 1533184260, 46, 39.099998474121094, 39.099998474121094, 39.099998474121094, 39.099998474121094, 9551, 39.099998474121094, 39.099998474121094, 39.099998474121094, 39.099998474121094, 9551), (\'IDFCBANK\', \'02-Aug-2018\', 1533184320, 47, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 37197, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 37197), (\'IDFCBANK\', \'02-Aug-2018\', 1533184380, 48, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 4825, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 4825), (\'IDFCBANK\', \'02-Aug-2018\', 1533184440, 49, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 8363, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 8363), (\'IDFCBANK\', \'02-Aug-2018\', 1533184500, 50, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 565, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 565), (\'IDFCBANK\', \'02-Aug-2018\', 1533184560, 51, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 40199, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 40199), (\'IDFCBANK\', \'02-Aug-2018\', 1533184620, 52, 39.150001525878906, 39.20000076293945, 39.150001525878906, 39.20000076293945, 7384, 39.150001525878906, 39.20000076293945, 39.150001525878906, 39.20000076293945, 7384), (\'IDFCBANK\', \'02-Aug-2018\', 1533184680, 53, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 9386, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 9386), (\'IDFCBANK\', \'02-Aug-2018\', 1533184740, 54, 39.099998474121094, 39.099998474121094, 39.099998474121094, 39.099998474121094, 3570, 39.099998474121094, 39.099998474121094, 39.099998474121094, 39.099998474121094, 3570), (\'IDFCBANK\', \'02-Aug-2018\', 1533184800, 55, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 4231, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 4231), (\'IDFCBANK\', \'02-Aug-2018\', 1533184860, 56, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 7059, 39.150001525878906, 39.150001525878906, 39.150001525878906, 39.150001525878906, 7059), (\'IDFCBANK\', \'02-Aug-2018\', 1533184920, 57, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 49769, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 49769), (\'IDFCBANK\', \'02-Aug-2018\', 1533184980, 58, 39.25, 39.45000076293945, 39.25, 39.400001525878906, 110243, 39.25, 39.45000076293945, 39.25, 39.400001525878906, 110243), (\'IDFCBANK\', \'02-Aug-2018\', 1533185040, 59, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 21281, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 21281), (\'IDFCBANK\', \'02-Aug-2018\', 1533185100, 60, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 19431, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 19431), (\'IDFCBANK\', \'02-Aug-2018\', 1533185160, 61, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3681, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3681), (\'IDFCBANK\', \'02-Aug-2018\', 1533185220, 62, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 4059, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 4059), (\'IDFCBANK\', \'02-Aug-2018\', 1533185280, 63, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 9736, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 9736), (\'IDFCBANK\', \'02-Aug-2018\', 1533185340, 64, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 211, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 211), (\'IDFCBANK\', \'02-Aug-2018\', 1533185400, 65, 39.349998474121094, 39.400001525878906, 39.29999923706055, 39.400001525878906, 18859, 39.349998474121094, 39.400001525878906, 39.29999923706055, 39.400001525878906, 18859), (\'IDFCBANK\', \'02-Aug-2018\', 1533185460, 66, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 18564, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 18564), (\'IDFCBANK\', \'02-Aug-2018\', 1533185520, 67, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 439, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 439), (\'IDFCBANK\', \'02-Aug-2018\', 1533185580, 68, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 2127, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 2127), (\'IDFCBANK\', \'02-Aug-2018\', 1533185640, 69, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 9268, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 9268), (\'IDFCBANK\', \'02-Aug-2018\', 1533185700, 70, 39.400001525878906, 39.45000076293945, 39.349998474121094, 39.45000076293945, 59407, 39.400001525878906, 39.45000076293945, 39.349998474121094, 39.45000076293945, 59407), (\'IDFCBANK\', \'02-Aug-2018\', 1533185760, 71, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 36014, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 36014), (\'IDFCBANK\', \'02-Aug-2018\', 1533185820, 72, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 2490, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 2490), (\'IDFCBANK\', \'02-Aug-2018\', 1533185880, 73, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 2245, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 2245), (\'IDFCBANK\', \'02-Aug-2018\', 1533185940, 74, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.45000076293945, 36809, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.45000076293945, 36809), (\'IDFCBANK\', \'02-Aug-2018\', 1533186000, 75, 39.45000076293945, 39.5, 39.45000076293945, 39.5, 24316, 39.45000076293945, 39.5, 39.45000076293945, 39.5, 24316), (\'IDFCBANK\', \'02-Aug-2018\', 1533186060, 76, 39.5, 39.5, 39.5, 39.5, 6149, 39.5, 39.5, 39.5, 39.5, 6149), (\'IDFCBANK\', \'02-Aug-2018\', 1533186120, 77, 39.5, 39.5, 39.45000076293945, 39.45000076293945, 38330, 39.5, 39.5, 39.45000076293945, 39.45000076293945, 38330), (\'IDFCBANK\', \'02-Aug-2018\', 1533186180, 78, 39.400001525878906, 39.5, 39.400001525878906, 39.5, 4564, 39.400001525878906, 39.5, 39.400001525878906, 39.5, 4564), (\'IDFCBANK\', \'02-Aug-2018\', 1533186240, 79, 39.45000076293945, 39.5, 39.45000076293945, 39.5, 2863, 39.45000076293945, 39.5, 39.45000076293945, 39.5, 2863), (\'IDFCBANK\', \'02-Aug-2018\', 1533186300, 80, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 4240, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 4240), (\'IDFCBANK\', \'02-Aug-2018\', 1533186360, 81, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 5285, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 5285), (\'IDFCBANK\', \'02-Aug-2018\', 1533186420, 82, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 5323, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 5323), (\'IDFCBANK\', \'02-Aug-2018\', 1533186480, 83, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 877, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 877), (\'IDFCBANK\', \'02-Aug-2018\', 1533186540, 84, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 7867, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 7867), (\'IDFCBANK\', \'02-Aug-2018\', 1533186600, 85, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 84186, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 84186), (\'IDFCBANK\', \'02-Aug-2018\', 1533186660, 86, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 8307, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 8307), (\'IDFCBANK\', \'02-Aug-2018\', 1533186720, 87, 39.25, 39.25, 39.25, 39.25, 3302, 39.25, 39.25, 39.25, 39.25, 3302), (\'IDFCBANK\', \'02-Aug-2018\', 1533186780, 88, 39.25, 39.349998474121094, 39.25, 39.349998474121094, 8051, 39.25, 39.349998474121094, 39.25, 39.349998474121094, 8051), (\'IDFCBANK\', \'02-Aug-2018\', 1533186840, 89, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 890, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 890), (\'IDFCBANK\', \'02-Aug-2018\', 1533186900, 90, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3615, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3615), (\'IDFCBANK\', \'02-Aug-2018\', 1533186960, 91, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1082, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1082), (\'IDFCBANK\', \'02-Aug-2018\', 1533187020, 92, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2112, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2112), (\'IDFCBANK\', \'02-Aug-2018\', 1533187080, 93, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 45846, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 45846), (\'IDFCBANK\', \'02-Aug-2018\', 1533187140, 94, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4734, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4734), (\'IDFCBANK\', \'02-Aug-2018\', 1533187200, 95, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 9180, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 9180), (\'IDFCBANK\', \'02-Aug-2018\', 1533187260, 96, 39.45000076293945, 39.45000076293945, 39.349998474121094, 39.349998474121094, 69177, 39.45000076293945, 39.45000076293945, 39.349998474121094, 39.349998474121094, 69177), (\'IDFCBANK\', \'02-Aug-2018\', 1533187320, 97, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4393, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4393), (\'IDFCBANK\', \'02-Aug-2018\', 1533187380, 98, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 7016, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 7016), (\'IDFCBANK\', \'02-Aug-2018\', 1533187440, 99, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 7593, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 7593), (\'IDFCBANK\', \'02-Aug-2018\', 1533187500, 100, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 17788, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 17788), (\'IDFCBANK\', \'02-Aug-2018\', 1533187560, 101, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 33093, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 33093), (\'IDFCBANK\', \'02-Aug-2018\', 1533187620, 102, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6424, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6424), (\'IDFCBANK\', \'02-Aug-2018\', 1533187680, 103, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 11556, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 11556), (\'IDFCBANK\', \'02-Aug-2018\', 1533187740, 104, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 170, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 170), (\'IDFCBANK\', \'02-Aug-2018\', 1533187800, 105, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 550, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 550), (\'IDFCBANK\', \'02-Aug-2018\', 1533187860, 106, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1684, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1684), (\'IDFCBANK\', \'02-Aug-2018\', 1533187920, 107, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 9140, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 9140), (\'IDFCBANK\', \'02-Aug-2018\', 1533187980, 108, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4593, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4593), (\'IDFCBANK\', \'02-Aug-2018\', 1533188040, 109, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 9428, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 9428), (\'IDFCBANK\', \'02-Aug-2018\', 1533188100, 110, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 6688, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 6688), (\'IDFCBANK\', \'02-Aug-2018\', 1533188160, 111, 39.400001525878906, 39.400001525878906, 39.349998474121094, 39.349998474121094, 3932, 39.400001525878906, 39.400001525878906, 39.349998474121094, 39.349998474121094, 3932), (\'IDFCBANK\', \'02-Aug-2018\', 1533188220, 112, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 43013, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 43013), (\'IDFCBANK\', \'02-Aug-2018\', 1533188280, 113, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 82660, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 82660), (\'IDFCBANK\', \'02-Aug-2018\', 1533188340, 114, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 68374, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 68374), (\'IDFCBANK\', \'02-Aug-2018\', 1533188400, 115, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 8364, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 8364), (\'IDFCBANK\', \'02-Aug-2018\', 1533188460, 116, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4893, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4893), (\'IDFCBANK\', \'02-Aug-2018\', 1533188520, 117, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1148, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1148), (\'IDFCBANK\', \'02-Aug-2018\', 1533188580, 118, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 3131, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 3131), (\'IDFCBANK\', \'02-Aug-2018\', 1533188640, 119, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 33262, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 33262), (\'IDFCBANK\', \'02-Aug-2018\', 1533188700, 120, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 782, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 782), (\'IDFCBANK\', \'02-Aug-2018\', 1533188760, 121, 39.29999923706055, 39.29999923706055, 39.25, 39.29999923706055, 22864, 39.29999923706055, 39.29999923706055, 39.25, 39.29999923706055, 22864), (\'IDFCBANK\', \'02-Aug-2018\', 1533188820, 122, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 12855, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 12855), (\'IDFCBANK\', \'02-Aug-2018\', 1533188880, 123, 39.25, 39.25, 39.25, 39.25, 1876, 39.25, 39.25, 39.25, 39.25, 1876), (\'IDFCBANK\', \'02-Aug-2018\', 1533188940, 124, 39.25, 39.25, 39.25, 39.25, 4132, 39.25, 39.25, 39.25, 39.25, 4132), (\'IDFCBANK\', \'02-Aug-2018\', 1533189000, 125, 39.25, 39.25, 39.25, 39.25, 2794, 39.25, 39.25, 39.25, 39.25, 2794), (\'IDFCBANK\', \'02-Aug-2018\', 1533189060, 126, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 2780, 39.20000076293945, 39.20000076293945, 39.20000076293945, 39.20000076293945, 2780), (\'IDFCBANK\', \'02-Aug-2018\', 1533189120, 127, 39.20000076293945, 39.25, 39.20000076293945, 39.25, 5751, 39.20000076293945, 39.25, 39.20000076293945, 39.25, 5751), (\'IDFCBANK\', \'02-Aug-2018\', 1533189180, 128, 39.25, 39.25, 39.25, 39.25, 3004, 39.25, 39.25, 39.25, 39.25, 3004), (\'IDFCBANK\', \'02-Aug-2018\', 1533189240, 129, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 3945, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 3945), (\'IDFCBANK\', \'02-Aug-2018\', 1533189300, 130, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6320, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6320), (\'IDFCBANK\', \'02-Aug-2018\', 1533189360, 131, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2922, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2922), (\'IDFCBANK\', \'02-Aug-2018\', 1533189420, 132, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 4801, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 4801), (\'IDFCBANK\', \'02-Aug-2018\', 1533189480, 133, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4667, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4667), (\'IDFCBANK\', \'02-Aug-2018\', 1533189540, 134, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1026, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1026), (\'IDFCBANK\', \'02-Aug-2018\', 1533189600, 135, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 2352, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 2352), (\'IDFCBANK\', \'02-Aug-2018\', 1533189660, 136, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4630, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4630), (\'IDFCBANK\', \'02-Aug-2018\', 1533189720, 137, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 367, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 367), (\'IDFCBANK\', \'02-Aug-2018\', 1533189780, 138, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1467, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1467), (\'IDFCBANK\', \'02-Aug-2018\', 1533189840, 139, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3115, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3115), (\'IDFCBANK\', \'02-Aug-2018\', 1533189900, 140, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2107, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2107), (\'IDFCBANK\', \'02-Aug-2018\', 1533189960, 141, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1357, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1357), (\'IDFCBANK\', \'02-Aug-2018\', 1533190020, 142, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 920, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 920), (\'IDFCBANK\', \'02-Aug-2018\', 1533190080, 143, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3351, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3351), (\'IDFCBANK\', \'02-Aug-2018\', 1533190140, 144, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 28810, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 28810), (\'IDFCBANK\', \'02-Aug-2018\', 1533190200, 145, 39.5, 39.650001525878906, 39.5, 39.650001525878906, 193280, 39.5, 39.650001525878906, 39.5, 39.650001525878906, 193280), (\'IDFCBANK\', \'02-Aug-2018\', 1533190260, 146, 39.54999923706055, 39.54999923706055, 39.45000076293945, 39.45000076293945, 41849, 39.54999923706055, 39.54999923706055, 39.45000076293945, 39.45000076293945, 41849), (\'IDFCBANK\', \'02-Aug-2018\', 1533190320, 147, 39.5, 39.54999923706055, 39.5, 39.54999923706055, 8723, 39.5, 39.54999923706055, 39.5, 39.54999923706055, 8723), (\'IDFCBANK\', \'02-Aug-2018\', 1533190380, 148, 39.5, 39.5, 39.5, 39.5, 52401, 39.5, 39.5, 39.5, 39.5, 52401), (\'IDFCBANK\', \'02-Aug-2018\', 1533190440, 149, 39.5, 39.5, 39.5, 39.5, 2888, 39.5, 39.5, 39.5, 39.5, 2888), (\'IDFCBANK\', \'02-Aug-2018\', 1533190500, 150, 39.5, 39.5, 39.5, 39.5, 10831, 39.5, 39.5, 39.5, 39.5, 10831), (\'IDFCBANK\', \'02-Aug-2018\', 1533190560, 151, 39.54999923706055, 39.599998474121094, 39.5, 39.5, 28413, 39.54999923706055, 39.599998474121094, 39.5, 39.5, 28413), (\'IDFCBANK\', \'02-Aug-2018\', 1533190620, 152, 39.5, 39.5, 39.5, 39.5, 7187, 39.5, 39.5, 39.5, 39.5, 7187), (\'IDFCBANK\', \'02-Aug-2018\', 1533190680, 153, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1141, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1141), (\'IDFCBANK\', \'02-Aug-2018\', 1533190740, 154, 39.400001525878906, 39.45000076293945, 39.400001525878906, 39.45000076293945, 19519, 39.400001525878906, 39.45000076293945, 39.400001525878906, 39.45000076293945, 19519), (\'IDFCBANK\', \'02-Aug-2018\', 1533190800, 155, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 37422, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 37422), (\'IDFCBANK\', \'02-Aug-2018\', 1533190860, 156, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 521, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 521), (\'IDFCBANK\', \'02-Aug-2018\', 1533190920, 157, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 12861, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 12861), (\'IDFCBANK\', \'02-Aug-2018\', 1533190980, 158, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1584, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1584), (\'IDFCBANK\', \'02-Aug-2018\', 1533191040, 159, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 5292, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 5292), (\'IDFCBANK\', \'02-Aug-2018\', 1533191100, 160, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 1644, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 1644), (\'IDFCBANK\', \'02-Aug-2018\', 1533191160, 161, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 182, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 182), (\'IDFCBANK\', \'02-Aug-2018\', 1533191220, 162, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 1097, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 1097), (\'IDFCBANK\', \'02-Aug-2018\', 1533191280, 163, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 4728, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 4728), (\'IDFCBANK\', \'02-Aug-2018\', 1533191340, 164, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 9650, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 9650), (\'IDFCBANK\', \'02-Aug-2018\', 1533191400, 165, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3851, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3851), (\'IDFCBANK\', \'02-Aug-2018\', 1533191460, 166, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1571, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1571), (\'IDFCBANK\', \'02-Aug-2018\', 1533191520, 167, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 3067, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 3067), (\'IDFCBANK\', \'02-Aug-2018\', 1533191580, 168, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 138, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 138), (\'IDFCBANK\', \'02-Aug-2018\', 1533191640, 169, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 732, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 732), (\'IDFCBANK\', \'02-Aug-2018\', 1533191700, 170, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 5231, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 5231), (\'IDFCBANK\', \'02-Aug-2018\', 1533191760, 171, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 7053, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 7053), (\'IDFCBANK\', \'02-Aug-2018\', 1533191820, 172, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.349998474121094, 1750, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.349998474121094, 1750), (\'IDFCBANK\', \'02-Aug-2018\', 1533191880, 173, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 142, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 142), (\'IDFCBANK\', \'02-Aug-2018\', 1533191940, 174, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1129, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1129), (\'IDFCBANK\', \'02-Aug-2018\', 1533192000, 175, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1267, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1267), (\'IDFCBANK\', \'02-Aug-2018\', 1533192060, 176, 39.5, 39.5, 39.400001525878906, 39.400001525878906, 116330, 39.5, 39.5, 39.400001525878906, 39.400001525878906, 116330), (\'IDFCBANK\', \'02-Aug-2018\', 1533192120, 177, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 30807, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 30807), (\'IDFCBANK\', \'02-Aug-2018\', 1533192180, 178, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1527, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1527), (\'IDFCBANK\', \'02-Aug-2018\', 1533192240, 179, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 14593, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 14593), (\'IDFCBANK\', \'02-Aug-2018\', 1533192300, 180, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6618, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6618), (\'IDFCBANK\', \'02-Aug-2018\', 1533192360, 181, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 25426, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 25426), (\'IDFCBANK\', \'02-Aug-2018\', 1533192420, 182, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 16016, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 16016), (\'IDFCBANK\', \'02-Aug-2018\', 1533192480, 183, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6726, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6726), (\'IDFCBANK\', \'02-Aug-2018\', 1533192540, 184, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 11706, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 11706), (\'IDFCBANK\', \'02-Aug-2018\', 1533192600, 185, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 718, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 718), (\'IDFCBANK\', \'02-Aug-2018\', 1533192660, 186, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 2020, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 2020), (\'IDFCBANK\', \'02-Aug-2018\', 1533192720, 187, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 6015, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 6015), (\'IDFCBANK\', \'02-Aug-2018\', 1533192780, 188, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 11146, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 11146), (\'IDFCBANK\', \'02-Aug-2018\', 1533192840, 189, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3045, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3045), (\'IDFCBANK\', \'02-Aug-2018\', 1533192900, 190, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 6672, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 6672), (\'IDFCBANK\', \'02-Aug-2018\', 1533192960, 191, 39.32499885559082, 39.35000038146973, 39.29999923706055, 39.32500076293945, 15107.5, 39.32499885559082, 39.35000038146973, 39.29999923706055, 39.32500076293945, 15107.5), (\'IDFCBANK\', \'02-Aug-2018\', 1533193020, 192, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 23543, 39.29999923706055, 39.29999923706055, 39.25, 39.25, 23543), (\'IDFCBANK\', \'02-Aug-2018\', 1533193080, 193, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 11246, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 11246), (\'IDFCBANK\', \'02-Aug-2018\', 1533193140, 194, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3426, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3426), (\'IDFCBANK\', \'02-Aug-2018\', 1533193200, 195, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 6526, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 6526), (\'IDFCBANK\', \'02-Aug-2018\', 1533193260, 196, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 26495, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 26495), (\'IDFCBANK\', \'02-Aug-2018\', 1533193320, 197, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 8636, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 8636), (\'IDFCBANK\', \'02-Aug-2018\', 1533193380, 198, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 11063, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 11063), (\'IDFCBANK\', \'02-Aug-2018\', 1533193440, 199, 39.32499885559082, 39.32499885559082, 39.29999923706055, 39.29999923706055, 5999, 39.32499885559082, 39.32499885559082, 39.29999923706055, 39.29999923706055, 5999), (\'IDFCBANK\', \'02-Aug-2018\', 1533193500, 200, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 935, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 935), (\'IDFCBANK\', \'02-Aug-2018\', 1533193560, 201, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3266, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3266), (\'IDFCBANK\', \'02-Aug-2018\', 1533193620, 202, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 10532, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 10532), (\'IDFCBANK\', \'02-Aug-2018\', 1533193680, 203, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1485, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1485), (\'IDFCBANK\', \'02-Aug-2018\', 1533193740, 204, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6605, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6605), (\'IDFCBANK\', \'02-Aug-2018\', 1533193800, 205, 39.5, 39.5, 39.5, 39.5, 49539, 39.5, 39.5, 39.5, 39.5, 49539), (\'IDFCBANK\', \'02-Aug-2018\', 1533193860, 206, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 24820, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 24820), (\'IDFCBANK\', \'02-Aug-2018\', 1533193920, 207, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 29903, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 29903), (\'IDFCBANK\', \'02-Aug-2018\', 1533193980, 208, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 19302, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 19302), (\'IDFCBANK\', \'02-Aug-2018\', 1533194040, 209, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 10577, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 10577), (\'IDFCBANK\', \'02-Aug-2018\', 1533194100, 210, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 11689, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 11689), (\'IDFCBANK\', \'02-Aug-2018\', 1533194160, 211, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 20707, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 20707), (\'IDFCBANK\', \'02-Aug-2018\', 1533194220, 212, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 12140, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 12140), (\'IDFCBANK\', \'02-Aug-2018\', 1533194280, 213, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 35107, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 35107), (\'IDFCBANK\', \'02-Aug-2018\', 1533194340, 214, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 12711, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 12711), (\'IDFCBANK\', \'02-Aug-2018\', 1533194400, 215, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3849, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3849), (\'IDFCBANK\', \'02-Aug-2018\', 1533194460, 216, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 81976, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 81976), (\'IDFCBANK\', \'02-Aug-2018\', 1533194520, 217, 39.400001525878906, 39.400001525878906, 39.29999923706055, 39.29999923706055, 27878, 39.400001525878906, 39.400001525878906, 39.29999923706055, 39.29999923706055, 27878), (\'IDFCBANK\', \'02-Aug-2018\', 1533194580, 218, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 12743, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 12743), (\'IDFCBANK\', \'02-Aug-2018\', 1533194640, 219, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 8184, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 8184), (\'IDFCBANK\', \'02-Aug-2018\', 1533194700, 220, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3625, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3625), (\'IDFCBANK\', \'02-Aug-2018\', 1533194760, 221, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3568, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3568), (\'IDFCBANK\', \'02-Aug-2018\', 1533194820, 222, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3531, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3531), (\'IDFCBANK\', \'02-Aug-2018\', 1533194880, 223, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3722, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3722), (\'IDFCBANK\', \'02-Aug-2018\', 1533194940, 224, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 497, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 497), (\'IDFCBANK\', \'02-Aug-2018\', 1533195000, 225, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 390, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 390), (\'IDFCBANK\', \'02-Aug-2018\', 1533195060, 226, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1153, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1153), (\'IDFCBANK\', \'02-Aug-2018\', 1533195120, 227, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2148, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2148), (\'IDFCBANK\', \'02-Aug-2018\', 1533195180, 228, 39.32499885559082, 39.32499885559082, 39.32499885559082, 39.32499885559082, 25219, 39.32499885559082, 39.32499885559082, 39.32499885559082, 39.32499885559082, 25219), (\'IDFCBANK\', \'02-Aug-2018\', 1533195240, 229, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 48290, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 48290), (\'IDFCBANK\', \'02-Aug-2018\', 1533195300, 230, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4666, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4666), (\'IDFCBANK\', \'02-Aug-2018\', 1533195360, 231, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 431, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 431), (\'IDFCBANK\', \'02-Aug-2018\', 1533195420, 232, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 189, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 189), (\'IDFCBANK\', \'02-Aug-2018\', 1533195480, 233, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1809, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1809), (\'IDFCBANK\', \'02-Aug-2018\', 1533195540, 234, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 162, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 162), (\'IDFCBANK\', \'02-Aug-2018\', 1533195600, 235, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1080, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1080), (\'IDFCBANK\', \'02-Aug-2018\', 1533195660, 236, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6990, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 6990), (\'IDFCBANK\', \'02-Aug-2018\', 1533195720, 237, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2919, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 2919), (\'IDFCBANK\', \'02-Aug-2018\', 1533195780, 238, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 819, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 819), (\'IDFCBANK\', \'02-Aug-2018\', 1533195840, 239, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3577, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 3577), (\'IDFCBANK\', \'02-Aug-2018\', 1533195900, 240, 39.375, 39.375, 39.375, 39.375, 4188.5, 39.375, 39.375, 39.375, 39.375, 4188.5), (\'IDFCBANK\', \'02-Aug-2018\', 1533195960, 241, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4800, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 4800), (\'IDFCBANK\', \'02-Aug-2018\', 1533196020, 242, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 1813, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 1813), (\'IDFCBANK\', \'02-Aug-2018\', 1533196080, 243, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 404, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 404), (\'IDFCBANK\', \'02-Aug-2018\', 1533196140, 244, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1390, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1390), (\'IDFCBANK\', \'02-Aug-2018\', 1533196200, 245, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 124, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 124), (\'IDFCBANK\', \'02-Aug-2018\', 1533196260, 246, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 12890, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 12890), (\'IDFCBANK\', \'02-Aug-2018\', 1533196320, 247, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1750, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1750), (\'IDFCBANK\', \'02-Aug-2018\', 1533196380, 248, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 2586, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 2586), (\'IDFCBANK\', \'02-Aug-2018\', 1533196440, 249, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 8427, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 8427), (\'IDFCBANK\', \'02-Aug-2018\', 1533196500, 250, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 157, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 157), (\'IDFCBANK\', \'02-Aug-2018\', 1533196560, 251, 39.400001525878906, 39.400001525878906, 39.29999923706055, 39.29999923706055, 3849, 39.400001525878906, 39.400001525878906, 39.29999923706055, 39.29999923706055, 3849), (\'IDFCBANK\', \'02-Aug-2018\', 1533196620, 252, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 2466, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 2466), (\'IDFCBANK\', \'02-Aug-2018\', 1533196680, 253, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 94, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 94), (\'IDFCBANK\', \'02-Aug-2018\', 1533196740, 254, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1219, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 1219), (\'IDFCBANK\', \'02-Aug-2018\', 1533196800, 255, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 1412, 39.29999923706055, 39.349998474121094, 39.29999923706055, 39.349998474121094, 1412), (\'IDFCBANK\', \'02-Aug-2018\', 1533196860, 256, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 869, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 869), (\'IDFCBANK\', \'02-Aug-2018\', 1533196920, 257, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 646, 39.349998474121094, 39.349998474121094, 39.29999923706055, 39.29999923706055, 646), (\'IDFCBANK\', \'02-Aug-2018\', 1533196980, 258, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1656, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1656), (\'IDFCBANK\', \'02-Aug-2018\', 1533197040, 259, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1418, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 1418), (\'IDFCBANK\', \'02-Aug-2018\', 1533197100, 260, 39.32499885559082, 39.32499885559082, 39.32499885559082, 39.32499885559082, 944.5, 39.32499885559082, 39.32499885559082, 39.32499885559082, 39.32499885559082, 944.5), (\'IDFCBANK\', \'02-Aug-2018\', 1533197160, 261, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 471, 39.29999923706055, 39.29999923706055, 39.29999923706055, 39.29999923706055, 471), (\'IDFCBANK\', \'02-Aug-2018\', 1533197220, 262, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 29249, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 29249), (\'IDFCBANK\', \'02-Aug-2018\', 1533197280, 263, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 475, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 475), (\'IDFCBANK\', \'02-Aug-2018\', 1533197340, 264, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 284, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 284), (\'IDFCBANK\', \'02-Aug-2018\', 1533197400, 265, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3391, 39.349998474121094, 39.349998474121094, 39.349998474121094, 39.349998474121094, 3391), (\'IDFCBANK\', \'02-Aug-2018\', 1533197460, 266, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 14811, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 14811), (\'IDFCBANK\', \'02-Aug-2018\', 1533197520, 267, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 7455, 39.349998474121094, 39.400001525878906, 39.349998474121094, 39.400001525878906, 7455), (\'IDFCBANK\', \'02-Aug-2018\', 1533197580, 268, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1279, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1279), (\'IDFCBANK\', \'02-Aug-2018\', 1533197640, 269, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 4051, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 4051), (\'IDFCBANK\', \'02-Aug-2018\', 1533197700, 270, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 15270, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 15270), (\'IDFCBANK\', \'02-Aug-2018\', 1533197760, 271, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 412, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 412), (\'IDFCBANK\', \'02-Aug-2018\', 1533197820, 272, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 1879, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 1879), (\'IDFCBANK\', \'02-Aug-2018\', 1533197880, 273, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 6684, 39.45000076293945, 39.45000076293945, 39.400001525878906, 39.400001525878906, 6684), (\'IDFCBANK\', \'02-Aug-2018\', 1533197940, 274, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1721, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1721), (\'IDFCBANK\', \'02-Aug-2018\', 1533198000, 275, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 3468, 39.45000076293945, 39.45000076293945, 39.45000076293945, 39.45000076293945, 3468), (\'IDFCBANK\', \'02-Aug-2018\', 1533198060, 276, 39.42500114440918, 39.42500114440918, 39.42500114440918, 39.42500114440918, 2391, 39.42500114440918, 39.42500114440918, 39.42500114440918, 39.42500114440918, 2391), (\'IDFCBANK\', \'02-Aug-2018\', 1533198120, 277, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1314, 39.400001525878906, 39.400001525878906, 39.400001525878906, 39.400001525878906, 1314), (\'IDFCBANK\', \'02-Aug-2018\', 1533198180, 278, 39.5, 39.54999923706055, 39.5, 39.54999923706055, 35144, 39.5, 39.54999923706055, 39.5, 39.54999923706055, 35144), (\'IDFCBANK\', \'02-Aug-2018\', 1533198240, 279, 39.599998474121094, 39.650001525878906, 39.599998474121094, 39.650001525878906, 77983, 39.599998474121094, 39.650001525878906, 39.599998474121094, 39.650001525878906, 77983), (\'IDFCBANK\', \'02-Aug-2018\', 1533198300, 280, 39.70000076293945, 40.099998474121094, 39.70000076293945, 40, 481730, 39.70000076293945, 40.099998474121094, 39.70000076293945, 40, 481730), (\'IDFCBANK\', \'02-Aug-2018\', 1533198360, 281, 39.95000076293945, 39.95000076293945, 39.900001525878906, 39.95000076293945, 239932, 39.95000076293945, 39.95000076293945, 39.900001525878906, 39.95000076293945, 239932), (\'IDFCBANK\', \'02-Aug-2018\', 1533198420, 282, 40.04999923706055, 40.04999923706055, 40, 40, 123200, 40.04999923706055, 40.04999923706055, 40, 40, 123200), (\'IDFCBANK\', \'02-Aug-2018\', 1533198480, 283, 39.95000076293945, 40.04999923706055, 39.95000076293945, 40, 52552, 39.95000076293945, 40.04999923706055, 39.95000076293945, 40, 52552), (\'IDFCBANK\', \'02-Aug-2018\', 1533198540, 284, 40.04999923706055, 40.04999923706055, 40, 40, 23060, 40.04999923706055, 40.04999923706055, 40, 40, 23060), (\'IDFCBANK\', \'02-Aug-2018\', 1533198600, 285, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 42415, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 42415), (\'IDFCBANK\', \'02-Aug-2018\', 1533198660, 286, 40.04999923706055, 40.099998474121094, 40.04999923706055, 40.099998474121094, 35822, 40.04999923706055, 40.099998474121094, 40.04999923706055, 40.099998474121094, 35822), (\'IDFCBANK\', \'02-Aug-2018\', 1533198720, 287, 40.150001525878906, 40.20000076293945, 40.150001525878906, 40.20000076293945, 78707, 40.150001525878906, 40.20000076293945, 40.150001525878906, 40.20000076293945, 78707), (\'IDFCBANK\', \'02-Aug-2018\', 1533198780, 288, 40.20000076293945, 40.20000076293945, 40.150001525878906, 40.150001525878906, 38802, 40.20000076293945, 40.20000076293945, 40.150001525878906, 40.150001525878906, 38802), (\'IDFCBANK\', \'02-Aug-2018\', 1533198840, 289, 40.150001525878906, 40.150001525878906, 40, 40, 136078, 40.150001525878906, 40.150001525878906, 40, 40, 136078), (\'IDFCBANK\', \'02-Aug-2018\', 1533198900, 290, 40.04999923706055, 40.04999923706055, 40, 40, 12728, 40.04999923706055, 40.04999923706055, 40, 40, 12728), (\'IDFCBANK\', \'02-Aug-2018\', 1533198960, 291, 40, 40, 40, 40, 21887, 40, 40, 40, 40, 21887), (\'IDFCBANK\', \'02-Aug-2018\', 1533199020, 292, 40, 40, 40, 40, 52056, 40, 40, 40, 40, 52056), (\'IDFCBANK\', \'02-Aug-2018\', 1533199080, 293, 40, 40, 40, 40, 20139, 40, 40, 40, 40, 20139), (\'IDFCBANK\', \'02-Aug-2018\', 1533199140, 294, 39.95000076293945, 40, 39.95000076293945, 40, 34074, 39.95000076293945, 40, 39.95000076293945, 40, 34074), (\'IDFCBANK\', \'02-Aug-2018\', 1533199200, 295, 39.95000076293945, 39.95000076293945, 39.95000076293945, 39.95000076293945, 31631, 39.95000076293945, 39.95000076293945, 39.95000076293945, 39.95000076293945, 31631), (\'IDFCBANK\', \'02-Aug-2018\', 1533199260, 296, 40.04999923706055, 40.04999923706055, 40, 40, 17745, 40.04999923706055, 40.04999923706055, 40, 40, 17745), (\'IDFCBANK\', \'02-Aug-2018\', 1533199320, 297, 40, 40, 40, 40, 5907, 40, 40, 40, 40, 5907), (\'IDFCBANK\', \'02-Aug-2018\', 1533199380, 298, 40.04999923706055, 40.04999923706055, 40, 40, 5129, 40.04999923706055, 40.04999923706055, 40, 40, 5129), (\'IDFCBANK\', \'02-Aug-2018\', 1533199440, 299, 40, 40, 40, 40, 16436, 40, 40, 40, 40, 16436), (\'IDFCBANK\', \'02-Aug-2018\', 1533199500, 300, 40, 40, 39.95000076293945, 39.95000076293945, 27515, 40, 40, 39.95000076293945, 39.95000076293945, 27515), (\'IDFCBANK\', \'02-Aug-2018\', 1533199560, 301, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 55197, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 55197), (\'IDFCBANK\', \'02-Aug-2018\', 1533199620, 302, 40.04999923706055, 40.04999923706055, 39.95000076293945, 39.95000076293945, 29792, 40.04999923706055, 40.04999923706055, 39.95000076293945, 39.95000076293945, 29792), (\'IDFCBANK\', \'02-Aug-2018\', 1533199680, 303, 39.95000076293945, 40, 39.95000076293945, 40, 2982, 39.95000076293945, 40, 39.95000076293945, 40, 2982), (\'IDFCBANK\', \'02-Aug-2018\', 1533199740, 304, 40, 40, 40, 40, 64034, 40, 40, 40, 40, 64034), (\'IDFCBANK\', \'02-Aug-2018\', 1533199800, 305, 40, 40, 40, 40, 43565, 40, 40, 40, 40, 43565), (\'IDFCBANK\', \'02-Aug-2018\', 1533199860, 306, 40.04999923706055, 40.04999923706055, 40, 40, 24744, 40.04999923706055, 40.04999923706055, 40, 40, 24744), (\'IDFCBANK\', \'02-Aug-2018\', 1533199920, 307, 39.95000076293945, 40.04999923706055, 39.95000076293945, 40.04999923706055, 33991, 39.95000076293945, 40.04999923706055, 39.95000076293945, 40.04999923706055, 33991), (\'IDFCBANK\', \'02-Aug-2018\', 1533199980, 308, 40, 40, 40, 40, 23985, 40, 40, 40, 40, 23985), (\'IDFCBANK\', \'02-Aug-2018\', 1533200040, 309, 40.04999923706055, 40.04999923706055, 40, 40, 10661, 40.04999923706055, 40.04999923706055, 40, 40, 10661), (\'IDFCBANK\', \'02-Aug-2018\', 1533200100, 310, 40, 40, 40, 40, 26306, 40, 40, 40, 40, 26306), (\'IDFCBANK\', \'02-Aug-2018\', 1533200160, 311, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 89210, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 89210), (\'IDFCBANK\', \'02-Aug-2018\', 1533200220, 312, 40, 40, 40, 40, 29664, 40, 40, 40, 40, 29664), (\'IDFCBANK\', \'02-Aug-2018\', 1533200280, 313, 40, 40, 40, 40, 54321, 40, 40, 40, 40, 54321), (\'IDFCBANK\', \'02-Aug-2018\', 1533200340, 314, 40, 40, 40, 40, 4856, 40, 40, 40, 40, 4856), (\'IDFCBANK\', \'02-Aug-2018\', 1533200400, 315, 39.95000076293945, 40, 39.95000076293945, 40, 13560, 39.95000076293945, 40, 39.95000076293945, 40, 13560), (\'IDFCBANK\', \'02-Aug-2018\', 1533200460, 316, 40, 40, 40, 40, 23945, 40, 40, 40, 40, 23945), (\'IDFCBANK\', \'02-Aug-2018\', 1533200520, 317, 40, 40, 40, 40, 7290, 40, 40, 40, 40, 7290), (\'IDFCBANK\', \'02-Aug-2018\', 1533200580, 318, 40, 40, 40, 40, 1398, 40, 40, 40, 40, 1398), (\'IDFCBANK\', \'02-Aug-2018\', 1533200640, 319, 40, 40, 40, 40, 6221, 40, 40, 40, 40, 6221), (\'IDFCBANK\', \'02-Aug-2018\', 1533200700, 320, 40, 40, 40, 40, 21996, 40, 40, 40, 40, 21996), (\'IDFCBANK\', \'02-Aug-2018\', 1533200760, 321, 39.95000076293945, 39.95000076293945, 39.95000076293945, 39.95000076293945, 23206, 39.95000076293945, 39.95000076293945, 39.95000076293945, 39.95000076293945, 23206), (\'IDFCBANK\', \'02-Aug-2018\', 1533200820, 322, 40, 40.04999923706055, 40, 40.04999923706055, 45665, 40, 40.04999923706055, 40, 40.04999923706055, 45665), (\'IDFCBANK\', \'02-Aug-2018\', 1533200880, 323, 39.95000076293945, 39.95000076293945, 39.95000076293945, 39.95000076293945, 35498, 39.95000076293945, 39.95000076293945, 39.95000076293945, 39.95000076293945, 35498), (\'IDFCBANK\', \'02-Aug-2018\', 1533200940, 324, 40, 40, 40, 40, 51262, 40, 40, 40, 40, 51262), (\'IDFCBANK\', \'02-Aug-2018\', 1533201000, 325, 40, 40, 39.95000076293945, 39.95000076293945, 79718, 40, 40, 39.95000076293945, 39.95000076293945, 79718), (\'IDFCBANK\', \'02-Aug-2018\', 1533201060, 326, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 16410, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 16410), (\'IDFCBANK\', \'02-Aug-2018\', 1533201120, 327, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 3293, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 3293), (\'IDFCBANK\', \'02-Aug-2018\', 1533201180, 328, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 3668, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 3668), (\'IDFCBANK\', \'02-Aug-2018\', 1533201240, 329, 40.20000076293945, 40.20000076293945, 40.150001525878906, 40.150001525878906, 113979, 40.20000076293945, 40.20000076293945, 40.150001525878906, 40.150001525878906, 113979), (\'IDFCBANK\', \'02-Aug-2018\', 1533201300, 330, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 30607, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 30607), (\'IDFCBANK\', \'02-Aug-2018\', 1533201360, 331, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 15588, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 15588), (\'IDFCBANK\', \'02-Aug-2018\', 1533201420, 332, 40.20000076293945, 40.20000076293945, 40.150001525878906, 40.150001525878906, 54663, 40.20000076293945, 40.20000076293945, 40.150001525878906, 40.150001525878906, 54663), (\'IDFCBANK\', \'02-Aug-2018\', 1533201480, 333, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 12494, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 12494), (\'IDFCBANK\', \'02-Aug-2018\', 1533201540, 334, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 45141, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 45141), (\'IDFCBANK\', \'02-Aug-2018\', 1533201600, 335, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 5295, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 5295), (\'IDFCBANK\', \'02-Aug-2018\', 1533201660, 336, 40.150001525878906, 40.150001525878906, 40.099998474121094, 40.099998474121094, 9899, 40.150001525878906, 40.150001525878906, 40.099998474121094, 40.099998474121094, 9899), (\'IDFCBANK\', \'02-Aug-2018\', 1533201720, 337, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 3603, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 3603), (\'IDFCBANK\', \'02-Aug-2018\', 1533201780, 338, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 35577, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 35577), (\'IDFCBANK\', \'02-Aug-2018\', 1533201840, 339, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 4166, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 4166), (\'IDFCBANK\', \'02-Aug-2018\', 1533201900, 340, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 2836, 40.150001525878906, 40.150001525878906, 40.150001525878906, 40.150001525878906, 2836), (\'IDFCBANK\', \'02-Aug-2018\', 1533201960, 341, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 8967, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 8967), (\'IDFCBANK\', \'02-Aug-2018\', 1533202020, 342, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 13969, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 13969), (\'IDFCBANK\', \'02-Aug-2018\', 1533202080, 343, 40, 40, 40, 40, 35592, 40, 40, 40, 40, 35592), (\'IDFCBANK\', \'02-Aug-2018\', 1533202140, 344, 40, 40, 40, 40, 34132, 40, 40, 40, 40, 34132), (\'IDFCBANK\', \'02-Aug-2018\', 1533202200, 345, 40.099998474121094, 40.099998474121094, 40.04999923706055, 40.04999923706055, 96790, 40.099998474121094, 40.099998474121094, 40.04999923706055, 40.04999923706055, 96790), (\'IDFCBANK\', \'02-Aug-2018\', 1533202260, 346, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 77549, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 77549), (\'IDFCBANK\', \'02-Aug-2018\', 1533202320, 347, 40.04999923706055, 40.04999923706055, 40, 40, 65930, 40.04999923706055, 40.04999923706055, 40, 40, 65930), (\'IDFCBANK\', \'02-Aug-2018\', 1533202380, 348, 39.900001525878906, 39.900001525878906, 39.900001525878906, 39.900001525878906, 22857, 39.900001525878906, 39.900001525878906, 39.900001525878906, 39.900001525878906, 22857), (\'IDFCBANK\', \'02-Aug-2018\', 1533202440, 349, 39.900001525878906, 39.95000076293945, 39.900001525878906, 39.95000076293945, 93633, 39.900001525878906, 39.95000076293945, 39.900001525878906, 39.95000076293945, 93633), (\'IDFCBANK\', \'02-Aug-2018\', 1533202500, 350, 40, 40, 40, 40, 35141, 40, 40, 40, 40, 35141), (\'IDFCBANK\', \'02-Aug-2018\', 1533202560, 351, 39.900001525878906, 40, 39.900001525878906, 40, 66725, 39.900001525878906, 40, 39.900001525878906, 40, 66725), (\'IDFCBANK\', \'02-Aug-2018\', 1533202620, 352, 40, 40, 40, 40, 204595, 40, 40, 40, 40, 204595), (\'IDFCBANK\', \'02-Aug-2018\', 1533202680, 353, 39.95000076293945, 40, 39.95000076293945, 40, 114754, 39.95000076293945, 40, 39.95000076293945, 40, 114754), (\'IDFCBANK\', \'02-Aug-2018\', 1533202740, 354, 40.04999923706055, 40.04999923706055, 40, 40, 35301, 40.04999923706055, 40.04999923706055, 40, 40, 35301), (\'IDFCBANK\', \'02-Aug-2018\', 1533202800, 355, 40, 40.04999923706055, 40, 40, 48702, 40, 40.04999923706055, 40, 40, 48702), (\'IDFCBANK\', \'02-Aug-2018\', 1533202860, 356, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 48816, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 48816), (\'IDFCBANK\', \'02-Aug-2018\', 1533202920, 357, 40, 40.099998474121094, 40, 40.099998474121094, 37071, 40, 40.099998474121094, 40, 40.099998474121094, 37071), (\'IDFCBANK\', \'02-Aug-2018\', 1533202980, 358, 40, 40, 40, 40, 89861, 40, 40, 40, 40, 89861), (\'IDFCBANK\', \'02-Aug-2018\', 1533203040, 359, 40, 40, 40, 40, 122206, 40, 40, 40, 40, 122206), (\'IDFCBANK\', \'02-Aug-2018\', 1533203100, 360, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 19548, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 19548), (\'IDFCBANK\', \'02-Aug-2018\', 1533203160, 361, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 111454, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 111454), (\'IDFCBANK\', \'02-Aug-2018\', 1533203220, 362, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 74139, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 74139), (\'IDFCBANK\', \'02-Aug-2018\', 1533203280, 363, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 73795, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 73795), (\'IDFCBANK\', \'02-Aug-2018\', 1533203340, 364, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 85020, 40.04999923706055, 40.04999923706055, 40.04999923706055, 40.04999923706055, 85020), (\'IDFCBANK\', \'02-Aug-2018\', 1533203400, 365, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 291383, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 291383), (\'IDFCBANK\', \'02-Aug-2018\', 1533203460, 366, 40.099998474121094, 40.099998474121094, 40.04999923706055, 40.04999923706055, 10744, 40.099998474121094, 40.099998474121094, 40.04999923706055, 40.04999923706055, 10744), (\'IDFCBANK\', \'02-Aug-2018\', 1533203520, 367, 40.04999923706055, 40.099998474121094, 40.04999923706055, 40.099998474121094, 45646, 40.04999923706055, 40.099998474121094, 40.04999923706055, 40.099998474121094, 45646), (\'IDFCBANK\', \'02-Aug-2018\', 1533203580, 368, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 179773, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 179773), (\'IDFCBANK\', \'02-Aug-2018\', 1533203640, 369, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 135979, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 135979), (\'IDFCBANK\', \'02-Aug-2018\', 1533203700, 370, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 141038, 40.099998474121094, 40.099998474121094, 40.099998474121094, 40.099998474121094, 141038), (\'IDFCBANK\', \'02-Aug-2018\', 1533203760, 371, 40.25, 40.29999923706055, 40.25, 40.29999923706055, 193020, 40.25, 40.29999923706055, 40.25, 40.29999923706055, 193020), (\'IDFCBANK\', \'02-Aug-2018\', 1533203820, 372, 40.400001525878906, 40.400001525878906, 40.349998474121094, 40.349998474121094, 333405, 40.400001525878906, 40.400001525878906, 40.349998474121094, 40.349998474121094, 333405), (\'IDFCBANK\', \'02-Aug-2018\', 1533203880, 373, 40.25, 40.25, 40.25, 40.25, 55183, 40.25, 40.25, 40.25, 40.25, 55183), (\'IDFCBANK\', \'02-Aug-2018\', 1533203940, 374, 40.400001525878906, 40.400001525878906, 40.099998474121094, 40.099998474121094, 97174, 40.400001525878906, 40.400001525878906, 40.099998474121094, 40.099998474121094, 97174), (\'IDFCBANK\', \'03-Aug-2018\', 1533267900, 0, 40.79999923706055, 41, 40.79999923706055, 41, 401837, 40.79999923706055, 41, 40.79999923706055, 41, 401837), (\'IDFCBANK\', \'03-Aug-2018\', 1533267960, 1, 41.099998474121094, 41.349998474121094, 41.099998474121094, 41.349998474121094, 220034, 41.099998474121094, 41.349998474121094, 41.099998474121094, 41.349998474121094, 220034), (\'IDFCBANK\', \'03-Aug-2018\', 1533268020, 2, 41.349998474121094, 41.349998474121094, 41.25, 41.25, 436003, 41.349998474121094, 41.349998474121094, 41.25, 41.25, 436003), (\'IDFCBANK\', \'03-Aug-2018\', 1533268080, 3, 41.349998474121094, 41.349998474121094, 41.29999923706055, 41.29999923706055, 157777, 41.349998474121094, 41.349998474121094, 41.29999923706055, 41.29999923706055, 157777), (\'IDFCBANK\', \'03-Aug-2018\', 1533268140, 4, 41.25, 41.29999923706055, 41.25, 41.25, 76355, 41.25, 41.29999923706055, 41.25, 41.25, 76355), (\'IDFCBANK\', \'03-Aug-2018\', 1533268200, 5, 41.25, 41.25, 41, 41, 304715, 41.25, 41.25, 41, 41, 304715), (\'IDFCBANK\', \'03-Aug-2018\', 1533268260, 6, 41, 41.04999923706055, 41, 41.04999923706055, 113692, 41, 41.04999923706055, 41, 41.04999923706055, 113692), (\'IDFCBANK\', \'03-Aug-2018\', 1533268320, 7, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 73609, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 73609), (\'IDFCBANK\', \'03-Aug-2018\', 1533268380, 8, 41.04999923706055, 41.04999923706055, 41, 41, 250390, 41.04999923706055, 41.04999923706055, 41, 41, 250390), (\'IDFCBANK\', \'03-Aug-2018\', 1533268440, 9, 41, 41.04999923706055, 41, 41, 87437, 41, 41.04999923706055, 41, 41, 87437), (\'IDFCBANK\', \'03-Aug-2018\', 1533268500, 10, 41.04999923706055, 41.04999923706055, 40.95000076293945, 41, 17191, 41.04999923706055, 41.04999923706055, 40.95000076293945, 41, 17191), (\'IDFCBANK\', \'03-Aug-2018\', 1533268560, 11, 41, 41.04999923706055, 41, 41.04999923706055, 100234, 41, 41.04999923706055, 41, 41.04999923706055, 100234), (\'IDFCBANK\', \'03-Aug-2018\', 1533268620, 12, 40.95000076293945, 40.95000076293945, 40.900001525878906, 40.900001525878906, 71080, 40.95000076293945, 40.95000076293945, 40.900001525878906, 40.900001525878906, 71080), (\'IDFCBANK\', \'03-Aug-2018\', 1533268680, 13, 40.95000076293945, 41, 40.95000076293945, 41, 70634, 40.95000076293945, 41, 40.95000076293945, 41, 70634), (\'IDFCBANK\', \'03-Aug-2018\', 1533268740, 14, 41, 41, 40.95000076293945, 41, 18674, 41, 41, 40.95000076293945, 41, 18674), (\'IDFCBANK\', \'03-Aug-2018\', 1533268800, 15, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.95000076293945, 12867, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.95000076293945, 12867), (\'IDFCBANK\', \'03-Aug-2018\', 1533268860, 16, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.95000076293945, 94673, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.95000076293945, 94673), (\'IDFCBANK\', \'03-Aug-2018\', 1533268920, 17, 40.900001525878906, 40.900001525878906, 40.75, 40.79999923706055, 165845, 40.900001525878906, 40.900001525878906, 40.75, 40.79999923706055, 165845), (\'IDFCBANK\', \'03-Aug-2018\', 1533268980, 18, 40.70000076293945, 40.75, 40.70000076293945, 40.70000076293945, 43860, 40.70000076293945, 40.75, 40.70000076293945, 40.70000076293945, 43860), (\'IDFCBANK\', \'03-Aug-2018\', 1533269040, 19, 40.70000076293945, 40.70000076293945, 40.400001525878906, 40.400001525878906, 626468, 40.70000076293945, 40.70000076293945, 40.400001525878906, 40.400001525878906, 626468), (\'IDFCBANK\', \'03-Aug-2018\', 1533269100, 20, 40.5, 40.5, 40.5, 40.5, 85917, 40.5, 40.5, 40.5, 40.5, 85917), (\'IDFCBANK\', \'03-Aug-2018\', 1533269160, 21, 40.5, 40.5, 40.45000076293945, 40.5, 83653, 40.5, 40.5, 40.45000076293945, 40.5, 83653), (\'IDFCBANK\', \'03-Aug-2018\', 1533269220, 22, 40.54999923706055, 40.650001525878906, 40.54999923706055, 40.599998474121094, 146803, 40.54999923706055, 40.650001525878906, 40.54999923706055, 40.599998474121094, 146803), (\'IDFCBANK\', \'03-Aug-2018\', 1533269280, 23, 40.599998474121094, 40.70000076293945, 40.599998474121094, 40.70000076293945, 32801, 40.599998474121094, 40.70000076293945, 40.599998474121094, 40.70000076293945, 32801), (\'IDFCBANK\', \'03-Aug-2018\', 1533269340, 24, 40.599998474121094, 40.650001525878906, 40.54999923706055, 40.54999923706055, 204460, 40.599998474121094, 40.650001525878906, 40.54999923706055, 40.54999923706055, 204460), (\'IDFCBANK\', \'03-Aug-2018\', 1533269400, 25, 40.54999923706055, 40.599998474121094, 40.54999923706055, 40.599998474121094, 27747, 40.54999923706055, 40.599998474121094, 40.54999923706055, 40.599998474121094, 27747), (\'IDFCBANK\', \'03-Aug-2018\', 1533269460, 26, 40.54999923706055, 40.650001525878906, 40.54999923706055, 40.599998474121094, 69638, 40.54999923706055, 40.650001525878906, 40.54999923706055, 40.599998474121094, 69638), (\'IDFCBANK\', \'03-Aug-2018\', 1533269520, 27, 40.650001525878906, 40.650001525878906, 40.650001525878906, 40.650001525878906, 6201, 40.650001525878906, 40.650001525878906, 40.650001525878906, 40.650001525878906, 6201), (\'IDFCBANK\', \'03-Aug-2018\', 1533269580, 28, 40.650001525878906, 40.70000076293945, 40.650001525878906, 40.70000076293945, 19611, 40.650001525878906, 40.70000076293945, 40.650001525878906, 40.70000076293945, 19611), (\'IDFCBANK\', \'03-Aug-2018\', 1533269640, 29, 40.75, 40.75, 40.70000076293945, 40.70000076293945, 38509, 40.75, 40.75, 40.70000076293945, 40.70000076293945, 38509), (\'IDFCBANK\', \'03-Aug-2018\', 1533269700, 30, 40.70000076293945, 40.75, 40.70000076293945, 40.75, 6967, 40.70000076293945, 40.75, 40.70000076293945, 40.75, 6967), (\'IDFCBANK\', \'03-Aug-2018\', 1533269760, 31, 40.849998474121094, 40.849998474121094, 40.79999923706055, 40.79999923706055, 20152, 40.849998474121094, 40.849998474121094, 40.79999923706055, 40.79999923706055, 20152), (\'IDFCBANK\', \'03-Aug-2018\', 1533269820, 32, 40.75, 40.75, 40.75, 40.75, 9399, 40.75, 40.75, 40.75, 40.75, 9399), (\'IDFCBANK\', \'03-Aug-2018\', 1533269880, 33, 40.79999923706055, 40.79999923706055, 40.75, 40.75, 7303, 40.79999923706055, 40.79999923706055, 40.75, 40.75, 7303), (\'IDFCBANK\', \'03-Aug-2018\', 1533269940, 34, 40.75, 40.79999923706055, 40.75, 40.79999923706055, 7634, 40.75, 40.79999923706055, 40.75, 40.79999923706055, 7634), (\'IDFCBANK\', \'03-Aug-2018\', 1533270000, 35, 40.75, 40.75, 40.75, 40.75, 22490, 40.75, 40.75, 40.75, 40.75, 22490), (\'IDFCBANK\', \'03-Aug-2018\', 1533270060, 36, 40.75, 40.79999923706055, 40.75, 40.79999923706055, 12259, 40.75, 40.79999923706055, 40.75, 40.79999923706055, 12259), (\'IDFCBANK\', \'03-Aug-2018\', 1533270120, 37, 40.75, 40.75, 40.70000076293945, 40.70000076293945, 10532, 40.75, 40.75, 40.70000076293945, 40.70000076293945, 10532), (\'IDFCBANK\', \'03-Aug-2018\', 1533270180, 38, 40.70000076293945, 40.75, 40.70000076293945, 40.75, 4500, 40.70000076293945, 40.75, 40.70000076293945, 40.75, 4500), (\'IDFCBANK\', \'03-Aug-2018\', 1533270240, 39, 40.75, 40.75, 40.75, 40.75, 31536, 40.75, 40.75, 40.75, 40.75, 31536), (\'IDFCBANK\', \'03-Aug-2018\', 1533270300, 40, 40.79999923706055, 40.79999923706055, 40.79999923706055, 40.79999923706055, 13918, 40.79999923706055, 40.79999923706055, 40.79999923706055, 40.79999923706055, 13918), (\'IDFCBANK\', \'03-Aug-2018\', 1533270360, 41, 40.75, 40.79999923706055, 40.75, 40.79999923706055, 9402, 40.75, 40.79999923706055, 40.75, 40.79999923706055, 9402), (\'IDFCBANK\', \'03-Aug-2018\', 1533270420, 42, 40.75, 40.900001525878906, 40.75, 40.900001525878906, 52690, 40.75, 40.900001525878906, 40.75, 40.900001525878906, 52690), (\'IDFCBANK\', \'03-Aug-2018\', 1533270480, 43, 40.849998474121094, 40.900001525878906, 40.849998474121094, 40.849998474121094, 8149, 40.849998474121094, 40.900001525878906, 40.849998474121094, 40.849998474121094, 8149), (\'IDFCBANK\', \'03-Aug-2018\', 1533270540, 44, 40.95000076293945, 40.95000076293945, 40.900001525878906, 40.900001525878906, 47463, 40.95000076293945, 40.95000076293945, 40.900001525878906, 40.900001525878906, 47463), (\'IDFCBANK\', \'03-Aug-2018\', 1533270600, 45, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.900001525878906, 14640, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.900001525878906, 14640), (\'IDFCBANK\', \'03-Aug-2018\', 1533270660, 46, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 19177, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 19177), (\'IDFCBANK\', \'03-Aug-2018\', 1533270720, 47, 40.900001525878906, 41, 40.900001525878906, 40.95000076293945, 56883, 40.900001525878906, 41, 40.900001525878906, 40.95000076293945, 56883), (\'IDFCBANK\', \'03-Aug-2018\', 1533270780, 48, 40.95000076293945, 41, 40.95000076293945, 41, 68158, 40.95000076293945, 41, 40.95000076293945, 41, 68158), (\'IDFCBANK\', \'03-Aug-2018\', 1533270840, 49, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.04999923706055, 65861, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.04999923706055, 65861), (\'IDFCBANK\', \'03-Aug-2018\', 1533270900, 50, 41.04999923706055, 41.150001525878906, 41.04999923706055, 41.150001525878906, 60382, 41.04999923706055, 41.150001525878906, 41.04999923706055, 41.150001525878906, 60382), (\'IDFCBANK\', \'03-Aug-2018\', 1533270960, 51, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.150001525878906, 46586, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.150001525878906, 46586), (\'IDFCBANK\', \'03-Aug-2018\', 1533271020, 52, 41.150001525878906, 41.150001525878906, 41.04999923706055, 41.099998474121094, 69912, 41.150001525878906, 41.150001525878906, 41.04999923706055, 41.099998474121094, 69912), (\'IDFCBANK\', \'03-Aug-2018\', 1533271080, 53, 41.150001525878906, 41.150001525878906, 41.04999923706055, 41.04999923706055, 23863, 41.150001525878906, 41.150001525878906, 41.04999923706055, 41.04999923706055, 23863), (\'IDFCBANK\', \'03-Aug-2018\', 1533271140, 54, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 26449, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 26449), (\'IDFCBANK\', \'03-Aug-2018\', 1533271200, 55, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 31957, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 31957), (\'IDFCBANK\', \'03-Aug-2018\', 1533271260, 56, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 22670, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 22670), (\'IDFCBANK\', \'03-Aug-2018\', 1533271320, 57, 41.04999923706055, 41.150001525878906, 41.04999923706055, 41.150001525878906, 12119, 41.04999923706055, 41.150001525878906, 41.04999923706055, 41.150001525878906, 12119), (\'IDFCBANK\', \'03-Aug-2018\', 1533271380, 58, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 3237, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 3237), (\'IDFCBANK\', \'03-Aug-2018\', 1533271440, 59, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 32049, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 32049), (\'IDFCBANK\', \'03-Aug-2018\', 1533271500, 60, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 8151, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 8151), (\'IDFCBANK\', \'03-Aug-2018\', 1533271560, 61, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 7480, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 7480), (\'IDFCBANK\', \'03-Aug-2018\', 1533271620, 62, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 10386, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 10386), (\'IDFCBANK\', \'03-Aug-2018\', 1533271680, 63, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 6149, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 6149), (\'IDFCBANK\', \'03-Aug-2018\', 1533271740, 64, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 15192, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 15192), (\'IDFCBANK\', \'03-Aug-2018\', 1533271800, 65, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 4814, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 4814), (\'IDFCBANK\', \'03-Aug-2018\', 1533271860, 66, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 31722, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 31722), (\'IDFCBANK\', \'03-Aug-2018\', 1533271920, 67, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.099998474121094, 15564, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.099998474121094, 15564), (\'IDFCBANK\', \'03-Aug-2018\', 1533271980, 68, 41.04999923706055, 41.04999923706055, 41, 41, 18388, 41.04999923706055, 41.04999923706055, 41, 41, 18388), (\'IDFCBANK\', \'03-Aug-2018\', 1533272040, 69, 41, 41, 41, 41, 10946, 41, 41, 41, 41, 10946), (\'IDFCBANK\', \'03-Aug-2018\', 1533272100, 70, 41.04999923706055, 41.04999923706055, 40.95000076293945, 40.95000076293945, 76466, 41.04999923706055, 41.04999923706055, 40.95000076293945, 40.95000076293945, 76466), (\'IDFCBANK\', \'03-Aug-2018\', 1533272160, 71, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 4842, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 4842), (\'IDFCBANK\', \'03-Aug-2018\', 1533272220, 72, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40822, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40822), (\'IDFCBANK\', \'03-Aug-2018\', 1533272280, 73, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 17468, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 17468), (\'IDFCBANK\', \'03-Aug-2018\', 1533272340, 74, 40.95000076293945, 40.95000076293945, 40.900001525878906, 40.900001525878906, 25210, 40.95000076293945, 40.95000076293945, 40.900001525878906, 40.900001525878906, 25210), (\'IDFCBANK\', \'03-Aug-2018\', 1533272400, 75, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 19456, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 19456), (\'IDFCBANK\', \'03-Aug-2018\', 1533272460, 76, 40.900001525878906, 40.95000076293945, 40.849998474121094, 40.849998474121094, 16684, 40.900001525878906, 40.95000076293945, 40.849998474121094, 40.849998474121094, 16684), (\'IDFCBANK\', \'03-Aug-2018\', 1533272520, 77, 40.849998474121094, 40.849998474121094, 40.849998474121094, 40.849998474121094, 5169, 40.849998474121094, 40.849998474121094, 40.849998474121094, 40.849998474121094, 5169), (\'IDFCBANK\', \'03-Aug-2018\', 1533272580, 78, 40.849998474121094, 40.849998474121094, 40.849998474121094, 40.849998474121094, 5690, 40.849998474121094, 40.849998474121094, 40.849998474121094, 40.849998474121094, 5690), (\'IDFCBANK\', \'03-Aug-2018\', 1533272640, 79, 40.900001525878906, 40.900001525878906, 40.849998474121094, 40.849998474121094, 1501, 40.900001525878906, 40.900001525878906, 40.849998474121094, 40.849998474121094, 1501), (\'IDFCBANK\', \'03-Aug-2018\', 1533272700, 80, 40.900001525878906, 41, 40.900001525878906, 40.95000076293945, 236719, 40.900001525878906, 41, 40.900001525878906, 40.95000076293945, 236719), (\'IDFCBANK\', \'03-Aug-2018\', 1533272760, 81, 41, 41, 41, 41, 8739, 41, 41, 41, 41, 8739), (\'IDFCBANK\', \'03-Aug-2018\', 1533272820, 82, 41, 41, 40.95000076293945, 40.95000076293945, 12739, 41, 41, 40.95000076293945, 40.95000076293945, 12739), (\'IDFCBANK\', \'03-Aug-2018\', 1533272880, 83, 40.95000076293945, 41, 40.95000076293945, 41, 14721, 40.95000076293945, 41, 40.95000076293945, 41, 14721), (\'IDFCBANK\', \'03-Aug-2018\', 1533272940, 84, 41, 41, 41, 41, 4497, 41, 41, 41, 41, 4497), (\'IDFCBANK\', \'03-Aug-2018\', 1533273000, 85, 41, 41.04999923706055, 40.95000076293945, 40.95000076293945, 123793, 41, 41.04999923706055, 40.95000076293945, 40.95000076293945, 123793), (\'IDFCBANK\', \'03-Aug-2018\', 1533273060, 86, 41, 41, 40.95000076293945, 40.95000076293945, 18674, 41, 41, 40.95000076293945, 40.95000076293945, 18674), (\'IDFCBANK\', \'03-Aug-2018\', 1533273120, 87, 41, 41, 40.95000076293945, 40.95000076293945, 11877, 41, 41, 40.95000076293945, 40.95000076293945, 11877), (\'IDFCBANK\', \'03-Aug-2018\', 1533273180, 88, 41, 41, 41, 41, 22593, 41, 41, 41, 41, 22593), (\'IDFCBANK\', \'03-Aug-2018\', 1533273240, 89, 41, 41, 41, 41, 26939, 41, 41, 41, 41, 26939), (\'IDFCBANK\', \'03-Aug-2018\', 1533273300, 90, 41, 41, 41, 41, 696, 41, 41, 41, 41, 696), (\'IDFCBANK\', \'03-Aug-2018\', 1533273360, 91, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 449, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 449), (\'IDFCBANK\', \'03-Aug-2018\', 1533273420, 92, 41.04999923706055, 41.04999923706055, 41, 41, 5069, 41.04999923706055, 41.04999923706055, 41, 41, 5069), (\'IDFCBANK\', \'03-Aug-2018\', 1533273480, 93, 41.04999923706055, 41.04999923706055, 41, 41, 47117, 41.04999923706055, 41.04999923706055, 41, 41, 47117), (\'IDFCBANK\', \'03-Aug-2018\', 1533273540, 94, 41, 41, 41, 41, 14658, 41, 41, 41, 41, 14658), (\'IDFCBANK\', \'03-Aug-2018\', 1533273600, 95, 41, 41, 41, 41, 3527, 41, 41, 41, 41, 3527), (\'IDFCBANK\', \'03-Aug-2018\', 1533273660, 96, 41, 41, 41, 41, 1534, 41, 41, 41, 41, 1534), (\'IDFCBANK\', \'03-Aug-2018\', 1533273720, 97, 41.04999923706055, 41.04999923706055, 41, 41, 35147, 41.04999923706055, 41.04999923706055, 41, 41, 35147), (\'IDFCBANK\', \'03-Aug-2018\', 1533273780, 98, 41.04999923706055, 41.04999923706055, 41, 41, 22258.5, 41.04999923706055, 41.04999923706055, 41, 41, 22258.5), (\'IDFCBANK\', \'03-Aug-2018\', 1533273840, 99, 41.04999923706055, 41.04999923706055, 41, 41, 9370, 41.04999923706055, 41.04999923706055, 41, 41, 9370), (\'IDFCBANK\', \'03-Aug-2018\', 1533273900, 100, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 24471, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 24471), (\'IDFCBANK\', \'03-Aug-2018\', 1533273960, 101, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 874, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 874), (\'IDFCBANK\', \'03-Aug-2018\', 1533274020, 102, 41.04999923706055, 41.04999923706055, 41, 41, 24935, 41.04999923706055, 41.04999923706055, 41, 41, 24935), (\'IDFCBANK\', \'03-Aug-2018\', 1533274080, 103, 40.95000076293945, 41.04999923706055, 40.95000076293945, 41.04999923706055, 158356, 40.95000076293945, 41.04999923706055, 40.95000076293945, 41.04999923706055, 158356), (\'IDFCBANK\', \'03-Aug-2018\', 1533274140, 104, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 3738, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 3738), (\'IDFCBANK\', \'03-Aug-2018\', 1533274200, 105, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 3375, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 3375), (\'IDFCBANK\', \'03-Aug-2018\', 1533274260, 106, 40.95000076293945, 41, 40.95000076293945, 41, 15074, 40.95000076293945, 41, 40.95000076293945, 41, 15074), (\'IDFCBANK\', \'03-Aug-2018\', 1533274320, 107, 41, 41, 41, 41, 11601, 41, 41, 41, 41, 11601), (\'IDFCBANK\', \'03-Aug-2018\', 1533274380, 108, 41, 41, 40.95000076293945, 40.95000076293945, 6736, 41, 41, 40.95000076293945, 40.95000076293945, 6736), (\'IDFCBANK\', \'03-Aug-2018\', 1533274440, 109, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 7127, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 7127), (\'IDFCBANK\', \'03-Aug-2018\', 1533274500, 110, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 5338, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 5338), (\'IDFCBANK\', \'03-Aug-2018\', 1533274560, 111, 41, 41, 41, 41, 20309, 41, 41, 41, 41, 20309), (\'IDFCBANK\', \'03-Aug-2018\', 1533274620, 112, 41, 41, 41, 41, 35385, 41, 41, 41, 41, 35385), (\'IDFCBANK\', \'03-Aug-2018\', 1533274680, 113, 41, 41.04999923706055, 41, 41.04999923706055, 21527, 41, 41.04999923706055, 41, 41.04999923706055, 21527), (\'IDFCBANK\', \'03-Aug-2018\', 1533274740, 114, 41, 41, 41, 41, 2981, 41, 41, 41, 41, 2981), (\'IDFCBANK\', \'03-Aug-2018\', 1533274800, 115, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 12066, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 12066), (\'IDFCBANK\', \'03-Aug-2018\', 1533274860, 116, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 36852, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 36852), (\'IDFCBANK\', \'03-Aug-2018\', 1533274920, 117, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 11676, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 11676), (\'IDFCBANK\', \'03-Aug-2018\', 1533274980, 118, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2435, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2435), (\'IDFCBANK\', \'03-Aug-2018\', 1533275040, 119, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 12455, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 12455), (\'IDFCBANK\', \'03-Aug-2018\', 1533275100, 120, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 20707, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 20707), (\'IDFCBANK\', \'03-Aug-2018\', 1533275160, 121, 41, 41.04999923706055, 41, 41.04999923706055, 6220, 41, 41.04999923706055, 41, 41.04999923706055, 6220), (\'IDFCBANK\', \'03-Aug-2018\', 1533275220, 122, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4166, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4166), (\'IDFCBANK\', \'03-Aug-2018\', 1533275280, 123, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 513, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 513), (\'IDFCBANK\', \'03-Aug-2018\', 1533275340, 124, 41.04999923706055, 41.04999923706055, 41, 41, 8598, 41.04999923706055, 41.04999923706055, 41, 41, 8598), (\'IDFCBANK\', \'03-Aug-2018\', 1533275400, 125, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 22111, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 22111), (\'IDFCBANK\', \'03-Aug-2018\', 1533275460, 126, 41, 41, 41, 41, 7565, 41, 41, 41, 41, 7565), (\'IDFCBANK\', \'03-Aug-2018\', 1533275520, 127, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2683, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2683), (\'IDFCBANK\', \'03-Aug-2018\', 1533275580, 128, 41, 41, 41, 41, 1249, 41, 41, 41, 41, 1249), (\'IDFCBANK\', \'03-Aug-2018\', 1533275640, 129, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 6923, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 6923), (\'IDFCBANK\', \'03-Aug-2018\', 1533275700, 130, 41, 41, 41, 41, 75621, 41, 41, 41, 41, 75621), (\'IDFCBANK\', \'03-Aug-2018\', 1533275760, 131, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 24182, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 24182), (\'IDFCBANK\', \'03-Aug-2018\', 1533275820, 132, 41, 41, 41, 41, 525, 41, 41, 41, 41, 525), (\'IDFCBANK\', \'03-Aug-2018\', 1533275880, 133, 40.95000076293945, 41, 40.95000076293945, 41, 10645, 40.95000076293945, 41, 40.95000076293945, 41, 10645), (\'IDFCBANK\', \'03-Aug-2018\', 1533275940, 134, 41, 41, 41, 41, 33943, 41, 41, 41, 41, 33943), (\'IDFCBANK\', \'03-Aug-2018\', 1533276000, 135, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4419, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4419), (\'IDFCBANK\', \'03-Aug-2018\', 1533276060, 136, 41.04999923706055, 41.04999923706055, 41, 41, 9041, 41.04999923706055, 41.04999923706055, 41, 41, 9041), (\'IDFCBANK\', \'03-Aug-2018\', 1533276120, 137, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2139, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2139), (\'IDFCBANK\', \'03-Aug-2018\', 1533276180, 138, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 26975, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 26975), (\'IDFCBANK\', \'03-Aug-2018\', 1533276240, 139, 41, 41, 41, 41, 847, 41, 41, 41, 41, 847), (\'IDFCBANK\', \'03-Aug-2018\', 1533276300, 140, 41, 41, 41, 41, 1006, 41, 41, 41, 41, 1006), (\'IDFCBANK\', \'03-Aug-2018\', 1533276360, 141, 41, 41, 41, 41, 709, 41, 41, 41, 41, 709), (\'IDFCBANK\', \'03-Aug-2018\', 1533276420, 142, 41, 41.04999923706055, 41, 41.04999923706055, 127460, 41, 41.04999923706055, 41, 41.04999923706055, 127460), (\'IDFCBANK\', \'03-Aug-2018\', 1533276480, 143, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 79052, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 79052), (\'IDFCBANK\', \'03-Aug-2018\', 1533276540, 144, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4891, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4891), (\'IDFCBANK\', \'03-Aug-2018\', 1533276600, 145, 41, 41, 41, 41, 4945, 41, 41, 41, 41, 4945), (\'IDFCBANK\', \'03-Aug-2018\', 1533276660, 146, 41, 41.04999923706055, 41, 41.04999923706055, 81538, 41, 41.04999923706055, 41, 41.04999923706055, 81538), (\'IDFCBANK\', \'03-Aug-2018\', 1533276720, 147, 41, 41, 41, 41, 8975, 41, 41, 41, 41, 8975), (\'IDFCBANK\', \'03-Aug-2018\', 1533276780, 148, 41.04999923706055, 41.04999923706055, 41, 41, 28175, 41.04999923706055, 41.04999923706055, 41, 41, 28175), (\'IDFCBANK\', \'03-Aug-2018\', 1533276840, 149, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 15758, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 15758), (\'IDFCBANK\', \'03-Aug-2018\', 1533276900, 150, 41.04999923706055, 41.04999923706055, 41, 41, 9023, 41.04999923706055, 41.04999923706055, 41, 41, 9023), (\'IDFCBANK\', \'03-Aug-2018\', 1533276960, 151, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 9815, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 9815), (\'IDFCBANK\', \'03-Aug-2018\', 1533277020, 152, 40.95000076293945, 41, 40.95000076293945, 41, 25438, 40.95000076293945, 41, 40.95000076293945, 41, 25438), (\'IDFCBANK\', \'03-Aug-2018\', 1533277080, 153, 41, 41, 41, 41, 49529, 41, 41, 41, 41, 49529), (\'IDFCBANK\', \'03-Aug-2018\', 1533277140, 154, 41, 41, 41, 41, 32568, 41, 41, 41, 41, 32568), (\'IDFCBANK\', \'03-Aug-2018\', 1533277200, 155, 41, 41, 41, 41, 5118, 41, 41, 41, 41, 5118), (\'IDFCBANK\', \'03-Aug-2018\', 1533277260, 156, 41, 41, 41, 41, 440, 41, 41, 41, 41, 440), (\'IDFCBANK\', \'03-Aug-2018\', 1533277320, 157, 41, 41, 41, 41, 550, 41, 41, 41, 41, 550), (\'IDFCBANK\', \'03-Aug-2018\', 1533277380, 158, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 19425, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 19425), (\'IDFCBANK\', \'03-Aug-2018\', 1533277440, 159, 41, 41, 41, 41, 61848, 41, 41, 41, 41, 61848), (\'IDFCBANK\', \'03-Aug-2018\', 1533277500, 160, 41, 41, 41, 41, 4258, 41, 41, 41, 41, 4258), (\'IDFCBANK\', \'03-Aug-2018\', 1533277560, 161, 41, 41, 41, 41, 209, 41, 41, 41, 41, 209), (\'IDFCBANK\', \'03-Aug-2018\', 1533277620, 162, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11280, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11280), (\'IDFCBANK\', \'03-Aug-2018\', 1533277680, 163, 41, 41, 41, 41, 2794, 41, 41, 41, 41, 2794), (\'IDFCBANK\', \'03-Aug-2018\', 1533277740, 164, 40.95000076293945, 41, 40.95000076293945, 41, 14665, 40.95000076293945, 41, 40.95000076293945, 41, 14665), (\'IDFCBANK\', \'03-Aug-2018\', 1533277800, 165, 41, 41, 40.95000076293945, 40.95000076293945, 62107, 41, 41, 40.95000076293945, 40.95000076293945, 62107), (\'IDFCBANK\', \'03-Aug-2018\', 1533277860, 166, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 64828, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 64828), (\'IDFCBANK\', \'03-Aug-2018\', 1533277920, 167, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 22853, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 22853), (\'IDFCBANK\', \'03-Aug-2018\', 1533277980, 168, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 8493, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 8493), (\'IDFCBANK\', \'03-Aug-2018\', 1533278040, 169, 40.95000076293945, 41, 40.95000076293945, 41, 16870, 40.95000076293945, 41, 40.95000076293945, 41, 16870), (\'IDFCBANK\', \'03-Aug-2018\', 1533278100, 170, 41, 41, 41, 41, 4800, 41, 41, 41, 41, 4800), (\'IDFCBANK\', \'03-Aug-2018\', 1533278160, 171, 41, 41, 41, 41, 8819, 41, 41, 41, 41, 8819), (\'IDFCBANK\', \'03-Aug-2018\', 1533278220, 172, 41, 41, 41, 41, 9440, 41, 41, 41, 41, 9440), (\'IDFCBANK\', \'03-Aug-2018\', 1533278280, 173, 41.04999923706055, 41.04999923706055, 41, 41, 20279, 41.04999923706055, 41.04999923706055, 41, 41, 20279), (\'IDFCBANK\', \'03-Aug-2018\', 1533278340, 174, 41, 41, 41, 41, 12744, 41, 41, 41, 41, 12744), (\'IDFCBANK\', \'03-Aug-2018\', 1533278400, 175, 41, 41, 41, 41, 1232, 41, 41, 41, 41, 1232), (\'IDFCBANK\', \'03-Aug-2018\', 1533278460, 176, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 225897, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 225897), (\'IDFCBANK\', \'03-Aug-2018\', 1533278520, 177, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 49962, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 49962), (\'IDFCBANK\', \'03-Aug-2018\', 1533278580, 178, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 8965, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 8965), (\'IDFCBANK\', \'03-Aug-2018\', 1533278640, 179, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1262, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1262), (\'IDFCBANK\', \'03-Aug-2018\', 1533278700, 180, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 6736, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 6736), (\'IDFCBANK\', \'03-Aug-2018\', 1533278760, 181, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1479, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1479), (\'IDFCBANK\', \'03-Aug-2018\', 1533278820, 182, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 3992, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 3992), (\'IDFCBANK\', \'03-Aug-2018\', 1533278880, 183, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 371, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 371), (\'IDFCBANK\', \'03-Aug-2018\', 1533278940, 184, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 4014, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 4014), (\'IDFCBANK\', \'03-Aug-2018\', 1533279000, 185, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1060, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1060), (\'IDFCBANK\', \'03-Aug-2018\', 1533279060, 186, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 521, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 521), (\'IDFCBANK\', \'03-Aug-2018\', 1533279120, 187, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 9336, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 9336), (\'IDFCBANK\', \'03-Aug-2018\', 1533279180, 188, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 3476, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 3476), (\'IDFCBANK\', \'03-Aug-2018\', 1533279240, 189, 41, 41, 41, 41, 2596, 41, 41, 41, 41, 2596), (\'IDFCBANK\', \'03-Aug-2018\', 1533279300, 190, 41.02499961853027, 41.02499961853027, 41, 41, 4711, 41.02499961853027, 41.02499961853027, 41, 41, 4711), (\'IDFCBANK\', \'03-Aug-2018\', 1533279360, 191, 41.04999923706055, 41.04999923706055, 41, 41, 6826, 41.04999923706055, 41.04999923706055, 41, 41, 6826), (\'IDFCBANK\', \'03-Aug-2018\', 1533279420, 192, 41, 41, 41, 41, 45511, 41, 41, 41, 41, 45511), (\'IDFCBANK\', \'03-Aug-2018\', 1533279480, 193, 41, 41.02499961853027, 41, 41.02499961853027, 35506, 41, 41.02499961853027, 41, 41.02499961853027, 35506), (\'IDFCBANK\', \'03-Aug-2018\', 1533279540, 194, 41, 41.04999923706055, 41, 41.04999923706055, 25501, 41, 41.04999923706055, 41, 41.04999923706055, 25501), (\'IDFCBANK\', \'03-Aug-2018\', 1533279600, 195, 41.02499961853027, 41.04999923706055, 41, 41.02499961853027, 19796, 41.02499961853027, 41.04999923706055, 41, 41.02499961853027, 19796), (\'IDFCBANK\', \'03-Aug-2018\', 1533279660, 196, 41.04999923706055, 41.04999923706055, 41, 41, 14091, 41.04999923706055, 41.04999923706055, 41, 41, 14091), (\'IDFCBANK\', \'03-Aug-2018\', 1533279720, 197, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1801, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 1801), (\'IDFCBANK\', \'03-Aug-2018\', 1533279780, 198, 41, 41, 41, 41, 19919, 41, 41, 41, 41, 19919), (\'IDFCBANK\', \'03-Aug-2018\', 1533279840, 199, 41.02499961853027, 41.02499961853027, 40.97500038146973, 40.97500038146973, 40495.5, 41.02499961853027, 41.02499961853027, 40.97500038146973, 40.97500038146973, 40495.5), (\'IDFCBANK\', \'03-Aug-2018\', 1533279900, 200, 41.04999923706055, 41.04999923706055, 40.95000076293945, 40.95000076293945, 61072, 41.04999923706055, 41.04999923706055, 40.95000076293945, 40.95000076293945, 61072), (\'IDFCBANK\', \'03-Aug-2018\', 1533279960, 201, 41, 41, 41, 41, 12639, 41, 41, 41, 41, 12639), (\'IDFCBANK\', \'03-Aug-2018\', 1533280020, 202, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 912, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 912), (\'IDFCBANK\', \'03-Aug-2018\', 1533280080, 203, 40.95000076293945, 40.97500038146973, 40.95000076293945, 40.97500038146973, 36502, 40.95000076293945, 40.97500038146973, 40.95000076293945, 40.97500038146973, 36502), (\'IDFCBANK\', \'03-Aug-2018\', 1533280140, 204, 40.95000076293945, 41, 40.95000076293945, 41, 72092, 40.95000076293945, 41, 40.95000076293945, 41, 72092), (\'IDFCBANK\', \'03-Aug-2018\', 1533280200, 205, 41, 41, 41, 41, 1296, 41, 41, 41, 41, 1296), (\'IDFCBANK\', \'03-Aug-2018\', 1533280260, 206, 41, 41, 41, 41, 75119, 41, 41, 41, 41, 75119), (\'IDFCBANK\', \'03-Aug-2018\', 1533280320, 207, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 5360, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 5360), (\'IDFCBANK\', \'03-Aug-2018\', 1533280380, 208, 41.02499961853027, 41.02499961853027, 41.02499961853027, 41.02499961853027, 4237.5, 41.02499961853027, 41.02499961853027, 41.02499961853027, 41.02499961853027, 4237.5), (\'IDFCBANK\', \'03-Aug-2018\', 1533280440, 209, 41, 41, 41, 41, 3115, 41, 41, 41, 41, 3115), (\'IDFCBANK\', \'03-Aug-2018\', 1533280500, 210, 41, 41, 41, 41, 16704, 41, 41, 41, 41, 16704), (\'IDFCBANK\', \'03-Aug-2018\', 1533280560, 211, 41, 41, 41, 41, 13958, 41, 41, 41, 41, 13958), (\'IDFCBANK\', \'03-Aug-2018\', 1533280620, 212, 41, 41, 41, 41, 2419, 41, 41, 41, 41, 2419), (\'IDFCBANK\', \'03-Aug-2018\', 1533280680, 213, 41, 41, 41, 41, 12240, 41, 41, 41, 41, 12240), (\'IDFCBANK\', \'03-Aug-2018\', 1533280740, 214, 41, 41, 41, 41, 9208, 41, 41, 41, 41, 9208), (\'IDFCBANK\', \'03-Aug-2018\', 1533280800, 215, 41, 41, 41, 41, 1612, 41, 41, 41, 41, 1612), (\'IDFCBANK\', \'03-Aug-2018\', 1533280860, 216, 41, 41, 41, 41, 154, 41, 41, 41, 41, 154), (\'IDFCBANK\', \'03-Aug-2018\', 1533280920, 217, 41, 41, 41, 41, 1693, 41, 41, 41, 41, 1693), (\'IDFCBANK\', \'03-Aug-2018\', 1533280980, 218, 41, 41, 41, 41, 26952, 41, 41, 41, 41, 26952), (\'IDFCBANK\', \'03-Aug-2018\', 1533281040, 219, 41, 41, 41, 41, 2255, 41, 41, 41, 41, 2255), (\'IDFCBANK\', \'03-Aug-2018\', 1533281100, 220, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1921, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1921), (\'IDFCBANK\', \'03-Aug-2018\', 1533281160, 221, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 6901, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 6901), (\'IDFCBANK\', \'03-Aug-2018\', 1533281220, 222, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 15451, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 15451), (\'IDFCBANK\', \'03-Aug-2018\', 1533281280, 223, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1100, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1100), (\'IDFCBANK\', \'03-Aug-2018\', 1533281340, 224, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 48089, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 48089), (\'IDFCBANK\', \'03-Aug-2018\', 1533281400, 225, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 39373, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 39373), (\'IDFCBANK\', \'03-Aug-2018\', 1533281460, 226, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 5120, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 5120), (\'IDFCBANK\', \'03-Aug-2018\', 1533281520, 227, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 58475, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 58475), (\'IDFCBANK\', \'03-Aug-2018\', 1533281580, 228, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.95000076293945, 21617, 40.900001525878906, 40.95000076293945, 40.900001525878906, 40.95000076293945, 21617), (\'IDFCBANK\', \'03-Aug-2018\', 1533281640, 229, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 184287, 40.900001525878906, 40.900001525878906, 40.900001525878906, 40.900001525878906, 184287), (\'IDFCBANK\', \'03-Aug-2018\', 1533281700, 230, 41, 41, 41, 41, 838785, 41, 41, 41, 41, 838785), (\'IDFCBANK\', \'03-Aug-2018\', 1533281760, 231, 41, 41, 40.95000076293945, 40.95000076293945, 45753, 41, 41, 40.95000076293945, 40.95000076293945, 45753), (\'IDFCBANK\', \'03-Aug-2018\', 1533281820, 232, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 23388, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 23388), (\'IDFCBANK\', \'03-Aug-2018\', 1533281880, 233, 41, 41, 41, 41, 946, 41, 41, 41, 41, 946), (\'IDFCBANK\', \'03-Aug-2018\', 1533281940, 234, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 3336, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 3336), (\'IDFCBANK\', \'03-Aug-2018\', 1533282000, 235, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1497, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1497), (\'IDFCBANK\', \'03-Aug-2018\', 1533282060, 236, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 4545, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 4545), (\'IDFCBANK\', \'03-Aug-2018\', 1533282120, 237, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2524, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2524), (\'IDFCBANK\', \'03-Aug-2018\', 1533282180, 238, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 176, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 176), (\'IDFCBANK\', \'03-Aug-2018\', 1533282240, 239, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 239, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 239), (\'IDFCBANK\', \'03-Aug-2018\', 1533282300, 240, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 10865, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 10865), (\'IDFCBANK\', \'03-Aug-2018\', 1533282360, 241, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 856, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 856), (\'IDFCBANK\', \'03-Aug-2018\', 1533282420, 242, 40.95000076293945, 41, 40.95000076293945, 41, 3673, 40.95000076293945, 41, 40.95000076293945, 41, 3673), (\'IDFCBANK\', \'03-Aug-2018\', 1533282480, 243, 41, 41, 41, 41, 7759, 41, 41, 41, 41, 7759), (\'IDFCBANK\', \'03-Aug-2018\', 1533282540, 244, 41, 41, 41, 41, 127, 41, 41, 41, 41, 127), (\'IDFCBANK\', \'03-Aug-2018\', 1533282600, 245, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 4246, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 4246), (\'IDFCBANK\', \'03-Aug-2018\', 1533282660, 246, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 282, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 282), (\'IDFCBANK\', \'03-Aug-2018\', 1533282720, 247, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1024, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1024), (\'IDFCBANK\', \'03-Aug-2018\', 1533282780, 248, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2765, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2765), (\'IDFCBANK\', \'03-Aug-2018\', 1533282840, 249, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 954, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 954), (\'IDFCBANK\', \'03-Aug-2018\', 1533282900, 250, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1922, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1922), (\'IDFCBANK\', \'03-Aug-2018\', 1533282960, 251, 41, 41, 40.95000076293945, 40.95000076293945, 2408, 41, 41, 40.95000076293945, 40.95000076293945, 2408), (\'IDFCBANK\', \'03-Aug-2018\', 1533283020, 252, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 20971, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 20971), (\'IDFCBANK\', \'03-Aug-2018\', 1533283080, 253, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 6301, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 6301), (\'IDFCBANK\', \'03-Aug-2018\', 1533283140, 254, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2188, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2188), (\'IDFCBANK\', \'03-Aug-2018\', 1533283200, 255, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 10293, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 10293), (\'IDFCBANK\', \'03-Aug-2018\', 1533283260, 256, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 178, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 178), (\'IDFCBANK\', \'03-Aug-2018\', 1533283320, 257, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 47014, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 47014), (\'IDFCBANK\', \'03-Aug-2018\', 1533283380, 258, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 8557, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 8557), (\'IDFCBANK\', \'03-Aug-2018\', 1533283440, 259, 41, 41, 40.95000076293945, 40.95000076293945, 17121, 41, 41, 40.95000076293945, 40.95000076293945, 17121), (\'IDFCBANK\', \'03-Aug-2018\', 1533283500, 260, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 510, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 510), (\'IDFCBANK\', \'03-Aug-2018\', 1533283560, 261, 41, 41, 41, 41, 2270, 41, 41, 41, 41, 2270), (\'IDFCBANK\', \'03-Aug-2018\', 1533283620, 262, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 21204, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 21204), (\'IDFCBANK\', \'03-Aug-2018\', 1533283680, 263, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11355, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11355), (\'IDFCBANK\', \'03-Aug-2018\', 1533283740, 264, 41, 41, 41, 41, 28085, 41, 41, 41, 41, 28085), (\'IDFCBANK\', \'03-Aug-2018\', 1533283800, 265, 41, 41, 40.95000076293945, 40.95000076293945, 14016, 41, 41, 40.95000076293945, 40.95000076293945, 14016), (\'IDFCBANK\', \'03-Aug-2018\', 1533283860, 266, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11576, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11576), (\'IDFCBANK\', \'03-Aug-2018\', 1533283920, 267, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 7901, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 7901), (\'IDFCBANK\', \'03-Aug-2018\', 1533283980, 268, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 206, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 206), (\'IDFCBANK\', \'03-Aug-2018\', 1533284040, 269, 41, 41, 41, 41, 1791, 41, 41, 41, 41, 1791), (\'IDFCBANK\', \'03-Aug-2018\', 1533284100, 270, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 509, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 509), (\'IDFCBANK\', \'03-Aug-2018\', 1533284160, 271, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2729, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2729), (\'IDFCBANK\', \'03-Aug-2018\', 1533284220, 272, 41.04999923706055, 41.04999923706055, 40.95000076293945, 40.95000076293945, 205998, 41.04999923706055, 41.04999923706055, 40.95000076293945, 40.95000076293945, 205998), (\'IDFCBANK\', \'03-Aug-2018\', 1533284280, 273, 41, 41, 41, 41, 12983, 41, 41, 41, 41, 12983), (\'IDFCBANK\', \'03-Aug-2018\', 1533284340, 274, 41, 41, 41, 41, 3725, 41, 41, 41, 41, 3725), (\'IDFCBANK\', \'03-Aug-2018\', 1533284400, 275, 41, 41, 41, 41, 5898, 41, 41, 41, 41, 5898), (\'IDFCBANK\', \'03-Aug-2018\', 1533284460, 276, 41, 41, 41, 41, 3425, 41, 41, 41, 41, 3425), (\'IDFCBANK\', \'03-Aug-2018\', 1533284520, 277, 41, 41, 40.95000076293945, 40.95000076293945, 5383, 41, 41, 40.95000076293945, 40.95000076293945, 5383), (\'IDFCBANK\', \'03-Aug-2018\', 1533284580, 278, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1145, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1145), (\'IDFCBANK\', \'03-Aug-2018\', 1533284640, 279, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11938, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 11938), (\'IDFCBANK\', \'03-Aug-2018\', 1533284700, 280, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 934, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 934), (\'IDFCBANK\', \'03-Aug-2018\', 1533284760, 281, 40.95000076293945, 41.04999923706055, 40.95000076293945, 41.04999923706055, 13378, 40.95000076293945, 41.04999923706055, 40.95000076293945, 41.04999923706055, 13378), (\'IDFCBANK\', \'03-Aug-2018\', 1533284820, 282, 41, 41, 41, 41, 2702, 41, 41, 41, 41, 2702), (\'IDFCBANK\', \'03-Aug-2018\', 1533284880, 283, 41, 41, 41, 41, 4024, 41, 41, 41, 41, 4024), (\'IDFCBANK\', \'03-Aug-2018\', 1533284940, 284, 41, 41, 40.95000076293945, 40.95000076293945, 7300, 41, 41, 40.95000076293945, 40.95000076293945, 7300), (\'IDFCBANK\', \'03-Aug-2018\', 1533285000, 285, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1422, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 1422), (\'IDFCBANK\', \'03-Aug-2018\', 1533285060, 286, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 6522, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 6522), (\'IDFCBANK\', \'03-Aug-2018\', 1533285120, 287, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 573, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 573), (\'IDFCBANK\', \'03-Aug-2018\', 1533285180, 288, 40.95000076293945, 41, 40.95000076293945, 41, 6510, 40.95000076293945, 41, 40.95000076293945, 41, 6510), (\'IDFCBANK\', \'03-Aug-2018\', 1533285240, 289, 41, 41, 41, 41, 1232, 41, 41, 41, 41, 1232), (\'IDFCBANK\', \'03-Aug-2018\', 1533285300, 290, 41, 41.04999923706055, 41, 41.04999923706055, 50905, 41, 41.04999923706055, 41, 41.04999923706055, 50905), (\'IDFCBANK\', \'03-Aug-2018\', 1533285360, 291, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 15008, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 15008), (\'IDFCBANK\', \'03-Aug-2018\', 1533285420, 292, 41, 41, 41, 41, 20645, 41, 41, 41, 41, 20645), (\'IDFCBANK\', \'03-Aug-2018\', 1533285480, 293, 41, 41, 41, 41, 6622, 41, 41, 41, 41, 6622), (\'IDFCBANK\', \'03-Aug-2018\', 1533285540, 294, 41, 41, 41, 41, 3466, 41, 41, 41, 41, 3466), (\'IDFCBANK\', \'03-Aug-2018\', 1533285600, 295, 41, 41, 41, 41, 2330, 41, 41, 41, 41, 2330), (\'IDFCBANK\', \'03-Aug-2018\', 1533285660, 296, 41, 41, 41, 41, 2705, 41, 41, 41, 41, 2705), (\'IDFCBANK\', \'03-Aug-2018\', 1533285720, 297, 41, 41, 41, 41, 4434, 41, 41, 41, 41, 4434), (\'IDFCBANK\', \'03-Aug-2018\', 1533285780, 298, 41, 41, 41, 41, 5881, 41, 41, 41, 41, 5881), (\'IDFCBANK\', \'03-Aug-2018\', 1533285840, 299, 41, 41, 41, 41, 11015, 41, 41, 41, 41, 11015), (\'IDFCBANK\', \'03-Aug-2018\', 1533285900, 300, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 28882, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 28882), (\'IDFCBANK\', \'03-Aug-2018\', 1533285960, 301, 41, 41, 41, 41, 713, 41, 41, 41, 41, 713), (\'IDFCBANK\', \'03-Aug-2018\', 1533286020, 302, 41, 41, 41, 41, 1115, 41, 41, 41, 41, 1115), (\'IDFCBANK\', \'03-Aug-2018\', 1533286080, 303, 41, 41, 41, 41, 3084, 41, 41, 41, 41, 3084), (\'IDFCBANK\', \'03-Aug-2018\', 1533286140, 304, 41, 41, 41, 41, 8908, 41, 41, 41, 41, 8908), (\'IDFCBANK\', \'03-Aug-2018\', 1533286200, 305, 41, 41, 41, 41, 14371, 41, 41, 41, 41, 14371), (\'IDFCBANK\', \'03-Aug-2018\', 1533286260, 306, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 16093, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 16093), (\'IDFCBANK\', \'03-Aug-2018\', 1533286320, 307, 41, 41, 41, 41, 24613, 41, 41, 41, 41, 24613), (\'IDFCBANK\', \'03-Aug-2018\', 1533286380, 308, 41, 41, 41, 41, 134748, 41, 41, 41, 41, 134748), (\'IDFCBANK\', \'03-Aug-2018\', 1533286440, 309, 41, 41, 41, 41, 17256, 41, 41, 41, 41, 17256), (\'IDFCBANK\', \'03-Aug-2018\', 1533286500, 310, 41, 41, 41, 41, 32408, 41, 41, 41, 41, 32408), (\'IDFCBANK\', \'03-Aug-2018\', 1533286560, 311, 41, 41, 41, 41, 37468, 41, 41, 41, 41, 37468), (\'IDFCBANK\', \'03-Aug-2018\', 1533286620, 312, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 16411, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 16411), (\'IDFCBANK\', \'03-Aug-2018\', 1533286680, 313, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2062, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 2062), (\'IDFCBANK\', \'03-Aug-2018\', 1533286740, 314, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 8368, 40.95000076293945, 40.95000076293945, 40.95000076293945, 40.95000076293945, 8368), (\'IDFCBANK\', \'03-Aug-2018\', 1533286800, 315, 41, 41, 41, 41, 89916, 41, 41, 41, 41, 89916), (\'IDFCBANK\', \'03-Aug-2018\', 1533286860, 316, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 42286, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 42286), (\'IDFCBANK\', \'03-Aug-2018\', 1533286920, 317, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4174, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4174), (\'IDFCBANK\', \'03-Aug-2018\', 1533286980, 318, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 59281, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 59281), (\'IDFCBANK\', \'03-Aug-2018\', 1533287040, 319, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 14727, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 14727), (\'IDFCBANK\', \'03-Aug-2018\', 1533287100, 320, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4699, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 4699), (\'IDFCBANK\', \'03-Aug-2018\', 1533287160, 321, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 8121, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 8121), (\'IDFCBANK\', \'03-Aug-2018\', 1533287220, 322, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 7629, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 7629), (\'IDFCBANK\', \'03-Aug-2018\', 1533287280, 323, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2473, 41.04999923706055, 41.04999923706055, 41.04999923706055, 41.04999923706055, 2473), (\'IDFCBANK\', \'03-Aug-2018\', 1533287340, 324, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 7159, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 7159), (\'IDFCBANK\', \'03-Aug-2018\', 1533287400, 325, 41.20000076293945, 41.29999923706055, 41.20000076293945, 41.29999923706055, 141857, 41.20000076293945, 41.29999923706055, 41.20000076293945, 41.29999923706055, 141857), (\'IDFCBANK\', \'03-Aug-2018\', 1533287460, 326, 41.29999923706055, 41.29999923706055, 41.20000076293945, 41.20000076293945, 13765, 41.29999923706055, 41.29999923706055, 41.20000076293945, 41.20000076293945, 13765), (\'IDFCBANK\', \'03-Aug-2018\', 1533287520, 327, 41.20000076293945, 41.20000076293945, 41.099998474121094, 41.099998474121094, 46475, 41.20000076293945, 41.20000076293945, 41.099998474121094, 41.099998474121094, 46475), (\'IDFCBANK\', \'03-Aug-2018\', 1533287580, 328, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 9460, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 9460), (\'IDFCBANK\', \'03-Aug-2018\', 1533287640, 329, 41.25, 41.25, 41.20000076293945, 41.25, 139246, 41.25, 41.25, 41.20000076293945, 41.25, 139246), (\'IDFCBANK\', \'03-Aug-2018\', 1533287700, 330, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 52970, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 52970), (\'IDFCBANK\', \'03-Aug-2018\', 1533287760, 331, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.20000076293945, 4272, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.20000076293945, 4272), (\'IDFCBANK\', \'03-Aug-2018\', 1533287820, 332, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 6260, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 6260), (\'IDFCBANK\', \'03-Aug-2018\', 1533287880, 333, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 3864, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 3864), (\'IDFCBANK\', \'03-Aug-2018\', 1533287940, 334, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 24832, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 24832), (\'IDFCBANK\', \'03-Aug-2018\', 1533288000, 335, 41.20000076293945, 41.20000076293945, 41.099998474121094, 41.099998474121094, 79547, 41.20000076293945, 41.20000076293945, 41.099998474121094, 41.099998474121094, 79547), (\'IDFCBANK\', \'03-Aug-2018\', 1533288060, 336, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 2210, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 2210), (\'IDFCBANK\', \'03-Aug-2018\', 1533288120, 337, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 12139, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 12139), (\'IDFCBANK\', \'03-Aug-2018\', 1533288180, 338, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 19145, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 19145), (\'IDFCBANK\', \'03-Aug-2018\', 1533288240, 339, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 7545, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 7545), (\'IDFCBANK\', \'03-Aug-2018\', 1533288300, 340, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 10150, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 10150), (\'IDFCBANK\', \'03-Aug-2018\', 1533288360, 341, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 36455, 41.099998474121094, 41.099998474121094, 41.04999923706055, 41.04999923706055, 36455), (\'IDFCBANK\', \'03-Aug-2018\', 1533288420, 342, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 60277, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 60277), (\'IDFCBANK\', \'03-Aug-2018\', 1533288480, 343, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 4007, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 4007), (\'IDFCBANK\', \'03-Aug-2018\', 1533288540, 344, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 16584, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 16584), (\'IDFCBANK\', \'03-Aug-2018\', 1533288600, 345, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 8300, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 8300), (\'IDFCBANK\', \'03-Aug-2018\', 1533288660, 346, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 34278, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 34278), (\'IDFCBANK\', \'03-Aug-2018\', 1533288720, 347, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 25179, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 25179), (\'IDFCBANK\', \'03-Aug-2018\', 1533288780, 348, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 22734, 41.099998474121094, 41.150001525878906, 41.099998474121094, 41.150001525878906, 22734), (\'IDFCBANK\', \'03-Aug-2018\', 1533288840, 349, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 26835, 41.04999923706055, 41.099998474121094, 41.04999923706055, 41.099998474121094, 26835), (\'IDFCBANK\', \'03-Aug-2018\', 1533288900, 350, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 6639, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 6639), (\'IDFCBANK\', \'03-Aug-2018\', 1533288960, 351, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 16874, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 16874), (\'IDFCBANK\', \'03-Aug-2018\', 1533289020, 352, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 11066, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 11066), (\'IDFCBANK\', \'03-Aug-2018\', 1533289080, 353, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 19223, 41.150001525878906, 41.150001525878906, 41.099998474121094, 41.099998474121094, 19223), (\'IDFCBANK\', \'03-Aug-2018\', 1533289140, 354, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 33835, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 33835), (\'IDFCBANK\', \'03-Aug-2018\', 1533289200, 355, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 7581, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 7581), (\'IDFCBANK\', \'03-Aug-2018\', 1533289260, 356, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 75109, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 75109), (\'IDFCBANK\', \'03-Aug-2018\', 1533289320, 357, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 16912, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 16912), (\'IDFCBANK\', \'03-Aug-2018\', 1533289380, 358, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 12058, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 12058), (\'IDFCBANK\', \'03-Aug-2018\', 1533289440, 359, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 39875, 41.099998474121094, 41.099998474121094, 41.099998474121094, 41.099998474121094, 39875), (\'IDFCBANK\', \'03-Aug-2018\', 1533289500, 360, 41.099998474121094, 41.20000076293945, 41.099998474121094, 41.20000076293945, 78686, 41.099998474121094, 41.20000076293945, 41.099998474121094, 41.20000076293945, 78686), (\'IDFCBANK\', \'03-Aug-2018\', 1533289560, 361, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.20000076293945, 90649, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.20000076293945, 90649), (\'IDFCBANK\', \'03-Aug-2018\', 1533289620, 362, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 216397, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 216397), (\'IDFCBANK\', \'03-Aug-2018\', 1533289680, 363, 41.150001525878906, 41.25, 41.150001525878906, 41.25, 26097, 41.150001525878906, 41.25, 41.150001525878906, 41.25, 26097), (\'IDFCBANK\', \'03-Aug-2018\', 1533289740, 364, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.20000076293945, 32446, 41.150001525878906, 41.20000076293945, 41.150001525878906, 41.20000076293945, 32446), (\'IDFCBANK\', \'03-Aug-2018\', 1533289800, 365, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 56141, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 56141), (\'IDFCBANK\', \'03-Aug-2018\', 1533289860, 366, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 29762, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 29762), (\'IDFCBANK\', \'03-Aug-2018\', 1533289920, 367, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 34602, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 34602), (\'IDFCBANK\', \'03-Aug-2018\', 1533289980, 368, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 53323, 41.150001525878906, 41.150001525878906, 41.150001525878906, 41.150001525878906, 53323), (\'IDFCBANK\', \'03-Aug-2018\', 1533290040, 369, 41.150001525878906, 41.25, 41.150001525878906, 41.25, 48317, 41.150001525878906, 41.25, 41.150001525878906, 41.25, 48317), (\'IDFCBANK\', \'03-Aug-2018\', 1533290100, 370, 41.20000076293945, 41.25, 41.20000076293945, 41.25, 53886, 41.20000076293945, 41.25, 41.20000076293945, 41.25, 53886), (\'IDFCBANK\', \'03-Aug-2018\', 1533290160, 371, 41.20000076293945, 41.25, 41.20000076293945, 41.25, 38768, 41.20000076293945, 41.25, 41.20000076293945, 41.25, 38768), (\'IDFCBANK\', \'03-Aug-2018\', 1533290220, 372, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 24601, 41.20000076293945, 41.20000076293945, 41.20000076293945, 41.20000076293945, 24601), (\'IDFCBANK\', \'03-Aug-2018\', 1533290280, 373, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 35942, 41.20000076293945, 41.20000076293945, 41.150001525878906, 41.150001525878906, 35942), (\'IDFCBANK\', \'03-Aug-2018\', 1533290340, 374, 41.150001525878906, 41.150001525878906, 41.04999923706055, 41.150001525878906, 59623, 41.150001525878906, 41.150001525878906, 41.04999923706055, 41.150001525878906, 59623),?,?,?,?,?,?,?,?) ON DUPLICATE KEY  UPDATE OPEN = ?, HIGH = ?, LOW=?, CLOSE =?, VOLUME = ? ' 

select * from bracket_

SELECT * FROM INSTRUMENT_TOKENS
where exchange = 'NSE'
CREATE TABLE INSTRUMENT_TOKENS (
instrument_token DECIMAL(20,0),
	exchange_token DECIMAL(20,0),
	tradingsymbol	VARCHAR(30),
    name VARCHAR(100),
	segment	VARCHAR(25),
    exchange VARCHAR(30)
)



############ #################
select * from
(
select symbol, sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset <=3
and day <> '09-Aug-2018'
group by symbol
order by symbol, sum(volume) desc
) allday,
(
select symbol, sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset <=3
and day = '09-Aug-2018'
group by symbol
having sum(volume) > 10000
order by symbol, sum(volume) desc
) today
where allday.symbol = today.symbol
order by today.total * allday.cnt/allday.total * today.cnt desc
limit 5


select * from stock_minute_data
where volume is not null
and minuteOffset <=30
and day = '08-Aug-2018'
and symbol ='MERCK'
having sum(volume) > 10000
//Create a volume chart .. BUY stock having highest difference in first minute . Sell them after 15 minute if they already have a good profit.
 




#### NIFTY NEXT 400, 9:25 AM HIGH VILUMES  ########
select purchase.*,sell.potential,  sell.sellval ,  (sell.potential -  purchase.open ) * 100 / purchase.open ,  ( purchase.open - sell.sellval ) * 100 / purchase.open from
(
select symbol,  sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset <=12
group by symbol
order by symbol, sum(volume) desc
) as allday,
(select symbol from nifty_500 as n500
 where  not exists ( 
 select  symbol from nifty_100 as n100  where n100.symbol = n500.symbol)
 ) as nifty_400,
(
select symbol, day, avg(open) open, sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset <=12
group by symbol, day
having sum(volume) > 10000
order by symbol, sum(volume) desc
) as today,

(
select symbol, open, day from stock_minute_data
where volume is not null
and minuteOffset =15

) as purchase,
(select min(open) sellval, day, max(open) potential, symbol from stock_minute_data
where volume is not null
and minuteOffset >=10
and minuteoffset <=320
group by symbol, day

) as sell
where allday.symbol = today.symbol
and allday.symbol = nifty_400.symbol
and allday.symbol = sell.symbol
and allday.symbol = purchase.symbol
and today.day = sell.day
and today.day = purchase.day
#and today.symbol = 'IOB'
#and allday.day = '06-Aug-2018'
order by today.total * allday.cnt/allday.total * today.cnt desc
limit 10



####### HIGHEST INCREASE TILL NOW SELL THEM ###
select purchase.*,sell.potential,  sell.sellval ,  (sell.potential -  purchase.open ) * 100 / purchase.open ,  ( purchase.open - sell.sellval ) * 100 / purchase.open from
(
select symbol, day,  sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset <=12
group by symbol, day
order by symbol, sum(volume) desc
) as allday,
(select symbol from nifty_500 as n500
 where  not exists ( 
 select  symbol from nifty_100 as n100  where n100.symbol = n500.symbol)
 ) as nifty_400,
(
select symbol, day, avg(open) open, sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset <=12
group by symbol, day
having sum(volume) > 10000
order by symbol, sum(volume) desc
) as today,

(
select symbol, open, day from stock_minute_data
where volume is not null
and minuteOffset =15

) as purchase,
(select min(open) sellval, day, max(open) potential, symbol from stock_minute_data
where volume is not null
and minuteOffset >=10
and minuteoffset <=320
group by symbol, day

) as sell
where allday.symbol = today.symbol
and allday.symbol = nifty_400.symbol
and allday.symbol = sell.symbol
and allday.symbol = purchase.symbol
and allday.day = sell.day
and allday.day = purchase.day
and allday.day = today.day
#and today.symbol = 'IOB'
and allday.day = '06-Aug-2018'
order by today.total * allday.cnt/allday.total * today.cnt desc
limit 10


############## MIN DEVIATION IN VOLUME ##############
select * from
(
select symbol, sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset >= 0
and minuteOffset <= 350

and day <> '09-Aug-2018'
group by symbol
order by symbol, sum(volume) desc
) allday,
(
select symbol, sum(volume) total, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset >= 0
and minuteOffset <= 350
and day = '09-Aug-2018'
group by symbol
having sum(volume) > 10000
order by symbol, sum(volume) desc
) today
where allday.symbol = today.symbol
order by today.total * allday.cnt/allday.total * today.cnt asc
limit 5


select * from stock_minute_data
where symbol = 'TCS'
and day = '09-Aug-2018'


(
select open from stock_minute_data
where volume is not null
and day = '09-Aug-2018'
and minuteOffset = 300
) , 
(
select open from stock_minute_data
where volume is not null
and day = '09-Aug-2018'
and minuteOffset <= 350
) 




select symbol, avg(volume) average, stddev(volume) deviation, count(*) cnt from stock_minute_data
where volume is not null
and minuteOffset <= 350
and day = '09-Aug-2018'
group by symbol
order by  avg(volume)/stddev(volume)  asc


#########  DAY END HIGH VOLUME AND DECREASE #########
select 100 * (todaysell.open - buyprice)/buyprice , todaysell.open, buytime.*, (maxsell - buyprice) * 100/buyprice maxPercent, (minsell - buyprice) * 100/buyprice minPercent, (avgsell - buyprice) * 100/buyprice avgPercent, selltime.* from 
(
select open buyprice, symbol, day from stock_minute_data
where minuteoffset = 360
and day = '10-Aug-2018'
) buytime,
(
select max(open) maxsell, min(open) minsell , avg(open) avgsell ,  symbol, day from stock_minute_data
where minuteoffset <= 360
group by symbol, day
) selltime,
(
select day, avg(open), symbol, avg(volume) volume from stock_minute_data
where minuteoffset < 360
#and minuteoffset > 330
group by  symbol , day

) avgsell,
(
select day, avg(open) open, symbol, avg(volume) volume from stock_minute_data
where minuteoffset < 360
#and minuteoffset > 330
group by  symbol , day

) todaysell, NIFTY_50 AS NIFTY

where buytime.symbol = selltime.symbol
and buytime.symbol = avgsell.symbol
and buytime.symbol = todaysell.symbol
and buytime.symbol = todaysell.symbol
and buytime.symbol = NIFTY.symbol
and todaysell.day = buytime.day
and avgsell.day  = buytime.day
and buytime.day = '03-Aug-2018'
and selltime.day = '06-Aug-2018'
order by 100 * (todaysell.open - buyprice)/buyprice

#order by avgsell.volume/ todaysell.volume  


#order by today.total * allday.cnt/allday.total * today.cnt desc

















