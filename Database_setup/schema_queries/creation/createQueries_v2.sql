DROP DATABASE IF EXISTS Food_ordering_system;

use master;


create DATABASE Food_ordering_system;
use Food_ordering_system;

-- Create Schema
CREATE SCHEMA FoodOrderingSystem;

GO

---------------------------------------------------
-- USERS (Master table for all roles)
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,      -- NVARCHAR: supports multilingual names
    Email VARCHAR(100) UNIQUE NOT NULL,   -- VARCHAR: emails are ASCII only
    Phone VARCHAR(15),                    -- VARCHAR: digits/symbols only
    PasswordHash VARBINARY(256) NOT NULL, -- VARBINARY: binary hash
    PasswordSalt VARBINARY(256) NOT NULL, -- VARBINARY: salt bytes
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Admin','Customer','RestaurantOwner')), -- controlled ASCII values
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

---------------------------------------------------
-- ADMINS (optional extra info for admins)
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Admins (
    AdminId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT UNIQUE NOT NULL,           -- FK to Users
    -- Add admin-specific fields here if needed
    FOREIGN KEY (UserId) REFERENCES FoodOrderingSystem.Users(UserId)
);

---------------------------------------------------
-- CUSTOMERS (optional extra info for customers)
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Customers (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT UNIQUE NOT NULL,           -- FK to Users
    -- Add customer-specific fields here (loyalty points, preferences, etc.)
    FOREIGN KEY (UserId) REFERENCES FoodOrderingSystem.Users(UserId)
);

---------------------------------------------------
-- STATES MASTER
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.States (
    StateId INT PRIMARY KEY IDENTITY(1,1),
    StateName NVARCHAR(100) NOT NULL UNIQUE, -- NVARCHAR: supports multilingual
    IsActive BIT DEFAULT 1
);

---------------------------------------------------
-- CITIES MASTER
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Cities (
    CityId INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(100) NOT NULL,         -- NVARCHAR: multilingual city names
    StateId INT NOT NULL,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (StateId) REFERENCES FoodOrderingSystem.States(StateId)
);

---------------------------------------------------
-- RESTAURANTS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Restaurants (
    RestaurantId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT UNIQUE NOT NULL,             -- FK to Users (Owner)
    Name NVARCHAR(150) NOT NULL,            -- NVARCHAR: restaurant names may contain Unicode
    Description NVARCHAR(300),              -- NVARCHAR: description can be multilingual
    Address NVARCHAR(300),                  -- NVARCHAR: free-text address
    CityId INT NOT NULL,
    StateId INT NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pending','Approved','Rejected')), -- controlled ASCII values
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES FoodOrderingSystem.Users(UserId),
    FOREIGN KEY (CityId) REFERENCES FoodOrderingSystem.Cities(CityId),
    FOREIGN KEY (StateId) REFERENCES FoodOrderingSystem.States(StateId)
);

---------------------------------------------------
-- ADDRESSES (Customer Delivery Address)
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Addresses (
    AddressId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,
    AddressLine NVARCHAR(300),  -- NVARCHAR: free-text user address
    CityId INT NOT NULL,
    StateId INT NOT NULL,
    IsDefault BIT DEFAULT 0,
    FOREIGN KEY (UserId) REFERENCES FoodOrderingSystem.Users(UserId),
    FOREIGN KEY (CityId) REFERENCES FoodOrderingSystem.Cities(CityId),
    FOREIGN KEY (StateId) REFERENCES FoodOrderingSystem.States(StateId)
);

---------------------------------------------------
-- MENU CATEGORIES
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.MenuCategories (
    CategoryId INT PRIMARY KEY IDENTITY(1,1),
    RestaurantId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,  -- NVARCHAR: category names can be multilingual
    FOREIGN KEY (RestaurantId) REFERENCES FoodOrderingSystem.Restaurants(RestaurantId)
);

---------------------------------------------------
-- MENU ITEMS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.MenuItems (
    MenuItemId INT PRIMARY KEY IDENTITY(1,1),
    CategoryId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,        -- NVARCHAR: dish names may be multilingual
    Description NVARCHAR(300),          -- NVARCHAR: detailed description may use Unicode
    Price DECIMAL(10,2) NOT NULL,
    IsAvailable BIT DEFAULT 1,
    FOREIGN KEY (CategoryId) REFERENCES FoodOrderingSystem.MenuCategories(CategoryId)
);

---------------------------------------------------
-- CART
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Carts (
    CartId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES FoodOrderingSystem.Users(UserId)
);

---------------------------------------------------
-- CART ITEMS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.CartItems (
    CartItemId INT PRIMARY KEY IDENTITY(1,1),
    CartId INT NOT NULL,
    MenuItemId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (CartId) REFERENCES FoodOrderingSystem.Carts(CartId),
    FOREIGN KEY (MenuItemId) REFERENCES FoodOrderingSystem.MenuItems(MenuItemId)
);

---------------------------------------------------
-- ORDERS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Orders (
    OrderId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL, -- Customer
    RestaurantId INT NOT NULL,
    AddressId INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pending','Confirmed','Preparing','OutForDelivery','Delivered','Cancelled')), -- controlled ASCII values
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES FoodOrderingSystem.Users(UserId),
    FOREIGN KEY (RestaurantId) REFERENCES FoodOrderingSystem.Restaurants(RestaurantId),
    FOREIGN KEY (AddressId) REFERENCES FoodOrderingSystem.Addresses(AddressId)
);

---------------------------------------------------
-- ORDER ITEMS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.OrderItems (
    OrderItemId INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT NOT NULL,
    MenuItemId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL, -- Snapshot at order time
    FOREIGN KEY (OrderId) REFERENCES FoodOrderingSystem.Orders(OrderId),
    FOREIGN KEY (MenuItemId) REFERENCES FoodOrderingSystem.MenuItems(MenuItemId)
);

---------------------------------------------------
-- REVIEWS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Reviews (
    ReviewId INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT NOT NULL,                      -- FK to Customers table
    RestaurantId INT NOT NULL,                    -- FK to Restaurants table
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5), -- rating 1-5
    Comment NVARCHAR(500),                        -- NVARCHAR: multilingual user comment
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerId) REFERENCES FoodOrderingSystem.Customers(CustomerId),
    FOREIGN KEY (RestaurantId) REFERENCES FoodOrderingSystem.Restaurants(RestaurantId)
);
