DROP TABLE IF EXISTS tbl_ins_ret;

CREATE TABLE tbl_ins_ret(
    id SERIAL PRIMARY KEY,
    name TEXT
);


INSERT INTO tbl_ins_ret VALUES(DEFAULT, 'Hello'), (DEFAULT, 'World') RETURNING *;
