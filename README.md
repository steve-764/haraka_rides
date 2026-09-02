# Haraka Rides - Project Brief

## The Scenario

Haraka Rides is a Nairobi ride-hailing company. Two different systems export their own raw data and have never been cleaned or connected:

- **Bookings system** — who rode with whom
- **Fleet system** — what it costs to keep each car on the road

Management wants one clean, connected database so they can finally ask:

> *Which vehicles are actually making us money?*

---

## The Two Raw Files

### `trips_staging.csv` — 406 rows, 18 columns

One row per trip, but denormalized — customer, driver, and vehicle details are repeated on every row they appear on, exactly as a booking-app export would look before anyone modeled it properly.

### `fleet_staging.csv` — 106 rows, 17 columns

One row per fuel fill-up **OR** maintenance event — `event_type` tells you which.

Vehicle details (`plate`, `make`, `model`, `year`, `type`, `status`) repeat on every row for that vehicle.

Fuel-only columns are blank on maintenance rows, and vice versa.

---

# Dirty Data — Problems to Expect

I won't tell you exactly how many of each — profiling the data to find these yourself is **Phase 2**. But here's the category list so you know what to look for.

| Problem Category | Where You'll See It |
|---|---|
| **Inconsistent casing** | Names, statuses, payment methods, vehicle makes/models — UPPER, lower, Mixed all appear for the same real value |
| **Stray whitespace** | Leading/trailing spaces on names, plate numbers, station names |
| **Inconsistent phone formats** | Dashes, `+254` prefix, missing entirely |
| **Multiple date formats** | The same column has ISO, `DD/MM/YYYY`, `MM-DD-YYYY`, and 2-digit-year variants all mixed together |
| **Currency-prefixed / comma-formatted numbers** | `fare_amount`, `fuel_cost`, `maintenance_cost` sometimes stored as text like `"KES 1,320"` |
| **Invalid values** | Ratings outside the valid 1–5 range, negative distances |
| **Missing values** | Blank cells scattered throughout — some meaningful (a fuel-only row has no `maintenance_cost`), some not (a genuinely missing phone number) |
| **Exact duplicate rows** | A handful of rows appear more than once, as if double-submitted |
| **Same entity, different spelling** | The same vehicle's `plate_number` typed slightly differently across (and even within) each file |

---

# Phase 1 — Load As-Is (Staging)

Create a staging table for each CSV with **every single column as `TEXT`**. No exceptions, even for things that look numeric — you haven't verified they're clean yet.

Load each CSV in directly. Nothing should fail to load; if a row fails, your staging table isn't wide-open enough yet.

### 1. Decide where each staging table lives

Does it make more sense to put `trips_staging` in the same schema as the clean booking tables will live, or somewhere separate?

**Justify your choice.**

### 2. Load both CSVs

