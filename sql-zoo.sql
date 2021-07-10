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

-- **********************************************************************************************************************************
-- ************************************************************* SUM and COUNT ******************************************************
-- **********************************************************************************************************************************

-- Total world population 1. Show the total population of the world.
SELECT SUM(population)
FROM world

-- List of continents 2. List all the continents - just once each.
SELECT DISTINCT continent FROM world

-- GDP of Africa 3. Give the total GDP of Africa
SELECT SUM(gdp) FROM world WHERE continent = 'Africa'

-- Count the big countries 4. How many countries have an area of at least 1000000
SELECT COUNT(*) FROM world WHERE area >= 1000000

-- Baltic states population 5. What is the total population of ('Estonia', 'Latvia', 'Lithuania')
SELECT SUM(population) FROM world WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

-- Counting the countries of each continent 6. For each continent show the continent and number of countries.
SELECT continent, COUNT(name) FROM world GROUP BY continent

-- Counting big countries in each continent 7. For each continent show the continent and number of countries with populations of at least 10 million.
SELECT continent, COUNT(name) FROM world WHERE population/1000000>10 GROUP BY continent

-- Counting big continents 8. List the continents that have a total population of at least 100 million.
SELECT continent FROM world GROUP BY continent HAVING SUM(population/1000000)>100

-- **********************************************************************************************************************************
-- ************************************************************* JOIN ***************************************************************
-- **********************************************************************************************************************************

-- 1. Modify it to show the matchid and player name for all goals scored by Germany
SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'
  
-- 2.Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game WHERE id = 1012

-- 3. Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT goal.player, goal.teamid, game.stadium, game.mdate 
  FROM game JOIN goal ON (goal.matchid=game.id) INNER JOIN eteam ON (eteam.id=goal.teamid) WHERE eteam.teamname = 'Germany'

-- 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT game.team1, game.team2, goal.player
  FROM game JOIN goal ON (goal.matchid=game.id) WHERE goal.player LIKE 'Mario%'

-- 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
  FROM goal JOIN eteam ON eteam.id = goal.teamid
 WHERE gtime<=10

-- 6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT game.mdate, eteam.teamname
  FROM game JOIN eteam ON game.team1=eteam.id
 WHERE eteam.coach= 'Fernando Santos'

-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT goal.player
  FROM goal JOIN game ON game.id=goal.matchid
 WHERE game.stadium= 'National Stadium, Warsaw'

-- 8. More difficult questions Instead show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id
  WHERE (team1='GER' OR team2 = 'GER') AND goal.teamid != 'GER'

-- 9. Show teamname and the total number of goals scored.
SELECT teamname, COUNT(goal.matchid)
  FROM eteam JOIN goal ON eteam.id=goal.teamid
 GROUP BY teamname

-- 10. Show the stadium and the number of goals scored in each stadium.
 SELECT game.stadium, COUNT(goal.matchid)
  FROM game JOIN goal ON game.id=goal.matchid
 GROUP BY stadium

