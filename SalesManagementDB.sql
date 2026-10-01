-- Sales Management System - database script
-- Run this on (localdb)\MSSQLLocalDB to create the database, tables and sample data.

IF DB_ID('SalesManagementDB') IS NULL
    CREATE DATABASE SalesManagementDB;
GO

USE SalesManagementDB;
GO

-- Products table
IF OBJECT_ID('dbo.Products', 'U') IS NULL
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Category    NVARCHAR(100),
    Price       DECIMAL(10,2) NOT NULL,
    Stock       INT NOT NULL,
    Supplier    NVARCHAR(100),
    Status      NVARCHAR(50)
);
GO

-- Customers table
IF OBJECT_ID('dbo.Customers', 'U') IS NULL
CREATE TABLE Customers (
    CustomerID   INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100) NOT NULL,
    Phone        NVARCHAR(20),
    Email        NVARCHAR(100),
    Address      NVARCHAR(250)
);
GO

-- Sales table (with foreign keys)
IF OBJECT_ID('dbo.Sales', 'U') IS NULL
CREATE TABLE Sales (
    SaleID      INT PRIMARY KEY IDENTITY(1,1),
    CustomerID  INT NOT NULL,
    ProductID   INT NOT NULL,
    Quantity    INT NOT NULL,
    UnitPrice   DECIMAL(10,2) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    SaleDate    DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Sales_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Sales_Products  FOREIGN KEY (ProductID)  REFERENCES Products(ProductID)
);
GO

-- Sample products (only if table is empty)
IF NOT EXISTS (SELECT 1 FROM Products)
INSERT INTO Products (ProductName, Category, Price, Stock, Supplier, Status) VALUES
('Laptop',         'Electronics', 45000.00, 10,  'Tech World',  'Active'),
('Wireless Mouse', 'Accessories',   599.00, 50,  'Digital Hub', 'Active'),
('Keyboard',       'Accessories',   899.00, 30,  'Digital Hub', 'Active'),
('Notebook',       'Stationery',     60.00, 200, 'Paper Mart',  'Active'),
('Pen Pack',       'Stationery',    120.00, 3,   'Paper Mart',  'Active'),
('Headphones',     'Electronics',  1499.00, 15,  'Tech World',  'Active');
GO

-- Sample customers (only if table is empty)
IF NOT EXISTS (SELECT 1 FROM Customers)
INSERT INTO Customers (CustomerName, Phone, Email, Address) VALUES
('Arun Kumar', '9876543210', 'arun@example.com',    'Trichy, Tamil Nadu'),
('Priya S',    '9123456780', 'priya@example.com',   'Thanjavur, Tamil Nadu'),
('Karthik R',  '9988776655', 'karthik@example.com', 'Madurai, Tamil Nadu'),
('Divya M',    '9090909090', 'divya@example.com',   'Coimbatore, Tamil Nadu');
GO