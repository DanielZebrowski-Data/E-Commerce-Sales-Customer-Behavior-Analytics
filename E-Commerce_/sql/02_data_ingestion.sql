copy ecommerce.dim_customers
from 'C:/path_to_data/customer_master.csv'
delimiter ','
csv header;

copy ecommerce.dim_products
from 'C:/path_to_data/product_catalog.csv'
delimiter ','
csv header;

select count(*) from ecommerce.dim_customers dc;
select count(*) from ecommerce.dim_products dp;


-- create date_hisory
insert into ecommerce.dim_dates(
	full_date, 
	year, 
	quarter, 
	month_num, 
	month_name, 
	day_of_week, 
	is_weekend
)
select 
	datum::date as full_date,
	extract(year from datum) as year,
	extract(quarter from datum) as quarter,
	extract(month from datum) as month_num,
	to_char(datum, 'TMMonth') as month_name,
	to_char(datum, 'TMDay') as day_of_week,
	case
		when extract(isodow from datum) in(6,7) then true
		else False
	end as is_weekend
from generate_series(
	'2021-01-01'::date,
	'2025-12-31'::date,
	'1 day'::interval
)as datum;

select * from ecommerce.dim_dates;

-- create raw db 
create unlogged table if not exists ecommerce.stg_sales();
	
-- transfer values from raw db to original
select * from ecommerce.fact_sales fs; 

insert into ecommerce.fact_sales (
	customer_id,
	order_date,
	order_id,
	quantity,
	unit_price,
	gross_sales,
	net_sales,
	profit,
	payment_method,
	shipping_method,
	order_status
) 
select
	ss.customer_id,
	ss.order_date::date,
	ss.order_id,
	ss.quantity,
	case
		when ss.quantity > 0 then ss.gross_sales  / ss.quantity
		else 0
	end as unit_price,
	ss.gross_sales,
	ss.net_sales,
	ss.profit,
	ss.payment_method,
	ss.shipping_method,
	ss.order_status
from ecommerce.stg_sales ss;








