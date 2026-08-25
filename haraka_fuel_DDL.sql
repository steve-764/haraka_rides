set search_path to haraka;

-- =============================================================================================================

CREATE TABLE haraka.fuel (
    fuelling_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER NOT NULL,
    event_date DATE,
    liters NUMERIC(10,2),
    fuel_cost NUMERIC(12,2),
    odometer_reading NUMERIC(12,2),
    station_name VARCHAR(100),
    CONSTRAINT fk_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES haraka.vehicles(vehicle_id)
);


-- =============================================================================================================

/* checking if all fuel events have a corresponding vehicle plate */


SELECT
    fs.vehicle_plate,
    COUNT(*) AS fuel_events
FROM haraka.fleet_staging fs
LEFT JOIN haraka.vehicles v
    ON TRIM(UPPER(fs.vehicle_plate)) =
       TRIM(UPPER(v.vehicle_plate))
WHERE LOWER(TRIM(fs.event_type)) = 'fuel'
  AND v.vehicle_id IS NULL
GROUP BY fs.vehicle_plate;


-- =============================================================================================================
/* inserting data into fuel table */

INSERT INTO haraka.fuel (
    vehicle_id,
    event_date,
    liters,
    fuel_cost,
    odometer_reading,
    station_name
)
SELECT
    v.vehicle_id,
    TRIM(fs.event_date)::DATE,
    NULLIF(TRIM(fs.liters), '')::NUMERIC(10,2),
    NULLIF(
        REGEXP_REPLACE(TRIM(fs.fuel_cost), '[^0-9.-]', '', 'g'),
        ''
    )::NUMERIC(12,2),
    NULLIF(TRIM(fs.odometer_reading), '')::NUMERIC(12,2),
    TRIM(fs.station_name)
FROM haraka.fleet_staging fs
JOIN haraka.vehicles v
    ON TRIM(UPPER(fs.vehicle_plate)) =
       TRIM(UPPER(v.vehicle_plate))
WHERE LOWER(TRIM(fs.event_type)) = 'fuel';

-- =============================================================================================================

select * from haraka.fuel f;

