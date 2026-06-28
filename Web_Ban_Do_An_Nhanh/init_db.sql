-- Create Database if not exists
CREATE DATABASE IF NOT EXISTS web_ban_do_an_nhanh;
USE web_ban_do_an_nhanh;

-- Create Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    is_activated TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Food Items table
CREATE TABLE IF NOT EXISTS food_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    image_url VARCHAR(500),
    category VARCHAR(50)
);

-- Insert dummy foods if empty
INSERT INTO food_items (id, name, description, price, image_url, category)
SELECT 1, 'Double Cheese Burger', 'Flame-grilled double beef patty, melted cheddar cheese, lettuce, tomatoes, and signature sauce.', 5.99, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80', 'Burgers'
WHERE NOT EXISTS (SELECT 1 FROM food_items WHERE id = 1);

INSERT INTO food_items (id, name, description, price, image_url, category)
SELECT 2, 'Pepperoni Premium Pizza', 'Crispy thin crust topped with rich marinara sauce, mozzarella cheese, and loaded with spicy pepperoni.', 8.99, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=500&q=80', 'Pizzas'
WHERE NOT EXISTS (SELECT 1 FROM food_items WHERE id = 2);

INSERT INTO food_items (id, name, description, price, image_url, category)
SELECT 3, 'Crispy Chicken Wings', 'Golden-fried crunchy chicken wings tossed in your choice of sweet and spicy BBQ or hot buffalo sauce.', 4.99, 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&w=500&q=80', 'Sides'
WHERE NOT EXISTS (SELECT 1 FROM food_items WHERE id = 3);

INSERT INTO food_items (id, name, description, price, image_url, category)
SELECT 4, 'Fresh Strawberry Milkshake', 'Thick and creamy vanilla milkshake blended with fresh strawberries and topped with whipped cream.', 2.99, 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?auto=format&fit=crop&w=500&q=80', 'Drinks'
WHERE NOT EXISTS (SELECT 1 FROM food_items WHERE id = 4);

-- Insert a test user (username: testuser, email: test@gmail.com, password: 123456 [SHA-256 hashed])
INSERT INTO users (id, username, email, phone, password, fullname)
SELECT 1, 'testuser', 'test@gmail.com', '0123456789', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Nguyễn Văn Test'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE id = 1);
