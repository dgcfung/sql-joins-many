DROP DATABASE IF EXISTS customers_db;
CREATE DATABASE customers_db;
\connect customers_db;
\i schema.sql;
