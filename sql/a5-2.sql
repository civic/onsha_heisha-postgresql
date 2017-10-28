DROP TABLE IF EXISTS circles;
CREATE TABLE circles(
    c circle,
    EXCLUDE USING gist(c WITH &&)
);
INSERT INTO circles VALUES('<(0, 0), 5>');
INSERT INTO circles VALUES('<(10, 0), 5>');


