from flask import Flask, render_template, request, redirect, url_for, g
import pyodbc
import random
import string

# Database connection details
DRIVER_NAME = 'ODBC Driver 17 for SQL Server'
SERVER_NAME = 'MAI'
DATABASE_NAME = 'FastFoodRestaurantDB'

app = Flask(__name__)

# Database connection function
def get_db():
    if 'db' not in g:
        g.db = pyodbc.connect(
            f'Driver={{{DRIVER_NAME}}};'
            f'Server={SERVER_NAME};'
            f'Database={DATABASE_NAME};'
            f'Trusted_Connection=yes;'
        )
        g.cursor = g.db.cursor()
    return g.db, g.cursor

# Helper Functions
def get_all_products():
    """Retrieve all products."""
    db, cursor = get_db()
    cursor.execute("exec spGetAllProducts")
    return cursor.fetchall()
# done 1

def get_product_by_id(product_id):
    """Retrieve a product by its ID."""
    db, cursor = get_db()
    cursor.execute("EXEC spGetProductById @product_id = ?", product_id)
    return cursor.fetchone()
# done 2
def get_cart_items(user_id):
    """Retrieve items in the user's cart."""
    db, cursor = get_db()

    cursor.execute("EXEC spGetCartItems @user_id = ?", user_id)
    return cursor.fetchall()

def add_to_cart(user_id, product_id, quantity):
    """Add an item to the cart."""
    db, cursor = get_db()
    cursor.execute(
        "EXEC spAddToCart @user_id = ?, @product_id = ?, @quantity = ?",
        (user_id, product_id, quantity)
    )
    db.commit()

def get_Total_Price(user_id):
    """Total Price."""
    db, cursor = get_db()
    cursor.execute("exec spGetTotalPrice @user_id =?", user_id)
    return cursor.fetchone()

def update_cart_quantity(user_id, product_id, quantity):
    """Update the quantity of an item in the cart."""
    db, cursor = get_db()
    cursor.execute(
        "EXEC spUpdateCartQuantity @user_id = ?, @product_id = ?, @quantity = ?",
        (quantity, user_id, product_id)
    )
    db.commit()

def delete_from_cart(user_id, product_id):
    """Delete an item from the cart."""
    db, cursor = get_db()
    cursor.execute(
        "EXEC spDeleteFromCart @user_id = ?, @product_id = ?",
        (user_id, product_id)
    )
    db.commit()
def increase_decrease_quentity(quantity,user_id,product_id ,status):
    """increase quantity  by one """
    db, cursor = get_db()
    if status=='inc':
        cursor.execute("""UPDATE carts
                    SET quantity = ?
                    WHERE productid =? and userid=?;""",( quantity+1,product_id,user_id))
    elif status=='dec':
        cursor.execute("""UPDATE carts
                    SET quantity = ?
                    WHERE productid =? and userid=?;""",( quantity-1,product_id,user_id))
    db.commit()

def place_order(user_id):
    """Place an order and clear the cart."""
    db, cursor = get_db()
    order_no = ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))

    cart_items = get_cart_items(user_id)
    cursor.execute(
        "INSERT INTO Orders (OrderNo, UserId, Status, PaymentId) VALUES (?, ?, ?, ?)",
        (order_no, user_id, 'Pending', 1)
    )
    db.commit()

    order_id = cursor.execute(
        "SELECT OrderId FROM Orders WHERE OrderNo = ?",
        order_no
    ).fetchone()[0]

    for item in cart_items:
        product_id, quantity = item[1], item[0]
        cursor.execute(
            "INSERT INTO OrderDetails (OrderId, ProductId, Quantity) VALUES (?, ?, ?)",
            (order_id, product_id, quantity)
        )
    
    cursor.execute("DELETE FROM Carts WHERE UserId = ?", user_id)
    db.commit()
    return order_no

def save_contact_message(user_id, subject, message):
    """Save a contact message."""
    db, cursor = get_db()
    cursor.execute(
        "EXEC spSaveContactMessage @user_id = ?, @subject = ?, @message = ?",
        (user_id, subject, message)
    )
    db.commit()

# Routes
@app.route('/')
def index():
    products = get_all_products()
    return render_template('index.html', products=products)

@app.route('/product/<int:product_id>')
def view_product(product_id):
    product = get_product_by_id(product_id)
    return render_template('product_detail.html', product=product)

@app.route('/add_to_cart/<int:product_id>', methods=['POST'])
def add_to_cart_route(product_id):
    user_id = 1  # Simulated user ID
    quantity = int(request.form['quantity'])

    db, cursor = get_db()
    existing_item = cursor.execute(
        "SELECT Quantity FROM Carts WHERE UserId = ? AND ProductId = ?",
        (user_id, product_id)
    ).fetchone()

    if existing_item:
        new_quantity = existing_item[0] + quantity
        update_cart_quantity(user_id, product_id, new_quantity)
    else:
        add_to_cart(user_id, product_id, quantity)
    return redirect(url_for('view_cart'))

@app.route('/remove_from_cart/<int:product_id>')
def remove_from_cart(product_id):
    user_id = 1  # Simulated user ID
    delete_from_cart(user_id, product_id)
    return redirect(url_for('view_cart'))

@app.route('/increase_decrease/<int:product_id>/<int:quantity>/<string:status>')
def increase_decrease(product_id , quantity , status):
    user_id = 1  # Simulated user ID
    increase_decrease_quentity(quantity , user_id ,product_id ,status)
    return redirect(url_for('view_cart'))

@app.route('/view_cart')
def view_cart():
    user_id = 1  # Simulated user ID
    cart_items = get_cart_items(user_id)
    # total_price = sum(item[3] * item[0] for item in cart_items)
    total_price = get_Total_Price(user_id)
    return render_template('cart.html', cart_items=cart_items, total_price=total_price)

@app.route('/checkout', methods=['POST'])
def checkout():
    user_id = 1  # Simulated user ID
    order_no = place_order(user_id)
    return redirect(url_for('order_confirmation', order_no=order_no))

@app.route('/order_confirmation/<order_no>')
def order_confirmation(order_no):
    db, cursor = get_db()

    # Fetch the order details
    query = f"SELECT * FROM Orders WHERE OrderNo = '{order_no}'"
    cursor.execute(query)
    order = cursor.fetchone()

    # Fetch the products in the order
    query = f"""
        SELECT P.Name, OD.Quantity, P.Price
        FROM OrderDetails OD
        JOIN Products P ON OD.ProductId = P.ProductId
        WHERE OD.OrderId = (
            SELECT OrderId FROM Orders WHERE OrderNo = '{order_no}'
        )
    """
    cursor.execute(query)
    order_details = cursor.fetchall()

    if not order:
        # Handle missing order gracefully
        return render_template('order_confirmation.html', order=None)

    return render_template('order_confirmation.html', order=order, order_details=order_details)


@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        user_id = 1  # Simulated user ID
        subject = request.form['subject']
        message = request.form['message']
        save_contact_message(user_id, subject, message)
        return redirect(url_for('contact_confirmation', subject=subject))

    return render_template('contact.html')

@app.route('/contact_confirmation')
def contact_confirmation():
    subject = request.args.get('subject')
    return render_template('contact_confirmation.html', subject=subject)

@app.teardown_appcontext
def shutdown_session(exception=None):
    db = g.pop('db', None)
    if db:
        db.close()

# Run the application
if __name__ == '__main__':
    app.run(debug=True)
