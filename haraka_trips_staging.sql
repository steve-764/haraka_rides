-- =============================================================================================================
-- ================================		trip_staging cleaning	================================================
-- =============================================================================================================

-- customer name

select distinct customer_name, 
		count(*) as customer_count 
from haraka.trip_staging
group by customer_name ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

select customer_name
from haraka.trip_staging ts 
where ts.customer_name != INITCAP(TRIM(customer_name)); -- 147 rows 

update haraka.trip_staging ts 
set customer_name = INITCAP(TRIM(customer_name))
where ts.customer_name != INITCAP(TRIM(customer_name));

-- =============================================================================================================

-- customer phone

SELECT 
    customer_phone
FROM haraka.trip_staging ts 
-- checking phone numners satrting with "+254" or having a (-) separator.
WHERE customer_phone LIKE '+254%' OR customer_phone LIKE '%-%';
-- 118 customer phone numbers with issues

-- filtering out customer phone with a - separator

select customer_phone
from haraka.trip_staging ts 
where customer_phone like '%-%'; 

update haraka.trip_staging ts 
set customer_phone = regexp_replace(customer_phone,'[^0-9]','','g') -- replacing all non numeric characters with an empty field to remove the -
where ts.customer_phone like '%-%';


-- filtering out customer phone starting with "+254"

select customer_phone 
from haraka.trip_staging ts 
where ts.customer_phone like '+254%';  -- 60 rows 

update haraka.trip_staging ts 
set customer_phone = '0' || SUBSTRING(REGEXP_REPLACE(customer_phone,'[^0-9]','','g'),4)
where ts.customer_phone like '+254%';


-- =============================================================================================================

-- customer area 

select distinct customer_area , 
		count(*) as area_count 
from haraka.trip_staging
group by customer_area ;

/* case issue- standerdize to proper case. 
	leading whitespace issue 
	spelling issues*/

select customer_area
from haraka.trip_staging ts 
where ts.customer_area != INITCAP(TRIM(customer_area)); -- 102 rows 

update haraka.trip_staging ts 
set customer_area = INITCAP(TRIM(customer_area))
where ts.customer_area != INITCAP(TRIM(customer_area));

/* spelling issues 
 * 		Burubburu to Buruburu
 * 		Westllands to Westlands
 * 		Langgata to Langata
 * 		Cbbd to Cbd
 * 		Runnda to Runda
 * 		Parkllands to Parklands
 * 		Soutth B to South B
 * 		Kasarrani to Kasarani
 * 		Lavinngton to Lavington 
 * 		Soutth C to South C
 * 		
 */

 update haraka.trip_staging ts 
 set  customer_area = case
 	when customer_area in ('Burubburu') then 'Buruburu'
 	when customer_area in ('Westllands') then 'Westlands'
 	when customer_area in ('Langatta') then 'Langata'
 	when customer_area in ('Langgata') then 'Langata'
 	when customer_area in ('Cbbd') then 'Cbd'
 	when customer_area in ('Runnda') then 'Runda'
 	when customer_area in ('Parkllands') then 'Parklands'
 	when customer_area in ('Soutth B') then 'South B'
 	when customer_area in ('Kasarrani') then 'Kasarani'
 	when customer_area in ('Lavinngton') then 'Lavington'
 	when customer_area in ('Soutth C') then 'South C'
 	else ts.customer_area 
 end;
 
 

-- =============================================================================================================

-- driver name

select distinct driver_name , 
		count(*) as driver_count 
from haraka.trip_staging
group by driver_name ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

select driver_name
from haraka.trip_staging ts 
where ts.driver_name != INITCAP(TRIM(driver_name)); -- 146 rows 

update haraka.trip_staging ts 
set driver_name = INITCAP(TRIM(driver_name))
where ts.driver_name != INITCAP(TRIM(driver_name));

-- =============================================================================================================

-- driver phone

SELECT 
    ts.driver_phone 
FROM haraka.trip_staging ts 
-- checking phone numners satrting with "+254" or having a (-) separator.
WHERE driver_phone LIKE '+254%' OR driver_phone LIKE '%-%'; 
-- 103 driver phone numbers with issues

-- filtering out driver phone with a - separator

select driver_phone
from haraka.trip_staging ts 
where driver_phone like '%-%'; -- 61 rows

