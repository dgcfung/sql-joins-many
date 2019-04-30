DROP TABLE if exists countries;
DROP TABLE if exists cities;

CREATE TABLE countries (
  id BIGSERIAL PRIMARY KEY,
  name TEXT
);

CREATE TABLE cities (
  id BIGSERIAL PRIMARY KEY,
  name TEXT,
  population INTEGER,
  country_id INTEGER REFERENCES countries(id)
);

INSERT INTO countries (name) VALUES ('United States of America');
INSERT INTO countries (name) VALUES ('England');
INSERT INTO cities (name, population, country_id) VALUES ('New York', 8538000, 1);
INSERT INTO cities (name, population, country_id) VALUES ('Chicago', 2700000, 1);
INSERT INTO cities (name, population, country_id) VALUES ('London', 8780000, 2);
