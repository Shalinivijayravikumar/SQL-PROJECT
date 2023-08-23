select * from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


select * from PortfolioProject..CovidVaccination
where continent is not null
order by 3,4

select count(*) from PortfolioProject..CovidVaccination

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--finding percentage of total cases in population

select (total_cases * 100)/population as 'percentage_of_population'
from PortfolioProject..CovidDeaths
where continent is not null
order by total_cases desc

SELECT
    location,total_cases,
    population,
    CASE 
        WHEN population > 0 THEN (total_cases * 100.0) / population
        ELSE NULL -- or some appropriate value to indicate no population data
    END AS percentage_cases_to_population
FROM
    PortfolioProject..CovidDeaths
where continent is not null
ORDER BY
    total_cases DESC;

--finding total case vs total death

select location,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 as PERCENTAG_OF_DEATH
FROM  PortfolioProject..CovidDeaths
where location like '%India%' and continent is not null
order by 1,2

--TOTAL CASE VS TOTAL POPULATION

select location,date,total_cases,population ,(total_cases/population)*100 as PERCENTAG_OF_DEATH
FROM  PortfolioProject..CovidDeaths
where location like '%India%' and continent is not null
order by 1,2


--which country has highest death population 

select location,population,max(total_cases) as HighestInfectionCount,max(total_cases/population)*100 as Percentpopulationeffected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by Percentpopulationeffected desc

--finding HighestInfectionCount and death as per population

select location,max(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathcount desc

--displaying continent with the highest death count as per population

select continent,max(cast(total_deaths as int)) as 'highest death count as per population' 
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by 'highest death count as per population' desc

---GLOBAL NUMBERS-----

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM
(cast(new_deaths AS int))/sum(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--finding total population vs Vaccinations

--using over partition--

select Dea.continent,Dea.location,Dea.date,Dea.population ,sum(convert(int,Vacc.new_vaccinations))
over(Partition by Dea.location) as TotalpeopleVaccinated
--(TotalpeopleVaccinated/population)*100--
from PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccination Vacc
on Dea.location=Vacc.location and
Dea.date =Vacc.date
where Dea.location like '%India%' or Vacc.location like '%States%' and Dea.continent is not null
order by 2,3




----using CTE(COMMON TABLE EXPRESSION) and over partition--

with PopuvsVacc (continent,location,date,population,New_Vaccinations,TotalpeopleVaccinated)
as 
(
select Dea.continent,Dea.location,Dea.date,Dea.population ,Vacc.new_vaccinations,
sum(convert(int,Vacc.new_vaccinations))over(Partition by Dea.location order by Dea.Location,Dea.date)
as TotalpeopleVaccinated
--(TotalpeopleVaccinated/population)*100--
from PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccination Vacc
on Dea.location=Vacc.location and
Dea.date =Vacc.date
where Dea.location like '%India%' or Vacc.location like '%States%' and Dea.continent is not null
--order by 2,3--
)
select *, (TotalpeopleVaccinated/population)*100 as PercentageofPeopleVaccinated from PopuvsVacc

--Using Temp Table--

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_Vaccination numeric,
TotalpeopleVaccinated numeric
)



INSERT into #PercentPopulationVaccinated
select Dea.continent,Dea.location,Dea.date,Dea.population ,Vacc.new_vaccinations,
sum(convert(int,Vacc.new_vaccinations))over(Partition by Dea.location order by Dea.Location,Dea.date)
as TotalpeopleVaccinated
--(TotalpeopleVaccinated/population)*100--
from PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccination Vacc
on Dea.location=Vacc.location and
Dea.date =Vacc.date
where Dea.location like '%India%' or Vacc.location like '%States%' and Dea.continent is not null
--order by 2,3--

select *,(TotalpeopleVaccinated/population)*100
from #PercentPopulationVaccinated 


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATONS---

Create view PercentPopulationVaccinated as
select Dea.continent,Dea.location,Dea.date,Dea.population ,Vacc.new_vaccinations,
sum(convert(int,Vacc.new_vaccinations))over(Partition by Dea.location order by Dea.Location,Dea.date)
as TotalpeopleVaccinated
--(TotalpeopleVaccinated/population)*100--
from PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccination Vacc
on Dea.location=Vacc.location and
Dea.date =Vacc.date
where Dea.location like '%India%' or Vacc.location like '%States%' and Dea.continent is not null

select *from PercentPopulationVaccinated





	



