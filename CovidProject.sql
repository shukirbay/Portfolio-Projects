--select *
--from CovidDeaths

select location, date, total_cases, new_cases, total_deaths
from CovidDeaths
order by 1, 2

-- Looking at Total Cases vs Total Deaths
-- Likelihood of Dying %
select location, date, total_cases, total_deaths, (total_deaths/convert(FLOAT,total_cases)) * 100 as death_percentage
from CovidDeaths
where location = 'Kazakhstan'
order by 1, 2

-- Looking at Total Cases vs Population
-- % of Population got Covid
select location, date, total_cases, population, (convert(float,total_cases)/population) * 100 as population_percentage_covid
from CovidDeaths
where location = 'Kazakhstan'
order by 1, 2

-- Looking at Countries with the Highest Infection Rate vs Population
select location, population, max(total_cases) as highest_infection_count, max((convert(FLOAT,total_cases)/population))*100 as percent_population_infected
from CovidDeaths
group by location, population
order by percent_population_infected desc


-- Looking at Countries with the Highest Death Rate vs Population
select location, max(cast(total_deaths as float)) as total_death_count
from CovidDeaths
where continent is not null
group by location
order by total_death_count desc


-- USE CTE
with PopvsVac (continent, location, date, population, new_vaccinations, Total_People_Vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Total_People_Vaccinated
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (Total_People_Vaccinated/population)*100 as Vaccinated_Population_Percentage
from PopvsVac
where location = 'Kazakhstan'
order by location, date






-- Creating View to store data for later visualizations
 create view Vaccinated_Population_Percentage as
 with PopvsVac (continent, location, date, population, new_vaccinations, Total_People_Vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Total_People_Vaccinated
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (Total_People_Vaccinated/population)*100 as Vaccinated_Population_Percentage
from PopvsVac
--order by location, date

create view DeathPercentage as
select location, date, total_cases, total_deaths, (total_deaths/convert(FLOAT,total_cases)) * 100 as death_percentage
from CovidDeaths

create view PopulationPercentageCovid as
select location, date, total_cases, population, (convert(float,total_cases)/population) * 100 as population_percentage_covid
from CovidDeaths

create view HighestInfectionRate as
select location, population, max(total_cases) as highest_infection_count, max((convert(FLOAT,total_cases)/population))*100 as percent_population_infected
from CovidDeaths
group by location, population

create view HighestDeathRate as
select location, max(cast(total_deaths as float)) as total_death_count
from CovidDeaths
where continent is not null
group by location

