
----GROUP 1----

--Group 1 2189 
select count(distinct user_id)
from temptablesmo.active_veteran_app_users
where app_session_bucket = 'Fully Transitioned'

---ORDERS DATA---

--Group 1 before app adoption, orders, total spent, and AOV - 2189|14,005|83.18
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull 
	and shipping >= '2022-03-07' and shipping <='2022-06-15')
select count(distinct g1.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_1 g1
left join orders_data od on g1.sub_ids = od.subscription

--Group 1 after app adoption, orders, total spent, and AOV - 2189 | 14966 | 93.86
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull
	and shipping >='2023-03-07' and shipping <='2023-06-15')
select count(distinct g1.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_1 g1
left join orders_data od on g1.sub_ids = od.subscription

---CUSTOMIZATION---

--Group 1 customized orders before app 1581|11926 --fixed years 15144 total orders
with group_1 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Fully Transitioned'),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true and 
	c.order_id is not null
	group by 1, 3, 2)
select count(distinct g1.users)customers, count(distinct co.ordered) orders
from group_1 g1
join cart_orders co on g1.users = co.customers

with group_1 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Fully Transitioned'),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	join heroku_postgres.order_items oi on c.order_id = oi.order_id
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true and 
	c.order_id is not null
	group by 1, 3, 2)
select count(distinct g1.users)customers, count(distinct co.ordered) orders
from group_1 g1
join cart_orders co on g1.users = co.customers

---check of above 1581 users
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
orders_data as (select oi.order_id order_ids, sum(oi.price) price, s.user_id users, 
date(m.shipping_on) shipping, c.overridden_recipes 
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	join heroku_postgres.carts c on o.id = c.order_id
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull 
	and shipping >= '2022-03-07' and shipping <='2022-06-15' and c.overridden_recipes
group by 1, 3, 4, 5)
select count(distinct g1.users) users, count(distinct od.order_ids) orders, sum(od.price) total_spent,
Round((total_spent/orders),2) AOV
from group_1 g1
join orders_data od on g1.users = od.users


select oi.order_id order_ids, sum(oi.price) price, s.user_id users, date(m.shipping_on) shipping, c.overridden_recipes 
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	join heroku_postgres.carts c on o.id = c.order_id
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull 
	and shipping >= '2022-03-07' and shipping <='2022-06-15' and s.user_id = 1445823
group by 1, 3, 4, 5
limit 100



--Group 1 count of customizations
with group_1 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Fully Transitioned'),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true
	group by 1, 3, 2)
select count(co.cart_id)
from group_1 g1
join cart_orders co on g1.users = co.customers

--Group 1 customized orders after app 1804 customers | 8802 orders, 13,277 changes | 1.51 changes per order 
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_1 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Fully Transitioned')
select count(distinct g1.users) customers, count(distinct ca.orders) orders, count(cust.platform)changes, 
Round((count(cust.platform)::decimal/count(distinct ca.orders)::decimal),2) avg_cust
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_1 g1 on ca.customer = g1.users

--Group 1 customized orders 13,277 changes \ 11528 App \ 950 desktop \ 799 mobile web
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_1 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Fully Transitioned')
select cust.platform, count(cust.platform) changes
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_1 g1 on ca.customer = g1.users
	group by 1

select substring(cc.cart, 7, 7)cart_id, count(cart_id) id_count, count(distinct pc_source_v2) platforms
from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'
	group by 1
	having id_count >=2
	order by 1

with custom as (select substring(cc.cart, 7, 7)cart_id, pc_source_v2, av.app_session_bucket
from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	join temptablesmo.active_veteran_app_users av on u."identity" = av.user_id
	where cart_id = 4449384),
cart_orders as(select carts.id cart_id, carts.order_id
from heroku_postgres.carts )
select cc.cart_id, cc.pc_source_v2, co.order_id
from custom cc
join cart_orders co on cc.cart_id = co.cart_id


---SKIPS---

