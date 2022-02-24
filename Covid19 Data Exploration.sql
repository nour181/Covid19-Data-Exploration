# coviddeath data

SELECT 
    *
FROM
    coviddeath
LIMIT 20;

# covidvacination data

SELECT 
    *
FROM
    covidvacination
LIMIT 20;

# Delete confused Rows from Data

DELETE FROM coviddeath 
WHERE
    location IN ('High income' , 'Europe',
    'North America',
    'South America',
    'European Union',
    'oceania',
    'aisa',
    'africa',
    'International',
    'Low income');


# Number of cases in every country till now

SELECT 
    cd.continent,
    cd.location,
    max(total_cases) AS total_cases_for_every_country
FROM
    coviddeath cd
GROUP BY cd.location
ORDER BY cd.continent , cd.location;


# Show me specific country with total number of cases

delimiter $$
USE covid_data $$
CREATE PROCEDURE recent_total_cases(IN p_country TEXT)
BEGIN
SELECT 
    cd.location, MAX(cd.total_cases)
FROM
    coviddeath cd
WHERE
    cd.location = p_country;

END $$
delimiter ;


# follow the development of cases from beginning till now in specific country

delimiter $$
USE covid_data $$
CREATE PROCEDURE follow_covid19_in_specific_country(IN p_country TEXT)
BEGIN
SELECT 
    cd.date, cd.new_cases, cd.total_cases as Total_cases_till_ThisMoment
FROM
    coviddeath cd
WHERE
    cd.location = p_country
ORDER BY cd.date;

END $$
delimiter ;



# Number of deaths in Each Country 

SELECT 
    cd.location, MAX(cd.total_deaths) AS Current_Total_Deaths
FROM
    coviddeath cd
GROUP BY cd.location
ORDER BY Current_Total_Deaths DESC;


# Percentage of Dying in each country from total cases

SELECT 
    cd.location,
    MAX(total_cases),
    MAX(total_deaths),
    (total_deaths / total_cases) * 100 AS Percentage_of_deaths_from_cases
FROM
    coviddeath cd
GROUP BY cd.location
ORDER BY Percentage_of_deaths_from_cases DESC;

# Percentage of Dying in each country from total cases in specific country

delimiter $$
use covid_data $$
CREATE PROCEDURE Percentage_of_Dying_from_Cases(IN p_country TEXT, OUT percent DECIMAL(4,2))
BEGIN
SELECT 
    (cd.total_deaths / cd.total_cases) * 100
INTO percent FROM
    coviddeath cd
WHERE
    cd.location = p_country
GROUP BY cd.location;
 
END $$
delimiter ;


# the 10 highest countries in Covid Cases

SELECT 
    cd.location, MAX(cd.total_cases) AS Total_Cases
FROM
    coviddeath cd
GROUP BY cd.location
ORDER BY Total_Cases DESC
LIMIT 10;

# the 10 highest countries in Deaths

SELECT 
    cd.location, MAX(cd.total_deaths) AS Total_Deaths
FROM
    coviddeath cd
GROUP BY cd.location
ORDER BY Total_Deaths DESC
LIMIT 10;

# delete noncountries from the location column

SELECT DISTINCT
    location
FROM
    covidvacination;

DELETE FROM covidvacination 
WHERE
    location IN ('High income' , 'Europe',
    'North America',
    'South America',
    'European Union',
    'oceania',
    'aisa',
    'africa',
    'International',
    'Low income');



# Total Vaccination in each country
SELECT 
    cv.location, CAST(max(total_vaccinations) AS UNSIGNED) as Total_Vaccinations
FROM
    covidvacination cv
GROUP BY cv.location
ORDER BY Total_Vaccinations DESC;


# Percentage of people vacinated from total population of each country
 
SELECT 
    cd.location,
    (max(cv.total_vaccinations) / cd.Population) * 100 AS vaccinated_from_Population
FROM
	coviddeath cd
        left join
    covidvacination cv ON cd.location = cv.location
GROUP BY cd.location
ORDER BY vaccinated_from_Population DESC;


# median age for people vaccinated for each country

SELECT 
    location, median_age
FROM
    covidvacination
GROUP BY location
ORDER BY median_age DESC;
