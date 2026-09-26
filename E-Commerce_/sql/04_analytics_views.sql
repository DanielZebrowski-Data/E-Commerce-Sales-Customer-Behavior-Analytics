		-- Business Analytics & SQL Views

set search_path to ecommerce;

-- Executive KPI Summary
create or replace view vw_exec_kpi_summary as
	select 
		count(fs.order_id) as total_orders,
		count(distinct fs.customer_id) as total_customers,
		sum(fs.gross_sales) as total_gross_value,
		sum(fs.net_sales) as total_net_sales,
		sum(fs.quantity) as total_unit_sold,
		round(sum(fs.net_sales) / count(fs.order_id),2)as avg_order_value
from fact_sales fs;

select * from vw_exec_kpi_summary;

-- Customer Geography & Performance
create or replace view vw_customer_performance as
	select 
		dc.customer_country,
		count(distinct fs.customer_id) as customers,
		sum(fs.net_sales) as total_net_sales,
		round(sum(fs.net_sales) / count(fs.order_id),2) as average_order_value,
		sum(fs.quantity) as total_units_sold
	from fact_sales fs
	left join dim_customers dc on fs.customer_id = dc.customer_id
	group by dc.customer_country;

select * from vw_customer_performance;

--Order Status & Shipping Breakdown
create or replace view vw_order_fulfillment_status as
	select
		fs.shipping_method,
		fs.order_status,
		count(fs.order_id) as total_orders,
		sum(fs.quantity) as total_quantity,
		sum(fs.profit) as total_profit,
		sum(fs.net_sales) as net_sales
	from fact_sales fs
	group by fs.shipping_method, fs.order_status;

select * from vw_order_fulfillment_status;

-- Payment Method Performance
create or replace view vw_payment_method_analysis as
	select
		fs.payment_method,
		sum(fs.profit) as total_profit,
		sum(fs.net_sales) as total_net_sales,
		count(fs.order_id) as total_orders
	from fact_sales fs
	group by fs.payment_method;

select * from vw_payment_method_analysis;

-- Percentage Share
drop view vw_percentage_share_payment_method_analysis;
create or replace view vw_percentage_share_payment_method_analysis as
	select
	    dc.customer_country,
	    fs.payment_method,
	    sum(fs.net_sales)::numeric(12,2) as net_sales_per_method,
	    round(
	        (sum(fs.net_sales) / sum(sum(fs.net_sales)) over(partition by dc.customer_country)) * 100, 2
	    )::numeric(10,2) as pct_share_within_country
	from ecommerce.fact_sales fs
	left join ecommerce.dim_customers dc on fs.customer_id = dc.customer_id
	group by dc.customer_country, fs.payment_method;

select * from vw_percentage_share_payment_method_analysis;