Look up how your tool of choice (`psql \copy`, pgAdmin's import wizard, or otherwise) loads a CSV with a header row.

---

# Phase 2 — Profile the Mess

Before fixing anything, prove to yourselves what's actually wrong.

For each staging table:

### 1. Count distinct values

Count distinct values in every categorical-looking column:

- `status`
- `payment_method`
- `event_type`
- `vehicle_status`
- etc.

How many variants of the same real value do you see?

### 2. Check for format inconsistency

Check for format inconsistency in **every date and money column**.

Can you spot more than one date pattern just by eyeballing a sample?

### 3. Look for NULLs and blanks

Look for `NULL`s and blanks column by column.

Which ones are expected (event-type-dependent) and which are genuinely missing data?

### 4. Check vehicle plates

Check `vehicle_plate` in both files.

How many distinct-looking plates are there in each, before and after you mentally normalize casing/whitespace?

Do the counts make sense against each other?

---

# Phase 3 — Design the Clean Schema

Design two schemas:

1. One for the **booking side**
2. One for the **fleet side**

Before writing any `CREATE TABLE`, sketch it out — on paper or a whiteboard — and answer these as a group.

### 1. What are the real entities?

A trip mentions a customer, a driver, and a vehicle — but only one of those (the trip itself) truly belongs in a `trips` table.

What separate tables do customer and driver details belong in?

### 2. Where does `vehicle` live, and only once?

Vehicle details appear in both raw files.

Which schema should own the single, canonical `vehicles` table?

What happens to the vehicle columns in the other file's staging data?

### 3. What's the reconciliation key?

Once you've decided which schema owns vehicles, how will the **other schema's tables** know which `vehicle_id` a row refers to, given they only have a dirty `plate_number` to go on?

### 4. What are your primary and foreign keys?

Which columns are surrogate keys you'll generate, and which foreign keys need to reach across schemas?

---

# Phase 4 — Clean & Load

Migrate data from staging into your new clean tables.

This is graded on your reasoning as much as your result — **comment your queries to explain each decision**.

Work through it roughly in this order:

### 1. Build the vehicles table first

Every other table depends on knowing which `vehicle_id` corresponds to which real car.

Handle the casing/whitespace problem so the same car isn't counted twice.

### 2. Build customers and drivers next

Extract distinct people from the messy trip rows.

Think carefully about what makes two rows "the same person" when one field (like phone) might be missing on some of their rows.

### 3. Build trips last

Look up the correct:

- `customer_id`
- `driver_id`
- Cross-schema `vehicle_id`

For every row:

- Fix the date formats.
- Strip currency symbols from money fields.
- Decide what to do with out-of-range ratings.
- Decide what to do with negative distances.

### 4. Build `fuel_logs` and `maintenance_logs`

Do the same for `fuel_logs` and `maintenance_logs` in the fleet schema, splitting the merged event log back into two proper tables based on `event_type`.

### 5. Remove exact duplicates

Remove exact duplicates however you find most natural — there's more than one valid way to do this.

---

# Phase 5 — Analysis (JOINs & Subqueries)

These are guided business questions, not SQL to copy.

For each one, work out:

1. **Which tables do you need?**
2. **Whether it's a plain JOIN or if you need a subquery/CTE**
3. **Whether the question needs both schemas talking to each other**

We're not giving you the query — **that's the point**.

---

## Booking-Side Questions

### B1. Top 5 Drivers

Which 5 drivers have completed the most trips?

What does **"completed"** mean here, and which table tells you that?

### B2. Customers Who Never Completed a Trip

Which customers have never actually completed a trip — even if they show up in the customers table at all?

Think about what kind of JOIN finds **"nothing on the other side."**

### B3. Revenue by Payment Method

Calculate total revenue broken down by payment method, counting only completed trips.

What do you need to:

- Filter?
- Group by?

---

## Fleet-Side Questions

### F1. Vehicles Ranked by Fuel Cost

Rank vehicles by total fuel cost.

Which two tables does this need, and is a plain JOIN enough?

### F2. Vehicles With More Than 3 Maintenance Events

Which vehicles have had more than 3 maintenance events, and what's their total maintenance spend?

> **Hint:** This needs a `HAVING`, not a `WHERE`.

### F3. Vehicles With No Fuel Logs

Is there a vehicle that has never had a single fuel log?

How would you prove a row genuinely doesn't exist on the other side of a JOIN, rather than just not showing up because of a mismatched key?

---

## Cross-Schema Questions

### X1. Vehicle Details on Completed Trips

For completed trips, show the vehicle's:

- Plate
- Make
- Model

alongside the trip.

This is the simplest possible cross-schema JOIN — get comfortable with it before the harder ones below.

### X2. Total Revenue per Vehicle

Calculate total revenue generated per vehicle for completed trips only.

Some vehicles may have generated zero revenue — make sure your JOIN choice doesn't accidentally drop them from the result.

### X3. Under-Repair Vehicles Still Carrying Trips

Are there any vehicles marked **`Under Repair`** in the fleet system that still show up carrying trips in the booking system?

What would that finding mean for the business, if it existed?

---

# Subquery Challenges

## S1. Customers Who Ride Further Than Average

Which customers ride further than average?

> **Question:** "Average" of what, exactly — and does that number need to come from a subquery, or can you get it another way?

## S2. Vehicles Spending More Than Average on Fuel

Which vehicles spend more on fuel than the average vehicle's total fuel spend?

> **Important:** This needs an **average of an aggregate** (each vehicle's own total), not a plain average of every row in `fuel_logs`.

Think about what has to happen first before you can average it.

## S3. Trips With Above-Average Fares for Their Payment Method

For each completed trip, determine whether its fare is higher than the average fare for that same payment method.

> **Hint:** This is a correlated subquery — the "average" is different depending on which row you're looking at.

---

# Capstone — Vehicle Profitability Report

Produce one result containing, for **every vehicle**:

- Total revenue from completed trips
- Total fuel cost
- Total maintenance cost
- Net profit

### Net Profit Formula

```text
Net Profit = Revenue - Fuel Cost - Maintenance Cost