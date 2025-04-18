--MO pick ticket as a union of MOs and SOs
SELECT 
    moi.mo_num AS mo_number, 
    pti.location_group_name, 
    pti.date_scheduled, 
    dpap.part_num, 
    dpap.part_description, 
    ROUND(SUM(pti.pickitem_qty), 2) AS pickitem_qty,
    pti.uom_code, 
    SUM(pti.vendor_case_qty) AS actual_cases_needed, 
    CEIL(SUM(pti.vendor_case_qty)) AS rounded_cases_needed,  
    pti.vendor_uom_code, 
    SUM(pti.vendor_uom_quantity) AS vendor_uom_total
FROM 
    analytics.pick_ticket_items pti 
JOIN 
    analytics.dim_parts_and_products dpap ON pti.part_id = dpap.part_id
JOIN 
    analytics.work_order_items woi ON pti.wo_item_id = woi.wo_item_id 
JOIN 
    analytics.manufacturing_order_items moi ON woi.woitem_mo_item_id = moi.mo_item_id
WHERE 
    moi.mo_num = 'MK 1738 4/15/24'
GROUP BY 
    1, 2, 3, 4, 5, 7, 10
UNION
SELECT 
    soi.so_num AS mo_number, 
    pti.location_group_name, 
    pti.date_scheduled, 
    dpap.part_num, 
    dpap.part_description, 
    ROUND(SUM(pti.pickitem_qty), 2) AS pickitem_qty,
    pti.uom_code, 
    SUM(pti.vendor_case_qty) AS actual_cases_needed, 
    CEIL(SUM(pti.vendor_case_qty)) AS rounded_cases_needed,  
    pti.vendor_uom_code, 
    SUM(pti.vendor_uom_quantity) AS vendor_uom_total
FROM 
    analytics.pick_ticket_items pti 
JOIN  
    analytics.sales_order_items soi ON soi.so_item_id = pti.so_item_id 
JOIN 
    analytics.dim_parts_and_products dpap ON pti.part_id = dpap.part_id
WHERE 
    so_num = 'MK 1738 4/15/24'
GROUP BY 
    1, 2, 3, 4, 5, 7, 10
    
    
    
  --mo_pick_ticket as CTE in order to filter by 1 criterion in a single where statement  
   with mo_pick_ticket as( SELECT 
    moi.mo_num AS mo_number, 
    pti.location_group_name, 
    pti.date_scheduled, 
    dpap.part_num, 
    dpap.part_description, 
    ROUND(SUM(pti.pickitem_qty), 2) AS pickitem_qty,
    pti.uom_code, 
    SUM(pti.vendor_case_qty) AS actual_cases_needed, 
    CEIL(SUM(pti.vendor_case_qty)) AS rounded_cases_needed,  
    pti.vendor_uom_code, 
    SUM(pti.vendor_uom_quantity) AS vendor_uom_total
FROM 
    analytics.pick_ticket_items pti 
JOIN 
    analytics.dim_parts_and_products dpap ON pti.part_id = dpap.part_id
JOIN 
    analytics.work_order_items woi ON pti.wo_item_id = woi.wo_item_id 
JOIN 
    analytics.manufacturing_order_items moi ON woi.woitem_mo_item_id = moi.mo_item_id
GROUP BY 
    1, 2, 3, 4, 5, 7, 10
UNION
SELECT 
    soi.so_num AS mo_number, 
    pti.location_group_name, 
    pti.date_scheduled, 
    dpap.part_num, 
    dpap.part_description, 
    ROUND(SUM(pti.pickitem_qty), 2) AS pickitem_qty,
    pti.uom_code, 
    SUM(pti.vendor_case_qty) AS actual_cases_needed, 
    CEIL(SUM(pti.vendor_case_qty)) AS rounded_cases_needed,  
    pti.vendor_uom_code, 
    SUM(pti.vendor_uom_quantity) AS vendor_uom_total
FROM 
    analytics.pick_ticket_items pti 
JOIN  
    analytics.sales_order_items soi ON soi.so_item_id = pti.so_item_id 
JOIN 
    analytics.dim_parts_and_products dpap ON pti.part_id = dpap.part_id
GROUP BY 
    1, 2, 3, 4, 5, 7, 10)
  select *
  from mo_pick_ticket
  where mo_number =  'MK 1738 4/15/24'