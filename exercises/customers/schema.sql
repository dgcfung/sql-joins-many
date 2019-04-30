CREATE DATABASE customers_db;
\c customers_db

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(255),
  zip INTEGER
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES customers,
  amount MONEY,
  order_date DATE
);

INSERT INTO customers (name, address, city, state, zip) VALUES ('Walter Key', '79 Highland Ave.', 'Somerville', 'MA', '02143');
INSERT INTO customers (name, address, city, state, zip) VALUES ('Grayce Mission', '40 College Avenue', 'Somerville', 'MA', '02143');
INSERT INTO customers (name, address, city, state, zip) VALUES ('Rosalinda Motorway', '115 Broadway', 'Somerville', 'MA', '02143');
INSERT INTO customers (name, address, city, state, zip) VALUES ('Holland St', '98', 'Louisville', 'KY', '01234');

INSERT INTO orders (customer_id, amount, order_date) VALUES (1, 111.51, '01/5/2016');
INSERT INTO orders (customer_id, amount, order_date) VALUES (2, 151.88, '07/13/2015');
INSERT INTO orders (customer_id, amount, order_date) VALUES (3, 78.50, '05/05/2014');
INSERT INTO orders (customer_id, amount, order_date) VALUES (1, 124.00, '07/13/2015');
INSERT INTO orders (customer_id, amount, order_date) VALUES (2, 65.50, '09/16/2014');
INSERT INTO orders (customer_id, amount, order_date) VALUES (1, 25.50, '09/16/2014');
INSERT INTO orders (customer_id, amount, order_date) VALUES (2, 14.40, '09/16/2014');
INSERT INTO orders (customer_id, amount, order_date) VALUES (1, 234.56, '10/08/2015');