--Group 1 skips before app release 1570|11095
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
skips as(select user_id user_skip
	from heroku_postgres.skip_menu_surveys sms
	where updated_at >= '2022-03-07' and updated_at <='2022-06-15')
select count(distinct g1.users) customers, count(s.user_skip) skips
from group_1 g1
join skips s on g1.users = s.user_skip

--Group 1 skips since app release 608|1854
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
skips as(select user_id user_skip
	from heroku_postgres.skip_menu_surveys sms
	where updated_at >='2023-03-07'and updated_at <= '2023-06-15')
select count(distinct g1.users) customers, count(s.user_skip) skips
from group_1 g1
join skips s on g1.users = s.user_skip

--once this data is productionized in dash, it might be helpful to show skips as a percentage to 
--better contexualize. like total skips/total carts or something like that --- I agree

---RECIPE VIEWS---

--Group 1 before app -- 1496|30818
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
recipe_pages as(select date(p."time") event_date, u."identity" user_ids, p."path" page
	from main_production.pageviews p
	join main_production.users u on p.user_id = u.user_id
	where user_ids is not null and p."path" like('/recipe/%') and event_date >='2022-03-07' 
	and event_date <='2022-06-15'
	order by event_date desc)
select count(distinct g1.users) customers, count( rp.page) views, Round((views/customers),2) avg_views
from group_1 g1
join recipe_pages rp on g1.users = rp.user_ids;


--Group 1 after app,only 2059|17405 --
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
recipe_pages as(select  u."identity" user_ids, count(vrs.product_title) page_count
	from main_production.visit_recipe_show vrs 
	join main_production.users u on vrs.user_id = u.user_id
	where u."identity" is not null and vrs."time" >='2023-03-07' and vrs."time" <= '2023-06-15'
	group by 1)
select count (distinct g1.users) customers, sum(rp.page_count) views, Round((views/customers),2) avg_views
from group_1 g1
join recipe_pages rp on g1.users = rp.user_ids;

--in production, might be helpful to display this is
-- average recipe views per customer. total_views/customers --agreed

--Group 1 after app, app vs web views  2059|17,405
with group_1 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Fully Transitioned'),
recipe_pages as(select  u."identity" user_ids, count(distinct vrs.session_id) views, vrs.pc_source_v2 "source"
	from main_production.visit_recipe_show vrs 
	join main_production.users u on vrs.user_id = u.user_id
	where u."identity" is not null and vrs."time" >='2023-03-07' and vrs."time" <= '2023-06-15'
	group by 1, 3)
select count(distinct g1.users) customers, 
 		sum(case when (rp."source"='App') then rp.views else NULL end) as app_views,
        sum(case when (rp."source" like('%Tablet%')) then rp.views else NULL end) as mobile_web,
        sum(case when (rp."source" like('%Desktop%')) then rp.views else NULL end) as desktop
from group_1 g1
join recipe_pages rp on g1.users = rp.user_ids;

-- i think counting non-distinct pc_source_v2 here is causing the app data to behave weirdly. 
--it might be better to count distinct sessions. see comparison below for app

select  v.user_id, product_title, count (product_title)page_visits, count(distinct session_id)sessions
from main_production.visit_recipe_show v
where pc_source = 'App' and product_title is not null
group by 1, 2
order by user_id

select pc_source_v2, count(distinct session_id) total_unique_sessions, count( product_id)
from  main_production.visit_recipe_show 
group by pc_source_v2;

---------GROUP 2-----------

--Group 2 1227
select count(distinct user_id)
from temptablesmo.active_veteran_app_users
where app_session_bucket = 'Partially Transition'

---ORDERS DATA---

--Group 2 before app adoption, orders, total spent, and AOV - 1227|7612|82.21
with group_2 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Partially Transition'),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull 
	and shipping >= '2022-03-07' and shipping <='2022-06-15')
