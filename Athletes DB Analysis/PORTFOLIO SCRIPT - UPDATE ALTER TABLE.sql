alter table athlete_events
alter column Height int

update athlete_events
set Age=''
where Age='NA'

update athlete_events
set Weight=''
where Weight='NA'

update athlete_events
set Height=''
where Height='NA'

alter table athlete_events
alter column Weight float

alter table athlete_events
alter column Age int

alter table athlete_events
alter column Year int