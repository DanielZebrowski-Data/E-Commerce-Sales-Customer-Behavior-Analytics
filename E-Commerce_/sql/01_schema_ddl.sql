			-- Project: E-Commerce Sales & Customer Analytics
			-- Script: 01_schema_ddl.sql
			-- Description: Creates schema, dimension tables, and fact table

create schema if not exists ecommerce;
set search_path to ecommerce;

create table if not exists dim_customers(
	customer_id varchar(30) primary key,
	customer_name varchar(50),
	customer_age int,
	gender varchar(10),
	customer_segment varchar(20),
	customer_city varchar(30),
	customer_state varchar(30),
	customer_country varchar(20),
	region varchar(30),
	customer_postal_code varchar(20),
	customer_acquisition_cost numeric(10, 2)
);
select * from ecommerce.dim_customers;

create table if not exists dim_products(
	product_id varchar(30) primary key,
	product_name varchar(255),
	product_category varchar(50),
	product_subcategory varchar(50),
	brand varchar(30),
	supplier varchar(30),
	unit_price numeric(10,2),
	product_cost numeric(10,2),
	product_rating numeric(3,1)
);
select * from ecommerce.dim_products;

create table if not exists dim_dates(
	full_date date primary key,
	year int,
	quarter int,
	month_num int,
	month_name varchar(20),
	day_of_week varchar(20),
	is_weekend boolean
);
select * from ecommerce.dim_dates;

create table if not exists fact_sales(
	sales_id serial primary key,
	customer_id varchar(30) references ecommerce.dim_customers(customer_id),
	order_date date references ecommerce.dim_dates(full_date),
	order_id varchar(30),
	quantity int,
	unit_price numeric(10,2),
	gross_sales numeric(10,2),
	net_sales numeric(10,2),
	profit numeric(10,2),
	payment_method varchar(30),
	shipping_method varchar(30),
	order_status varchar(30)
);
select * from ecommerce.fact_sales fs















