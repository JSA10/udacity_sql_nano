select * from regions limit 10

SELECT COUNT(DISTINCT r.country_name), COUNT(DISTINCT r.country_code), COUNT(DISTINCT r.region), 
       COUNT(DISTINCT r.income_group), count(*)
FROM regions r;

SELECT r.country_name, r.income_group
FROM regions r
WHERE r.income_group = 'NULL';

SELECT DISTINCT r.region
FROM regions r;

SELECT DISTINCT r.income_group
FROM regions r;

SELECT COUNT(DISTINCT(l.country_name)), count(l.country_code), count(*)
FROM land_area l;

SELECT COUNT(DISTINCT (l.year)),  COUNT(DISTINCT (l.total_area_sq_mi))
FROM land_area l;

SELECT MIN(l.year), MAX(l.year)
FROM land_area l;

SELECT MIN(l.total_area_sq_mi), MAX(l.total_area_sq_mi)
FROM land_area l;

SELECT COUNT(f.country_name), count(f.country_code), count(*)
FROM forest_area f;

SELECT COUNT(DISTINCT(f.country_name)), COUNT(DISTINCT(f.country_code)), COUNT(DISTINCT (f.year)),  COUNT(DISTINCT (f.forest_area_sqkm))
FROM forest_area f;

SELECT MIN(f.year), MAX(f.year)
FROM forest_area f;

SELECT MIN(f.forest_area_sqkm), MAX(f.forest_area_sqkm)
FROM forest_area f;

SELECT * from land_area l;

SELECT f.country_code, f.country_name, f.year, f.forest_area_sqkm, l.total_area_sq_mi, r.region, r.income_group
FROM forest_area f
LEFT JOIN land_area l
ON f.country_code = l.country_code AND f.year = l.year
LEFT JOIN regions r
ON f.country_code = r.country_code;

CREATE VIEW forestation
AS 
SELECT f.country_code, f.country_name, f.year, f.forest_area_sqkm, l.total_area_sq_mi, r.region, r.income_group, 
	   l.total_area_sq_mi * 2.59 as total_area_sqkm, f.forest_area_sqkm / (l.total_area_sq_mi * 2.59) as percent_forest
FROM forest_area f
LEFT JOIN land_area l
ON f.country_code = l.country_code AND f.year = l.year
LEFT JOIN regions r
ON f.country_code = r.country_code;
