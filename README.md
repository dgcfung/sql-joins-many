# LECTURE_U02_D04

# Relationships in SQL / SQL JOINs

## Learning Objectives

- Define what a foreign key is
- Describe how to represent a one-to-many relationship in SQL database
- Explain how to represent one-to-one and many-to-many relationships in a SQL DB
- Distinguish between keys, foreign keys, and indexes
- Describe the purpose of the JOIN
- Use JOIN to combine tables in a SELECT
- Describe what it means for a database to be normalized

## Review: Carmen Sandiego

Going back to the Carmen Sandiego homework, recall that there were three tables
in the database schema, viz., `city`, `country`, and `countrylanguage`.  If we wanted
to access data from more than one table, multiple SQL queries were needed.

For example, to get all the languages spoken in the Netherlands, first we would
need a SQL statement to get the countrycode for the Netherlands
```sql
carmen=# SELECT code FROM country WHERE name = 'Netherlands';
-[ RECORD 1 ]
code | NLD
```

Then a second SQL statement to get the languages that match that
```sql
carmen=# SELECT * FROM countrylanguage WHERE countrycode = 'NLD';
. . .
```

But this is very verbose and makes gathering complex data tedious, as the
sequence of clues/queries from the homework probably made clear.
The next step in effectively analyzing and organizing our data is grounded
in `relationships`, as in relational database.


## Introduction

One of the key features of relational databases is that they can represent
relationships between rows in different tables.

Consider spotify, we could start out with two tables, `artist` and `track`.
Our goal now is to somehow indicate the relationship between an artist and a track.
In this case, that relationship indicates who performed the track.

You can imagine that we'd like to use this information in a number of ways, such as...
- Getting the artist information for a given track
- Getting all tracks performed by a given artist
- Searching for tracks based on attributes of the artist (e.g., all tracks
  performed by artists at Interscope)

## Domain Modeling

Domain Modeling allows us to outline the data values that we need to persist.
- We only consider the specific data our application needs, but not the behavior of the application
- A domain model in problem solving and software engineering is a conceptual model of all items and topics related to a specific problem
- It describes the various entities, their attributes, roles and relationships, plus the constraints that govern the problem domain

The big takeaway here is that domain modeling **does not describe solutions to the problem**. Instead, it defines how our data is structured.

### ERDs

An ERD -- or **Entity Relationship Diagram** -- is a tool we use to visualize and describe the data relating to the major entities that will exist in our programs.
- Ultimately lends itself to planning out and creating our database table structure
- It allows us to outline the data in our application, not the behavior

### Example: An Orchard

Take a minute to look through the below diagram. Note down any observations you have.

![orchard example](images/orchard.png)

- The squares represent our entities and are filled with the attributes associated with our entity.
- The arrows between the squares indicate how the entities relate to one another.

### Relationships

![relationships](images/sample-relationships.png)

**One-to-one:** A Country has one Capital City
- Usually denotes that one entity should be an attribute of the other
- Usually separated for physical space considerations

**One-to-many:** A Location has many Cohorts
- The most common relationship you will define in WDI.

**Many-to-many:** A Membership has many Assignments through Submissions, and an Assignment has many Memberships through Submissions.
- Requires a join table. In this example, that is Submissions.

#### ERD Symbols Guide
<details>
  <summary> Legend </summary>
  <img src="./images/erd-notation.png">
</details>

## JOINS

To `SELECT` information on two or more tables at ones, we can use a `JOIN` clause.
This will produce rows that contain information from both tables. When joining
two or more tables, we have to tell the database how to match up the rows.
(e.g. to make sure the author information is correct for each book).

This is done using the `ON` clause, which specifies which properties to match.

```SQL
SELECT country.language
FROM countrylanguage
JOIN country ON country.code = countrylanguage.countrycode
WHERE country.name = 'Netherlands';
```

Notice that now we should include the table name for each column.
In some cases this isn't necessary where SQL can disambiguate the columns
between the various tables, but it makes parsing the statement much easier
when table names are explicitly included.

Also, our select items can be more varied now and include either all or
just some of the columns from the associated tables.

