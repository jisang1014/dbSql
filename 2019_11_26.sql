SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;


--ana1
SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;


--no_ana2
--부서별 인원수
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT ename, empno, emp.deptno, b.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
           FROM emp
           GROUP BY deptno ) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;


--분석함수를 통한 부서별 직원수 (COUNT)
SELECT ename, empno, deptno, 
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--부서별 사원의 급여 합계
--SUM 분석함수
SELECT ename, empno, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--ana2
SELECT empno, ename, sal, deptno, /*부서별 급여평균 소수점 두자리까지*/
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;


-- no_ana [실습 3] ===================================================================
SELECT a_1.empno, a_1.ename, a_1.sal, sum(b_1.sal) c_sum
FROM
    (SELECT a.*, rownum a_rn FROM(SELECT empno, ename, sal FROM emp ORDER BY sal, empno) a) a_1,
    (SELECT rownum b_rn, b.* FROM (SELECT sal FROM emp ORDER BY sal, empno) b) b_1
WHERE a_1.a_rn >= b_1.b_rn(+)
GROUP BY a_1.empno, a_1.ename, a_1.sal
ORDER BY a_1.sal, a_1.emono;



SELECT a_1.empno, a_1.ename, a_1.sal, sum(b_1.sal), NVL(a_1.sal+b_1.sal, a_1.sal) c_sum
FROM
    (SELECT a.*, rownum a_rn FROM(SELECT empno, ename, sal FROM emp ORDER BY sal, empno) a) a_1,
    (SELECT rownum b_rn, b.* FROM (SELECT sal FROM emp ORDER BY sal, empno) b) b_1
WHERE a_1.a_rn >= b_1.b_rn(+)
ORDER BY a_1.sal;


-- WINDOWING
-- UNBOUNDED PRECEDING: 현재 행을 기준으로 선행하는 모든 행
-- CURRENT ROW: 현재 행
-- UNBOUNDED FOLLOWING: 현재 행을 기준으로 후행하는 모든 행
-- N(정수) PRECEDING: 현재 행을 기준으로 선행하는 N개의 행
-- N(정수) FOLLOWING: 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
                      
       SUM(sal) OVER (ORDER BY sal, empno
                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
    
       SUM(sal) OVER (ORDER BY sal, empno
                      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal2
FROM emp;



-- ana [실습7] ======================================================================================
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;


SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
       
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;




















