class Product:
    def __init__(self, product_id, name, description, price, quantity):
        """Initialize a product with its details."""
        self.product_id = product_id
        self.name = name
        self.description = description
        self.price = price
        self.quantity = quantity

    def __repr__(self):
        """Represent the product as a string."""
        return f"Product(ProductId={self.product_id}, Name={self.name}, Price={self.price}, Quantity={self.quantity})"

    def update_quantity(self, quantity):
        """Update the quantity of the product."""
        if quantity < 0:
            raise ValueError("Quantity cannot be negative")
        self.quantity = quantity

    def decrease_quantity(self, quantity):
        """Decrease the quantity of the product."""
        if quantity < 0:
            raise ValueError("Quantity cannot be negative")
        if self.quantity < quantity:
            raise ValueError("Not enough stock")
        self.quantity -= quantity


class CartItem:
    def __init__(self, product, quantity):
        """Initialize a cart item with a product and quantity."""
        self.product = product
        self.quantity = quantity

    def __repr__(self):
        """Represent the cart item as a string."""
        return f"CartItem(ProductId={self.product.product_id}, Name={self.product.name}, Quantity={self.quantity})"


class Cart:
    def __init__(self, user_id):
        """Initialize the cart with a user and an empty set of items."""
        self.user_id = user_id
        self.items = {}  # Store products by ProductId as key

    def add_item(self, product, quantity):
        """Add a product to the cart. If it already exists, update the quantity."""
        if product.product_id in self.items:
            self.items[product.product_id].quantity += quantity
        else:
            self.items[product.product_id] = CartItem(product, quantity)

    def remove_item(self, product_id):
        """Remove a product from the cart."""
        if product_id in self.items:
            del self.items[product_id]
        else:
            raise ValueError("Product not found in cart")

    def get_total(self):
        """Calculate the total price for all items in the cart."""
        return sum(item.quantity * item.product.price for item in self.items.values())

    def __repr__(self):
        """Represent the cart as a string."""
        items_str = ', '.join([str(item) for item in self.items.values()])
        return f"Cart(UserId={self.user_id}, Items=[{items_str}])"


class OrderDetails:
    def __init__(self, order_id, product, quantity):
        """Initialize the order details with order id, product, and quantity."""
        self.order_id = order_id
        self.product_id = product.product_id
        self.product_name = product.name
        self.quantity = quantity
        self.price = product.price

    def __repr__(self):
        """Represent the order detail as a string."""
        return f"OrderDetails(OrderId={self.order_id}, ProductId={self.product_id}, ProductName={self.product_name}, Quantity={self.quantity}, Price={self.price})"


class Order:
    def __init__(self, order_no, user_id, status, payment_id, order_details=None):
        """Initialize an order with details such as order number, user, and status."""
        self.order_no = order_no
        self.user_id = user_id
        self.status = status
        self.payment_id = payment_id
        self.order_details = order_details if order_details else []

    def add_order_detail(self, order_detail):
        """Add an order detail to the order."""
        self.order_details.append(order_detail)

    def get_total(self):
        """Calculate the total price for the order."""
        return sum(detail.quantity * detail.price for detail in self.order_details)

    def __repr__(self):
        """Represent the order as a string."""
        order_details_str = ', '.join([str(detail) for detail in self.order_details])
        return f"Order(OrderNo={self.order_no}, UserId={self.user_id}, Status={self.status}, PaymentId={self.payment_id}, OrderDetails=[{order_details_str}], Total={self.get_total()})"


# Example Usage:

# 1. Create some products
product1 = Product(1, "Burger", "Delicious beef burger", 5.99, 100)
product2 = Product(2, "Pizza", "Cheese pizza", 8.99, 50)

# 2. Add products to a cart
cart = Cart(user_id=123)
cart.add_item(product1, 2)  # Add 2 burgers to the cart
cart.add_item(product2, 1)  # Add 1 pizza to the cart

print(cart)  # Output the cart with items

# 3. Create an order
order_detail1 = OrderDetails(order_id=1, product=product1, quantity=2)
order_detail2 = OrderDetails(order_id=1, product=product2, quantity=1)
order = Order(order_no="ORD123", user_id=123, status="Pending", payment_id=1001)
order.add_order_detail(order_detail1)
order.add_order_detail(order_detail2)

print(order)  # Output the order with details and total
