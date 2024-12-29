use FastFoodRestaurantDB


--insert data
--categories 
INSERT INTO Categories (Name,  CreatedDate) VALUES ('Burger',  GETDATE());
INSERT INTO Categories (Name,  CreatedDate) VALUES ('Pizza', DATEADD(DAY, -1, GETDATE()));
INSERT INTO Categories (Name,  CreatedDate) VALUES ('Pasta',   DATEADD(DAY, -2, GETDATE()));
INSERT INTO Categories (Name,  CreatedDate) VALUES ('Fries',   DATEADD(DAY, -3, GETDATE()));
INSERT INTO Categories (Name,  CreatedDate) VALUES ('Drinks',   DATEADD(DAY, -4, GETDATE()));
INSERT INTO Categories (Name,  CreatedDate) VALUES ('Sandwitch',  DATEADD(DAY, -5, GETDATE()));


select * from Categories


--product 
INSERT INTO Products (Name, Description, Price, Quantity, CategoryId, CreatedDate)
VALUES 
('Classic Beef Burger', 'A juicy beef patty with lettuce, tomato, onion, pickles, ketchup, and mustard on a sesame seed bun.', 100.99, 100, 1, GETDATE()),
('Cheeseburger', 'A beef patty topped with melted cheddar cheese, lettuce, tomato, and a slice of pickle with mayonnaise on a toasted bun.', 150.49, 200, 1, DATEADD(DAY, -1, GETDATE())),
('Chicken Burger', 'A grilled or crispy chicken breast with lettuce, mayonnaise, and tomato on a brioche bun.', 200.00, 150, 1, DATEADD(DAY, -2, GETDATE())),
('Margherita Pizza', 'A classic pizza with a simple base of tomato sauce, fresh mozzarella cheese, basil leaves, and a drizzle of olive oil.', 80.75, 300, 2, DATEADD(DAY, -3, GETDATE())),
('Pepperoni Pizza', 'A pizza topped with tomato sauce, mozzarella cheese, and generous slices of pepperoni, baked to perfection.', 120.49, 50, 2, DATEADD(DAY, -4, GETDATE())),
('Vegetarian Pizza', 'A pizza topped with a variety of fresh vegetables like bell peppers, onions, mushrooms, olives, and spinach, with tomato sauce and mozzarella cheese.', 50.00, 75, 2, DATEADD(DAY, -5, GETDATE())),
('Spaghetti Bolognese','A classic Italian pasta dish with spaghetti topped with a rich, slow-cooked beef and tomato sauce, garnished with Parmesan cheese and fresh basil.', 250.00, 125, 3, DATEADD(DAY, -6, GETDATE())),
('Penne Alfredo', 'Penne pasta in a creamy Alfredo sauce made with butter, cream, and Parmesan cheese, often topped with grilled chicken or vegetables.', 130.00, 60, 3, DATEADD(DAY, -7, GETDATE())),
('Loaded Fries','Crispy fries topped with melted cheese, crispy bacon bits, sour cream, and green onions, often served with a side of ranch or barbecue sauce.', 160.00, 80, 4, DATEADD(DAY, -9, GETDATE())),
('Coca-Cola','A classic carbonated soft drink known for its sweet, crisp taste and caffeine content.', 19.99, 180, 5, DATEADD(DAY, -12, GETDATE())),
('Lemonade','A refreshing, tangy drink made with fresh lemon juice, water, and sugar, served chilled.', 17.49, 130, 5, DATEADD(DAY, -13, GETDATE())),
('Iced Tea','A chilled tea beverage, often served with lemon slices or sweetened with sugar, offering a refreshing option for hot days.', 33.99, 120, 5, DATEADD(DAY, -15, GETDATE()))


select * from Products


--users
INSERT INTO Users ( Name, Username, Mobile, Email, Address, PostCode, Password, CreatedDate)
VALUES 
('John Doe', 'johndoe', '1234567890', 'john.doe@example.com', '123 Elm Street', '12345', 'john123456', GETDATE()),
('Jane Smith', 'janesmith', '9876543210', 'jane.smith@example.com', '456 Oak Avenue', '67890', 'Jane123456', GETDATE()),
('Alice Johnson', 'alicej', '4567891230', 'alice.j@example.com', '789 Pine Road', '54321', 'Alice123456', GETDATE()),
('Ahmed Ali', 'ahmed_ali', '01012345678', 'ahmed.ali@example.com', '123 Main St, Cairo', '12345', 'Ahmed123456', GETDATE()),
('Sara Mohammed', 'sara_mohammed', '01234567890', 'sara.mohammed@example.com', '456 Elm St, Giza', '67890', 'Sara123456', GETDATE()),
('Tariq Hussein', 'tariq_hussein', '01123456789', 'tariq.hussein@example.com', '789 Oak St, Alexandria', '11223', 'Tariq123456', GETDATE()),
('Mona Yasser', 'mona_yasser', '01098765432', 'mona.yasser@example.com', '321 Pine St, Mansoura', '44556', 'Mona123456', GETDATE()),
('Hassan Karim', 'hassan_karim', '01234567891', 'hassan.karim@example.com', '654 Maple St, Tanta', '77889', 'Hassan123456', GETDATE());

SELECT * FROM Users;

