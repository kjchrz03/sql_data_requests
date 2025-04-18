with tmp as(
select date_trunc('month',created_at)::date "month", count(distinct id)total_gift_purchases
,sum(value) total_gift_value
,sum(value_applied)total_gift_value_used
,sum(value_refunded)total_gift_value_refunded
from "heroku_postgres"."gift_purchases"
where sending_method <> 3
and status not in (0,2)
and purchaser_email <> 'bulk.code@thepurplecarrot.com'
group by date_trunc('month',created_at))
select month, total_gift_purchases
, total_gift_value
, total_gift_value_used
, total_gift_value_refunded
from tmp
order by month;

with tmp as(
select date_trunc('month',created_at)::date "month", count(distinct id)total_gift_purchases
,sum(value) total_gift_value
,sum(value_applied)total_gift_value_used
,sum(value_refunded)total_gift_value_refunded
from "heroku_postgres"."gift_purchases"
where sending_method <> 3
and status not in (0,2)
and purchaser_email <> 'bulk.code@thepurplecarrot.com'
group by date_trunc('month',created_at))
select month, total_gift_purchases
, total_gift_value
,total_gift_value_used
,total_gift_value-total_gift_value_used gift_value_unused
, total_gift_value_refunded
--,total_gift_value-total_gift_value_refunded net_gift_value
--,(total_gift_value-total_gift_value_refunded)-total_gift_value_used total_gift_value_unused 
from tmp
where month = '2015-06-01'



with tmp as(
select date_trunc('month',created_at)::date "month", count(distinct id)total_gift_purchases
,sum(value) total_gift_value
,sum(value_applied)total_gift_value_used
,sum(value_refunded)total_gift_value_refunded
from "heroku_postgres"."gift_purchases"
where sending_method <> 3
and status not in (0,2)
and purchaser_email <> 'bulk.code@thepurplecarrot.com'
group by date_trunc('month',created_at))
select month, total_gift_purchases
, total_gift_value
, total_gift_value_used
, total_gift_value_refunded
,total_gift_value-total_gift_value_used unused
,total_gift_value-total_gift_value_used-total_gift_value_refunded unused_minus_refund
from tmp
order by month;



with tmp as(
select date_trunc('month',created_at)::date "month", count(distinct id)total_gift_purchases
,sum(value) total_gift_value
,sum(value_applied)total_gift_value_used
,sum(value_refunded)total_gift_value_refunded
from "heroku_postgres"."gift_purchases"
where sending_method <> 3
and status not in (0,2)
and purchaser_email !~* ('bulk.code|whitespectre|tb12pop')
group by date_trunc('month',created_at))
select month, total_gift_purchases
,total_gift_value
,total_gift_value_used, total_gift_value_refunded
,total_gift_value-total_gift_value_refunded net_gift_value
,(total_gift_value-total_gift_value_refunded)-total_gift_value_used net_gift_value_unused
from tmp
order by month;