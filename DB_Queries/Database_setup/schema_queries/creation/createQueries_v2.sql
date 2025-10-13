DROP DATABASE IF EXISTS Food_ordering_system;

use master;


create DATABASE Food_ordering_system;
use Food_ordering_system;


-- Create Schema
go
CREATE SCHEMA FoodOrderingSystem;

GO

---------------------------------------------------
-- USERS (Admin / Customer / RestaurantOwner)
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,      -- NVARCHAR: user names may contain Unicode (हिंदी, 中文, emojis)
    Email VARCHAR(100) UNIQUE NOT NULL,   -- VARCHAR: email addresses are always ASCII
    Phone VARCHAR(15),                    -- VARCHAR: phone numbers contain only digits/symbols
    PasswordHash VARBINARY(256) NOT NULL, -- Store hashed password (binary)
    PasswordSalt VARBINARY(256) NOT NULL, -- Store salt (binary)
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Admin','Customer','RestaurantOwner')), -- VARCHAR: fixed set of ASCII values
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

---------------------------------------------------
-- STATES MASTER
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.States (
    StateId INT PRIMARY KEY IDENTITY(1,1),
    StateName NVARCHAR(100) NOT NULL UNIQUE, -- NVARCHAR: state names may include non-English characters
    IsActive BIT DEFAULT 1
);

---------------------------------------------------
-- CITIES MASTER
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Cities (
    CityId INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(100) NOT NULL,         -- NVARCHAR: city names may be multilingual
    StateId INT NOT NULL,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (StateId) REFERENCES FoodOrderingSystem.States(StateId)
);

---------------------------------------------------
-- RESTAURANTS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.Restaurants (
    RestaurantId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL, -- FK to Users (Owner)
    Name NVARCHAR(150) NOT NULL,       -- NVARCHAR: restaurant names may contain Unicode
    Description NVARCHAR(300),         -- NVARCHAR: descriptions can be multilingual
    Address NVARCHAR(300),             -- NVARCHAR: full addresses may have Unicode
    CityId INT NOT NULL,
    StateId INT NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pending','Approved','Rejected')), -- VARCHAR: controlled status values
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
    Name NVARCHAR(100) NOT NULL,  -- NVARCHAR: category names can be multilingual (e.g., "पिज्जा")
    FOREIGN KEY (RestaurantId) REFERENCES FoodOrderingSystem.Restaurants(RestaurantId)
);

---------------------------------------------------
-- MENU ITEMS
---------------------------------------------------
CREATE TABLE FoodOrderingSystem.MenuItems (
    MenuItemId INT PRIMARY KEY IDENTITY(1,1),
    CategoryId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,        -- NVARCHAR: dish names can be multilingual
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
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pending','Confirmed','Preparing','OutForDelivery','Delivered','Cancelled')), -- VARCHAR: predefined status
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

