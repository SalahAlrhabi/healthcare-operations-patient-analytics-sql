# Healthcare Operations & Patient Analytics — SQL

## Project Overview

This project analyzes a global hospital network dataset to evaluate patient activity, appointment performance, physician workload, hospital operations, readmissions, and financial performance.

The project follows an end-to-end SQL workflow, from data auditing and cleaning to exploratory and advanced analysis, with the final results translated into actionable business insights.

## Business Objective

The objective is to help healthcare management understand:

* Patient demographics and healthcare utilization
* Appointment completion, cancellations, and no-shows
* Waiting times and patient satisfaction
* Physician workload and specialty performance
* Hospital admissions, ICU utilization, and readmissions
* Appointment billing and admission charges
* Monthly trends and operational performance

## Dataset

**Dataset:** Global Hospital Network Dataset (2024–2026)
**Source:** Prime Levels
**Type:** Synthetic healthcare dataset

The analysis includes five main datasets:

* Patients
* Appointments
* Physicians
* Facilities
* Admissions

## Tools & SQL Skills

**Tools**

* MySQL
* MySQL Workbench
* VS Code

**SQL Skills**

* Data Cleaning
* Data Validation
* Joins
* Aggregations
* CASE Statements
* Common Table Expressions (CTEs)
* Window Functions
* `LAG()`
* `RANK()`
* `PARTITION BY`
* Rolling Averages
* Date Analysis

## Project Structure

```text
Healthcare-Operations-Patient-Analytics/
│
├── README.md
├── data/
│   ├── facilities.csv
│   ├── physicians.csv
│   ├── patients.csv
│   ├── appointments.csv
│   └── admissions.csv
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_audit.sql
│   ├── 03_data_cleaning.sql
│   ├── 04_patient_analysis.sql
│   ├── 05_appointment_analysis.sql
│   ├── 06_physician_analysis.sql
│   ├── 07_hospital_operations.sql
│   ├── 08_financial_analysis.sql
│   └── 09_advanced_analysis.sql
│
└── insights/
    └── business_insights.md
```

## Analysis Areas

### Patient Analysis

Analyzed patient demographics, insurance coverage, chronic conditions, geographic distribution, and age groups.

### Appointment Analysis

Evaluated appointment volume, completion rates, cancellations, no-shows, rescheduling, waiting times, and patient satisfaction.

### Physician Analysis

Analyzed physician workload, specialty activity, appointment volume, and completion rates.

### Hospital Operations

Evaluated admissions, length of stay, ICU utilization, and 30-day readmissions across facilities.

### Financial Analysis

Analyzed appointment billing, insurance coverage, patient payments, admission charges, facilities, and specialties.

### Advanced Analysis

Used CTEs and window functions to analyze monthly trends, month-over-month growth, facility rankings, rolling averages, no-show trends, and patient appointment frequency.

## Key Insights

* The network recorded **24,000 appointments** with a **76.50% completion rate**, while no-shows accounted for **11.24%**.
* **Sunrise Multispecialty Hospital** handled the highest appointment volume (**3,221**) and recorded the highest average waiting time (**33.98 minutes**).
* **Telemedicine** achieved the highest average satisfaction score (**4.99**), compared with **3.11** for Emergency appointments.
* The overall **30-day readmission rate was 3.71%**, while Bayou Medical Center recorded the highest facility rate at **5.35%**.
* Appointment billing totaled **$3.29M**, while admission charges reached **$51.37M**.
* **Pediatrics** led appointment volume, while **Emergency Medicine** generated the highest appointment billing, showing that service volume and financial contribution were not necessarily aligned.

For additional findings, see `insights/business_insights.md`.

## How to Run

1. Create the MySQL database using `01_database_setup.sql`.
2. Import the raw CSV datasets.
3. Run `02_data_audit.sql` to inspect data quality.
4. Run `03_data_cleaning.sql` to create analysis-ready `_clean` tables.
5. Run the analysis scripts from `04` through `09`.
6. Review the final findings in `insights/business_insights.md`.

## Workflow

```text
Raw CSV Files
      ↓
MySQL Database
      ↓
Data Audit
      ↓
Data Cleaning
      ↓
Analysis-Ready Tables
      ↓
SQL Analysis
      ↓
Advanced Analysis
      ↓
Business Insights
```
