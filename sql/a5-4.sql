CREATE USER foobar;
GRANT SELECT ON emp TO foobar;


ALTER TABLE emp ENABLE ROW LEVEL SECURITY;
CREATE POLICY emp_reader ON emp TO foobar USING (job='SALESMAN');
