# Task-3-Waliyullahi-Akorede-Husain
Repository for Task 3
# Decodelabs Internship Diary: Project 3 – Database Engineering & Advanced SQL Analytics

Data analysis isn't just about reading data, it's about knowing how to safely migrate, transform, and secure it. Moving from the visual grids of Excel to writing pure command-line SQL script marked a major technical shift in my Decodelabs internship.

This repository documents how I overcame complex data pipeline failures, executed schema modifications using Data Definition Language (DDL), and wrote advanced SQL queries to interrogate the underlying database engine.

---

## Tech Stack & SQL Concepts Applied
* **Database Engine:** MySQL / Relational Database Management System (RDBMS)
* **DDL (Data Definition Language):** Schema optimization, type casting (`ALTER`, `MODIFY`)
* **DML (Data Manipulation Language):** Data transformation, parallel-track column engineering (`UPDATE`)
* **Advanced Aggregations:** Time-series date parsing, conditional logic (`CASE WHEN`), and conditional aggregation

---

## Challenges & Solutions

### 1. Eliminating CSV Import Corruption 
* Importing the raw CSV into the database caused character encoding corruption, transforming the primary key header into `ï»¿OrderID`. Traditional quotation marks threw syntax errors when attempting to fix it.
* I leveraged MySQL-specific syntax, using backticks (`` ` ``) rather than single quotes (`'`) to force the database engine to recognize the messy, character-heavy string as a valid system object during an `ALTER TABLE` statement.

### 2. Safe Date Casting
* The raw dataset stored dates as text strings in a non-standard `DD/MM/YYYY` format. Altering the column directly to a strict `DATE` data type caused a data wipe, turning all records into `NULL` values since MySQL natively expects `YYYY-MM-DD`.
* I engineered a **parallel-track data migration**:
  1. Added a temporary, type-safe column to the schema.
  2. Executed a DML script using `STR_TO_DATE(TRIM(Date), '%d/%m/%Y')` to clean, parse, and copy the records.
  3. Safely dropped the legacy text column and renamed the new, clean column.

### 3. Structural Schema Optimization
* To maximize query execution speed and ensure high-level analytical performance, I used strict DDL commands to permanently modify the table structure—transforming loose `TEXT` fields into optimal `INT` and `DOUBLE` numeric types for quantities and prices.

---

## Business Insights Uncovered via SQL

Once the schema integrity was locked down, I wrote queries to drive key business insights:

### 1.
By extracting and grouping the temporal data using `DAYNAME()`, a clear weekly pattern emerged:

* **Sundays** represent peak performance, generating the highest gross revenue (**$199,194.84**) and the lowest order cancellations (**18.28%**).
* **Tuesdays** represent a severe operational risk, showing a major cancellation spike of **24.24%**.

### 2. 
Using conditional `CASE WHEN` logic, I built dynamic customer profile segments directly in the query layer:

* **Large Bulk Carts (7+ items)** maintained a high average item price (**$351.19**), driving a massive average total order value of **$1,394.20**.

### 3. 

To see if the business's high cancellation rates were tied to specific coupon exploits, I calculated cancellation percentages across separate marketing promotions using conditional aggregation:

* The cancellation rate flatlined uniformly across the board. While `WINTER15` hit **22.95%**, transactions with **`NO COUPON`** still hovered at a staggering **18.77%**. This proves that the ~20% revenue leakage is not a promotional abuse.

---


Auditing the data distribution via SQL grouping functions confirmed the exact same phenomenon discovered during my Excel EDA phase: a uniform, symmetrical split across every key variable. 
