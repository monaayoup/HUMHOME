use FastFoodRestaurantDB
go


------------------------------------------------------------------------
-- in user's cart
create PROCEDURE spCartDetailsByUserId
@user_id int

AS
BEGIN

select   u.name , p.name , p.Description , c.quantity , p.price from products p 
join carts c on c.ProductId = P.ProductId
join users u on c.UserId=u.UserId
where c.UserId = @user_id
END

exec spCartDetailsByUserId @user_id =5

exec spCartDetailsByUserId @user_id =1
drop proc spCartItemsByUserId
--hint
SELECT * FROM CARTS
select * from products
select * from users
--------------------------------------------------------------------






---------------------------------------------------------------------
--login system
---------------------------------------------------------------
--already have an account
CREATE PROCEDURE spSignIn
    @user_name NVARCHAR(50),
	@email NVARCHAR(50),
	@passward NVARCHAR(255),
	@user_id int output
	as
	begin 
	begin try
	insert into users (username , email , Password )
	values 
	(@user_name , @email , @passward)
	if not exists (select * from users where Username=@user_name and email=@email and Password=@passward)
	begin 
	delete from users where Username=@user_name and email=@email and Password=@passward
	end 
	end try
	begin catch
	select @user_id=userId from users  where Username=@user_name and email=@email and Password=@passward
	end catch
	end






----------------------------------------------------------------
--sign up create new account
CREATE PROCEDURE spSignUp
    @name NVARCHAR(50),
    @user_name NVARCHAR(50),
    @mobile NVARCHAR(15),
    @email NVARCHAR(50),
    @address NVARCHAR(MAX),
    @post_code NVARCHAR(10),
    @passward NVARCHAR(255),
    @msg NVARCHAR(50) OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Attempt to insert into Users table
        INSERT INTO Users (Name, Username, Mobile, Email, Address, PostCode, Password)
        VALUES 
        (@name, @user_name, @mobile, @email, @address, @post_code, @passward);

        -- Set message to indicate success
        SET @msg = 'Success';
    END TRY
    BEGIN CATCH
        -- Check if the username already exists
        IF EXISTS (SELECT 1 FROM Users WHERE Username = @user_name)
        BEGIN
            SET @msg = ' Username already exists';
        END
        ELSE IF EXISTS (SELECT 1 FROM Users WHERE Email = @email)
        BEGIN
            SET @msg = ' email already exists';
        END
		ELSE IF EXISTS (SELECT 1 FROM Users WHERE Password = @passward)
        BEGIN
            SET @msg = ' passward already exists';
        END
    END CATCH
END;


--
DECLARE @message NVARCHAR(50);

EXEC spSignUp 
    @name = 'Ahmed', 
    @user_name = 'ahmed_189', 
    @mobile = '01234567897', 
    @email = 'dfghj90k123@gmail.com', 
    @address = 'giza123', 
    @post_code = '1234', 
    @passward = '12319023123', 
    @msg = @message OUTPUT;

-- Check the message
SELECT @message AS Result;
EXEC spCartItemsByUserId @USER_ID =1

select * from contact



