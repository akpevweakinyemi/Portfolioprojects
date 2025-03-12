Select *
From PortfolioProjects..CovidDeaths$
Where continent is not null
order by 3,4

Select *
From PortfolioProjects..covidvaccinations$
Where continent is not null
order by 3,4

Select location, date,total_cases, new_cases, population
From PortfolioProjects..CovidDeaths$
Where continent is not null
order by 3,4

--Total cases versus Total deaths
--Shows the likelihood of dying if you contract covid19

Select location, date,total_cases,(total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProjects..CovidDeaths$
Where continent is not null
--Where location like 'Nigeria'
order by 1,2

--Total cases versus the Population
--shows what percentage of population got covid

Select location, date,population,total_cases, (total_cases/population) * 100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths$
Where continent is not null
--Where location like 'Nigeria'
order by 1,2

--Countries with highest infection rates compared to population

Select location,population,Max(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100 as 
PercentPopulationInfected
From PortfolioProjects..CovidDeaths$
Where continent is not null
--Where location like 'Nigeria'
Group by location, population
order by PercentPopulationInfected DESC

--countries with highest death count

Select location, Max(Cast(total_deaths as int)) as TotaldeathCount 
From PortfolioProjects..CovidDeaths$
--Where location like 'Nigeria'
Where continent is not null
Group by location
order by TotaldeathCount  DESC

--Continent with highest death count

Select continent, Max(Cast(total_deaths as int)) as TotaldeathCount 
From PortfolioProjects..CovidDeaths$
--Where location like 'Nigeria'
Where continent is not null
Group by continent
order by TotaldeathCount  DESC

--Global numbers

Select continent, Max(Cast(total_deaths as int)) as TotaldeathCount 
From PortfolioProjects..CovidDeaths$
--Where location like 'Nigeria'
Where continent is not null
Group by continent
order by TotaldeathCount  DESC

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 
as DeathPercentage
From PortfolioProjects..CovidDeaths$
--Where location like 'Nigeria'
where continent is not null 
Group By date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 
as DeathPercentage
From PortfolioProjects..CovidDeaths$
--Where location like 'Nigeria'
where continent is not null 
--Group By date
order by 1,2


Select *
From PortfolioProjects..covidvaccinations$

Select *
From PortfolioProjects..CovidDeaths$

--Total population versus vaccination

Select *
From PortfolioProjects..CovidDeaths$  dea
join PortfolioProjects..covidvaccinations$  vac
on dea.location = vac.location
and dea.date = vac.date

Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
---(RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$  dea
join PortfolioProjects..covidvaccinations$  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USING CTE

With PopvsVac (continent,location,date,population, new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
---,(RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$  dea
join PortfolioProjects..covidvaccinations$  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100
from PopvsVac


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$ dea
Join PortfolioProjects..covidvaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating views for data visualization

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$ dea
Join PortfolioProjects..covidvaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * 
from PercentPopulationVaccinated

