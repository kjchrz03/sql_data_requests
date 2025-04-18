with all_recipes as(
SELECT distinct
    "products"."title" AS Kit_Title,
    "products"."subtitle" AS "products.subtitle",
    "products"."title"||' '||"products"."subtitle" Recipe_Title,
    "products"."id" AS product_id,
    "recipe_feedbacks"."sku_id" AS "recipe_feedbacks.sku_id",
     trim(replace(replace(replace(recipe_title, 'and', ''), '&',''), ' ', '')) trimmed_recipe,
     case when recipe_meal_type = 0 THEN 'Dinner'
     when recipe_meal_type = 1 THEN 'Breakfast'
     when recipe_meal_type = 2 THEN 'Lunch'
     when recipe_meal_type = 3 THEN 'Extension'
     ELSE NULL 
     END Meal_Type
FROM
    "heroku_postgres"."recipe_feedback_surveys" AS "recipe_feedback_surveys"
    LEFT JOIN "heroku_postgres"."recipe_feedbacks" AS "recipe_feedbacks" ON "recipe_feedback_surveys"."id" = "recipe_feedbacks"."recipe_feedback_survey_id"
    LEFT JOIN "heroku_postgres"."orders" AS "orders" ON "recipe_feedback_surveys"."order_id" = "orders"."id"
    LEFT JOIN "heroku_postgres"."order_items" AS "order_items" ON "orders"."id" = "order_items"."order_id"
    LEFT JOIN "heroku_postgres"."skus" AS "skus" ON "recipe_feedbacks"."sku_id" = "skus"."id" AND "order_items"."sku_id" = "skus"."id"
    LEFT JOIN "heroku_postgres"."products" AS "products" ON "skus"."product_id" = "products"."id"
GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7
ORDER BY
    6)
,latest_recipe_title as (
SELECT distinct
    "products"."title"||' '||"products"."subtitle" Recipe_Title,
     trim(replace(replace(replace(recipe_title, 'and', ''), '&',''), ' ', '')) trimmed_recipe,
     show_in_products_catalog
FROM
    "heroku_postgres"."recipe_feedback_surveys" AS "recipe_feedback_surveys"
    LEFT JOIN "heroku_postgres"."recipe_feedbacks" AS "recipe_feedbacks" ON "recipe_feedback_surveys"."id" = "recipe_feedbacks"."recipe_feedback_survey_id"
    LEFT JOIN "heroku_postgres"."orders" AS "orders" ON "recipe_feedback_surveys"."order_id" = "orders"."id"
    LEFT JOIN "heroku_postgres"."order_items" AS "order_items" ON "orders"."id" = "order_items"."order_id"
    LEFT JOIN "heroku_postgres"."skus" AS "skus" ON "recipe_feedbacks"."sku_id" = "skus"."id" AND "order_items"."sku_id" = "skus"."id"
    LEFT JOIN "heroku_postgres"."products" AS "products" ON "skus"."product_id" = "products"."id"
    where show_in_products_catalog =1
GROUP BY
    1,
    2,
    3
ORDER BY
    1
)
select a.Kit_Title, b.recipe_title master_title,a.recipe_title, 
listagg(distinct product_id::varchar, ', ')
within group (order by a.Kit_Title) as product_ids
from all_recipes a
join latest_recipe_title b on b.trimmed_recipe=a.trimmed_recipe
group by a.Kit_Title, b.recipe_title,a.recipe_title;