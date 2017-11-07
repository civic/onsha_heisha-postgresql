
CREATE ROLE heisha;

GRANT heisha TO shain1;

CREATE TABLE hoge(id integer);

GRANT SELECT ON hoge TO heisha;

CREATE ROLE shain2 LONIN NOINHERIT;

GRANT heisha TO shain2;
