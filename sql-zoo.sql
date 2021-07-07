-- **********************************************************************************************************************************
-- ************************************************************* SELECT Basics ******************************************************
-- **********************************************************************************************************************************

-- Modify it to show the population of Germany
SELECT population FROM world
  WHERE name = 'Germany'

-- Show the name and the population for 'Sweden', 'Norway' and 'Denmark'
SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- Modify it to show the country and the area for countries with an area between 200,000 and 250,000
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

-- **********************************************************************************************************************************
-- ********************************************************** SELECT From World *****************************************************
-- **********************************************************************************************************************************

-- Introduction 1. show the name, continent and population of all countries
SELECT name, continent, population FROM world

-- Large Countries 2. Show the name for the countries that have a population of at least 200 million. 200 million is 200000000, there are eight zeros
SELECT name
  FROM world
 WHERE population > 200000000

 -- Per capita GDP 3. Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name,gdp/population
  FROM world
 WHERE population > 200000000

 -- South America In millions 4. Show the name and population in millions for the countries of the continent 'South America'. Divide the population by 1000000 to get population in millions.
SELECT name,population/1000000
  FROM world
 WHERE continent = 'South America'

-- France, Germany, Italy 5. Show the name and population for France, Germany, Italy
SELECT name,population
  FROM world
 WHERE name IN ('France', 'Germany', 'Italy');

-- United 6. Show the countries which have a name that includes the word 'United'
 SELECT name
  FROM world
 WHERE name LIKE '%United%';

-- Two ways to be big 7. Show the countries that are big by area or big by population. Show name, population and area.
 SELECT name, population, area
  FROM world
 WHERE area > 3000000 OR population> 250000000;

-- One or the other (but not both) 8. Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both. Show name, population and area.
 SELECT name, population, area
  FROM world
 WHERE (area > 3000000 AND population < 250000000) OR (area < 3000000 AND population > 250000000);

 -- Rounding 9. For South America show population in millions and GDP in billions both to 2 decimal places.
SELECT name, ROUND(population/1000000,2), ROUND(gdp/1000000000,2)
  FROM world
 WHERE continent = 'South America';

 -- Trillion dollar economies 10. Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name, ROUND(gdp/population,-3)
  FROM world
 WHERE gdp >=  1000000000000;

-- Name and capital have the same length 11. Show the name and capital where the name and the capital have the same number of characters.
SELECT name, capital
  FROM world
 WHERE length(name)=length(capital);

-- Matching name and capital 12. Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
SELECT name, capital
  FROM world
 WHERE LEFT(name,1)=LEFT(capital,1) AND name <> capital;

-- All the vowels 13. Find the country that has all the vowels and no spaces in its name.
SELECT name
   FROM world
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE '%u%' AND name NOT LIKE '% %';

-- **********************************************************************************************************************************
-- ************************************************************* SELECT From Nobel **************************************************
-- **********************************************************************************************************************************

-- Winners from 1950 1. Change the query shown so that it displays Nobel prizes for 1950.
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

-- 1962 Literature 2. Show who won the 1962 prize for Literature.
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'Literature'

-- Albert Einstein 3. Show the year and subject that won 'Albert Einstein' his prize.
SELECT yr, subject
  FROM nobel
 WHERE winner= 'Albert Einstein'

-- Recent Peace Prizes 4. Give the name of the 'Peace' winners since the year 2000, including 2000.
SELECT winner
  FROM nobel
 WHERE Subject= 'Peace' AND yr >= 2000

-- Literature in the 1980's 5. Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
SELECT yr,subject,winner
  FROM nobel
 WHERE Subject= 'Literature' AND yr BETWEEN 1980 AND 1989;

-- Only Presidents 6.
SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt','Woodrow Wilson','Jimmy Carter','Barack Obama')

-- John 7. Show the winners with first name John
SELECT winner FROM nobel
 WHERE winner LIKE 'john%'

-- Chemistry and Physics from different years 8. Show the year, subject, and name of Physics winners for 1980 together with the Chemistry winners for 1984.
SELECT yr,subject,winner
  FROM nobel
 WHERE (Subject = 'Physics' AND yr = 1980) OR (Subject = 'Chemistry' AND yr = 1984);

-- Exclude Chemists and Medics 9. Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine
SELECT yr,subject,winner
  FROM nobel
 WHERE Subject NOT IN('Chemistry','Medicine') AND yr = 1980;

-- Early Medicine, Late Literature 10.
SELECT yr,subject,winner
  FROM nobel
 WHERE (Subject = 'Medicine' AND yr < 1910) OR (Subject = 'Literature' AND yr >= 2004);

-- Umlaut 11. Find all details of the prize won by PETER GRÜNBERG
SELECT *
  FROM nobel
 WHERE winner = 'PETER GRÜNBERG'

-- Apostrophe 12. Find all details of the prize won by EUGENE O'NEILL
SELECT *
  FROM nobel
 WHERE winner LIKE 'EUGENE O_NEILL'

-- Knights of the realm 13. Knights in order
SELECT winner,yr,subject
  FROM nobel
 WHERE winner LIKE 'Sir%' ORDER BY yr DESC ;

-- Chemistry and Physics last 14. Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.
SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY subject IN ('Physics','Chemistry'),subject ,winner 


-- **********************************************************************************************************************************
-- ************************************************************* SELECT in SELECT ***************************************************
-- **********************************************************************************************************************************


-- Bigger than Russia 1. List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia');

-- Richer than UK 2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name FROM world
  WHERE continent = 'Europe' AND 
     gdp/population >
     (SELECT gdp/population FROM world
      WHERE name='United Kingdom');

-- Neighbours of Argentina and Australia 3. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name,continent FROM world
WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina','AUSTRALIA')) ORDER BY name

-- Between Canada and Poland 4. Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population FROM world WHERE
population > (SELECT population FROM world WHERE name ='Canada') AND population < (SELECT population FROM world WHERE name ='Poland') 

-- Percentages of Germany 5. Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name,CONCAT(ROUND(population*100/(SELECT population FROM world WHERE name = 'Germany')),'%') AS percentage FROM world WHERE continent = 'Europe';

--Bigger than every country in Europe 6. Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name FROM world WHERE gdp>(SELECT MAX(gdp) FROM world WHERE continent ='Europe')

-- Largest in each continent 7. Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area FROM world x
  WHERE area>= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

-- First country of each continent (alphabetically) 8. List each continent and the name of the country that comes first alphabetically.
SELECT A.continent, A.name FROM world A
WHERE A.name<= ALL(SELECT name FROM world B WHERE A.continent = B.continent)


-- Difficult Questions That Utilize Techniques Not Covered In Prior Sections 9. Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population FROM world 
WHERE continent NOT IN 
(SELECT continent FROM world WHERE population > 25000000)

-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT a.name, a.continent FROM world a WHERE population > ALL(SELECT population*3 FROM world b WHERE a.continent=b.continent AND a.name != b.name)