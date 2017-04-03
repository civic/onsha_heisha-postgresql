DROP TABLE IF EXISTS reservation;

CREATE TABLE reservation(
    during daterange,
    EXCLUDE USING GIST(during WITH &&)
);

INSERT INTO reservation VALUES('[2017-03-10, 2017-03-12]');
INSERT INTO reservation VALUES('[2017-03-11, 2017-03-13]'); --重なりがあるのでエラー

CREATE EXTENSION btree_gist;

DROP TABLE IF EXISTS room_reservation;
CREATE TABLE room_reservation(
    room text,
    during daterange,
    EXCLUDE USING GIST(room WITH =, during WITH &&)
);
INSERT INTO room_reservation VALUES('1', '[2017-03-10, 2017-03-12]');
INSERT INTO room_reservation VALUES('2', '[2017-03-11, 2017-03-13]'); --違うroomは重なりがあってもよい
INSERT INTO room_reservation VALUES('1', '[2017-03-12, 2017-03-15]'); --重なりがあるのでエラー



