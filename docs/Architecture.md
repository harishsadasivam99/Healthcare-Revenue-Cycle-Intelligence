# Project Architecture

## Overview

The Healthcare Revenue Cycle Intelligence Platform follows an end-to-end analytics architecture that moves data from synthetic source files into a PostgreSQL database, applies SQL-based analytics logic, and prepares curated views for Power BI reporting.

---

## Architecture Flow

```text
Synthetic Data Generator
        ↓
CSV Data Files
        ↓
Python ETL Pipeline
        ↓
PostgreSQL Database
        ↓
SQL Analytics Views
        ↓
KPI Queries
        ↓
Power BI Dashboard