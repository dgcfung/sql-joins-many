DROP TABLE if exists books;
DROP TABLE if exists reviews;

CREATE TABLE books (
  id SERIAL,
  title VARCHAR(100) NOT NULL,
  author VARCHAR(100) NOT NULL,
  published_date TIMESTAMP NOT NULL,
  isbn CHAR(12),
  PRIMARY KEY (id),
  UNIQUE (isbn)
);

CREATE TABLE reviews (
  id SERIAL,
  book_id INTEGER NOT NULL,
  reviewer_name VARCHAR(255),
  content VARCHAR(255),
  rating INTEGER,
  published_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

INSERT INTO books (id, title, author, published_date, isbn)
VALUES
  (1, 'My First SQL Book', 'Mary Parker', '2012-02-22 12:08:17.320053-03', '981483029127'),
  (2, 'My Second SQL Book', 'John Mayer', '1972-07-03 09:22:45.050088-07', '857300923713'),
  (3, 'My First SQL Book', 'Cary Flint', '2015-10-18 14:05:44.547516-07', '523120967812');

INSERT INTO reviews (id, book_id, reviewer_name, content, rating, published_date)
VALUES
  (1, 1, 'John Smith', 'My first review', 4, '2017-12-10 05:50:11.127281-02'),
  (2, 2, 'John Smith', 'My second review', 5, '2017-10-13 15:05:12.673382-05'),
  (3, 2, 'Alice Walker', 'Another review', 1, '2017-10-22 23:47:10.407569-07');