-- 11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid,MAX(game.mdate) AS mdate, COUNT(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL') GROUP BY goal.matchid

-- 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, MAX(mdate), COUNT(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE teamid = 'GER' GROUP BY goal.matchid

-- 13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
SELECT mdate,
  team1, SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
  team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
  FROM game LEFT JOIN goal ON matchid = id GROUP BY mdate,matchid,team1,team2

-- **********************************************************************************************************************************
-- ************************************************************* More JOIN **********************************************************
-- **********************************************************************************************************************************

-- 1962 movies 1. List the films where the yr is 1962 [Show id, title]
SELECT id, title  FROM movie  WHERE yr=1962

-- When was Citizen Kane released? 2. Give year of 'Citizen Kane'.
SELECT yr  FROM movie WHERE title='Citizen Kane'

-- Star Trek movies 3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr  FROM movie  WHERE title LIKE '%Star Trek%' ORDER BY yr

-- id for actor Glenn Close 4. What id number does the actor 'Glenn Close' have?
SELECT id FROM actor WHERE name = 'Glenn Close'

-- id for Casablanca 5. What is the id of the film 'Casablanca'
SELECT id FROM movie WHERE title= 'Casablanca'

-- Cast list for Casablanca 6. Obtain the cast list for 'Casablanca'.
SELECT name FROM actor JOIN casting ON id=actorid WHERE movieid = (SELECT id FROM movie WHERE title= 'Casablanca')

-- Alien cast list 7. Obtain the cast list for the film 'Alien'
SELECT name FROM actor JOIN casting ON id=actorid WHERE movieid = (SELECT id FROM movie WHERE title= 'Alien')

-- Harrison Ford movies 8. List the films in which 'Harrison Ford' has appeared
SELECT title FROM movie INNER JOIN casting ON movie.id=movieid INNER JOIN actor ON actor.id = casting.actorid WHERE name= 'Harrison Ford'

-- Harrison Ford as a supporting actor 9. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title FROM movie INNER JOIN casting ON movie.id=movieid INNER JOIN actor ON actor.id = casting.actorid WHERE name= 'Harrison Ford' AND ord != 1

-- Lead actors in 1962 movies 10. List the films together with the leading star for all 1962 films.
SELECT title , name FROM movie INNER JOIN casting ON movie.id=movieid INNER JOIN actor ON actor.id = casting.actorid WHERE yr= 1962 AND ord = 1

-- Busy years for Rock Hudson 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2
Submit 

-- Lead actor in Julie Andrews movies 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in. Did you get "Little Miss Marker twice"?
SELECT title,actor.name FROM movie JOIN casting ON (movie.id=movieid AND ord = 1) JOIN actor ON  actor.id=actorid
WHERE movieid IN (
  SELECT movieid FROM casting
  WHERE actorid IN(SELECT id from actor WHERE name ='Julie Andrews'))

-- Actors with 15 leading roles 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name FROM actor JOIN casting ON (actorid=id) GROUP BY ord,name HAVING SUM(ord)>=15

-- 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title,COUNT(actorid) FROM movie JOIN casting ON (id=movieid) WHERE yr=1978  GROUP BY title ORDER BY COUNT(actorid) DESC, title;

-- 15. List all the people who have worked with 'Art Garfunkel'.
SELECT name FROM actor JOIN casting ON (actor.id=actorid) WHERE movieid IN (SELECT movie.id FROM movie JOIN casting ON movieid=movie.id JOIN actor ON actorid=actor.id WHERE actor.name=  'Art Garfunkel') AND actor.name !=  'Art Garfunkel'


-- **********************************************************************************************************************************
-- ************************************************************* USING NULL *********************************************************
-- **********************************************************************************************************************************

-- 1. List the teachers who have NULL for their department.
SELECT name FROM teacher WHERE dept IS NULL

-- 2. Note the INNER JOIN misses the teachers with no department and the departments with no teacher.
SELECT teacher.name, dept.name FROM teacher INNER JOIN dept ON (teacher.dept=dept.id)

-- 3. Use a different JOIN so that all teachers are listed.
SELECT teacher.name, dept.name FROM teacher LEFT JOIN dept ON (teacher.dept=dept.id)

-- 4. Use a different JOIN so that all departments are listed.
SELECT teacher.name, dept.name FROM teacher RIGHT JOIN dept ON (teacher.dept=dept.id)

-- 5. Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. Show teacher name and mobile number or '07986 444 2266'
SELECT teacher.name, COALESCE(teacher.mobile,'07986 444 2266') FROM teacher

-- 6. Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.
SELECT teacher.name, COALESCE(dept.name,'None') FROM teacher LEFT JOIN dept ON teacher.dept=dept.id

-- 7. Use COUNT to show the number of teachers and the number of mobile phones.
SELECT COUNT(teacher.id),COUNT(teacher.mobile) FROM teacher

-- 8. Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.
SELECT dept.name, COUNT(teacher.id) FROM teacher RIGHT JOIN dept ON dept.id=teacher.dept GROUP BY dept.name

-- 9. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.
SELECT name,
 CASE WHEN dept=1 OR dept=2 THEN 'Sci' ELSE 'Art' END 
 FROM teacher

-- 10. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.
SELECT name,
 CASE
  WHEN dept=1 OR dept=2 THEN 'Sci'
  WHEN dept=3 THEN 'Art'
  ELSE 'None'
 END
 FROM teacher

-- **********************************************************************************************************************************
-- ************************************************************* SELF JOIN **********************************************************
-- **********************************************************************************************************************************

-- 1. How many stops are in the database. 
SELECT COUNT(*) FROM route

-- 2. Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops WHERE name = 'Craiglockhart'

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT id,name FROM stops JOIN route ON stops.id = route.stop WHERE num = '4' AND company = 'LRT'


-- Routes and stops 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num HAVING COUNT(*)=2

-- 5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149

-- 6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road'

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT a.company, a.num FROM route a JOIN route b ON (a.num =  b.num)
AND a.stop=115 AND b.stop=137  GROUP BY a.company,a.num

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = (SELECT id FROM stops WHERE name='Tollcross') 

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT s2.name,a.company,a.num 
FROM route a 
JOIN route b ON (a.num=b.num AND a.company=b.company) 
JOIN stops s1 ON (a.stop=s1.id) 
JOIN stops s2 ON (b.stop=s2.id) WHERE s1.name= 'Craiglockhart'

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.

SELECT aa.anum, aa.acom, aa.dname, bb.hh, bb.ii
FROM (SELECT c.name AS begin, a.num AS anum, a.company AS acom, d.name AS dname
      FROM route a JOIN route b ON a.company = b.company AND a.num = b.num
      JOIN stops c ON c.id = a.stop
      JOIN stops d ON d.id = b.stop
      WHERE c.name = 'Craiglockhart') AS aa
	  
     JOIN(SELECT e.name AS jj, h.num AS hh, h.company AS ii, f.name AS final
     FROM route g JOIN route h ON g.company = h.company AND g.num = h.num
     JOIN stops e ON e.id = g.stop
     JOIN stops f ON f.id = h.stop
     WHERE f.name = 'Lochend') AS bb 
	 
	 ON aa.dname = bb.jj
ORDER BY anum, dname, hh

-- **********************************************************************************************************************************
-- ************************************************************* NSS Tutorial *******************************************************
-- **********************************************************************************************************************************

-- 1. The example shows the number who responded for: Show the the percentage who STRONGLY AGREE
SELECT A_STRONGLY_AGREE
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'

-- 2. Show the institution and subject where the score is at least 100 for question 15.
SELECT institution, subject
  FROM nss
 WHERE question='Q15'
   AND score >= 100

-- 3. Show the institution and score where the score for '(8) Computer Science' is less than 50 for question 'Q15'
SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND score <50
   AND subject='(8) Computer Science'

-- 4. Show the subject and total number of students who responded to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.
SELECT subject,SUM(response)
  FROM nss
 WHERE question='Q22'
   AND subject IN ('(8) Computer Science','(H) Creative Arts and Design') GROUP BY subject

-- 5. Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.
SELECT subject,SUM(response*A_STRONGLY_AGREE/100)
  FROM nss
 WHERE question='Q22'
 AND subject IN ('(8) Computer Science','(H) Creative Arts and Design') GROUP BY subject

-- Strongly Agree, Percentage 6.Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.
SELECT subject,ROUND((SUM(A_STRONGLY_AGREE*response/100))*100/SUM(response))
  FROM nss
 WHERE question='Q22'
 AND subject IN ('(8) Computer Science','(H) Creative Arts and Design') GROUP BY subject

-- Scores for Institutions in Manchester 7. Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.
SELECT institution, ROUND(SUM(score*response/100)*100/SUM(response))
  FROM nss
 WHERE question='Q22'
   AND (institution LIKE '%Manchester%')
GROUP BY institution
ORDER BY institution

-- Number of Computing Students in Manchester 8. Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'.
SELECT institution,SUM(sample), (SELECT sample FROM nss b WHERE subject ='(8) Computer Science' AND a.institution=b.institution AND question='Q01') AS comp
  FROM nss a WHERE question='Q01' AND (institution LIKE '%Manchester%') GROUP BY institution;

-- **********************************************************************************************************************************
-- ************************************************************* Window Functions ***************************************************
-- **********************************************************************************************************************************

-- 1. Show the lastName, party and votes for the constituency 'S14000024' in 2017.
SELECT lastName, party, votes FROM ge WHERE constituency = 'S14000024' AND yr = 2017 ORDER BY votes DESC

-- 2. You can use the RANK function to see the order of the candidates. If you RANK using (ORDER BY votes DESC) then the candidate with the most votes has rank 1. Show the party and RANK for constituency S14000024 in 2017. List the output by party
SELECT party, votes, RANK() OVER (ORDER BY votes DESC) as posn
  FROM ge WHERE constituency = 'S14000024' AND yr = 2017 ORDER BY party

-- 3. The 2015 election is a different PARTITION to the 2017 election. We only care about the order of votes for each year. Use PARTITION to show the ranking of each party in S14000021 in each year. Include yr, party, votes and ranking (the party with the most votes is 1).
SELECT yr,party, votes, RANK() OVER (PARTITION BY yr ORDER BY votes DESC) as posn
  FROM ge  WHERE constituency = 'S14000021' ORDER BY party,yr

-- 4. Edinburgh constituencies are numbered S14000021 to S14000026. Use PARTITION BY constituency to show the ranking of each party in Edinburgh in 2017. Order your results so the winners are shown first, then ordered by constituency.
SELECT constituency,party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) as posn
  FROM ge WHERE constituency BETWEEN 'S14000021' AND 'S14000026' AND yr  = 2017
ORDER BY posn,constituency 

-- 5. You can use SELECT within SELECT to pick out only the winners in Edinburgh. Show the parties that won for each Edinburgh constituency in 2017.
select  constituency,party from (SELECT constituency,party, votes, rank() OVER (PARTITION BY constituency order by votes desc) posn FROM ge WHERE constituency BETWEEN 'S14000021' AND 'S14000026' AND yr  = 2017 ORDER BY constituency,votes DESC) ge1 
WHERE posn=1

-- 6. You can use COUNT and GROUP BY to see how each party did in Scotland. Scottish constituencies start with 'S'. Show how many seats for each party in Scotland in 2017.
SELECT party,COUNT(party) FROM (SELECT constituency,party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) as posn FROM ge WHERE constituency LIKE 'S%' AND yr  = 2017) ge1 
WHERE ge1.posn=1 
GROUP BY ge1.party


