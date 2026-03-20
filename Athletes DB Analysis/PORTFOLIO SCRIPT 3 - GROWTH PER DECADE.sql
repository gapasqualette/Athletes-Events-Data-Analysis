---- **************** SCRIPT 3 - TEMPORAL ANALYSIS ***********************
---- *********************************************************************

-- 3.1 - NUMBER OF EVENTS THROUGH THE DECADES

-- ******************************************

with cte_filter as (
	select (Year / 10) * 10 as Decade, Sport, Count(Distinct Event) as [Number Event per Sport]
	from athlete_events
	group by (Year / 10) * 10, Sport
	)
select Decade, Sport, [Number Event per Sport]
from cte_filter
group by Decade, Sport, [Number Event per Sport]
order by Decade desc, [Number Event per Sport] desc

-- ******************************************


-- 3.2 - GROWTH RATE FOR FEMALE ATHLETES THROUGHOUT THE DECADES

-- ************************************************************

with cte_female as (
	select 
		(Year / 10) * 10 as Decade, 
		Count(Distinct ID) as [Females Athletes], 
		LAG(Count(Distinct ID), 1) over (order by (Year / 10) * 10) as [Previous Number],
		Round(100.0 * (Count(Distinct ID) - LAG(Count(Distinct ID), 1) over (order by (Year / 10) * 10)) / LAG(Count(Distinct ID), 1) over (order by (Year / 10) * 10),2) as Growth
	from athlete_events
	where Sex = 'F'
	group by (Year / 10) * 10
	)
select Decade, [Females Athletes], [Previous Number], Growth
from cte_female
order by Decade
-- ************************************************************

--	Insight: Number was pretty small in early years (1900s and 1910s) because they were not incentivized to practice any kind of sport, just a few pre-selected.
--			There was a raise in the 1920s mostly because of WWI, when women had to do lots of activities, previously male's. Therefore, they were less oppressed 
--			since roles between men and woman were equalizing little by little.
--			Since the 50s until 2010s, historic moviments by women made possible to grow number of women's sports and events, so they were more welcome to sports in general.

-- ************************************************************


-- 3.3 - NUMBER OF ATHLETES & AVERAGE AGE BY DECADE

-- ************************************************

with cte_age as (
	select 
		(Year / 10) * 10 as Decade, 
		Sport,
		Count(distinct ID) as [Number of Athletes],
		avg(Age) as [Average Age]
	from athlete_events
	where Age > 0
	group by (Year / 10) * 10, Sport
)
select Decade, Sport, [Number of Athletes], [Average Age]
from cte_age
order by Decade desc, [Average Age] desc

-- ************************************************

-- Insight: In the 2010s, it is seen that the lesser the physical requirement, bigger the average age. And the opposite for higher physical effort sports.

-- ******************************************************


-- 3.4 - GOLD MEDALS THROUGH THE DECADES 

-- ******************************************************

with cte_gold_per_decade as (
	select 
		NOC,
		(Year / 10) * 10 as Decade, 
		count(distinct concat(Games, Sport, Event)) as [Number of Gold Medals]
	from athlete_events
	where Medal = 'Gold'
	group by (Year / 10) * 10, NOC
),
cte_gold_cumulative as (
	select 
		NOC,
		Decade,
		[Number of Gold Medals],
		Sum([Number of Gold Medals]) over (partition by NOC order by Decade ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as [Cumulative Gold Medals]	
	from cte_gold_per_decade
),
cte_rank_cumulative as (
	select
		NOC,
		Decade,
		[Number of Gold Medals],
		[Cumulative Gold Medals],
		rank() over (partition by Decade order by [Cumulative Gold Medals] desc) as Ranking	
	from cte_gold_cumulative
)
select Decade, NOC, [Number of Gold Medals],[Cumulative Gold Medals], Ranking
from cte_rank_cumulative
where Ranking <=10
order by Decade 

-- ******************************************************

-- Insight: Besides USA and China, mostly european countries have been in the top 10 most gold medals countries. 
--			This is because these countries were always in the Olympics so they could accumulate more medals.

-- ******************************************************


-- 3.5 - TOTAL FEMALES PERCENTAGE THROUGH THE DECADES (CTE WAY)

-- ********************************************

with cte_females as (
	select 
		(Year  / 10) * 10 as Decade,
		Sex,
		count(distinct ID) as [Number of Athletes]
	from athlete_events
	group by (Year / 10) * 10, Sex
),
cte_females_sub as (
	select
		Decade,
		Sex,
		[Number of Athletes],
		round(100.0 * [Number of Athletes] / sum([Number of Athletes]) over (partition by Decade), 2) as Percentage
	from cte_females
	group by Decade, Sex, [Number of Athletes]
)
select Decade, Sex, [Number of Athletes], Percentage
from cte_females_sub
order by Decade desc, Sex

-- ********************************************

-- 3.5 - TOTAL FEMALES PERCENTAGE THROUGH THE DECADES (BASIC WAY)

-- ********************************************

select 
	(Year / 10)*10 as Decade, 
	Sex, 
	count(distinct ID) as [Number of Athletes], 
	round(100.0 * count(distinct ID) / sum(count(distinct ID)) over (partition by (Year / 10)*10), 2) as Percentage
from athlete_events
group by (Year / 10)*10, Sex
order by Decade desc, Sex

-- ********************************************