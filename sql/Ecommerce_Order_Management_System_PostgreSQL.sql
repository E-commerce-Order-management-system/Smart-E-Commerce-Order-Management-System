-- E-COMMERCE ORDER MANAGEMENT SYSTEM
-- DBMS Capstone Project
-- PostgreSQL version
--
-- STEP 1: Run the following database command while connected to the default
-- PostgreSQL database (usually "postgres"):
-- CREATE DATABASE ecommerce_order_management;
--
-- STEP 2: In pgAdmin, connect/open Query Tool for the newly created
-- ecommerce_order_management database and run the rest of this script.

-- =========================================================
-- 1. CUSTOMER
-- =========================================================
CREATE TABLE Customer (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- =========================================================
-- 2. CUSTOMER PHONE
-- =========================================================
CREATE TABLE Customer_Phone (
    phone_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    phone VARCHAR(15) NOT NULL,
    UNIQUE (customer_id, phone),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- =========================================================
-- 3. ADDRESS
-- =========================================================
CREATE TABLE Address (
    address_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    street VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    address_type VARCHAR(20) NOT NULL DEFAULT 'Home',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- =========================================================
-- 4. CATEGORY
-- =========================================================
CREATE TABLE Category (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    parent_category_id INTEGER,
    FOREIGN KEY (parent_category_id) REFERENCES Category(category_id)
);

-- =========================================================
-- 5. PRODUCT
-- =========================================================
CREATE TABLE Product (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    category_id INTEGER,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- =========================================================
-- 6. PRODUCT TAGS
-- =========================================================
CREATE TABLE Product_Tags (
    product_id INTEGER NOT NULL,
    tag VARCHAR(50) NOT NULL,
    PRIMARY KEY (product_id, tag),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- =========================================================
-- 7. ORDERS
-- =========================================================
CREATE TABLE Orders (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    address_id INTEGER NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    order_status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

-- =========================================================
-- 8. ORDER ITEMS
-- =========================================================
CREATE TABLE Order_Item (
    item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    UNIQUE (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- =========================================================
-- 9. PAYMENT
-- =========================================================
CREATE TABLE Payment (
    payment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    payment_date DATE,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    transaction_id VARCHAR(100) UNIQUE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- =========================================================
-- SAMPLE DATA
-- =========================================================

INSERT INTO Customer (first_name, last_name, email, registration_date) VALUES
('Anita','Patel','anita@mail.com','2023-01-15'),
('Ramesh','Nair','ramesh@mail.com','2023-03-22'),
('Divya','Singh','divya@mail.com','2024-06-10'),
('Karthik','Rao','karthik@mail.com','2024-07-18'),
('Meera','Sharma','meera@mail.com','2024-08-02');

INSERT INTO Customer_Phone (customer_id, phone) VALUES
(1,'9876543210'),
(2,'9876543211'),
(3,'9876543212'),
(4,'9876543213'),
(5,'9876543214');

INSERT INTO Address
(customer_id, street, city, state, pincode, address_type) VALUES
(1,'12 MG Road','Vijayawada','Andhra Pradesh','520010','Home'),
(2,'45 Park Street','Hyderabad','Telangana','500001','Home'),
(3,'7 Lake View','Visakhapatnam','Andhra Pradesh','530017','Home'),
(4,'21 Main Road','Rajahmundry','Andhra Pradesh','533101','Office'),
(5,'8 Green Avenue','Guntur','Andhra Pradesh','522002','Home');

INSERT INTO Category (category_name, parent_category_id) VALUES
('Electronics',NULL),
('Fashion',NULL),
('Mobile Accessories',1),
('Laptops',1);

INSERT INTO Product
(product_name, description, price, stock_quantity, category_id) VALUES
('Samsung Galaxy S24','Android smartphone',65000.00,50,1),
('HP Pavilion Laptop','15-inch performance laptop',55000.00,30,4),
('Cotton T-Shirt','Comfortable cotton t-shirt',499.00,200,2),
('Wireless Earbuds','Bluetooth wireless earbuds',1999.00,100,3),
('Laptop Backpack','Water-resistant backpack',1499.00,75,4);

INSERT INTO Product_Tags (product_id, tag) VALUES
(1,'smartphone'),
(1,'android'),
(2,'laptop'),
(2,'computer'),
(3,'clothing'),
(4,'audio'),
(4,'wireless'),
(5,'bag');

INSERT INTO Orders
(customer_id, address_id, order_date, order_status) VALUES
(1,1,'2024-08-01','Delivered'),
(2,2,'2024-08-05','Shipped'),
(1,1,'2024-08-10','Pending'),
(3,3,'2024-08-12','Delivered'),
(4,4,'2024-08-15','Cancelled');

INSERT INTO Order_Item
(order_id, product_id, quantity, unit_price) VALUES
(1,1,1,65000.00),
(1,4,1,1999.00),
(2,2,1,55000.00),
(2,5,1,1499.00),
(3,3,3,499.00),
(4,4,2,1999.00),
(4,3,2,499.00),
(5,5,1,1499.00);

INSERT INTO Payment
(order_id, payment_date, amount, method, status, transaction_id) VALUES
(1,'2024-08-01',66999.00,'UPI','Success','TXN1001'),
(2,'2024-08-05',56499.00,'Card','Success','TXN1002'),
(3,'2024-08-10',1497.00,'COD','Pending',NULL),
(4,'2024-08-12',4996.00,'UPI','Success','TXN1004'),
(5,'2024-08-15',1499.00,'Card','Failed','TXN1005');

-- =========================================================
-- VIEWS
-- =========================================================

CREATE OR REPLACE VIEW Order_Details AS
SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS subtotal,
    o.order_date,
    o.order_status
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Order_Item oi ON o.order_id = oi.order_id
JOIN Product p ON oi.product_id = p.product_id;

CREATE OR REPLACE VIEW Customer_Order_Summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(
        SUM(
            CASE
                WHEN o.order_status <> 'Cancelled'
                THEN oi.quantity * oi.unit_price
                ELSE 0
            END
        ), 0
    ) AS total_spent
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Item oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- =========================================================
-- TRIGGER: PREVENT ORDERING MORE STOCK THAN AVAILABLE
-- =========================================================

CREATE OR REPLACE FUNCTION check_order_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    available_stock INTEGER;
BEGIN
    SELECT stock_quantity
    INTO available_stock
    FROM Product
    WHERE product_id = NEW.product_id;

    IF available_stock IS NULL THEN
        RAISE EXCEPTION 'Product does not exist';
    ELSIF NEW.quantity > available_stock THEN
        RAISE EXCEPTION 'Insufficient stock for product %', NEW.product_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER Before_Order_Item_Insert
BEFORE INSERT ON Order_Item
FOR EACH ROW
EXECUTE FUNCTION check_order_stock();

-- =========================================================
-- STORED PROCEDURE
-- =========================================================

CREATE OR REPLACE PROCEDURE Update_Order_Status(
    p_order_id INTEGER,
    p_status VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Orders
    SET order_status = p_status
    WHERE order_id = p_order_id;
END;
$$;

-- =========================================================
-- REPRESENTATIVE SQL QUERIES
-- =========================================================

-- 1. Display all products
SELECT * FROM Product;

-- 2. Display customers and their orders
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id;

-- 3. Complete order details
SELECT * FROM Order_Details;

-- 4. Total sales excluding cancelled orders
SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_sales
FROM Orders o
JOIN Order_Item oi ON o.order_id = oi.order_id
WHERE o.order_status <> 'Cancelled';

-- 5. Best-selling products
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM Product p
JOIN Order_Item oi ON p.product_id = oi.product_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;

-- 6. Customers spending more than 50000
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Item oi ON o.order_id = oi.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.unit_price) > 50000;

-- 7. Low-stock products
SELECT product_id, product_name, stock_quantity
FROM Product
WHERE stock_quantity < 50
ORDER BY stock_quantity;

-- 8. Pending orders
SELECT order_id, customer_id, order_date
FROM Orders
WHERE order_status = 'Pending';

-- 9. Subquery: products priced above average
SELECT product_name, price
FROM Product
WHERE price > (SELECT AVG(price) FROM Product);

-- 10. JOIN: products with categories
SELECT
    p.product_name,
    p.price,
    c.category_name
FROM Product p
JOIN Category c ON p.category_id = c.category_id;

-- 11. UPDATE example
UPDATE Orders
SET order_status = 'Shipped'
WHERE order_id = 3;

-- 12. Stored procedure example
CALL Update_Order_Status(3, 'Delivered');

-- 13. View query
SELECT * FROM Customer_Order_Summary;

-- 14. CRUD examples
INSERT INTO Customer(first_name, last_name, email)
VALUES ('Test','User','test@example.com');

SELECT *
FROM Customer
WHERE email = 'test@example.com';

UPDATE Customer
SET last_name = 'Updated'
WHERE email = 'test@example.com';

DELETE FROM Customer
WHERE email = 'test@example.com';

-- =========================================================
-- OPTIONAL: STOCK UPDATE AFTER A SUCCESSFUL ORDER
-- Run this only as part of your application/order transaction.
-- =========================================================
-- UPDATE Product
-- SET stock_quantity = stock_quantity - 2
-- WHERE product_id = 4 AND stock_quantity >= 2;