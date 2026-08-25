set search_path to haraka;

-- =============================================================================================================
-- ============================== 			HARAKA ANALYSIS				 =======================================


/* 									Booking-Side Questions													*/

/*
B1. Which 5 drivers have completed the most trips?*/

with driver_trips as (
	-- counting each driver trips where status = completed
	select driver_id, count(*) as trips_count
	from haraka.trips t 
	where status = 'Completed'
	group by driver_id
)
-- getting driver name from drivers table
select d.driver_name,dt.trips_count
from driver_trips dt
join haraka.drivers d
on dt.driver_id = d.driver_id
order by dt.trips_count desc
limit 5;


/*
B2. Which customers have never actually completed a trip - even if they show up in the customers table at all? 
 */


select 
		c.customer_name,
		t.status,
		count(*) as failed_trips_count
from haraka.trips t 
join haraka.customers c 
on t.customer_id = c.customer_id 
where status != 'Completed'
group by c.customer_name, t.status
order by c.customer_name asc;


/*
B3. Total revenue broken down by payment method, counting only completed trips.
*/

select 	payment_method, 
		sum(t.fare_amount ) as total_revenue
from haraka.trips t 
where status = 'Completed'
group by payment_method
order by total_revenue desc;


/* Fleet-Side Questions */

/* 
F1. Rank vehicles by total fuel cost.

*/

with total_cost as (
	select vehicle_id, 
			sum(fuel_cost) as total_fuel_cost
	from haraka.fuel f
	group by f.vehicle_id
)
select 
		v.vehicle_plate,
		tc.total_fuel_cost,
		dense_rank() over (order by total_fuel_cost desc)
from total_cost tc
join haraka.vehicles v 
on tc.vehicle_id = v.vehicle_id 
order by total_fuel_cost desc;


/* 
F2. Which vehicles have had more than 3 maintenance events, and what's their total maintenance spend? 

*/

select vehicle_id,
	count(*) as maintenance_count, 
	sum(maintenance_cost) as total_cost
from haraka.maintenance m 
group by m.vehicle_id 
having count(*) > 3
order by maintenance_count desc;


/*
F3. Is there a vehicle that has never had a single fuel log?
 How would you prove a row genuinely doesn't exist on the other side of a JOIN, 
 rather than just not showing up because of a mismatched key?
*/

select 
	v.vehicle_id,
	v.vehicle_plate,
	v.vehicle_make,
	v.vehicle_model
from haraka.vehicles v
where not exists (
	select *
	from haraka.fuel f 
	where v.vehicle_id = f.vehicle_id 
);

/* Cross-Schema Questions */

/* 
X1. For completed trips, show the vehicle's plate, make, and model alongside the trip.
*/  


select t.trip_id, 
		v.vehicle_plate,
		v.vehicle_make,
		v.vehicle_model 
from haraka.trips t
join haraka.vehicles v 
on t.vehicle_id = v.vehicle_id 
where status = 'Completed'
order by trip_id asc;


/* 
X2. Total revenue generated per vehicle (completed trips only). 
Some vehicles may have generated zero revenue - make sure your JOIN choice doesn't accidentally drop them from the result.*/

select  
	v.vehicle_plate,
	sum(fare_amount) as total_revenue
from haraka.trips t 
join haraka.vehicles v 
on t.vehicle_id = v.vehicle_id 
where t.status = 'Completed'
group by v.vehicle_plate 
order by total_revenue desc;


/*
X3. Are there any vehicles marked 'Under Repair' in the fleet system that still show up carrying trips in the booking system? 
What would that finding mean for the business, if it existed?
*/

SELECT DISTINCT
    v.vehicle_id,
    v.vehicle_plate,
    v.vehicle_make ,
    v.vehicle_model ,
    v.vehicle_status 
FROM haraka.vehicles v
INNER JOIN haraka.trips t
    ON v.vehicle_id = t.vehicle_id
WHERE LOWER(TRIM(v.vehicle_status)) = 'under repair';

/* no vehicle under repair shows up in the trips table */

/* Subquery Challenges	*/

/* 
S1. Which customers ride further than average?
*/

with avg_dist as (
	select round(avg(distance_km), 2) as avg_trip_dist
	from haraka.trips t -- 17.85
), cust_avg_dist as (
	select customer_id, 
	round(avg(distance_km), 2) as cust_dist_avg
	from haraka.trips t
	group by customer_id 
)
select 
	c.customer_name,
	cad.cust_dist_avg
from cust_avg_dist cad
cross join avg_dist 
join haraka.customers c 
on cad.customer_id = c.customer_id 
where cad.cust_dist_avg > avg_trip_dist
order by cad.cust_dist_avg desc;


/* 
S2. Which vehicles spend more on fuel than the average vehicle's total fuel spend?
Notice this needs an average OF AN AGGREGATE (each vehicle's own total) - not a plain average of every row in fuel_logs.
 Think about what has to happen first before you can average it.*/



/*
S3. For each completed trip, is its fare higher than the average fare for that same payment method? 
This is a correlated subquery - the "average" is different depending on which row you're looking at.
*/
