use FastFoodRestaurantDB

--product and categories
------------------------------------------------
--1. search product by first letter
--table valued function 
CREATE FUNCTION fnGetNameFirstLitter (@firstLitter varchar(1))
RETURNS table
AS
RETURN
(
SELECT  Name ,Description ,Price
FROM Products
where Name like @firstLitter + '%'
)
select * from dbo.fnGetNameFirstLitter('C');


-----------------------------------------------------------------------------------

--2. search product by fullname
--single valued function 
CREATE  FUNCTION fnGetProductFullName(@fullname nvarchar(50))
RETURNS varchar(50)
BEGIN
DECLARE @description varchar(50)
SELECT @description = Description 
FROM Products
WHERE LOWER(Name) = LOWER(@fullname);
RETURN @description
END

select dbo.fnGetProductFullName('Loaded Fries')
select dbo.fnGetProductFullName('wrong data')

--------------------------------------------------------------------------------------------

--3. show products from certain category
--table valued function
CREATE FUNCTION fnGetCategoryMeals (@categoryName varchar(50))
RETURNS TABLE
AS
RETURN
(
    SELECT p.Name AS productName, p.Price
    FROM Categories AS c
    JOIN Products AS p ON c.CategoryId = p.CategoryId
    WHERE c.Name = CASE
                    WHEN @categoryName = 'all' THEN c.Name
                    ELSE @categoryName
                   END
);

select * from dbo.fnGetCategoryMeals('All');
select * from dbo.fnGetCategoryMeals('pizza');
select * from dbo.fnGetCategoryMeals('Burger');
select * from dbo.fnGetCategoryMeals('pasta');
select * from dbo.fnGetCategoryMeals('Fries');
select * from dbo.fnGetCategoryMeals('Drinks');

------------------------------------------------------------------------------------

--5. sort 
--table valued function
select name , price from products 
order by price asc

--------------------------------------------------------------------------------------------

--6. View all products in a specific category(Burger):
SELECT 
    P.Name AS ProductName, 
    P.Price, 
    P.Quantity, 
    C.Name AS CategoryName 
FROM Products P INNER JOIN Categories C 
ON P.CategoryId = C.CategoryId
WHERE C.Name = 'Burger';

-------------------------------------------------------------------------------------

--7. Get total orders for each user:

SELECT 
    U.Name AS UserName, 
    COUNT(O.OrderId) AS TotalOrders
FROM Users U LEFT JOIN Orders O 
ON U.UserId = O.UserId
GROUP BY U.Name;

----------------------------------------------------------------------------------------
--8. List all orders along with payment details:
SELECT 
    O.OrderId,
    O.OrderNo,
    O.UserId,
    O.Status AS OrderStatus,
    O.OrderDate,
    P.PaymentId,
    P.CardNo,
    P.ExpiryDate,
    P.CvvNo,
    P.PaymentMode
FROM Orders O JOIN Payment P 
ON O.PaymentId = P.PaymentId;

----------------------------------------------------------------------------------------

--9. Get the most popular product (based on order quantity)

SELECT Top 1
    P.ProductId,
    P.Name AS ProductName,
    SUM(OD.Quantity) AS TotalQuantityOrdered
FROM OrderDetails OD JOIN Products P 
ON OD.ProductId = P.ProductId
GROUP BY P.ProductId, P.Name
ORDER BY TotalQuantityOrdered DESC;

---------------------------------------------------------------------------------------
--10. Revenue(الربح)generated from each product:

SELECT 
    P.Name AS ProductName, 
    SUM(OD.Quantity * P.Price) AS Revenue 
FROM OrderDetails OD INNER JOIN Products P 
ON OD.ProductId = P.ProductId
GROUP BY P.Name
ORDER BY Revenue DESC;

