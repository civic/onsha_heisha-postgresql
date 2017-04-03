DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;


CREATE TABLE t1(
    num integer primary key,
    name text
);
CREATE TABLE t2(
    num integer primary key,
    value text
);

INSERT INTO t1(num, name) VALUES(1, 'a'), (2, 'b'), (3, 'c');
INSERT INTO t2(num, value) VALUES(1, 'xxx'), (3, 'yyy'), (5, 'zzz');