-- **********************************************************************************************************************************
-- ************************************************************* COVID 19 ***********************************************************
-- **********************************************************************************************************************************


-- 1. The example uses a WHERE clause to show the cases in 'Italy' in March. Modify the query to show data from Spain
SELECT name, DAY(whn),
 confirmed, deaths, recovered
 FROM covid
WHERE name = 'Spain'
AND MONTH(whn) = 3
ORDER BY whn


-- 2. The LAG function is used to show data from the preceding row or the table. When lining up rows the data is partitioned by country name and ordered by the data whn. That means that only data from Italy is considered. Modify the query to show confirmed for the day before.
SELECT name, DAY(whn), confirmed,
   LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)
 FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3
ORDER BY whn

-- 3. The number of confirmed case is cumulative - but we can use LAG to recover the number of new cases reported for each day. Show the number of new cases for each day, for Italy, for March.
SELECT name, DAY(whn), confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)
 FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3
ORDER BY whn

-- 4. The data gathered are necessarily estimates and are inaccurate. However by taking a longer time span we can mitigate some of the effects. You can filter the data to view only Monday's figures WHERE WEEKDAY whn) = 0. Show the number of new cases in Italy for each week - show Monday only.
SELECT name, DATE_FORMAT(whn,'%Y-%m-%d'), confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)
 FROM covid
