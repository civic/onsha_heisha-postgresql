DROP INDEX IF EXISTS idx_books_info;

SELECT * FROM books WHERE price <= 1100 AND info @> '{"format": "pdf"}'::jsonb;

SELECT * FROM books WHERE info @> '{"tags": ["japanese", "comic", "science",  "nature"]}'::jsonb;

EXPLAIN SELECT * FROM books WHERE info @> '{"tags": ["japanese", "comic", "science",  "nature"]}'::jsonb;

CREATE INDEX idx_books_info ON books USING GIN(info);

EXPLAIN SELECT * FROM books WHERE info @> '{"tags": ["japanese", "comic", "science",  "nature"]}'::jsonb;
