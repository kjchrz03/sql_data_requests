--select rer.ship_week_monday, drfs.sku_id, dp.title, rer.customer_issue_id, rer.reason, rer.category, 
--drfs.question_2_answer, drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line
--from analytics.rpt_error_rate rer 
--join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
--join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
--where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'
--order by drfs.sku_id, rer.ship_week_monday


with menus as(select rer.ship_week_monday as ship_week, drfs.sku_id,dp.product_id,  dp.title, rer.customer_issue_id, rer.reason, 
rer.category, drfs.question_2_answer::float as flavor_score, 
	drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line, drfs.recipe_feedback_survey_id as survey_id
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'
order by drfs.sku_id, rer.ship_week_monday),
issues as(select rer.ship_week_monday as ship_week, drfs.sku_id, dp.product_id, dp.title, rer.customer_issue_id, rer.reason, rer.category, drfs.question_2_answer::float as flavor_score, 
	drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line, drfs.recipe_feedback_survey_id as survey_id
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit' and rer.customer_issue_id is not null
order by drfs.sku_id, rer.ship_week_monday
),
non_issues as (select rer.ship_week_monday as ship_week, drfs.sku_id, dp.product_id, dp.title, rer.customer_issue_id, rer.reason, rer.category, drfs.question_2_answer::float as flavor_score, 
	drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line, drfs.recipe_feedback_survey_id as survey_id
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'and rer.customer_issue_id is null
order by drfs.sku_id, rer.ship_week_monday)
SELECT 
    m.ship_week, 
    m.product_id, 
    m.title,
       COUNT(DISTINCT m.customer_issue_id) AS issues_recorded, 
    COUNT(DISTINCT m.survey_id) AS surveys_administered, 
    ROUND(AVG(m.flavor_score), 2) AS avg_score,
    ROUND(AVG(i.flavor_score), 2) AS avg_issue_score, 
    ROUND(AVG(ni.flavor_score), 2) AS avg_non_issue_score
FROM 
    menus m
JOIN 
    issues i ON m.product_id = i.product_id
JOIN 
    non_issues ni ON m.product_id = ni.product_id
GROUP BY 
    m.ship_week, m.product_id, m.title
ORDER BY  
    m.ship_week DESC, m.product_id


    
with menu as (select rer.ship_week_monday as ship_week, drfs.sku_id,dp.product_id,  dp.title, rer.customer_issue_id, rer.reason, 
rer.category, drfs.question_2_answer::float as flavor_score, 
	drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line, drfs.recipe_feedback_survey_id as survey_id
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'
order by drfs.sku_id, rer.ship_week_monday)
select ship_week, title, customer_issue_id, reason, question_5_answer, flavor_score
from menu
where customer_issue_id is not null
order by 1 desc
    
    
    
 with issues as(select rer.ship_week_monday as ship_week, drfs.sku_id, dp.product_id, dp.title, rer.customer_issue_id, rer.reason, rer.category, drfs.question_2_answer::float as flavor_score, 
	drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line, drfs.recipe_feedback_survey_id as survey_id
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit' and rer.customer_issue_id is not null
order by drfs.sku_id, rer.ship_week_monday
),
non_issues as (select rer.ship_week_monday as ship_week, drfs.sku_id, dp.product_id, dp.title, rer.customer_issue_id, rer.reason, rer.category, drfs.question_2_answer::float as flavor_score, 
	drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line, drfs.recipe_feedback_survey_id as survey_id
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'and rer.customer_issue_id is null
order by drfs.sku_id, rer.ship_week_monday)
select m. ship_week, m.title,  COUNT(DISTINCT m.customer_issue_id) AS issues_recorded, 
    COUNT(DISTINCT m.survey_id) AS surveys_administered, 
    ROUND(AVG(m.flavor_score), 2) AS avg_score,
    ROUND(AVG(i.flavor_score), 2) AS avg_issue_score, 
    ROUND(AVG(ni.flavor_score), 2) AS avg_non_issue_score
from (select rer.ship_week_monday as ship_week, drfs.sku_id,dp.product_id,  dp.title, rer.customer_issue_id, rer.reason, 
rer.category, drfs.question_2_answer::float as flavor_score, 
	drfs.question_suggestion_answer, drfs.question_5_answer, dp.product_line, drfs.recipe_feedback_survey_id as survey_id
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'
order by drfs.sku_id, rer.ship_week_monday) as  m
join  issues i ON m.product_id = i.product_id
join  non_issues ni ON m.product_id = ni.product_id
group by 1, 2
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

   
 select rer.ship_week_monday, to_char(avg(drfs.question_2_answer::numeric ), 'FM999999999.0') as flavor_score
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'
group by 1
order by 1

 select rer.ship_week_monday, round(avg(drfs.question_2_answer::float ), 2)as flavor_score
from analytics.rpt_error_rate rer 
join analytics.dim_recipe_feedback_surveys drfs  on rer.order_id = drfs.order_id
join analytics.dim_products dp on dp.sku_id = drfs.sku_id 
where rer.ship_week_monday >= '2022-01-01' and dp.product_line = 'Meal Kit'
group by 1
order by 1

select ship_week_monday,  sum(drfs.question_2_answer) as flavor_score_total, count(drfs.question_2_answer) as score_counts, round((flavor_score_total/score_counts),2) as avg_scores
from analytics.dim_recipe_feedback_surveys drfs 
where ship_week_monday >= '2022-01-01'
group by 1