select count(distinct g2.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_2 g2
left join orders_data od on g2.sub_ids = od.subscription;

--Group 2 after app adoption, orders, total spent, and AOV - 1227|7912|92.06
with group_2 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Partially Transition'),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull
	and shipping >='2023-03-07' and shipping <='2023-06-15')
select count(distinct g2.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_2 g2
left join orders_data od on g2.sub_ids = od.subscription;

---CUSTOMIZATION---

--Group 2 customized orders before app 858 customers | 6210 changed orders |8244 total orders
with group_2 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Partially Transition'),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true
	group by 1, 3, 2)
select count(distinct g2.users)customers, count(distinct co.ordered) orders
from group_2 g2
join cart_orders co on g2.users = co.customers;

--Group 2 count of customizations 6,211 changed carts
with group_2 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Partially Transition'),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true
	group by 1, 3, 2)
select count(co.cart_id)
from group_2 g2
join cart_orders co on g2.users = co.customers

--Group 2 customized orders after app 1011 cust | 4664 orders | 7056 changes | 1.51 changes per order
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_2 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Partially Transition')
select count(distinct g2.users) customers, count(distinct ca.orders) orders, count(cust.platform), 
Round((count(cust.platform)::decimal/count(distinct ca.orders)::decimal),2) avg_cust
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_2 g2 on ca.customer = g2.users

--Group 2 changes 7056 total changes \ 3848 app \ 1378 mobile web \ 1830 desktop
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_2 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Partially Transition')
select cust.platform, count(cust.platform) changes
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_2 g2 on ca.customer = g2.users
	group by 1

	

---SKIPS---

with all_cust As(select user_id customers
from heroku_postgres.subscriptions),
skips as(select user_id user_skip
from heroku_postgres.skip_menu_surveys sms
where updated_at >= '2022-03-07' and updated_at <='2022-06-15')
select count(distinct ag.customers) customers, count(s.user_skip) skips
from all_cust ag
join skips s on ag.customers = s.user_skip
	

--Group 2 skips before app release 877|6007
with group_2 As(select av.user_id users, s.id sub_ids
from temptablesmo.active_veteran_app_users av
join heroku_postgres.subscriptions s on av.user_id = s.user_id 
where app_session_bucket = 'Partially Transition'),
skips as(select user_id user_skip
from heroku_postgres.skip_menu_surveys sms
where updated_at >= '2022-03-07' and updated_at <='2022-06-15')
select count(distinct g2.users) customers, count(s.user_skip) skips
from group_2 g2
join skips s on g2.users = s.user_skip

--Group 2 skips since app release 834|3306
with group_2 As(select av.user_id users, s.id sub_ids
from temptablesmo.active_veteran_app_users av
join heroku_postgres.subscriptions s on av.user_id = s.user_id 
where app_session_bucket = 'Partially Transition'),
skips as(select user_id user_skip
from heroku_postgres.skip_menu_surveys sms
where updated_at >='2023-03-07'and updated_at <= '2023-06-15')
select count(distinct g2.users) customers, count(s.user_skip) skips
from group_2 g2
join skips s on g2.users = s.user_skip

---RECIPE VIEWS---

--Group 2 before app -- 839|18961
with group_2 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Partially Transition'),
recipe_pages as(select date(p."time") event_date, u."identity" user_ids, p."path" page
	from main_production.pageviews p
	join main_production.users u on p.user_id = u.user_id
	where user_ids is not null and p."path" like('/recipe/%') and event_date >='2022-03-07' 
	and event_date <='2022-06-15'
	order by event_date desc)
select count(distinct g2.users)customers, count(rp.page) views, Round((views/customers),2) avg_views
from group_2 g2
join recipe_pages rp on g2.users = rp.user_ids

--Group 2 after app, app views only 1119|12572 --
with group_2 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Partially Transition'),
recipe_pages as(select  u."identity" user_ids, count(vrs.product_title) page_count
	from main_production.visit_recipe_show vrs 
	join main_production.users u on vrs.user_id = u.user_id
	where u."identity" is not null and vrs."time" >='2023-03-07' and vrs."time" <= '2023-06-15'
	group by 1)
