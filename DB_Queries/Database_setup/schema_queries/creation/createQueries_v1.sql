-- ===============================
-- Food Ordering System Schema
-- With Cart
-- ===============================

create DATABASE Food_ordering_system;
use Food_ordering_system;
-- Admins
CREATE TABLE Admins (
    admin_id BIGINT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(20),
    password_hash NVARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Restaurants
CREATE TABLE Restaurants (
    restaurant_id BIGINT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(20),
    password_hash NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    address NVARCHAR(255),
    city NVARCHAR(100),
    state NVARCHAR(100),
    zipcode NVARCHAR(20),
    rating DECIMAL(2,1),
    created_at DATETIME DEFAULT GETDATE()
);

-- Customers
CREATE TABLE Customers (
    customer_id BIGINT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(20),
    password_hash NVARCHAR(255) NOT NULL,
    address NVARCHAR(255),
    city NVARCHAR(100),
    state NVARCHAR(100),
    zipcode NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE()
);

-- Menu Categories
CREATE TABLE MenuCategories (
    category_id BIGINT PRIMARY KEY IDENTITY(1,1),
    restaurant_id BIGINT NOT NULL FOREIGN KEY REFERENCES Restaurants(restaurant_id),
    name NVARCHAR(100) NOT NULL
);

-- Menu Items
CREATE TABLE MenuItems (
    item_id BIGINT PRIMARY KEY IDENTITY(1,1),
    category_id BIGINT NOT NULL FOREIGN KEY REFERENCES MenuCategories(category_id),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    is_available BIT DEFAULT 1,
    image_url NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);

-- Cart (one active cart per customer at a time)
CREATE TABLE Carts (
    cart_id BIGINT PRIMARY KEY IDENTITY(1,1),
    customer_id BIGINT NOT NULL FOREIGN KEY REFERENCES Customers(customer_id),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Cart Items
CREATE TABLE CartItems (
    cart_item_id BIGINT PRIMARY KEY IDENTITY(1,1),
    cart_id BIGINT NOT NULL FOREIGN KEY REFERENCES Carts(cart_id),
    item_id BIGINT NOT NULL FOREIGN KEY REFERENCES MenuItems(item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL
);

-- Orders
CREATE TABLE Orders (
    order_id BIGINT PRIMARY KEY IDENTITY(1,1),
    customer_id BIGINT NOT NULL FOREIGN KEY REFERENCES Customers(customer_id),
    restaurant_id BIGINT NOT NULL FOREIGN KEY REFERENCES Restaurants(restaurant_id),
    status NVARCHAR(20) CHECK (status IN ('pending','confirmed','preparing','out_for_delivery','delivered','cancelled')) DEFAULT 'pending',
    total_amount DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Order Items
CREATE TABLE OrderItems (
    order_item_id BIGINT PRIMARY KEY IDENTITY(1,1),
    order_id BIGINT NOT NULL FOREIGN KEY REFERENCES Orders(order_id),
    item_id BIGINT NOT NULL FOREIGN KEY REFERENCES MenuItems(item_id),
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Payments
CREATE TABLE Payments (
    payment_id BIGINT PRIMARY KEY IDENTITY(1,1),
    order_id BIGINT NOT NULL FOREIGN KEY REFERENCES Orders(order_id),
    amount DECIMAL(10,2) NOT NULL,
    method NVARCHAR(20) CHECK (method IN ('card','upi','cod','wallet')),
    status NVARCHAR(20) CHECK (status IN ('pending','completed','failed')) DEFAULT 'pending',
    transaction_id NVARCHAR(100),
    created_at DATETIME DEFAULT GETDATE()
);

-- Reviews
CREATE TABLE Reviews (
    review_id BIGINT PRIMARY KEY IDENTITY(1,1),
    customer_id BIGINT NOT NULL FOREIGN KEY REFERENCES Customers(customer_id),
    restaurant_id BIGINT NOT NULL FOREIGN KEY REFERENCES Restaurants(restaurant_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);
