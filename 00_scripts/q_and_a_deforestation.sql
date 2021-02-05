
SELECT f.year, f.forest_area_sqkm
FROM forestation f
WHERE country_name = 'World';

SELECT TOP 1 * 
FROM forestation f
WHERE year = '2016'
ORDER BY ABS(f.forest_area_sqkm - 1324449);

SELECT f.region, f.year,  AS perc_forest
FROM forestation f
WHERE f.year = '2016'
GROUP BY f.year, f.region
ORDER BY perc_forest desc;

