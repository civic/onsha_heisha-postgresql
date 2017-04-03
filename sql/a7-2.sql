SELECT * FROM generate_series(3, 7);

SELECT * FROM ROWS FROM(generate_series(3, 7), generate_series(5, 7)) AS g(g1, g2);

SELECT * FROM ROWS FROM(generate_series(3, 7), generate_series(5, 7)) WITH ORDINALITY AS g(g1, g2);
