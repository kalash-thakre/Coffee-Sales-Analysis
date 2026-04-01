# ☕ Coffee Sales Analysis

![SQL](https://img.shields.io/badge/SQL-BigQuery%20%7C%20MySQL-blue)

End-to-end SQL analysis of coffee sales data across BigQuery and MySQL, covering revenue trends, customer segmentation, product profitability, and temporal purchasing patterns.

---

## Overview

This project translates raw transactional coffee sales data into actionable business intelligence using advanced SQL constructs. Analysis runs across two platforms for cross-validation and performance benchmarking.

## Business questions

- What are the sales trends across daily, weekly, and monthly periods?
- Which products and categories contribute most to revenue and margin?
- How do purchasing patterns differ across customer regions and segments?
- Which customers represent the highest lifetime value?

## Tech stack

| Tool | Role |
|------|------|
| `BigQuery` | Large-scale processing, cloud infrastructure, query optimization |
| `MySQL Workbench` | Relational schema design, query development, data validation |
| `SQL` | Core language — extraction, transformation, aggregation |

## SQL techniques used

| Technique | Application |
|-----------|-------------|
| Window functions | `ROW_NUMBER`, `RANK`, `DENSE_RANK`; running totals; moving averages with `PARTITION BY` / `ORDER BY` |
| CTEs | Recursive CTEs for hierarchical data; multi-step `WITH` clause chaining; performance optimization |
| Aggregations | Group-level revenue, margin, and frequency metrics |
| Joins | Multi-table joins across customer, product, and transaction data |

## Project structure
```
coffee-sales-analysis/
├── dataset/
│   ├── city.csv
│   ├── customers.csv
│   ├── products.csv
│   ├── sales.csv
│   └── readme.md
├── docs/
│   ├── image_1.png
│   ├── image_2.png
│   ├── image_3.png
│   └── schema.png
├── README.md
├── coffee_sales_bigquery.sql
└── coffee_sales_mysql.sql
```

## Getting started

**Prerequisites**
- BigQuery project with billing enabled, *or* MySQL 8.0+
- Access to the `dataset/` folder

**Steps**
1. Import the CSV files from `dataset/` into your SQL environment
2. Refer to `dataset/readme.md` for column descriptions and data dictionary
3. Run `coffee_sales_bigquery.sql` for BigQuery or `coffee_sales_mysql.sql` for MySQL
4. Review output visuals in `docs/` and findings in `docs/schema.png`

> **Cross-platform note:** Queries are written to be compatible with both BigQuery standard SQL and MySQL 8.0+. Minor syntax differences are noted inline with comments.

## Recommendations

Based on the data analysis, the top three recommended cities for new store openings are:

### 1. Pune
- Lowest average rent per customer among top candidates
- Highest total revenue across all cities
- Strong average sales per customer

### 2. Delhi
- Largest estimated coffee consumer base at 7.7 million
- Highest total customer count at 68
- Average rent per customer remains manageable at ₹330 (under ₹500 threshold)

### 3. Jaipur
- Highest number of customers at 69
- Very low average rent per customer at ₹156
- Solid average sales per customer at ₹11.6k

> These cities were selected based on a combination of revenue potential, customer volume, and cost efficiency (rent per customer). Lower rent per customer with higher sales indicates strong unit economics for a new location.

---
