set search_path to ecommerce;
-- Data Quality & Cleaning

-- Referential Integrity Check (Orphan Records)
select
	fs.customer_id
from fact_sales fs
left join ecommerce.dim_customers dc on fs.customer_id = dc.customer_id
where dc.customer_id is null; -- None

--Duplicate Records Check
select 
	fs.order_id,
	count(order_id)
from fact_sales fs
group by order_id
having count(order_id) >1;

--Numerical & Logical Anomalies Check
select 
	*
from fact_sales fs
where 
	fs.quantity <= 0
	or fs.gross_sales < 0 
	or fs.net_sales  < 0; -- ok

-- Categorical Data Audit
select
	fs.payment_method,
	count(fs.payment_method) as value
from fact_sales fs 
group by fs.payment_method 
order by value desc; -- ok

select 
	fs.shipping_method,
	count(fs.shipping_method) as value
from fact_sales fs 
group by fs.shipping_method 
order by value desc; -- ok

select 
	fs.order_status,
	count(fs.order_status) as value
from fact_sales fs 
group by fs.order_status
order by value desc; -- ok 

-- Dimension Tables Audit (dim_customers & dim_products)

select 
	'Customer_id' as column_name,
	dc.customer_id::text as category_value,
	count(*)
from dim_customers dc 
group by dc.customer_id
having count(*) >1
union all
select
	'Customer_country' as column_name,
	dc.customer_country as category_value,
	count(*)
from dim_customers dc
group by dc.customer_country; -- ok



