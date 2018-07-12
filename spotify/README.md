## Further Lab

- first clone this repo
- Navigate to `spotify`
-  `createdb musicdb`
- `psql -d musicdb -f seed.sql`

Then do the following:

- Identify all relations/constraints on the track table, are there any others?
- Find all songs released on albums from the `Interscope` label
- Find all of Beyoncé's tracks
- Find all of the disc numbers only for Beyonce's tracks
- Find all of the names of Beyoncé's albums
- Find all of the album names, track names, and artist id associated with Beyoncé
- Find all songs released on `Virgin Records` that have a `popularity` score > 30
- Find the artist who has released tracks on the most albums
    Hint: The last few may need more than one `join` clause each
