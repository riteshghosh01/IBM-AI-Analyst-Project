-- Foodie relational data model (PostgreSQL)
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(30),
  address TEXT,
  password_hash TEXT,
  role VARCHAR(20) NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'admin')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE menu_categories (
  id BIGSERIAL PRIMARY KEY,
  category_name VARCHAR(80) UNIQUE NOT NULL
);

CREATE TABLE menu_items (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  description TEXT NOT NULL,
  category_id BIGINT NOT NULL REFERENCES menu_categories(id),
  price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  image TEXT,
  veg_or_nonveg VARCHAR(10) NOT NULL CHECK (veg_or_nonveg IN ('veg', 'nonveg')),
  rating NUMERIC(2,1) NOT NULL DEFAULT 0 CHECK (rating BETWEEN 0 AND 5),
  availability BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE cart (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  menu_item_id BIGINT NOT NULL REFERENCES menu_items(id),
  quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
  UNIQUE(user_id, menu_item_id)
);

CREATE TABLE orders (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id),
  order_type VARCHAR(20) NOT NULL CHECK (order_type IN ('delivery', 'pickup', 'dine_in')),
  total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
  order_status VARCHAR(30) NOT NULL DEFAULT 'Order Received',
  payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
  delivery_address TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
  id BIGSERIAL PRIMARY KEY,
  order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  menu_item_id BIGINT NOT NULL REFERENCES menu_items(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price NUMERIC(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE reservations (
  id BIGSERIAL PRIMARY KEY,
  customer_name VARCHAR(120) NOT NULL,
  phone VARCHAR(30) NOT NULL,
  email VARCHAR(255),
  date DATE NOT NULL,
  time TIME NOT NULL,
  guests INTEGER NOT NULL CHECK (guests > 0),
  special_request TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'Pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX orders_status_idx ON orders(order_status);
CREATE INDEX menu_items_category_idx ON menu_items(category_id);
