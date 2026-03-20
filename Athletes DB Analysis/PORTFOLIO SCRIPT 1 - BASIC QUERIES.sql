-- ********************** SCRIPT 1 - BASIC QUERIES ****************************
-- *************** WHERE - COUNT, GROUP BY, ORDER BY, ALIAS *******************

-- 1.1 - NUMBER OF ATHLETES PER GAME

-- *********************************

select Games, Count(Distinct ID) as Number_athletes 
from athlete_events
group by Games
order by Games

-- *********************************


-- 1.2 - NUMBER OF MEDALS PER GAME

-- *******************************

select Games, Count(Distinct concat(Games, Sport, Event)) as Number_athletes 
from athlete_events
where Medal <> 'NA' 
group by Games
order by Games

-- ***************************


-- 1.3 - TOP 10 SPORTS WITH MOST PARTICIPATIONS

-- *********************************************

select top 10 Sport, count(Distinct Games) as NumberSports
from athlete_events
group by Sport
order by NumberSports desc

-- **************************************


-- 1.4 - SPORTS COUNT PER OLYMPICS

-- *******************************

select Games, count(Distinct Sport) as count_sports
from athlete_events
group by Games
order by count_sports desc

-- *************************