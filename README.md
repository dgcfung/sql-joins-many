![](https://ga-dash.s3.amazonaws.com/production/assets/logo-9f88ae6c9c3871690e33280fcf557f33.png)

# SQL JOINs

## Learning Objectives

- What are JOIN tables?
- Why do we need JOINS?
- Implement a one-to-many relationship using Postgres
- Create tables with foreign key references.
- Select data from more than one table using a `join` query


## Introduction

While it is conceivable to store all of the data that is needed for a resource in a single table, there are downsides to the approach. For example, if we had a table that holds cities, we might include the name of the city as well as the country the city is a party of. We would be repeating the name of a country like United States of America in every row for Atlanta, New York, Chicago, etc. If the name of the country changed (like U.S.S.R. to Russia), we would have to update every single row for every city in Russia. Redundancy of common data points can make altering or updating these fields difficult.

Further, there are weak guarantees for the consistency and correctness of hard-coded fields in a single column; what prevents a developer who is working on a different feature from using U.S.A. rather than United States of America when inserting a new city? Leveraging table relations can improve data integrity and provide stronger guarantees regarding the consistency and correctness of what we store and retrieve from a database.


One of the key features of relational databases is that they can represent relationships between rows in different tables.  There are several different types of relationships that can be implemented using a relational database:

- one-to-one
- one-to-many
- many-to-many

as well as different variants of these relationships and other associated operations that are grounded on these approaches to structuring data.

The first relationship we will examine is the `one-to-many` relationship. We will establish the relationship with a Foreign Key.

## Foreign Key

A foreign key is a field or group of fields in a table that uniquely identifies a row in another table. In other words, a foreign key is defined in a table that references to the primary key of the other table.

The table that contains the foreign key is called referencing table or child table. And the table to which the foreign key references is called referenced table or parent table.

A table can have multiple foreign keys depending on its relationships with other tables.

In PostgreSQL, you define a foreign key through a foreign key constraint. A foreign key constraint indicates that values in a column or a group of columns in the child table match with the values in a column or a group of columns of the parent table. We say that a foreign key constraint maintains referential integrity between child and parent tables.

## One to Many

Considering the country and city example, we could define a table for each:

```sql
CREATE TABLE countries (
    country_id SERIAL UNIQUE PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE cities (
    city_id SERIAL UNIQUE PRIMARY KEY,
    name TEXT NOT NUll,
    population INT,
    country_id INT REFERENCES countries(country_id)
);
```

And suppose the following seed data:

```sql
INSERT INTO countries (name) VALUES ('United States of America');
INSERT INTO countries (name) VALUES ('England');
INSERT INTO cities (name, population, country_id) VALUES ('New York', 8538000, 1);
INSERT INTO cities (name, population, country_id) VALUES ('Chicago', 2700000, 1);
INSERT INTO cities (name, population, country_id) VALUES ('London', 8780000, 2);
```

We say that a cities-to-countries is a **one-to-many** relationship. A country **has many** cities, and a city **belongs to** one country.


#### Check for Understanding
Take a few minutes and brainstorm with your partner to come up with a few examples, either in the realm of web apps or real life, of entities that can be described using a *one-to-many* relationship. For example, the relationship between books and authors.

![](./images/one_to_many.png)


## `SELECT`ing across tables

Using basic `SELECT` statements, if we wanted to find all cities in the U.S. we would have to execute two queries:

```sql
SELECT * FROM countries WHERE name = 'United States of America';

id |           name           
----+--------------------------
  1 | United States of America
(1 row)
```

And then copy + paste the countries.id into a `SELECT` query `FROM` the `cities` table:

```sql
SELECT * FROM cities WHERE country_id = 1;

 id |  name   | population | country_id 
----+---------+------------+------------
  1 | Chicago |    2700000 |          1
  2 | New York |    8538000 |          1
(2 rows)
```

SQL has a great feature that lets us join together data from multiple tables, the `JOIN table_a ON table_b` clause.

```sql
SELECT * FROM cities 
JOIN countries on cities.country_id = countries.id 
WHERE countries.name = 'United States of America';

 id |  name   | population | country_id | id |           name           
----+---------+------------+------------+----+--------------------------
  1 | Chicago |    2700000 |          1 |  1 | United States of America
  2 | New York |    8538000 |          1 |  1 | United States of America
(2 rows)
```

The result set from the query will return columns from both tables. You'll notice that some columns like `name` and `id` show up in both tables, and end up in the result set. To disambiguate these columns in our result set, we can request specific columns from each table we want in the result set and give them custom names with the `AS` keyword.

```sql
SELECT cities.name AS city_name, cities.id AS city_id, countries.name AS country_name 
FROM cities 
JOIN countries on cities.country_id = countries.id
WHERE countries.name = 'United States of America';

 city_name | city_id |       country_name       
-----------+---------+--------------------------
 Chicago   |       1 | United States of America
 New York   |       2 | United States of America
(2 rows)
```

## Joining data from multiple tables

`JOIN` statements can also be linked together to query data across several tables. Considering if we had another table representing soccer teams across the world:

```sql
CREATE TABLE soccer_teams (
    team_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    city_id INT REFERENCES cities(city_id) 
);

INSERT INTO soccer_teams (name, city_id) VALUES ('New York City FC', 1);
INSERT INTO soccer_teams (name, city_id) VALUES ('Chicago Fire', 2);
INSERT INTO soccer_teams (name, city_id) VALUES ('Arsenal FC', 3);
```

We could join all three tables together, to query say all the soccer teams within a specific country:

```sql
SELECT 
soccer_teams.name AS team_name, 
countries.name AS country_name
FROM soccer_teams
JOIN cities ON cities.id = soccer_teams.city_id
JOIN countries ON countries.id = cities.country_id
WHERE countries.name = 'United States of America';

    team_name     |       country_name       
------------------+--------------------------
 New York City FC | United States of America
 Chicago Fire     | United States of America
(2 rows)
```

## 🚀 Independent Practice :: Soccer Teams Lab

Navigate to the [soccer teams](https://git.generalassemb.ly/sei-nyc-blizzard/sql-one-to-many-soccer-teams) repo and follow the directions in the `README`. Note: This is a one-to-many exercise.

## Many to Many

A many-to-many relationship exists between two entities if for one entity instance there may be multiple records in the other table, and vice versa.

Example: A user can check out many books. A book can be checked out by many users (over time).

![](./images/many_to_many.png)

In order to implement this sort of relationship we need to introduce a third, cross-reference, table. This table holds the relationship between the two entities, by having two FOREIGN KEYs, each of which references the PRIMARY KEY of one of the tables for which we want to create this relationship. We already have our books and users tables, so we just need to create the cross-reference table: checkouts.

What does the ERD for that look like?

## 🚀 Independent Practice :: Movies DB Lab

Navigate to the `lab` folder in this repo and follow the directions in the `README`. Note: This is a many-to-many exercise.

## Summary

To recap, here is a list of common relationships that you'll encounter when working with SQL:

| Relationship | Example|
| :--- | :--- |
| one-to-one | A User has ONE address |
| one-to-many | A book has MANY reviews |
| many-to-many | A User has MANY books and a book has MANY Users |

## 🚀 Independent Practice :: Library DB Lab

Navigate to the [library database](https://git.generalassemb.ly/sei-nyc-your-cohort/library_sql) repo and follow the directions in the `README`.


# Further Practice

- [SQL for Beginners](https://www.codewars.com/collections/sql-for-beginners/): Created by WDI14 graduate and current GA instructor Mike Nabil.
- [SQL Zoo](https://sqlzoo.net/)
- [Code School Try SQL](https://www.codeschool.com/courses/try-sql)
- [W3 Schools SQL tutorial](https://www.w3schools.com/sql/)
- [Postgres Guide](http://postgresguide.com/)
- [SQL Course](http://www.sqlcourse.com/)
- [aggregate functions](http://www.postgresqltutorial.com/postgresql-aggregate-functions/)
