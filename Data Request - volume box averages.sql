

select month_date, count(distinct order_id)
from(select TO_CHAR('2024-01-06'::timestamp, 'MM/YYYY')AS month_date, b.order_id, sum(volume_quantity) as total_volume
from analytics.mart_orders_detail a
join analytics.confirmed_orders_header b on b.order_id=a.order_id
where b.ship_week_monday >= '2023-02-01'
group by month_date, b.order_id)
group by month_date,derived_table1.total_volume
having total_volume <= 650

SELECT week_start, COUNT(DISTINCT order_id) AS order_count
FROM (
    SELECT
    TO_CHAR(MIN(b.ship_week_monday), 'MM/DD/YY') AS week_start,
    b.order_id,
    sum(a.volume_quantity) AS total_volume
FROM
    analytics.mart_orders_detail a
JOIN
    analytics.confirmed_orders_header b ON b.order_id = a.order_id
WHERE
    b.ship_week_monday = '2023-02-16'
GROUP BY
    b.order_id, TO_CHAR(b.ship_week_monday, 'IYYY-IW')
order by order_id
) AS derived_table
where
    total_volume >=600 and total_volume <=650
GROUP BY
    week_start
order by week_start


SELECT month_date, COUNT(DISTINCT order_id) AS order_count
FROM (
    SELECT
    date_trunc('month', ship_week_monday) month_date,
    b.order_id,
    sum(a.volume_quantity) AS total_volume
FROM
    analytics.mart_orders_detail a
JOIN
    analytics.confirmed_orders_header b ON b.order_id = a.order_id
WHERE
    b.ship_week_monday >= '2023-02-01'
GROUP BY
    month_date, b.order_id
order by order_id
) AS derived_table
where
    total_volume >=600 and total_volume <650
GROUP BY
    month_date
order by month_date





SELECT
    TO_CHAR(MIN(b.ship_week_monday), 'MM/DD/YY') AS week_start,
    COUNT(DISTINCT b.order_id) AS order_count
FROM
    analytics.mart_orders_detail a
JOIN
    analytics.confirmed_orders_header b ON b.order_id = a.order_id
WHERE
    b.ship_week_monday >= '2023-02-01'
GROUP BY
    TO_CHAR(b.ship_week_monday, 'IYYY-IW')
HAVING
    SUM(a.volume_quantity) <= 650
ORDER BY
    TO_CHAR(MIN(b.ship_week_monday), 'MM/DD/YY')
    
    
    


select week_start, count(distinct order_id)
from(SELECT
    TO_CHAR(MIN(b.ship_week_monday), 'MM/DD/YY') AS week_start,
    b.order_id,
    sum(a.volume_quantity) AS total_volume
FROM
    analytics.mart_orders_detail a
JOIN
    analytics.confirmed_orders_header b ON b.order_id = a.order_id
WHERE
    b.ship_week_monday >= '2023-02-01' and b.ship_week_monday <= '2023-12-04'
GROUP BY
    b.order_id, TO_CHAR(b.ship_week_monday, 'IYYY-IW')
having total_volume >=2050
order by order_id)
group by week_start
order by week_start