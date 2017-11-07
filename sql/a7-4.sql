SELECT job, MAX(sal) FROM emp GROUP BY job;
SELECT job, MAX(sal), RANK() OVER(ORDER BY MAX(sal) DESC) FROM emp GROUP BY job;
SELECT job, MAX(sal), RANK() OVER(ORDER BY MAX(sal) DESC) FROM emp GROUP BY job HAVING MAX(sal) < 3000;
SELECT * FROM (SELECT job, MAX(sal), RANK() OVER(ORDER BY MAX(sal) DESC) FROM emp GROUP BY job) s WHERE s.max < 3000;
