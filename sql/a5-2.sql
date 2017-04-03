DROP TABLE IF EXISTS schedules;
CREATE TABLE schedules(
    name text primary key,
    start_end int4range,
    EXCLUDE USING gist (start_end WITH &&)
);



