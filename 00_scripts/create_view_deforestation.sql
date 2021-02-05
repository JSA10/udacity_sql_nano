-- forestation view - a joined table for subsequent q & a 

CREATE VIEW forestation
AS 
SELECT f.country_code, f.country_name, f.year, f.forest_area_sqkm, 
       l.total_area_sq_mi, 
       r.region, r.income_group, 
	   l.total_area_sq_mi * 2.59 as total_area_sqkm, 
	   f.forest_area_sqkm / (l.total_area_sq_mi * 2.59) as percent_forest
FROM forest_area f
LEFT JOIN land_area l
ON f.country_code = l.country_code AND f.year = l.year
LEFT JOIN regions r
ON f.country_code = r.country_code;