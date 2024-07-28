select *
from portfolioproject..CovidDeaths
where continent is not null
order by 3,4

select *
from portfolioproject..CovidVaccinations
order by 3,4



select location ,date , total_cases	 ,new_cases ,total_deaths , population
from portfolioproject..CovidDeaths
where continent is not null
order by 1,2


-- loking at total cases Vs total deaths
-- Shows likelihood of dying if you contract covid in your country

select location ,date , total_cases	 ,total_deaths ,(total_deaths/total_cases)*100 as DeathPersentage
from portfolioproject..CovidDeaths
where location like 'Egypt'
and  continent is not null
order by 1,2


-- loking at total cases Vs Population 
-- Shows what percentage of population infected with Covid

select location ,date ,population, total_cases ,(total_cases/population)*100 as PersentPopulationInfected
from portfolioproject..CovidDeaths
where continent is not null
--where location like 'Egypt'
order by 1,2

--looking at countries with highest infection rate compared to population

select location ,population,  max (total_cases) ,max((total_cases/population))*100 as PersentPopulationInfected
from portfolioproject..CovidDeaths
--where location like 'Egypt'
where continent is not null
group by location ,population
order by PersentPopulationInfected desc


-- Countries with Highest Death Count per Population

select location , max (cast (total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths
where continent is not null
group by location 
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population


select continent , max (cast (total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths
where continent is not null
group by  continent 
order by TotalDeathCount desc

-- GLOBAL NUMBERS

select  sum(new_cases) as Total_Cases, sum(cast(new_deaths as int )) as Total_Deaths ,
sum(cast(new_deaths as int ))/sum(new_cases)*100 as DeathPersentage
from portfolioproject..CovidDeaths
where continent is not null
--group by date 
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select  dea.continent ,dea.location  , dea.date , dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int ))over (partition by dea.location order by dea.location ,dea.date )
as RollingPeapoleVaccinated
from portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
		
-- Using CTE to perform Calculation on Partition By in previous query

with PopVsVac (continent,location,date,population,new_vaccinations,RollingPeapoleVaccinated)
as 
(
select  dea.continent ,dea.location  , dea.date , dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int ))over (partition by dea.location order by dea.location ,dea.date )
as RollingPeapoleVaccinated
from portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (RollingPeapoleVaccinated/population)*100
from PopVsVac 



-- Using Temp Table to perform Calculation on Partition By in previous query

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime ,
population numeric ,
New_vaccinations numeric ,
RollingPeapoleVaccinated numeric
)
 insert into #PercentPopulationVaccinated

select  dea.continent ,dea.location  , dea.date , dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int ))over (partition by dea.location order by dea.location ,dea.date )
as RollingPeapoleVaccinated
from portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
select * , (RollingPeapoleVaccinated/population)*100
from #PercentPopulationVaccinated 


-- Creating View to store data for later visualizations

create view PercentPopulationVaccinated as
select  dea.continent ,dea.location  , dea.date , dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int ))over (partition by dea.location order by dea.location ,dea.date )
as RollingPeapoleVaccinated
from portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated


















































