
-- 데이터 결합 [실습 8] ==========================================================
SELECT countries.region_id, region_name, country_name
FROM  countries JOIN regions ON (countries.region_id = regions.region_id)
WHERE region_name = 'Europe';


-- 데이터 결합 [실습 9] ==========================================================
SELECT countries.region_id, region_name, country_name, city
FROM countries, regions, locations
WHERE countries.region_id = regions.region_id
  AND countries.country_id = locations.country_id
  AND region_name = 'Europe';
  
  
-- 데이터 결합 [실습 10] ==========================================================
SELECT countries.region_id, region_name, country_name,department_name
FROM countries, regions, locations, departments
WHERE (countries.region_id = regions.region_id
      AND countries.country_id = locations.country_id
      AND locations.location_id = departments.location_id)
  AND region_name = 'Europe';
  
  
-- 데이터 결합 [실습 11] ==========================================================
SELECT countries.region_id, region_name, country_name, city,
       department_name, first_name||last_name name
FROM countries, regions, locations, departments, employees
WHERE (countries.region_id = regions.region_id
      AND countries.country_id = locations.country_id
      AND locations.location_id = departments.location_id
      AND departments.department_id = employees.department_id)
  AND region_name = 'Europe';
  
  
-- 데이터 결합 [실습 12] ==========================================================
SELECT employee_id, first_name||last_name name, jobs.job_id, job_title
FROM employees JOIN jobs ON(employees.job_id = jobs.job_id);
  
  
-- 데이터 결합 [실습 13] ==========================================================
SELECT b.manager_id mng_id, a.first_name||a.last_name mgr_name, b.employee_id,
       b.first_name||b.last_name name, jobs.job_id, job_title
FROM employees a, employees b, jobs
WHERE b.job_id = jobs.job_id
  AND b.manager_id = a.employee_id;







  
  
  
  
  
  