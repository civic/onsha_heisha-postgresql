DROP TABLE IF EXISTS places;
DROP TYPE IF EXISTS map_view_position;

CREATE TYPE map_view_position AS (
    latitude numeric,
    longitude numeric,
    zoom integer
);

CREATE TABLE places (
    name text primary key,
    pos map_view_position
);


INSERT INTO places VALUES
    ('新潟駅', ROW(37.9068379,139.0573775,16)),
    ('長岡市', ROW(37.4435243,138.6035752,10)),
    ('ニューヨーク', ROW(39.953089,-75.0634726,8))
    ;

SELECT * FROM places WHERE (pos).latitude <= 38;
