-- *************** SCRIPT 2 - FEMALE ATHLETES PRESENCE *******************
-- ***********************************************************************

-- 2.1 - GENDER PARTICIPATION OVER THE YEARS

-- *****************************************

select Games, sex, count(distinct ID) as count_sex, round(count(distinct ID) * 100 / sum(count(distinct ID)) over (partition by Games),2) as percentage
from athlete_events
group by Games, sex
order by Games desc, sex

-- *****************************************


-- 2.2 - FIRST FEMALE APPEARANCE

-- *****************************

select top 1 FIRST_VALUE(Games) over (order by Games asc) as FirstAppearance
from athlete_events
where Sex = 'F'
group by Games

-- *****************************


-- 2.3 - SPORTS WITH MOST FEMALE ATHLETES

-- **************************************

select Sport, count(distinct ID) as 'Number of Female Athletes', rank() over (partition by Sex order by count(distinct ID) desc) as rank_femaleAthletes
from athlete_events
where Sex = 'F'
group by Sport, Sex

-- **************************************


-- 2.4 - COMPARISON: NUMBER OF MEDALS MEN X WOMEN OVER THE YEARS

-- *************************************************************

select Games, Sex, count(Medal) as 'Total Medals per Sex', round(count(Medal) * 100 / sum(count(Medal)) over (partition by Games),2) as Percentage
from athlete_events
where Medal <> 'NA' and Games like '%Summer'
group by Games, Sex
order by Games desc, Sex

-- *************************************************************


-- 2.5 - TOP 20 COUNTRIES WITH MOST FEMALE PRESENCE

-- ************************************************

select top 20 NOC, Team, count(distinct ID) as 'Number of Female Athletes', rank() over (partition by Sex order by count(distinct ID) desc) as 'Rank'
from athlete_events
where Sex = 'F'
group by NOC, Team, Sex

-- ************************************************

-- Insight: Women athletes presence in the Olympics has been growning, especially after 2004 Summer Event, when it reached 40% of total atheletes.
-- Now, the tendency is reaching 50/50 between males and females athletes joining the Olympics games.
-- First world countries have the most successful programs to incentivize women to follow their dreams to join the sports and compete for medals 
