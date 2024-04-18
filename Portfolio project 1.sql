SELECT *

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

order by 3,4

-- Data we are using 
SELECT location, date, total_cases, new_cases, total_deaths, population

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Likelihood of dying if you contract Covid in your Country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage

FROM `caps-415921.portfolio_project.covid_deaths` 

Where location = 'Nigeria'

order by 1,2

-- Looking at Total Cases vs Population
-- Shows what Percentage of Population got Covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as infected_population_perc

FROM `caps-415921.portfolio_project.covid_deaths` 

Where location = 'Nigeria'

order by 1,2

-- Looking at countries with highest infection rate compared to population
SELECT location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as infected_population_perc

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

group by location, population

order by infected_population_perc desc

-- Showing countries with highest death compared to population
SELECT location, population, max(total_deaths) as highest_death_count, max((total_deaths/population))*100 as dead_population_perc

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

group by location, population

order by dead_population_perc desc

-- showing countries with highest death count
SELECT location, max(total_deaths) as highest_death_count

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

group by location

order by highest_death_count desc

-- Let us show by Continents

SELECT continent, max(total_deaths) as highest_death_count

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

group by continent

order by highest_death_count desc

-- World numbers (1)
SELECT date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as death_percentage

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

group by date

order by 1,2

-- World numbers (2)
SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as death_percentage

FROM `caps-415921.portfolio_project.covid_deaths` 

where continent is not null

order by 1,2

-- Vaccination table
SELECT *

FROM `caps-415921.portfolio_project.covid_vaccinations` 

order by 1,2

-- Join death table and vaccination table
SELECT *

FROM `caps-415921.portfolio_project.covid_deaths` as dea

join 

`caps-415921.portfolio_project.covid_vaccinations` as vac
on
dea.location = vac.location and
dea.date = vac.date
order by 1,2

-- Looking at total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated

FROM `caps-415921.portfolio_project.covid_deaths` as dea

join 

`caps-415921.portfolio_project.covid_vaccinations` as vac
on
dea.location = vac.location and
dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- Create CTE - PopulationvsVaccine
with populationvsvaccine as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated

FROM `caps-415921.portfolio_project.covid_deaths` as dea

join 

`caps-415921.portfolio_project.covid_vaccinations` as vac
on
dea.location = vac.location and
dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
SELECT location, population, max(rolling_people_vaccinated) as max_pple_vacc, max(rolling_people_vaccinated/population)*100 as max_perc_pop_vacc
FROM populationvsvaccine
group by location, population
order by max_pple_vacc desc