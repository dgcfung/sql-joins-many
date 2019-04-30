DROP DATABASE IF EXISTS books_db;
CREATE DATABASE books_db;
\connect books_db;
\i schema.sql;