update haraka.trip_staging ts 
set driver_phone = regexp_replace(driver_phone,'[^0-9]','','g') -- replacing all non numeric characters with an empty field to remove the -
where ts.driver_phone like '%-%';


-- filtering out driver phone starting with "+254"

select driver_phone 
from haraka.trip_staging ts 
where ts.driver_phone like '+254%';  -- 42 rows 

update haraka.trip_staging ts 
set driver_phone = '0' || SUBSTRING(REGEXP_REPLACE(driver_phone,'[^0-9]','','g'),4)
where ts.driver_phone like '+254%';


-- =============================================================================================================

-- vehicle plate

select distinct vehicle_plate, 
		count(*) as plates_count 
from haraka.trip_staging ts 
group by vehicle_plate ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

select vehicle_plate
from haraka.trip_staging ts 
where ts.vehicle_plate != UPPER(TRIM(vehicle_plate)); -- 126 rows 

update haraka.trip_staging ts 
set vehicle_plate = UPPER(TRIM(vehicle_plate))
where ts.vehicle_plate != UPPER(TRIM(vehicle_plate));


-- =============================================================================================================

-- vehicle make 

select distinct vehicle_make , 
		count(*) as make_count 
from haraka.trip_staging
group by vehicle_make ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

select vehicle_make
from haraka.trip_staging ts 
where ts.vehicle_make != INITCAP(TRIM(vehicle_make)); -- 107 rows 

update haraka.trip_staging ts 
set vehicle_make = INITCAP(TRIM(vehicle_make))
where ts.vehicle_make != INITCAP(TRIM(vehicle_make));

-- =============================================================================================================

-- vehicle model

select distinct vehicle_model , 
		count(*) as model_count 
from haraka.trip_staging
group by vehicle_model ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

select vehicle_model
from haraka.trip_staging ts 
where ts.vehicle_model != INITCAP(TRIM(vehicle_model)); -- 77 rows 

update haraka.trip_staging ts 
set vehicle_model = INITCAP(TRIM(vehicle_model))
where ts.vehicle_model != INITCAP(TRIM(vehicle_model));

-- =============================================================================================================

-- pickup area 

select distinct pickup_area  , 
		count(*) as pickup_count 
from haraka.trip_staging
group by pickup_area ;

-- setting all the rows to proper case

select pickup_area
from haraka.trip_staging ts 
where ts.pickup_area != INITCAP(TRIM(pickup_area)); -- 100 rows 

update haraka.trip_staging ts 
set pickup_area = INITCAP(TRIM(pickup_area))
where ts.pickup_area != INITCAP(TRIM(pickup_area));


/* spelling issues
 * 		CBBD to CBD
 * 		Rundda to Runda
 * 		Kilimmani to Kilimani
 * 		Langgata to Langata
 * 		Karren to Karen
 * 		Soutth C to South C
 * 		Westllands to Westlands
 * 		Lavinngton to Lavington
 * 		Parkllands to Parklands
 * case issues, standerdize to proper case
*/

update haraka.trip_staging ts 
 set  pickup_area = case
 	when pickup_area in ('Langgata') then 'Langata'
 	when pickup_area in ('Cbbd') then 'Cbd'
 	when pickup_area in ('Runnda') then 'Runda'
 	when pickup_area in ('Kilimmani') then 'Kilimani'
 	when pickup_area in ('Langatta') then 'Langata'
 	when pickup_area in ('Karren') then 'Karen'
 	when pickup_area in ('Soutth C') then 'South C'
 	when pickup_area in ('Westllands') then 'Westlands'
 	when pickup_area in ('Kasarrani') then 'Kasarani'
 	when pickup_area in ('Lavinngton') then 'Lavington'
 	when pickup_area in ('Parkllands') then 'Parklands'
 	else ts.pickup_area 
 end;


-- replacing empty pickup area with unknown

select trip_id, 
		ts.pickup_area 
from haraka.trip_staging ts
WHERE pickup_area = ''; -- 10 pickup_area instances were empty

UPDATE haraka.trip_staging ts
SET pickup_area = 'Unknown'
WHERE TRIM(pickup_area) = '';


-- =============================================================================================================

-- Dropoff area 