select count (distinct g2.users) customers, sum(rp.page_count) views, Round((views/customers),2) avg_views
from group_2 g2
join recipe_pages rp on g2.users = rp.user_ids;

--Group 2 after app, app views only 1052|5570 --
with group_2 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Partially Transition'),
recipe_pages as(select  u."identity" user_ids, count(distinct vrs.session_id) views
	from main_production.visit_recipe_show vrs 
	join main_production.users u on vrs.user_id = u.user_id
	where u."identity" is not null and vrs."time" >='2023-03-07' and vrs."time" <= '2023-06-15' and vrs.pc_source_v2 = 'App'
	group by 1)
select count(distinct g2.users)customers, sum(rp.views)
from group_2 g2
join recipe_pages rp on g2.users = rp.user_ids

--Group 2 after app, app vs web views 1119 | 5570 app | 8548 web --after launch but broken out by platform
with group_2 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Partially Transition'),
recipe_pages as(select  u."identity" user_ids, count(distinct vrs.session_id) views, vrs.pc_source_v2 "source"
	from main_production.visit_recipe_show vrs 
	join main_production.users u on vrs.user_id = u.user_id
	where u."identity" is not null and vrs."time" >='2023-03-07' and vrs."time" <= '2023-06-15'
	group by 1, 3)
select count(distinct g2.users) customers, 
 		sum(case when (rp."source"='App') then rp.views else NULL end) as app_views,
        sum(case when (rp."source" like('%Web')) then rp.views else NULL end) as web_views
from group_2 g2
join recipe_pages rp on g2.users = rp.user_ids


---GROUP 3---

select count(distinct user_id)
from temptablesmo.active_veteran_app_users
where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3

---ORDERS DATA---

--Group 3 before app adoption, orders, total spent, and AOV - 668 | 4619 | 82.99
with group_3 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull 
	and shipping >= '2022-03-07' and shipping <='2022-06-15')
select count(distinct g3.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_3 g3
left join orders_data od on g3.sub_ids = od.subscription;

--Group 3 after app adoption, orders, total spent, and AOV - 668 | 4401 | 91.38
with group_3 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull
	and shipping >='2023-03-07' and shipping <='2023-06-15')
select count(distinct g3.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_3 g3
left join orders_data od on g3.sub_ids = od.subscription;

---SKIPS---

--Group 3 skips before app release 514|3663
with group_3 As(select av.user_id users, s.id sub_ids
from temptablesmo.active_veteran_app_users av
join heroku_postgres.subscriptions s on av.user_id = s.user_id 
where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
skips as(select user_id user_skip
from heroku_postgres.skip_menu_surveys sms
where updated_at >= '2022-03-07' and updated_at <='2022-06-15')
select count(distinct g3.users) customers, count(s.user_skip) skips
from group_3 g3
join skips s on g3.users = s.user_skip

--Group 3 skips since app release 526|3056
with group_3 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
skips as(select user_id user_skip
	from heroku_postgres.skip_menu_surveys sms
	where updated_at >='2023-03-07'and updated_at <= '2023-06-15')
select count(distinct g3.users) customers, count(s.user_skip) skips
from group_3 g3
join skips s on g3.users = s.user_skip

---CUSTOMIZATION---
--Group 3 customized orders before app 529 customers | 3920 changed orders |4992 total orders
with group_3 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true
	group by 1, 3, 2)
select count(distinct g3.users)customers, count(distinct co.ordered) orders
from group_3 g3
join cart_orders co on g3.users = co.customers;

--Group 3 count of customizations 3921 changed carts
with group_3 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true
	group by 1, 3, 2)
select count(co.cart_id)
from group_3 g3
join cart_orders co on g3.users = co.customers

