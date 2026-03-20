-- ************************ SCRIPT 4 - ANALYSIS PER COUNTRY ************************
-- *********************************************************************************

-- 4.1 - OVERALL RANKING PER COUNTRY (GOLD MEDALS)
-- ***********************************************

select top 50 NOC, Sex, count(distinct concat(Games, Sport, Event, NOC, Medal)) as total_gold_medals, Rank() over (order by count(distinct concat(Games, Sport, Event)) desc) as Rank
from athlete_events
where medal = 'Gold'
group by NOC, Sex
order by Rank

-- ***********************************************


-- 4.2 - TOP 50 MOST TOTAL MEDALS PER TEAM (ALL MEDALS)

-- ****************************************************

select top 50 NOC, count(distinct concat(Games, Sport, Event)) as total_medals, Rank() over (order by count(distinct concat(Games, Sport, Event)) desc) as Rank
from athlete_events
where medal <> 'NA'
group by NOC
order by Rank

-- ****************************************************


-- 4.3 - EVOLUTION BY COUNTRY

-- **************************

with athelete_medalCTE as (
	select Games, NOC, count(Distinct concat(Games, Sport, Event)) as [Gold Medal Number], Rank() over (partition by Games order by count(Distinct concat(Games, Sport, Event)) desc) as Rank
	from athlete_events
	where Medal = 'Gold'
	group by Games, Noc
)
select *
from athelete_medalCTE
order by Games desc, Rank asc

-- **************************


-- 4.4 - MEDAL PER ATHLETE METRIC

-- *********************************

select NOC, 
	count(Distinct concat(Games, Sport, Event, NOC, Medal)) as [Medal Count], 
	count(Distinct ID) as [Number of Atheletes],
	Round(1.0 * count(Distinct concat(Games, Sport, Event)) / count(Distinct ID), 2) as [Medal per Athlete]
from athlete_events
where Medal <> 'NA'
group by NOC
order by [Number of Atheletes] desc

-- *********************************


-- 4.5 - TOP 10 GOLD MEDALS COUNTRIES PER OLYMPICS

-- ***********************************************
with athelete_medalCTE as (
	select Games, NOC, count(Distinct concat(Games, Sport, Event, NOC, Medal)) as Number_Golds, Rank() over (partition by Games order by count(Distinct concat(Games, Sport, Event)) desc) as Rank
	from athlete_events
	where Medal = 'Gold'
	group by Games, Noc
)
select *
from athelete_medalCTE
where Rank <= 10
order by Games desc, Rank asc

-- ***********************************************