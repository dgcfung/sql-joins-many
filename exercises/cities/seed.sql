DROP DATABASE IF EXISTS cities_db;
CREATE DATABASE cities_db;
\connect cities_db;
\i schema.sql;
