set search_path to haraka;

-- =============================================================================================================

/* creating trips table */

CREATE TABLE haraka.trips (
    trip_id VARCHAR(50) PRIMARY KEY,
    customer_id INTEGER,
    driver_id INTEGER,
    vehicle_id INTEGER,
    pickup_area VARCHAR(50),
    dropoff_area VARCHAR(50),
    trip_date DATE,
    pickup_time TIME,
    distance_km numeric(10, 2),
    payment_method VARCHAR(50),
    status VARCHAR(50),
    fare_amount INTEGER,
    customer_rating INTEGER,
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES haraka.customers(customer_id),
    CONSTRAINT fk_driver
        FOREIGN KEY (driver_id)
        REFERENCES haraka.drivers(driver_id),
    CONSTRAINT fk_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES haraka.vehicles(vehicle_id)
);


-- =============================================================================================================

/*  checking all customer names, driver names, vehicle plates in the trip staging table
 *  have a corresponding customer id, driver id and vehivle id in the respective tables */

SELECT
    ts.trip_id,
    ts.customer_name,
    c.customer_id,
    ts.driver_name,
    d.driver_id,
    ts.vehicle_plate,
    v.vehicle_id
FROM haraka.trip_staging ts
LEFT JOIN haraka.customers c
    ON TRIM(LOWER(ts.customer_name)) =
       TRIM(LOWER(c.customer_name))
LEFT JOIN haraka.drivers d
    ON TRIM(LOWER(ts.driver_name)) =
       TRIM(LOWER(d.driver_name))
LEFT JOIN haraka.vehicles v
    ON TRIM(UPPER(ts.vehicle_plate)) =
       TRIM(UPPER(v.vehicle_plate))
WHERE c.customer_id IS NULL
   OR d.driver_id IS NULL
   OR v.vehicle_id IS NULL;

/* no issue found */


-- =============================================================================================================

-- inserting data into trips table, from trips staging, drivers, customers and vehicles tables 

INSERT INTO haraka.trips (
    trip_id,
    customer_id,
    driver_id,
    vehicle_id,
    pickup_area,
    dropoff_area,
    trip_date,
    pickup_time,
    distance_km,
    payment_method,
    status,
    fare_amount,
    customer_rating
)
SELECT
    ts.trip_id,
    c.customer_id,
    d.driver_id,
    v.vehicle_id,
    ts.pickup_area,
    ts.dropoff_area,
    TO_DATE(ts.trip_date, 'YYYY-MM-DD'),
    TRIM(ts.pickup_time)::TIME AS pickup_time,
    NULLIF(TRIM(ts.distance_km), '')::numeric(10, 2),
    ts.payment_method,
    ts.status,
    NULLIF(TRIM(ts.fare_amount), '')::INTEGER AS fare_amount,
    nullif(TRIM(ts.customer_rating), '')::INTEGER AS customer_rating
FROM haraka.trip_staging ts
JOIN haraka.customers c
    ON TRIM(LOWER(ts.customer_name)) = TRIM(LOWER(c.customer_name))
JOIN haraka.drivers d
    ON TRIM(LOWER(ts.driver_name)) = TRIM(LOWER(d.driver_name))
JOIN haraka.vehicles v
    ON TRIM(UPPER(ts.vehicle_plate)) = TRIM(UPPER(v.vehicle_plate));

-- =============================================================================================================

/* viewing tha data in the trips table */

select * from haraka.trips t;



