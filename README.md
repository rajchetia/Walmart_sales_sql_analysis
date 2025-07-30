🛒 Walmart Sales Data Analysis (SQL)

This project involves cleaning and analyzing Walmart sales data using SQL. It demonstrates how to inspect schema, clean price and quantity fields, and handle missing data for reliable reporting.

📂 Dataset Assumptions
- Table: 'Walmart'
- Fields: 'unit_price', 'quantity', and others

🧹 Data Cleaning Steps
- Removed '$' from unit prices
- Converted 'unit_price' to decimal
- Removed rows with missing 'unit_price' or 'quantity'
- Checked data types using 'INFORMATION_SCHEMA.COLUMNS'

🛠 Tools Used
- SQL Server / MySQL
- Git & GitHub for versioning

📁 Files Included
- 'Walmart_Cleaning.sql' - script for data cleanin
- 'Walmart_analysis.sql' - script for insight analysis

📈 Next Steps
- Add aggregation queries (e.g., total sales, best-selling categories)
- Visualization with Tableau 