```SQL
SELECT *
FROM country
JOIN countrylanguage ON country.code = countrylanguage.countrycode
WHERE country.name = 'Brazil';
```

```SQL
SELECT country.indepyear, city.district
FROM city
JOIN country ON country.code = city.countrycode
WHERE city.name = 'Kabul';
```
## You Do (Carmen Practice) 15 min
- Find the name of the country where `Mendoza` is located
- Write a query that returns the country's head of state and the city's district
  where the city name is `Araguari`.
- Going back to the first two hints of the [Carmen homework](https://git.generalassemb.ly/wdi-nyc-thundercats/HW_U02_D02_SQL_APIs/tree/master/sql), try to find the
  language spoken in the least populous city in Southern Europe.

- Bonus: See how many clues you can solve using joins.  This may require a few
  small adjustments :)

## Building it up again
Let's build out our spotify database, starting with artist, album, and track.
Note how id's are PRIMARY KEYs, and relationships are established when these
ids are referenced by other tables.

```sql
CREATE TABLE artist(
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255)
);


CREATE TABLE album(
  name VARCHAR(255),
  label VARCHAR(255),
  id VARCHAR(255) PRIMARY KEY
);

CREATE TABLE track(
  name VARCHAR(255),
  artist_id VARCHAR(255),
  album_id VARCHAR(255),
  disc_number INTEGER,
  popularity INTEGER,
  id VARCHAR(255) PRIMARY KEY
);
```

### What could go wrong?
There are no explicit checks to ensure that we're actually obeying these references.

### Solution: Foreign Keys
To remedy this problem, we can instruct the database to ensure that the relationships
between tables are valid, and that new records cannot be inserted that break these
constraints.  In other words, the `referential integrity` of our data is maintained.

By using the `REFERENCES` keyword, foreign key constraints can be added to the schema.
```SQL
CREATE TABLE track(
  name VARCHAR(255),
  artist_id VARCHAR(255) REFERENCES artist(id),
  album_id VARCHAR(255) REFERENCES album(id),
  disc_number INTEGER,
  popularity INTEGER,
  id VARCHAR(255) PRIMARY KEY
);
```

Note: `\d+` and a table name displays a helpful view of the structure of a table along with
its relationships and constraints.

## Join tables
Join Tables are used for Many-to-Many relationships.  They typically consist
of at minimum, two foreign keys and possibly other metadata:

```SQL
CREATE TABLE spotify_user(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE likes(
  user_id SERIAL REFERENCES spotify_user(id),
  track_id VARCHAR(255) REFERENCES track(id),
  confirmed BOOLEAN DEFAULT FALSE
);
```

[Further reading on joins with visual guide](https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)

Also, `AS` can be used to give more descriptive names to the values returned
by join clauses:

```sql
SELECT country.name AS countryName, countrylanguage.isofficial AS isLangOfficial
FROM country
JOIN countrylanguage ON country.code = countrylanguage.countrycode
WHERE country.name = 'Brazil';
```

# Lab Join Queries
### first clone this repo
### `createdb musicdb`
### `psql -d musicdb -f seed.sql`

- Identify all relations/constraints on the track table, are there any others?
- Find all songs released on albums from the `Interscope` label
- Find all of Beyoncé's tracks
- Find all of the disc numbers only for Beyonce's tracks
- Find all of the names of Beyoncé's albums
- Find all of the album names, track names, and artist id associated with Beyoncé
- Find all songs released on `Virgin Records` that have a `popularity` score > 30
- Find the artist who has released tracks on the most albums
    Hint: The last few may need more than one `join` clause each

# Further Practice

- [SQL for Beginners](https://www.codewars.com/collections/sql-for-beginners/): Created by WDI14 graduate and current GA instructor Mike Nabil.
- [SQL Zoo](https://sqlzoo.net/)
- [Code School Try SQL](https://www.codeschool.com/courses/try-sql)
- [W3 Schools SQL tutorial](https://www.w3schools.com/sql/)
- [Postgres Guide](http://postgresguide.com/)
- [SQL Course](http://www.sqlcourse.com/)
