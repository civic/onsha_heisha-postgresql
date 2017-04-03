DROP TABLE IF EXISTS uesrs;
CREATE TABLE users(
    user_id integer primary key,
    screen_name text NOT NULL UNIQUE,
    gold integer CHECK(gold >=0) NOT NULL 
);

