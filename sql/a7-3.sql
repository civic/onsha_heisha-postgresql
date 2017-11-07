SELECT job FROM emp GROUP BY job;

SELECT job, AVG(sal) FROM emp GROUP BY job;

SELECT job, AVG(sal) FROM emp WHERE sal < 3000 GROUP BY job;

SELECT job, AVG(sal) FROM emp WHERE sal < 3000 GROUP BY job HAVING AVG(sal) >= 2000;
