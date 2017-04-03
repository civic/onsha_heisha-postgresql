DROP TABLE IF EXISTS emp_sales;
DROP TABLE IF EXISTS emp_other;
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS dept;

CREATE TABLE dept(  
      deptno     int primary key,  
      dname      varchar(14),  
      loc        varchar(13)
);
CREATE TABLE emp(  
      empno    int primary key,
      ename    varchar(10),  
      job      varchar(9),  
      mgr      numeric(4,0),  
      hiredate date,  
      sal      numeric(7,2),  
      comm     numeric(7,2),  
      deptno   int references dept(deptno)
);

-- パーティション作成
CREATE TABLE emp_sales (
    CHECK (job = 'SALESMAN')
) INHERITS (emp);

CREATE TABLE emp_other (
    CHECK (job != 'SALESMAN')
) INHERITS (emp);

-- パーティションごとのindex作成
CREATE INDEX idx_emp_sales_job ON emp_sales(job);
CREATE INDEX idx_emp_other_job ON emp_other(job);

-- triger関数の作成
CREATE OR REPLACE FUNCTION emp_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF ( NEW.job = 'SALESMAN') THEN
        INSERT INTO emp_sales VALUES (NEW.*);
    ELSE
        INSERT INTO emp_other VALUES (NEW.*);
    END IF;

    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

-- trigerの登録
CREATE TRIGGER insert_emp_trigger
    BEFORE INSERT ON emp
    FOR EACH ROW EXECUTE PROCEDURE emp_insert_trigger();


INSERT INTO dept (deptno, dname, loc) VALUES
    (10, 'ACCOUNTING', 'NEW YORK'),
    (20, 'RESEARCH', 'DALLAS'),
    (30, 'SALES', 'CHICAGO'),
    (40, 'OPERATIONS', 'BOSTON');

INSERT INTO emp VALUES
    (7839, 'KING', 'PRESIDENT', null,  '1981-11-17',  5000, null, 10),
    (7698, 'BLAKE', 'MANAGER', 7839,  '1981-5-1',  2850, null, 30  ),
    (7782, 'CLARK', 'MANAGER', 7839,  '1981-6-9',  2450, null, 10  ),
    (7566, 'JONES', 'MANAGER', 7839,  '1981-4-2',  2975, null, 20  ),
    (7788, 'SCOTT', 'ANALYST', 7566,  '1987-7-13',  3000, null, 20  ),
    (7902, 'FORD', 'ANALYST', 7566,  '1981-12-3',  3000, null, 20  ),
    (7369, 'SMITH', 'CLERK', 7902,  '1980-12-17',  800, null, 20  ),
    (7499, 'ALLEN', 'SALESMAN', 7698,  '1981-2-20',  1600, 300, 30  ),
    (7521, 'WARD', 'SALESMAN', 7698,  '1981-2-22',  1250, 500, 30  ),
    (7654, 'MARTIN', 'SALESMAN', 7698,  '1981-9-28',  1250, 1400, 30  ),
    (7844, 'TURNER', 'SALESMAN', 7698,  '1981-9-8',  1500, 0, 30  ),
    (7876, 'ADAMS', 'CLERK', 7788,  '1987-7-13',   1100, null, 20  ),
    (7900, 'JAMES', 'CLERK', 7698,  '1981-12-3',  950, null, 30  ),
    (7934, 'MILLER', 'CLERK', 7782,  '1982-1-23',  1300, null, 10  );
