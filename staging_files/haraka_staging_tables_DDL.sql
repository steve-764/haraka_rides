-- Table: haraka.fleet_staging

set search_path to haraka;

DROP TABLE IF EXISTS haraka.fleet_staging;

CREATE TABLE IF NOT EXISTS haraka.fleet_staging
(
    log_id text COLLATE pg_catalog."default",
    vehicle_plate text COLLATE pg_catalog."default",
    vehicle_make text COLLATE pg_catalog."default",
    vehicle_model text COLLATE pg_catalog."default",
    vehicle_year text COLLATE pg_catalog."default",
    vehicle_type text COLLATE pg_catalog."default",
    vehicle_status text COLLATE pg_catalog."default",
    event_type text COLLATE pg_catalog."default",
    event_date text COLLATE pg_catalog."default",
    liters text COLLATE pg_catalog."default",
    fuel_cost text COLLATE pg_catalog."default",
    odometer_reading text COLLATE pg_catalog."default",
    station_name text COLLATE pg_catalog."default",
    service_type text COLLATE pg_catalog."default",
    maintenance_cost text COLLATE pg_catalog."default",
    mechanic_name text COLLATE pg_catalog."default",
    next_service_due text COLLATE pg_catalog."default"
)
TABLESPACE pg_default;


-- Table: haraka.trips_staging

-- Table: haraka.trip_staging

DROP TABLE IF EXISTS haraka.trip_staging;

CREATE TABLE IF NOT EXISTS haraka.trip_staging
(
    trip_id text COLLATE pg_catalog."default",
    customer_name text COLLATE pg_catalog."default",
    customer_phone text COLLATE pg_catalog."default",
    customer_area text COLLATE pg_catalog."default",
    driver_name text COLLATE pg_catalog."default",
    driver_phone text COLLATE pg_catalog."default",
    vehicle_plate text COLLATE pg_catalog."default",
    vehicle_make text COLLATE pg_catalog."default",
    vehicle_model text COLLATE pg_catalog."default",
    pickup_area text COLLATE pg_catalog."default",
    dropoff_area text COLLATE pg_catalog."default",
    trip_date text COLLATE pg_catalog."default",
    pickup_time text COLLATE pg_catalog."default",
    distance_km text COLLATE pg_catalog."default",
    payment_method text COLLATE pg_catalog."default",
    status text COLLATE pg_catalog."default",
    fare_amount text COLLATE pg_catalog."default",
    customer_rating text COLLATE pg_catalog."default"
)
TABLESPACE pg_default;



