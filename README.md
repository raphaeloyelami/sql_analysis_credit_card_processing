# sql_credit_card_processing_analysis

![Alt text](https://www.firstcitizens.com/content/dam/firstcitizens/images/resources/commercial/credit/credit-card-processing-fees@2x.jpg.transform/image-scaled-2x-to-1x/image.20220407.jpeg)

This repository contains SQL queries for analyzing customer and transaction data for a credit card processing company. It uses advanced SQL techniques like window functions, CASE statements, and stored procedures to address business problems related to demographics, card usage, and transaction trends. Data is for educational purposes.

## Prerequisites

- [PostgreSQL](https://www.postgresql.org/download/)

### Project Objective:

As a data analyst at a credit card processing company, the goal of this project is to analyze financial and customer behavior data to uncover key insights and trends that can drive business decisions. By leveraging advanced SQL techniques such as window functions, CASE statements, CTEs (Common Table Expressions), intervals, COALESCE, temporary tables, and stored procedures, we aim to address a range of business problems related to customer demographics, transaction patterns, card usage, and overall performance across different regions.

### Problem and Purpose:

The purpose of this project is to gain a deeper understanding of customer behavior, transaction trends, and country-wise distribution. The key objectives are to:

1. **Understand customer demographics and rank countries** based on the number of customers, helping the company identify regions with high customer acquisition.
2. **Analyze card usage patterns** in different countries to identify the most popular card types and target areas for further product promotion.
3. **Examine transaction patterns over time**, such as monthly totals or year-over-year growth, to assess the performance and detect any significant shifts in customer spending behavior.
4. **Identify top customers** based on transaction values and determine their country of origin, helping to tailor marketing efforts.
5. **Categorize customers** based on transaction frequency to identify frequent, occasional, or infrequent users, enabling personalized customer outreach.
6. **Generate transaction statistics** at a country level and use that data for further strategic analysis or decision-making.

### Data Overview:

The analysis is performed on a simulated database with five main tables:

1. **country**: Contains information about countries with columns `id` (PK) and `country_name`.
2. **card_type**: Holds data about different card types with columns `id` (PK) and `card_type_name`.
3. **customer**: Includes customer details, with columns `id` (PK), `NIN`, `first_name`, `last_name`, and `country_id` (FK referencing `country.id`).
4. **card_number**: Contains the card details with columns `id` (PK), `card_number`, `customer_id` (FK referencing `customer.id`), and `card_type_id` (FK referencing `card_type.id`).
5. **card_transaction**: Stores transaction information with columns `id` (PK), `date`, `amount`, and `card_number_id` (FK referencing `card_number.id`).

### Important Notes:

- The data used for analysis is **simulated for educational purposes** and does not represent any real-world transactions or customer information.
- The SQL queries presented in this project aim to demonstrate how advanced SQL techniques can be applied to solve business problems related to financial data analysis.
  
The ultimate goal of this project is to provide actionable insights that will help the credit card processing company better understand its customer base, improve its marketing strategies, and optimize its operations based on data-driven decisions.
