# CSV Datasets Information

## Overview
This document outlines the structure of the CSV datasets used in the Coffee Sales Analysis project. It includes information about the different tables, their relationships, and foreign keys.

## Datasets

### 1. Sales Data
- **Table Name**: sales
- **Description**: Contains records of sales transactions.
- **Columns**:
  - `transaction_id`: Unique identifier for each transaction (Primary Key)
  - `product_id`: References the product sold (Foreign Key)
  - `quantity`: Number of items sold
  - `sale_date`: Date of the transaction

### 2. Products Data
- **Table Name**: products
- **Description**: Detailed information about products available for sale.
- **Columns**:
  - `product_id`: Unique identifier for each product (Primary Key)
  - `product_name`: Name of the product
  - `category`: Category of the product

### 3. Customers Data
- **Table Name**: customers
- **Description**: Information about customers.
- **Columns**:
  - `customer_id`: Unique identifier for each customer (Primary Key)
  - `customer_name`: Name of the customer

## Relationships
- The `sales` table has a many-to-one relationship with the `products` table based on `product_id`.
- The `sales` table may also have a many-to-one relationship with the `customers` table based on `customer_id` if that column is added.

## Foreign Keys
- `product_id` in the `sales` table is a foreign key that references `product_id` in the `products` table.

This documentation should help users understand the structure and connections between the datasets used in the Coffee Sales Analysis project.