--Group 3 customized orders after app 554 cust | 2595 orders | 3975 changes | 1.53 changes per order
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_3 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3)
select count(distinct g3.users) customers, count(distinct ca.orders) orders, count(cust.platform) changes, 
Round((count(cust.platform)::decimal/count(distinct ca.orders)::decimal),2) avg_cust
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_3 g3 on ca.customer = g3.users

--Group 3 changes 3975 total changes \ 1108 app \ 1036 mobile web \ 1831 desktop
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_3 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3)
select cust.platform, count(cust.platform) changes
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_3 g3 on ca.customer = g3.users
	group by 1

	
	----RECIPES-----
--499 \ 10779 before 
with group_3 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
recipe_pages as(select date(p."time") event_date, u."identity" user_ids, p."path" page
	from main_production.pageviews p
	join main_production.users u on p.user_id = u.user_id
	where user_ids is not null and p."path" like('/recipe/%') and event_date >='2022-03-07' 
	and event_date <='2022-06-15'
	order by event_date desc)
select count(distinct g3.users)customers, count(rp.page) views, Round((views/customers),2) avg_views
from group_3 g3
join recipe_pages rp on g3.users = rp.user_ids

--Group 3 after app,  601|3594 --
with group_3 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc >= 0.3),
recipe_pages as(select  u."identity" user_ids, count(vrs.product_title) page_count
	from main_production.visit_recipe_show vrs 
	join main_production.users u on vrs.user_id = u.user_id
	where u."identity" is not null and vrs."time" >='2023-03-07' and vrs."time" <= '2023-06-15'
	group by 1)
select count (distinct g3.users) customers, sum(rp.page_count) views, Round((views/customers),2) avg_views
from group_3 g3
join recipe_pages rp on g3.users = rp.user_ids;





---GROUP 4 ---
select count(distinct user_id)
from temptablesmo.active_veteran_app_users
where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3

---ORDERS DATA---

--Group 4 before app adoption, orders, total spent, and AOV - 958 | 6653 | 83.37
with group_4 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull 
	and shipping >= '2022-03-07' and shipping <='2022-06-15')
select count(distinct g4.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_4 g4
left join orders_data od on g4.sub_ids = od.subscription;

--Group 4 after app adoption, orders, total spent, and AOV - 958 | 6534 | 92.37
with group_4 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
orders_data As(select oi.order_id order_ids, oi.price price, o.subscription_id subscription, date(m.shipping_on) shipping
	from heroku_postgres.order_items oi 
	join heroku_postgres.orders o on oi.order_id = o.id 
	join heroku_postgres.subscriptions s on o.subscription_id = s.id 
	join heroku_postgres.menus m on o.menu_id =m.id 
	where o.fulfillment_status =1 and o.deleted_at isnull and oi.deleted_at isnull
	and shipping >='2023-03-07' and shipping <='2023-06-15')
select count(distinct g4.users) customers, count(distinct od.order_ids) orders, 
	sum(od.price) total_spent, Round((total_spent/orders),2) AOV
from group_4 g4
left join orders_data od on g4.sub_ids = od.subscription;

---SKIPS---

--Group 4 skips before app release 514|3663
with group_4 As(select av.user_id users, s.id sub_ids
from temptablesmo.active_veteran_app_users av
join heroku_postgres.subscriptions s on av.user_id = s.user_id 
where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
skips as(select user_id user_skip
from heroku_postgres.skip_menu_surveys sms
where updated_at >= '2022-03-07' and updated_at <='2022-06-15')
select count(distinct g4.users) customers, count(s.user_skip) skips
from group_4 g4
join skips s on g4.users = s.user_skip

--Group 4 skips since app release 807|5548
with group_4 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
skips as(select user_id user_skip
	from heroku_postgres.skip_menu_surveys sms
	where updated_at >='2023-03-07'and updated_at <= '2023-06-15')
select count(distinct g4.users) customers, count(s.user_skip) skips
from group_4 g4
join skips s on g4.users = s.user_skip

---CUSTOMIZATION---
--Group 4 customized orders before app 756 customers | 5965 changed orders |7219 total orders
with group_4 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true
	group by 1, 3, 2)
select count(distinct g4.users)customers, count(distinct co.ordered) orders
from group_4 g4
join cart_orders co on g4.users = co.customers;

--Group 4 count of customizations 5965 changed carts
with group_4 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
cart_orders as(select c.user_id customers, c.order_id ordered, c.id cart_id
	from heroku_postgres.carts c
	where c.created_at >='2022-03-07'and c.created_at <='2022-06-15' and c.overridden_recipes is true
	group by 1, 3, 2)
select count(co.cart_id)
from group_4 g4
join cart_orders co on g4.users = co.customers

--Group 4 customized orders after app 805 cust | 4005 orders | 6941 changes | 1.73 changes per order
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_4 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3)
select count(distinct g4.users) customers, count(distinct ca.orders) orders, count(cust.platform) changes, 
Round((count(cust.platform)::decimal/count(distinct ca.orders)::decimal),2) avg_cust
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_4 g4 on ca.customer = g4.users

