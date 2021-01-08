-- using this tutorial on YT to import csv file once created the new table
-- https://www.youtube.com/watch?v=Ikd2xSb00UI

CREATE TABLE regions
(
	country_name text,
	country_code text,
	region text,
	income_group text
);

select * from regions;

CREATE TABLE land_area
(
	country_code text,
	country_name text,
	year text,
	total_area_sq_mi double precision
);

select * from land_area;

CREATE TABLE forest_area
(
	country_code text,
	country_name text,
	year text,
	forest_area_sqkm double precision
);

select * from forest_area;