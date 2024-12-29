create database FastFoodRestaurantDB
go
use FastFoodRestaurantDB

-- Users Table
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Mobile NVARCHAR(15) NULL,
    Email NVARCHAR(50) UNIQUE NOT NULL,
    Address NVARCHAR(MAX) NULL,
    PostCode NVARCHAR(10) NULL,
    Password NVARCHAR(255) NOT NULL, -- For encrypted passwords
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Contact Table
CREATE TABLE Contact (
    ContactId INT IDENTITY(1,1) PRIMARY KEY,
	UserId INT,
    Subject NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
	CONSTRAINT FK_Contact_Users FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE
);

-- Payment Table
CREATE TABLE Payment (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    UserId int unique,
    CardNo NVARCHAR(16) NOT NULL,
    ExpiryDate NVARCHAR(5) NOT NULL,
    CvvNo INT NOT NULL,
    PaymentMode NVARCHAR(20) NOT NULL,
	CONSTRAINT FK_Payment_Users FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE
);
-- Categories Table
CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Products Table
CREATE TABLE Products (
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Price DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    CategoryId INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId) ON DELETE CASCADE
);

-- Carts Table
CREATE TABLE Carts (
    CartId INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UserId INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Carts_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE,
    CONSTRAINT FK_Carts_Users FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE
);


-- Orders Table
CREATE TABLE Orders (
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    OrderNo NVARCHAR(20) NOT NULL,
    UserId INT NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending',
    PaymentId INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Orders_Payment FOREIGN KEY (PaymentId) REFERENCES Payment(PaymentId) 
);

--Order_Product table
--many to many relationship
CREATE TABLE OrderDetails (
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderId, ProductId), -- Composite Key
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE
);
 