--Group 4 changes 6941 total changes \ 564 app \ 2906 mobile web \ 3471 desktop
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'),
group_4 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3)
select cust.platform, count(cust.platform) changes, count(distinct g4.users) customers
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_4 g4 on ca.customer = g4.users
	group by 1

--who are the mobile web people?
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15' and cc.pc_source_v2 = 'Mobile and Tablet Web'),
group_4 as(select  av.user_id users, date(ws.birthday) birthday,  (date('2023-06-15')-date(birthday))/365 "age",  ws.gender gender
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		left join heroku_postgres.welcome_surveys ws on ws.user_id = av.user_id
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3 and birthday > '1934-01-01')
select g4."age", g4.gender, count(distinct g4.users)
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_4 g4 on ca.customer = g4.users
	group by 1, 2

	---with age groups
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'and cc.pc_source_v2 = 'Mobile and Tablet Web'),
group_4 as(select  av.user_id users, date(ws.birthday) birthday,  (date('2023-06-15')-date(birthday))/365 "age",  ws.gender gender
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		left join heroku_postgres.welcome_surveys ws on ws.user_id = av.user_id
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3 and birthday > '1934-01-01')
select  case when g4."age" <20 then 'under 20'
	when g4."age" >=20 and g4."age" <30 then '20s'
	when g4."age" >=30 and g4."age" <40 then '30s'
	when g4."age" >=40 and g4."age" <50 then '40s'
	when g4."age" >=50 and g4."age" <60 then '50s'
	when g4."age" >=60 and g4."age" <70 then '60s'
	when g4."age" >=70 then 'over 70'
	else 'other' end age_group, count(distinct g4.users)
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_4 g4 on ca.customer = g4.users
	group by 1
	order by 2 desc
	
	---by gender
with carts as (select c.user_id customer, c.id cart_id, c.order_id orders
	from heroku_postgres.carts c
	where c.created_at>='2023-03-07' and c.created_at <='2023-06-15' and c.order_id is not null),
carts_customized as (select u."identity" user_ids, substring(cc.cart, 7, 7)cart_id, cc.pc_source_v2 platform
	from main_production.cart_customized cc
	join main_production.users u on cc.user_id = u.user_id
	where cc."time" >='2023-03-07' and cc."time" <='2023-06-15'and cc.pc_source_v2 = 'Mobile and Tablet Web'),
group_4 as(select  av.user_id users, date(ws.birthday) birthday,  (date('2023-06-15')-date(birthday))/365 "age",  ws.gender gender
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		left join heroku_postgres.welcome_surveys ws on ws.user_id = av.user_id
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3 and birthday > '1934-01-01')
select  g4.gender, count(distinct g4.users)
	from carts ca
	join carts_customized cust on ca.cart_id = cust.cart_id
	join group_4 g4 on ca.customer = g4.users
	group by 1
	order by 2 desc
	
	
	---platform and device breakdown