--Contacts
INSERT INTO Contact ( UserId, Subject, Message, CreatedDate)
VALUES
(1, 'Menu Inquiry', 'Can you share your special offers for this week?', GETDATE()),
(1, 'Feedback', 'The food was excellent, but the delivery took too long.', DATEADD(DAY, -1, GETDATE())),
(4, 'Complaint', 'I received the wrong order. Please assist me with this issue.', DATEADD(DAY, -2, GETDATE())), 
(5, 'Product Inquiry', 'I am interested in the Classic Beef Burger. Can you provide more details?', DATEADD(DAY, -3, GETDATE())),
(5, 'Order Issue', 'I received the wrong order. Please assist!', DATEADD(DAY, -4, GETDATE())),
(6, 'Feedback', 'Great service and amazing food. Keep it up!', DATEADD(DAY, -5, GETDATE())),
(6, 'Complaint', 'My pizza was cold when it arrived. Very disappointed.', DATEADD(DAY, -6, GETDATE())),
(8, 'Payment Issue', 'I was charged twice for my order. Please check.', DATEADD(DAY, -7, GETDATE()));

select * from Contact;

--payment

INSERT INTO Payment ( UserId,CardNo, ExpiryDate, CvvNo,  PaymentMode)
VALUES 
(1,'1111222233334444', '12/25', 123,  'Credit Card'),
(2, '5555666677778888', '11/24', 456, 'Debit Card'),
(3, '9999000011112222', '01/26', 789,  'Cash'),
(4, '1234567812345678', '12/25', 123,  'Credit Card'),
(5, '2345678923456789', '11/24', 456,  'Debit Card'),
(6, '3456789034567890', '09/26', 789,  'PayPal'),
(7, '4567890145678901', '08/23', 101,  'Credit Card'),
(8, '5678901256789012', '07/27', 202,  'Debit Card');

SELECT * FROM Payment;

--carts
INSERT INTO Carts (ProductId, Quantity, UserId, CreatedDate)
VALUES 
(1, 2, 1, GETDATE()), -- John Doe adds 2 Classic Beef Burgers to the cart
(4, 1, 2, DATEADD(DAY, -1, GETDATE())), -- Jane Smith adds 1 Margherita Pizza to the cart
(7, 3, 3, DATEADD(DAY, -2, GETDATE())), -- Alice Johnson adds 3 Spaghetti Bolognese to the cart
(1, 2, 4, DATEADD(DAY, -3, GETDATE())),  -- Classic Beef Burger for Ahmed Ali
(2, 1, 5, DATEADD(DAY, -4, GETDATE())), -- Cheeseburger for Sara Mohammed
(3, 3, 6, DATEADD(DAY, -5, GETDATE())), -- Chicken Burger for Tariq Hussein
(4, 2, 7, DATEADD(DAY, -6, GETDATE())), -- Margherita Pizza for Mona Yasser
(5, 1, 8, DATEADD(DAY, -7, GETDATE())); -- Pepperoni Pizza for Hassan K

SELECT * FROM Carts;





--orders
INSERT INTO Orders (OrderNo, UserId,  Status, PaymentId, OrderDate)
VALUES 
('ORD001', 1,  'Completed', 1, GETDATE()), -- John Doe orders 2 Classic Beef Burgers
('ORD002', 2,  'Pending', 2, DATEADD(DAY, -1, GETDATE())), -- Jane Smith orders 1 Margherita Pizza
('ORD003', 3,  'Processing', 3, DATEADD(DAY, -2, GETDATE())), -- Alice Johnson orders 3 Spaghetti Bolognese
('ORD004', 4,  'Pending', 4, GETDATE()),  -- Ahmed Ali's order for Classic Beef Burger
('ORD005', 5,  'Completed', 5, DATEADD(DAY, -1, GETDATE())), -- Sara Mohammed's order for Cheeseburger
('ORD006', 6,  'Pending', 6, DATEADD(DAY, -2, GETDATE())), -- Tariq Hussein's order for Chicken Burger
('ORD007', 7,  'Cancelled', 7, DATEADD(DAY, -3, GETDATE())), -- Mona Yasser's order for Margherita Pizza
('ORD008', 8,  'Completed', 8, DATEADD(DAY, -4, GETDATE())), -- Hassan Karim's order for Pepperoni Pizza
('ORD009', 8,  'Completed', 5, DATEADD(DAY, -1, GETDATE())), 
('ORD010', 2,  'Pending', 6, DATEADD(DAY, -2, GETDATE())), 
('ORD011', 7,  'completed', 7, DATEADD(DAY, -3, GETDATE())), 
('ORD012', 2,  'Completed', 8, DATEADD(DAY, -4, GETDATE())); 
SELECT * FROM Orders;

--orderDetails

INSERT INTO OrderDetails (OrderId , ProductId , Quantity)
VALUES 
(1,1,2),
(1,3,5),
(2,7,1),
(2,9,3),
(3,5,5),
(4,12,1),
(5,1,1),
(5,2,1),
(5,3,1),
(6,3,5),
(7,9,1),
(7,4,2),
(7,11,2),
(7,6,2),
(8,4,4),
(9,7,5),
(10,3,1),
(11,6,1),
(11,4,4),
(12,7,15),
(12,3,18);

select * from OrderDetails


