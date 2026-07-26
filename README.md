# Google Merchandise Store Sales Customer Analytics

## Project Background

This project analyzes transactional data from an e-commerce company to evaluate sales performance, product contribution, market performance, and customer behavior. The dataset contains historical transaction records covering product categories, product-level sales, customer purchases, geographic markets, order activity, and promotional information.

The analysis aims to understand the key factors influencing revenue performance and customer value, while identifying opportunities to improve sales, increase basket value, and strengthen customer retention.

The project focuses on three key areas:

- **Business Performance**: Analyze revenue trends, order volume, AOV, seasonality, and performance across key markets to identify major drivers and periods of growth or decline.

- **Product Performance**: Evaluate revenue contribution across product categories and individual products, identify high-value and high-volume products, and uncover cross-selling opportunities through association analysis.

- **Customer Analytics**: Analyze customer lifecycle and retention patterns, apply RFM segmentation to assess customer value and health, and identify opportunities to retain high-value customers and reactivate at-risk or lost customers.

The analysis leverages **Power Query**, **PivotTables**, and **Power Pivot** in **Microsoft Excel**, alongside **RFM segmentation** and **Association Rule Mining** in **R**, to transform raw transactional data into actionable business insights and strategic recommendations.

**Data Source:** [Marketing Insights for E-Commerce Company — Kaggle](https://www.kaggle.com/datasets/rishikumarrajvansh/marketing-insights-for-e-commerce-company)

## Data Structure & Initial Checks
The dataset consists of three tables: *Online_Sales*, *CustomersData*, and *Discount_Coupon*, with the Online_Sales table containing approximately **52,924** transaction records.

Before analysis, the data structure and potential relationships between the tables were reviewed, and initial data quality checks were performed using **Power Query**. These checks covered missing values, duplicate records, inconsistent data formats, and potential data integrity issues.

A key data integration challenge was identified between the *Online_Sales* and *Discount_Coupon* tables. The two tables did not initially share a common key: *Online_Sales* did not contain a Product_Coupon_ID field, while Discount_Coupon did not have a direct identifier that could be used to establish a relationship with sales transactions. To enable the integration of relevant promotional information, a derived Product_Coupon_ID was created by concatenating Month and Product_Category in both tables.

The resulting table structure and the derived Product_Coupon_ID used for data integration are illustrated below:

<p align="center">
  <img src="./assets/Data.svg" alt="Database Schema" width="60%">
</p>

Although this approach established a potential link between the two tables, maintaining the relationship through a formal relational model required additional transformations and introduced unnecessary complexity. Therefore, relevant fields from the supporting tables were instead integrated into the main *Online_Sales* dataset using **VLOOKUP** and **XLOOKUP** in **Microsoft Excel**. This resulted in a consolidated dataset containing the sales, customer, and promotional information required for subsequent analysis.

## Business Performance Overview

The analysis begins by assessing overall business performance across time, markets, and product categories to identify the primary drivers of revenue and areas requiring further investigation.

### Monthly Revenue Trends

!