with group_4 as(select av.user_id users, s.id sub_ids
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
device as(select u."identity" user_id, p.device_type device, 
case when p.platform like('iOS%') then 'iOS'
	when p.platform like('Android%') then 'Android'
	else 'Other' end platform
	from main_production.pageviews p
	join main_production.users u on p.user_id = u.user_id
	where p."time" >='2023-03-07' and p."time" <='2023-06-15' and p."library" = 'web' and (p.device_type = 'Mobile' or p.device_type = 'Tablet'))
select d.device, d.platform, count(distinct g4.users)
from group_4 g4
join device d on g4.users = d.user_id
group by 1, 2
order by 3 desc

---age and gender of these users
with group_4 as(select  av.user_id users, date(ws.birthday) birthday, ws.gender gender
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		left join heroku_postgres.welcome_surveys ws on ws.user_id = av.user_id
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3 and birthday > '1934-01-01'),
device as(select u."identity" user_id, p.device_type device, 
case when p.platform like('iOS%') then 'iOS'
	when p.platform like('Android%') then 'Android'
	else 'Other' end platform
	from main_production.pageviews p
	join main_production.users u on p.user_id = u.user_id
	where p."time" >='2023-03-07' and p."time" <='2023-06-15' and p."library" = 'web' and (p.device_type = 'Mobile' or p.device_type = 'Tablet'))
select d.device, d.platform, count(distinct g4.users)
from group_4 g4
join device d on g4.users = d.user_id
group by 1, 2
order by 3

select  av.user_id users, date(ws.birthday) birthday,  (date('2023-06-15')-date(birthday))/365 "age",  ws.gender gender,
	case when g4."age" <20 then 'under 20'
	when g4."age" >=20 and g4."age" <30 then '20s'
	when g4."age" >=30 and g4."age" <40 then '30s'
	when g4."age" >=40 and g4."age" <50 then '40s'
	when g4."age" >=50 and g4."age" <60 then '50s'
	when g4."age" >=60 and g4."age" <70 then '60s'
	when g4."age" >=70 then 'over 70'
	else 'other' end age_group,
		from temptablesmo.active_veteran_app_users av
		join heroku_postgres.subscriptions s on av.user_id = s.user_id 
		left join heroku_postgres.welcome_surveys ws on ws.user_id = av.user_id
		where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3 and birthday > '1934-01-01'
		
		
---RECIPES---
--group 4 pre app 
with group_4 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
recipe_pages as(select date(p."time") event_date, u."identity" user_ids, p."path" page
	from main_production.pageviews p
	join main_production.users u on p.user_id = u.user_id
	where user_ids is not null and p."path" like('/recipe/%') and event_date >='2022-03-07' 
	and event_date <='2022-06-15'
	order by event_date desc)
select count(distinct g4.users)customers, count(rp.page) views, Round((views/customers),2) avg_views
from group_4 g4
join recipe_pages rp on g4.users = rp.user_ids

--Group 4 after app,  601|3594 --
with group_4 As(select av.user_id users, s.id sub_ids
	from temptablesmo.active_veteran_app_users av
	join heroku_postgres.subscriptions s on av.user_id = s.user_id 
	where app_session_bucket = 'Non-Transitional' and app_session_perc < 0.3),
recipe_pages as(select  u."identity" user_ids, count(vrs.product_title) page_count
	from main_production.visit_recipe_show vrs 
	join main_production.users u on vrs.user_id = u.user_id
	where u."identity" is not null and vrs."time" >='2023-03-07' and vrs."time" <= '2023-06-15'
	group by 1)
select count (distinct g4.users) customers, sum(rp.page_count) views, Round((views/customers),2) avg_views
from group_4 g4
join recipe_pages rp on g4.users = rp.user_ids;
order by 2


select app_session_perc
		from temptablesmo.active_veteran_app_users av
group by 1
order by 1