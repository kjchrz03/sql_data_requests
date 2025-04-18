--total SABs sent
with first_cancel as (
select min(created_at) min_cancel_date, user_id
from heroku_postgres.subscription_cancellations sc 
group by user_id)
,sab_generated as (
select distinct g.created_at sab_created_at, g.id sabid, g.user_id, isnull(fc.min_cancel_date, '2025-01-01') first_cancel
from heroku_postgres.giveaways g
left join first_cancel fc on fc.user_id=g.user_id
where g.created_at between '2022-01-01' and '2022-12-31' -- created in 2021
-- and g.sent_at is not null-- sent invite
and g.expired_at is null)
select count(distinct sabid)total_sabs_gen_excl_first_canceled
from sab_generated
where sab_created_at < first_cancel -- SAB generated before first cancel
;

--total SABs redeemed
with first_cancel as (
select min(created_at) min_cancel_date, user_id
from heroku_postgres.subscription_cancellations sc 
group by user_id)
,sab_generated as (
select distinct g.created_at sab_created_at, g.id sabid, g.user_id, isnull(fc.min_cancel_date, '2025-01-01') first_cancel
from heroku_postgres.giveaways g
left join first_cancel fc on fc.user_id=g.user_id
where g.created_at between '2022-01-01' and '2022-12-31' -- created in 2021
and g.sent_at is not null-- sent invite
and g.expired_at is null)
select count(distinct sabid)redeemed
from sab_generated sg
join heroku_postgres.subscriptions s on s.giveaway_id=sg.sabid
where sab_created_at < first_cancel -- SAB generated before first cancel
and s.registered_at between '2022-01-01' and '2022-12-31';