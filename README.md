# Sales Management System

A web application to manage products, customers, sales and reports for a small business.
Built as a college Innovation Mark project.

## Features
- Login with session-based access control
- Dashboard with total products, customers, sales, revenue, recent sales and low stock alerts
- Product management (add, update, delete, search)
- Customer management (add, update, delete, search)
- Sales entry with automatic total calculation and stock reduction (SQL transaction)
- Sales history with search by customer and date
- Reports with top-selling products, daily sales report and revenue chart

## Tech Stack
- ASP.NET Web Forms (.NET Framework 4.8), C#
- SQL Server LocalDB, ADO.NET
- Bootstrap 5

## How to Run
1. Clone the repository and open the solution in Visual Studio 2022.
2. Run `SalesManagementDB.sql` on `(localdb)\MSSQLLocalDB` to create the database, tables and sample data.
3. Press F5 to run the project.
4. Login with username `admin` and password `admin123`.

## Modules
Login, Dashboard, Products, Customers, Sales, Sales History, Reports
