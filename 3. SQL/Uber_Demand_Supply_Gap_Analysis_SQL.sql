-- =====================================================
-- UBER DEMAND-SUPPLY GAP ANALYSIS PROJECT
-- =====================================================

-- ==================================
-- PART 0: TABLE CREATION
-- ==================================

create schema Uber_request_labmentix_project1;

create table uber_requests (
request_id int,
pickup_point varchar(50),
driver_id varchar(10),
status varchar(50),
request_timestamp varchar(30),
drop_timestamp varchar(30),
request_hour int,
weekday varchar(20),
time_slot varchar(50),
driver_assigned varchar(10),
trip_completed varchar(10)
);
-- set search path

set search_path to "Uber_request_labmentix_project1";

-- ==================================
-- DATA PREVIEW
-- ==================================

-- Show the whole dataset

select *
from uber_requests;

-- ==================================
-- PART 1: BASIC ANALYSIS
-- ==================================

-- Find total ride requests

select count(*) as total_requests
from uber_requests;

-- Find total completed trips

select count(*)
from uber_requests
where status = 'Trip Completed';

-- Find total cancelled trips

select count(*)
from uber_requests
where status = 'Cancelled';

-- Find total No Cars Available requests

select count(*)
from uber_requests
where status = 'No Cars Available';

-- What is the cancellation percentage?

select round(
count(*) filter (where status = 'Cancelled')::numeric /
count(*) * 100,
2
) as cancellation_percentage
from uber_requests;

-- What is the completion percentage?

select round(
count(*) filter (where status = 'Trip Completed')::numeric /
count(*) * 100,
2
) as completion_percentage
from uber_requests;

-- ==================================
-- PART 2: PICKUP POINT ANALYSIS
-- ==================================

-- Total requests by pickup point

select pickup_point,
count(*) as total_requests
from uber_requests
group by pickup_point;

-- Which pickup point generated more requests?

select pickup_point,
count(*) as total_requests
from uber_requests
group by pickup_point
order by total_requests desc
limit 1;

-- Completed trips by pickup point

select pickup_point,
count(*) as completed_trips
from uber_requests
where status = 'Trip Completed'
group by pickup_point;

-- Cancelled trips by pickup point

select pickup_point,
count(*) as cancelled_trips
from uber_requests
where status = 'Cancelled'
group by pickup_point;

-- No Cars Available by pickup point

select pickup_point,
count(*) as no_car_requests
from uber_requests
where status = 'No Cars Available'
group by pickup_point;

-- ==================================
-- PART 3: TIME SLOT ANALYSIS
-- ==================================

-- Total requests by time slot

select time_slot,
count(*) as total_requests
from uber_requests
group by time_slot
order by total_requests desc;

-- Highest demand time slot

select time_slot,
count(*) as requests
from uber_requests
group by time_slot
order by requests desc
limit 1;

-- Lowest demand time slot

select time_slot,
count(*) as requests
from uber_requests
group by time_slot
order by requests
limit 1;

-- Status distribution by time slot

select time_slot,
status,
count(*) as total_requests
from uber_requests
group by time_slot, status
order by time_slot;

-- ==================================
-- PART 4: CANCELLATION RATE ANALYSIS
-- ==================================

-- Cancellation rate by pickup point

select pickup_point,
round(
count(*) filter(where status = 'Cancelled')::numeric /
count(*) * 100,
2
) as cancellation_rate
from uber_requests
group by pickup_point;

-- Completion rate by pickup point

select pickup_point,
round(
count(*) filter(where status = 'Trip Completed')::numeric /
count(*) * 100,
2
) as completion_rate
from uber_requests
group by pickup_point;

-- No Cars Available rate by pickup point

select pickup_point,
round(
count(*) filter(where status = 'No Cars Available')::numeric /
count(*) * 100,
2
) as no_car_rate
from uber_requests
group by pickup_point;

-- ==================================
-- PART 5: HOURLY ANALYSIS
-- ==================================

-- Requests by hour

select request_hour,
count(*) as total_requests
from uber_requests
group by request_hour
order by request_hour;

-- Peak request hour

select request_hour,
count(*) as requests
from uber_requests
group by request_hour
order by requests desc
limit 1;

-- Peak cancellation hour

select request_hour,
count(*) as cancellations
from uber_requests
where status = 'Cancelled'
group by request_hour
order by cancellations desc
limit 1;

-- Peak No Cars Available hour

select request_hour,
count(*) as no_car_requests
from uber_requests
where status = 'No Cars Available'
group by request_hour
order by no_car_requests desc
limit 1;

-- ==================================
-- PART 6: WEEKDAY ANALYSIS
-- ==================================

-- Requests by weekday

select weekday,
count(*) as total_requests
from uber_requests
group by weekday
order by total_requests desc;

-- Status by weekday

select weekday,
status,
count(*) as total_requests
from uber_requests
group by weekday, status
order by status;

-- Weekday with highest requests

select weekday,
count(*) as requests
from uber_requests
group by weekday
order by requests desc
limit 1;

-- ==================================
-- PART 7: DRIVER AVAILABILITY ANALYSIS
-- ==================================

-- Driver assigned vs not assigned

select driver_assigned,
count(*) as total_requests
from uber_requests
group by driver_assigned;

-- Trip completed vs not completed

select trip_completed,
count(*) as total_requests
from uber_requests
group by trip_completed;

-- ==================================
-- PART 8: BUSINESS INSIGHTS
-- ==================================

-- Top 5 busiest hours

select request_hour,
count(*) as requests
from uber_requests
group by request_hour
order by requests desc
limit 5;

-- Top 5 cancellation hours

select request_hour,
count(*) as cancellations
from uber_requests
where status = 'Cancelled'
group by request_hour
order by cancellations desc
limit 5;

-- Pickup point and time slot with highest demand

select pickup_point,
time_slot,
count(*) as total_requests
from uber_requests
group by pickup_point, time_slot
order by total_requests desc
limit 1;

-- Compare completed, cancelled and no car requests

select pickup_point,
count(*) filter(where status = 'Trip Completed') as completed_trips,
count(*) filter(where status = 'Cancelled') as cancelled_trips,
count(*) filter(where status = 'No Cars Available') as no_car_requests
from uber_requests
group by pickup_point;

-- ==================================
-- PART 9: EXECUTIVE SUMMARY
-- ==================================

select pickup_point,
count(*) as total_requests,
count(*) filter(where status = 'Trip Completed') as completed_trips,
count(*) filter(where status = 'Cancelled') as cancelled_trips,
count(*) filter(where status = 'No Cars Available') as no_car_requests,
round(
count(*) filter(where status = 'Trip Completed')::numeric /
count(*) * 100,
2
) as completion_rate
from uber_requests
group by pickup_point;
