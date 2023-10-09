--pull all data 
select *
from PortforlioProject..CovidDeaths
where continent is not null
order by 3,4



--chances of dying if contacted the covid virus in your country
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercent
From CovidDeaths
where location = 'nigeria'
and continent is not null
Order By 1,2

--The Total Cases Of the infection versus the population
--This lets us know the percentage of the population 
--with the covid virus
Select Location,date,population,total_cases,(total_cases/population)*100 AS InfectionPercent
From CovidDeaths
where location = 'nigeria'
and continent is not null
Order By 1,2



--The country with the highest infection rate

Select Location,Population, max(total_cases) as HighestInfection, max(total_cases/population)*100 AS HigestInfectionPercent
From CovidDeaths
Group By location, population
Order By 4 desc;

--country with highest death count

Select continent, Max(cast(total_deaths as int)) as TotalDeath 
From CovidDeaths
where continent is NOT null
Group By continent
Order By 2 desc;

SELECT sum(new_cases)as Total_cases, sum(cast(new_deaths as int))
as Total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From CovidDeaths
--roup by date
order by 1,2


--The total population to the vaccinated

Select Dt.continent,Dt.location,Dt.date,population,
vc.new_vaccinations,
sum(convert(int,vc.new_vaccinations)) over (Partition by Dt.location order by Dt.location,Dt.date)
as In_ordered
from CovidDeaths Dt
join CovidVaccinations vc on Dt.location = vc.location
and Dt.date = vc.date
where  Dt.continent is not null
order by 2,3


--creating(CTE)

With PopToVic (continent,location,date,population,new_vaccinations,
In_ordered)
as
(
Select Dt.continent,Dt.location,Dt.date,population,
vc.new_vaccinations,
sum(convert(int,vc.new_vaccinations)) over (Partition by Dt.location order by Dt.location,Dt.date)
as In_ordered
from CovidDeaths Dt
join CovidVaccinations vc on Dt.location = vc.location
and Dt.date = vc.date
where  Dt.continent is not null
)

select *, (In_ordered/population)*100
from PopToVic


--creating a temp table

Create TABLE #PopToVaccinationPercent
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
In_ordered numeric
)

Insert into #PopToVaccinationPercent
Select Dt.continent,Dt.location,Dt.date,population,
vc.new_vaccinations,
sum(convert(int,vc.new_vaccinations)) over (Partition by Dt.location order by Dt.location,Dt.date)
as In_ordered
from CovidDeaths Dt
join CovidVaccinations vc on Dt.location = vc.location
and Dt.date = vc.date
where  Dt.continent is not null


select *, (In_ordered/population)*100
from #PopToVaccinationPercent


--creating a view

Create view PopToVaccinationPercent as
Select Dt.continent,Dt.location,Dt.date,population,
vc.new_vaccinations,
sum(convert(int,vc.new_vaccinations)) over (Partition by Dt.location order by Dt.location,Dt.date)
as In_ordered
from CovidDeaths Dt
join CovidVaccinations vc on Dt.location = vc.location
and Dt.date = vc.date
where  Dt.continent is not null


select * 
from PopToVaccinationPercent


