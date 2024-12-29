use FastFoodRestaurantDB

---Queries for website
--------------------------------------------------------
--1.get all products

CREATE PROCEDURE spGetAllProducts
AS
BEGIN
    SELECT * FROM Products;
END;

-------------------------------------------------------------
--2.get product by id

CREATE PROCEDURE spGetProductById
    @product_id INT
AS
BEGIN
    SELECT * FROM Products WHERE ProductId = @product_id;
END;

-----------------------------------------------------------
--3. get cart items

CREATE PROCEDURE spGetCartItems
    @user_id INT
AS
BEGIN
    SELECT Carts.Quantity, Products.ProductId, Products.Name, Products.Price
    FROM Carts
    JOIN Products ON Carts.ProductId = Products.ProductId
    WHERE Carts.UserId = @user_id;
END;

----------------------------------------------------------------------
---4.add to cart
CREATE PROCEDURE spAddToCart
    @user_id INT,
    @product_id INT,
    @quantity INT
AS
BEGIN
    INSERT INTO Carts (UserId, ProductId, Quantity)
    VALUES (@user_id, @product_id, @quantity);
END;
-------------------------------------------------------------------
--5.update cart quantity

CREATE PROCEDURE spUpdateCartQuantity
    @user_id INT,
    @product_id INT,
    @quantity INT
AS
BEGIN
    UPDATE Carts
    SET Quantity = @quantity
    WHERE UserId = @user_id AND ProductId = @product_id;
END;
-------------------------------------------------------------------------
---6.delete from cart 
CREATE PROCEDURE spDeleteFromCart
    @user_id INT,
    @product_id INT
AS
BEGIN
    DELETE FROM Carts
    WHERE UserId = @user_id AND ProductId = @product_id;
END;

-----------------------------------------------------------------------
--7. total price 
CREATE PROCEDURE spGetTotalPrice
    @user_id INT
AS
BEGIN
    SELECT SUM(Carts.Quantity * Products.Price) AS TotalPrice
    FROM Carts
    JOIN Products ON Carts.ProductId = Products.ProductId
    WHERE Carts.UserId = @user_id;
END;
-------------------------------------------------------------------------

---------------------------------------------------------------------------------
--8.save conact message
CREATE PROCEDURE spSaveContactMessage
    @user_id INT,
    @subject NVARCHAR(MAX),
    @message NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Contact (UserId, Subject, Message)
    VALUES (@user_id, @subject, @message);
END;
--------------------------------------------------------------------

