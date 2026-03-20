---- **************** SCRIPT 5 - PHYSICAL ANALYSIS PER SPORT ***********************
---- *******************************************************************************

-- 5.1 - AVERAGE WEIGHT PER SPORT (MEDAL ATHLETES)

-- *****************************************

with cte_medal as (
	select Sport, round(avg(Weight),2) as [Average Weight]
	from athlete_events
	where Medal <> 'NA' and Weight <> 0
	group by Sport
)
select *
from cte_medal
order by [Average Weight]

-- *****************************************

-- Insight: Generally, sports that require more speed to practice have the smallest average weight, that also include fight sports

-- *****************************************


-- 5.2 - AVERAGE HEIGHT PER SPORT (MEDAL ATHLETES)

-- ***********************************************

with cte_medal as (
	select Sport, round(avg(Height),2) as [Average Height]
	from athlete_events
	where Medal <> 'NA' and Height <> 0
	group by Sport
)
select *
from cte_medal
order by [Average Height] desc

-- ***********************************************

-- Insight: Sports that athletes need elasticity or is a team/double effort sports, results on athletes having more height.

-- ****************************************


-- 5.3 - MEDALIST X NON MEDALISTS
-- ******************************
with cte_medalist as (
	select Sport, Height, Weight,
	case 
		when Medal = 'NA' then 'Non Medalist'
		else 'Medalist'
	end as [Medal Status]
	from athlete_events
	where Height <> 0 and Weight <> 0
)
select Sport, [Medal Status], round(avg(Height),2) as [Average Height], round(avg(Weight),2) as [Average Weight]
from cte_medalist
group by Sport, [Medal Status]
order by Sport, [Medal Status] desc

-- *******************************