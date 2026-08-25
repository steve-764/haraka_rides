set search_path to haraka;

-- =============================================================================================================

CREATE TABLE haraka.maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER NOT NULL,
    event_date DATE,
    service_type VARCHAR(100),
    maintenance_cost NUMERIC(12,2),
    mechanic_name VARCHAR(100),
    next_service_due DATE,
    CONSTRAINT fk_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES haraka.vehicles(vehicle_id)
);


-- =============================================================================================================

/* inserting data from fleet staging where event type = maintenance */

INSERT INTO haraka.maintenance (
    vehicle_id,
    event_date,
    service_type,
    maintenance_cost,
    mechanic_name,
    next_service_due
)
SELECT
    v.vehicle_id,
    TRIM(fs.event_date)::DATE,
    TRIM(fs.service_type),
    NULLIF(
        REGEXP_REPLACE(TRIM(fs.maintenance_cost), '[^0-9.-]', '', 'g'),
        ''
    )::NUMERIC(12,2),
    TRIM(fs.mechanic_name),
    TRIM(fs.next_service_due)::DATE
FROM haraka.fleet_staging fs
JOIN haraka.vehicles v
    ON TRIM(UPPER(fs.vehicle_plate)) =
       TRIM(UPPER(v.vehicle_plate))
WHERE LOWER(TRIM(fs.event_type)) = 'maintenance';

-- =============================================================================================================

select * from haraka.maintenance m;