select distinct dropoff_area , 
		count(*) as dropoff_count 
from haraka.trip_staging
group by dropoff_area ;

/* fixing case issues */


select dropoff_area
from haraka.trip_staging ts 
where ts.dropoff_area != INITCAP(TRIM(dropoff_area)); -- 108 rows 

update haraka.trip_staging ts 
set dropoff_area = INITCAP(TRIM(dropoff_area))
where ts.dropoff_area != INITCAP(TRIM(dropoff_area));

/* spelling issues 
 * 		Runnda to Runda
 * 		Westllands to Westlands
 * 		Lavinngton to Lavington
 * 		CBBD to CBD
 * 		Embakkasi to Embakasi
 * 		Kilimmani to Kilimani
 * 		Langgata to Langata
 * 		Soutth B to South B
 * 		Soutth C to South C
 * 		Burubburu to Buruburu
 * 		Parkllands to Parklands
 */

update haraka.trip_staging ts 
 set  dropoff_area = case
 	when dropoff_area in ('Runnda') then 'Runda'
 	when dropoff_area in ('Westllands') then 'Westlands'
 	when dropoff_area in ('Lavinngton') then 'Lavington'
 	when dropoff_area in ('Cbbd') then 'Cbd'
 	when dropoff_area in ('Embakkasi') then 'Embakasi'
 	when dropoff_area in ('Kilimmani') then 'Kilimani'
 	when dropoff_area in ('Langgata') then 'Langata'
 	when dropoff_area in ('Karren') then 'Karen'
 	when dropoff_area in ('Soutth B') then 'South B'
 	when dropoff_area in ('Soutth C') then 'South C'
 	when dropoff_area in ('Kasarrani') then 'Kasarani'
 	when dropoff_area in ('Parkllands') then 'Parklands'
 	else ts.dropoff_area 
 end;

select distinct dropoff_area,
		count(*) as dropoff_count
from haraka.trip_staging ts 
group by dropoff_area; -- there are two versions of "Ngong Road" - need to remove whiespace in the middle to standerdize them.

SELECT 
   distinct dropoff_area,
    REGEXP_REPLACE(TRIM(dropoff_area),'\s+',' ','g') AS standardized_area
FROM haraka.trip_staging ts 
group by dropoff_area ;


UPDATE haraka.trip_staging
SET dropoff_area = REGEXP_REPLACE(TRIM(dropoff_area), '\s+', ' ', 'g');


-- replacing empty dropoff area with unknown

select trip_id, 
		ts.dropoff_area 
from haraka.trip_staging ts
WHERE dropoff_area = ''; -- 25 dropoff_area instances were empty

UPDATE haraka.trip_staging ts
SET dropoff_area = 'Unknown'
WHERE TRIM(dropoff_area) = '';

-- =============================================================================================================

-- trip date 

SELECT 
    trip_date 
FROM haraka.trip_staging 
WHERE trip_date NOT SIMILAR TO '[0-9]{4}-[0-9]{2}-[0-9]{2}'; -- checking dates not in frormat yyyy-mm-dd
-- total count is 207 dates not in proper format

-- checking dates with / separator

select trip_date from haraka.trip_staging t 
where t.trip_date like '%/%'; -- 137

/* 	some dates in dd/mm/yyyy
 	some dates in dd/mm/yy
*/

-- fixing date in form dd/mm/yy

select trip_date from haraka.trip_staging t 
where t.trip_date like '%/%' and LENGTH(trip_date) = 8; -- 38 dates in this format

UPDATE haraka.trip_staging
SET trip_date = TO_DATE(trip_date,'DD/MM/YY')::TEXT
WHERE trip_date LIKE '%/%' AND LENGTH(trip_date) = 8;


-- fixing dates in format dd/mm/yyyy

select trip_date from haraka.trip_staging t 
where t.trip_date like '%/%' and LENGTH(trip_date) = 10; -- 101 dates in this format

UPDATE haraka.trip_staging
SET trip_date = TO_DATE(trip_date,'DD/MM/YYYY')::TEXT
WHERE trip_date LIKE '%/%' AND LENGTH(trip_date) = 10;


/*   dates in mm-dd-yyyy
 */
select trip_date from haraka.trip_staging t 
where t.trip_date like '%-%';

