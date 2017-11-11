SELECT DISTINCT ON (job) job "役職", ename "代表社員" FROM emp;

SELECT DISTINCT job "役職", FIRST_VALUE(ename) OVER(PARTITION BY job) "代表社員" FROM emp;

SELECT job "役職", (SELECT ename FROM emp WHERE emp.job=e.job LIMIT 1) "代表社員" FROM emp e GROUP BY job;