WHERE name = 'Italy'
AND WEEKDAY(whn) = 0
ORDER BY whn

-- 5. You can JOIN a table using DATE arithmetic. This will give different results if data is missing. Show the number of new cases in Italy for each week - show Monday only. In the sample query we JOIN this week tw with last week lw using the DATE_ADD function.
SELECT tw.name, DATE_FORMAT(tw.whn,'%Y-%m-%d'), 
 tw.confirmed - lw.confirmed
 FROM covid tw LEFT JOIN covid lw ON 
  (DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn AND tw.name=lw.name)
WHERE tw.name = 'Italy' AND weekday(tw.whn) = 0

-- 6. The query shown shows the number of confirmed cases together with the world ranking for cases. United States has the highest number, Spain is number 2... Notice that while Spain has the second highest confirmed cases, Italy has the second highest number of deaths due to the virus. Include the ranking for the number of deaths in the table.
SELECT 
   name,
   confirmed,
   RANK() OVER (ORDER BY confirmed DESC) rc,
   deaths,
   RANK() OVER (ORDER BY deaths DESC) rc
  FROM covid
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC

-- 7. The query shown includes a JOIN t the world table so we can access the total population of each country and calculate infection rates (in cases per 100,000). Show the infect rate ranking for each country. Only include countries with a population of at least 10 million.
SELECT 
   world.name,
   ROUND(100000*confirmed/population,0),
 RANK() OVER (ORDER BY confirmed/population ) rank
  FROM covid JOIN world ON covid.name=world.name
WHERE whn = '2020-04-20' AND population > 10000000
ORDER BY population DESC

-- 8. For each country that has had at last 1000 new cases in a single day, show the date of the peak number of new cases.
select t.name,DATE_FORMAT(t.whn,'%Y-%m-%d'),t.cases from
  (select ncases.name,ncases.whn, rank() over(partition by name order by cases desc)as s, ncases.cases from 
          (select name, whn, (confirmed-lag(confirmed,1) over(partition by name order by whn))as cases from covid)as ncases)
		  as t
where t.s = 1 and t.cases >= 1000
order by t.whn











