-- filtering out dates in  mm-dd-yyyy format

SELECT trip_date
FROM haraka.trip_staging t 
WHERE trip_date LIKE '%-%'
  AND LENGTH(trip_date) = 10
  AND SPLIT_PART(trip_date,'-',1)::INTEGER <= 12; -- 68 dates in this format
  

UPDATE haraka.trip_staging t 
SET trip_date = TO_DATE(trip_date,'MM-DD-YYYY')::TEXT
WHERE trip_date LIKE '%-%'
  AND LENGTH(trip_date) = 10
  AND SPLIT_PART(trip_date,'-',1)::INTEGER <= 12; 


-- =============================================================================================================
-- distance

select distance_km from haraka.trip_staging ts
where ts.distance_km like '-%';		-- selecting rows with a - prefix -- 15 rows

/* - sign present in some rows,
 * empty rows - turn to null
 */

update haraka.trip_staging ts 
set distance_km = regexp_replace(ts.distance_km, '-', '', 'g') -- replacing - sign with a empty field to remove it
where ts.distance_km like '-%';


-- =============================================================================================================

-- payment method

select distinct payment_method , 
		count(*) as payment_count 
from haraka.trip_staging
group by payment_method ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

select payment_method
from haraka.trip_staging ts 
where ts.payment_method != INITCAP(TRIM(payment_method)); -- 157 rows 

update haraka.trip_staging ts 
set payment_method = INITCAP(TRIM(payment_method))
where ts.payment_method != INITCAP(TRIM(payment_method));

-- standerdizing  payment method

update haraka.trips t
set payment_method = case
	when payment_method in ('Mpesa') then 'M-Pesa'
	else payment_method
end;


-- =============================================================================================================

-- status

select distinct status , 
		count(*) as status_count 
from haraka.trip_staging
group by status ;

/* case issue- standerdize to proper case.  */

select status
from haraka.trip_staging ts 
where ts.status != INITCAP(TRIM(status)); -- 164 rows 

update haraka.trip_staging ts 
set status = INITCAP(TRIM(status))
where ts.status != INITCAP(TRIM(status));

-- standerdizing status

update haraka.trip_staging ts 
set status = case
	when status in ('Complete') then 'Completed'
	when status in ('No Show') then 'No-Show'
	else status
end;


-- =============================================================================================================

-- fare amount

select fare_amount from haraka.trip_staging ts
where ts.fare_amount like 'KES%'; -- 107 rows

/* KES prefix present in some rows, to be removed.
 * comma (,) present in some values, to  be removed.
*/

select fare_amount
from haraka.trip_staging t 
where fare_amount like 'KES%'; 		-- selecting rows starting with KES prefix -- 107 rows 


UPDATE haraka.trip_staging t 
SET fare_amount = REGEXP_REPLACE(fare_amount,'[^0-9.]','','g') -- replacing all characters not in range 0-9 with empty value to remove them.
WHERE fare_amount SIMILAR TO '%[^0-9.]%';

-- =============================================================================================================

-- customer rating

select distinct customer_rating  , 
		count(*) as rating_count 
from haraka.trip_staging
group by customer_rating ;

/* empty ratings,
 * ratings above limit 5, i.e. 6 
 * ratings below limit 1, i.e. 0
 */

-- count the values not in range of 0 to 5
SELECT count(*) as invalid_rating_count
FROM haraka.trip_staging 
WHERE customer_rating NOT IN ('1','2','3','4','5',''); -- 77 rows/records counted

UPDATE haraka.trip_staging
SET customer_rating = NULL
WHERE TRIM(customer_rating) NOT IN ('1','2','3','4','5','');

-- =============================================================================================================

/* chacking for duplicate trips  */

select trip_id,
		count(*) as trip_count
from haraka.trip_staging
group by trip_id 
having count(*) > 1;

/* trips 131, 46, 112, 11, 79 and 91 appear twice */
/* confirming that the logs are replicated */ 

select * from haraka.trip_staging t 
where trip_id in ('11', '46', '79', '91', '112', '131')
order by trip_id ;

/* removing the duplicates */

delete from haraka.trip_staging 
where ctid not in 
	(select min(ctid) from haraka.trip_staging group by trip_id);

-- =============================================================================================================


select * from haraka.trip_staging ts;