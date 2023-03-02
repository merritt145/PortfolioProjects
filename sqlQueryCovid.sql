SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

--SELECT data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at Total Cases vs population
--shows what percentage of poplation got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population



SELECT location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as 
PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

--showing countries with highest death count per population

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT



--showing continents with the highest death count per population



SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as 
DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
GROUP BY date
ORDER BY 1,2

--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
	where dea.continent is not null
	ORDER BY 2,3

	--Use CTE 

	With PopvsVac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
	as
	(
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
	where dea.continent is not null
	--ORDER BY 2,3
	)
	SELECT *, (RollingPeopleVaccinated/population)*100
	From PopvsVac


	--Temp Table

	DROP table if exists #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)



	INSERT into #PercentPopulationVaccinated
		SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
	--where dea.continent is not null
	--ORDER BY 2,3

	SELECT *, (RollingPeopleVaccinated/population)*100
	From #PercentPopulationVaccinated

	--Creating view to store data for later visualizations

	CREATE View PercentPopulationVaccinated as 
			SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is not null
	--ORDER BY 2,3

	CREATE View HighestDeathCount as
	SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
--ORDER BY TotalDeathCount desc
	

