--another way with function
-- Creating a scalar function to calculate total revenue for a product
CREATE FUNCTION dbo.fn_CalculateTotalRevenue (@ProductId INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(18,2);
    
    SELECT @TotalRevenue = SUM(OD.Quantity * P.Price)
    FROM OrderDetails OD INNER JOIN Products P 
	ON OD.ProductId = P.ProductId
    WHERE P.ProductId = @ProductId;
    
    RETURN @TotalRevenue;
END;
GO

-- Usage of the function to get total revenue for a specific product
SELECT 
    P.Name AS ProductName,
    dbo.fn_CalculateTotalRevenue(P.ProductId) AS TotalRevenue
FROM Products P;

-----------------------------------------------------------------------------------------

--11. Display cart details for a specific user(johndoe):

SELECT 
    U.Name AS UserName, 
    P.Name AS ProductName, 
    C.Quantity, 
    P.Price, 
    (C.Quantity * P.Price) AS TotalCost
FROM Carts C INNER JOIN Users U 
ON C.UserId = U.UserId INNER JOIN Products P 
ON C.ProductId = P.ProductId
WHERE U.Username = 'johndoe';

------------------------------------------------------------------------------------
--12. Orders placed in the last week:
SELECT 
    O.OrderId,
    O.OrderNo,
    O.UserId,
    O.Status,
    O.OrderDate,
    P.PaymentMode
FROM Orders O JOIN Payment P 
ON O.PaymentId = P.PaymentId
WHERE O.OrderDate >= DATEADD(WEEK, -1, GETDATE())
ORDER BY O.OrderDate DESC;

--------------------------------------------------------------------------------------
-- 13. Find users who ordered a specific product (e.g., "Cheeseburger"):

SELECT DISTINCT 
    U.UserId,
    U.Name,
    U.Email,
    O.OrderId,
    O.OrderNo,
    O.Status,
    O.OrderDate
FROM Users U JOIN Orders O 
ON U.UserId = O.UserId JOIN OrderDetails OD 
ON O.OrderId = OD.OrderId JOIN Products P 
ON OD.ProductId = P.ProductId
WHERE P.Name = 'Cheeseburger'
ORDER BY O.OrderDate DESC;


-----------------------------------------------------------------------------------------

--.15 Format the Date of Order into a More Readable Format

SELECT 
    O.OrderNo,
    FORMAT(O.OrderDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedOrderDate
FROM Orders O;

------------------------------------------------------------------------------------------
--16.Get Orders Placed Within a Specific Date Range Using a Function
-- Creating a function to get orders within a specific date range
CREATE FUNCTION dbo.fn_GetOrdersByDateRange (@StartDate DATETIME, @EndDate DATETIME)
RETURNS TABLE
AS
RETURN
    SELECT 
        O.OrderId,
        O.OrderNo,
        O.OrderDate,
        O.Status
    FROM Orders O
    WHERE O.OrderDate BETWEEN @StartDate AND @EndDate;
GO

-- Usage of the function to get orders placed in the last 30 days
SELECT * 
FROM dbo.fn_GetOrdersByDateRange(DATEADD(DAY, -30, GETDATE()), GETDATE());

--------------------------------------------------------------------------------------------
--17. the cheapest product
SELECT TOP 1 Name, Price 
FROM Products 
ORDER BY Price ASC;

---------------------------------------------------------------------------------------------
--18. the last 5 products added 
SELECT TOP 5 
    Name AS ProductName,
    CreatedDate
FROM Products
ORDER BY CreatedDate DESC;

-----------------------------------------------------------------------------------------------
-- 19.AVARGE PRICE For Each category
SELECT C.Name AS CategoryName, AVG(P.Price) AS AvgPrice
FROM Products P
JOIN Categories C ON P.CategoryId = C.CategoryId
GROUP BY C.Name;

--------------------------------------------------------------------------------------------
-- 20.the total amout of money that users pay 
SELECT 
    o.UserId,
    SUM(od.Quantity * p.Price) AS TotalAmountPaid
FROM Orders o JOIN OrderDetails od 
ON o.OrderId = od.OrderId JOIN Products p 
ON od.ProductId = p.ProductId
GROUP BY o.UserId
ORDER BY TotalAmountPaid DESC;

-------------------------------------------------------------------------------
-- 21. update the price of product
UPDATE Products
SET Price = Price * 1.10 -- زيادة السعر بنسبة 10%
WHERE ProductId = 1;

-------------------------------------------------------------------------------
--1. Stored Procedures
--a. Stored Procedure to Place an Order:

CREATE PROCEDURE PlaceOrder
    @UserId INT,
    @OrderNo NVARCHAR(20),
    @PaymentId INT,
    @ProductId INT,
    @Quantity INT
AS
BEGIN
    -- Insert into Orders table
    DECLARE @OrderId INT;
    INSERT INTO Orders (OrderNo, UserId, Status, PaymentId, OrderDate)
    VALUES (@OrderNo, @UserId, 'Pending', @PaymentId, GETDATE());
    
    SET @OrderId = SCOPE_IDENTITY();  -- Get the inserted OrderId

    -- Insert into OrderDetails table
    INSERT INTO OrderDetails (OrderId, ProductId, Quantity)
    VALUES (@OrderId, @ProductId, @Quantity);

    -- The product stock will be handled by a trigger
    SELECT 'Order Placed Successfully' AS Status, @OrderId AS OrderId;
END;

EXEC PlaceOrder  1,  'ORD1001',  1,  2,  3;


----------------------------------------------------------------------------------------

--b. Stored Procedure to Retrieve Order Details:
CREATE PROCEDURE GetOrderDetails
    @OrderId INT
AS
BEGIN
    SELECT o.OrderId, o.OrderNo, o.UserId, o.Status, o.OrderDate, 
           p.Name AS ProductName, od.Quantity
    FROM Orders o JOIN OrderDetails od 
	ON o.OrderId = od.OrderId JOIN Products p 
	ON od.ProductId = p.ProductId
    WHERE o.OrderId = @OrderId;
END;

EXEC GetOrderDetails @OrderId = 1;

--------------------------------------------------------------------------------
--c. Stored Procedure to Cancel an Order
CREATE PROCEDURE CancelOrder
    @OrderId INT
AS
BEGIN
    -- Check if the order is already shipped or completed
    DECLARE @OrderStatus NVARCHAR(50);
    SELECT @OrderStatus = Status FROM Orders WHERE OrderId = @OrderId;

    IF @OrderStatus IN ('Shipped', 'Completed')
    BEGIN
        SELECT 'Cannot cancel an order that has already been shipped or completed' AS Status;
    END
    ELSE
    BEGIN
        -- Update the order status to "Cancelled"
        UPDATE Orders
        SET Status = 'Cancelled'
        WHERE OrderId = @OrderId;

        SELECT 'Order cancelled successfully' AS Status;
    END
END;

EXEC CancelOrder @OrderId = 2;

-----------------------------------------------------------------------------
--d. Stored Procedure to Update Product Price
CREATE PROCEDURE UpdateProductPrice
    @ProductId INT,
    @NewPrice DECIMAL(18,2)
AS
BEGIN
    -- Check if the product exists
    IF EXISTS (SELECT 1 FROM Products WHERE ProductId = @ProductId)
    BEGIN
        -- Update the product price
        UPDATE Products
        SET Price = @NewPrice
        WHERE ProductId = @ProductId;

        PRINT 'Product price updated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Product not found.';
    END
END;

EXEC UpdateProductPrice  1,  150.99;

--------------------------------------------------------------------

----------------------------------------------------------------------
--2. Triggers
---1. Trigger to Update Product Stock After an Order is Placed:

CREATE TRIGGER UpdateProductStockAfterOrder
ON OrderDetails
AFTER INSERT
AS
BEGIN
    DECLARE @ProductId INT, @Quantity INT;
    SELECT @ProductId = ProductId, @Quantity = Quantity FROM inserted;
    
    -- Update the stock quantity of the product
    UPDATE Products
    SET Quantity = Quantity - @Quantity
    WHERE ProductId = @ProductId;
    
END;


--------------------------------------------------------------------
--2. Trigger: Update Order Status Automatically
CREATE TRIGGER AutoCompleteOrder
ON Payment
AFTER INSERT
AS
BEGIN
    UPDATE Orders
    SET Status = 'Completed'
    WHERE OrderId IN (SELECT OrderId FROM inserted);

    PRINT 'Order status updated to Completed!';
END;

--------------------------------------------------------------
---3. Log Deleted Products
CREATE TABLE ProductDeletionLog (
    ProductId INT,
    Name NVARCHAR(50),
    DeletionDate DATETIME
);

CREATE TRIGGER LogDeletedProducts
ON Products
AFTER DELETE
AS
BEGIN
    INSERT INTO ProductDeletionLog (ProductId, Name, DeletionDate)
    SELECT ProductId, Name, GETDATE()
    FROM deleted;

    PRINT 'Deleted product logged successfully!';
END;

--------------------------------------------------------------------
--4.Send Notification for Low Stock
-- Create LowStockAlerts table
CREATE TABLE LowStockAlerts (
    AlertId INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT,
    Quantity INT,
    AlertDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_LowStockAlerts_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);

-- Trigger to log low stock
CREATE TRIGGER trg_LowStockAlert
ON Products
AFTER UPDATE
AS
BEGIN
    DECLARE @ProductId INT, @Quantity INT;

    SELECT @ProductId = ProductId, @Quantity = Quantity FROM inserted;

    -- Check if stock is below threshold (e.g., 10 units)
    IF @Quantity <= 10
    BEGIN
        -- Insert low stock alert
        INSERT INTO LowStockAlerts (ProductId, Quantity)
        VALUES (@ProductId, @Quantity);
    END
END;

-----------------------------------------------------------------------------------------
-- 22. select users messages
select name , email , subject , message from Users U
inner join Contact C on U.UserId =C.UserId 

---------------------------------------------------------------------------------
-- 23. select users payment Info
select name , address ,CardNo , PaymentMode from Users U
inner join Payment P on U.UserId =P.UserId 
----------------------------------------------------------------------------
-- 24. select orderdetails
select   O.orderNo, p.name , OD.quantity , p.price from products p 
join orderDetails OD on p.ProductId=Od.ProductId
join orders o on o.orderId = OD.orderId
----------------------------------------------------------------------
-- 25.number of items in the order
select   O.orderNo,  sum(OD.quantity)  from Orders O
join orderDetails OD on o.orderId = OD.orderId
group by O.OrderNo
--------------------------------------------------------------------------
-- 26.total Price of the order

select   O.orderNo,  sum(OD.quantity*p.price) from products p 
join orderDetails OD on p.ProductId=Od.ProductId
join orders o on o.orderId = OD.orderId
group by O.OrderNo
--------------------------------------------------------------------------------
-- 27. user's history

select u.userId , o.orderNo , o.orderDate  from users U
left join orders O 
on U.userId =O.userId 
order by u.userid
----------------------------------------------------------------------------
-- 28. number of orders done by user
select u.name ,count(o.orderNo) numberIfOrders  from users U
left join orders O 
on U.userId =O.userId 
group by u.name

select * from carts where userId=1
-------------------------------------------------------------------------------------------
---- 29. select Cart Details
select   c.cartId, p.name , p.Description , CD.quantity , p.price , c.userid from products p 
join CartDetails CD on p.ProductId=cd.ProductId
join carts c on c.cartId = cD.cartId
where c.userid=1
select * from carts
-------------------------------------------------------------------------