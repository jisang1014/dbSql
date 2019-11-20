-- GROUPING (cube, rollup 절에 사용된 컬럼(
-- 해당 컬럼이 소계 계산에 사용된 경우 1
-- 사용되지 않은 경우 0


-- job 컬럼
-- case1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--        job --> '총계'
-- case else
--        job --> job
SELECT job, deptno,
    GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계'
            ELSE job
        END job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '[총계] ----'
            ELSE job
        END job, 
       CASE WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 0 THEN job || ' 소계' 
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '-----------> '
            ELSE TO_CHAR(deptno)
        END deptno,
        SUM(sal) sal, GROUPING(job) gjob, GROUPING(deptno) gdeptno
FROM emp
GROUP BY ROLLUP(job, deptno);



-- =========================================================================
-- GROUP BY ROLLUP [실습 4] /////////////////////////////////////////////////
-- =========================================================================
SELECT dname, job, sum(sal) sal
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
GROUP BY rollup(dname, job)
ORDER BY dname, job desc;


-- =========================================================================
-- GROUP BY ROLLUP [실습 5] /////////////////////////////////////////////////
-- =========================================================================
SELECT CASE WHEN GROUPING(dname) = 1 AND GROUPING(job) = 1 THEN '총합'
            ELSE dname
        END dname, job, sum(sal) sal
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
GROUP BY rollup(dname, job)
ORDER BY dname, job desc;





-- =========================================================
-- CUBE (col, col2...)
-- GROUP BY CUBE (job, deptno)
-- OO : GROUP BY job, deptno
-- OX : GROUP BY job
-- XO : GROUP BY deptno
-- XX : GROUP BY -- 모든 데이터에 대해서

-- GROUP BY CUBE(job, deptno, mgr) **경우의 수가 2의 (콜럼갯수)승으로 늘어남


SELECT job, deptno, sum(sal)
FROM emp
GROUP BY CUBE(job, deptno);


-- ======================================================================
-- subquery를 통한 업데이트
DROP TABLE emp_test;

-- emp테이블의 데이터를 포함해서 모드 컬럼을 emp_test테이블로 생성
CREATE TABLE emp_test AS 
    SELECT *
    FROM emp;


--emp_test 테이블의 dept테이블에서 관리되고 있는 dname컬럼(VARCHAR2(14)을 추가
SELECT *
FROM emp_test;

ALTER TABLE emp_test ADD ( dname VARCHAR2(14));


--emp_test 테이블의 dname 컬럼을 dept테이블의 dname 컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = ( SELECT dname
                              FROM dept
                              WHERE dept.deptno = emp_test.deptno );
commit;


-- =========================================================================
-- 서브쿼리 [실습 1] /////////////////////////////////////////////////////////
-- =========================================================================
DROP TABLE dept_test;

SELECT *
FROM dept_test;

commit;

--1
CREATE TABLE dept_test AS
            SELECT *
            FROM dept;
--2
ALTER TABLE dept_test ADD ( empcnt NUMBER(4));
--3
UPDATE dept_test SET empcnt = ( SELECT count(*)
                                FROM emp
                                WHERE dept_test.deptno = emp.deptno);
                                
                                
                                
-- =========================================================================
-- 서브쿼리 [실습 2] /////////////////////////////////////////////////////////
-- =========================================================================                                    
INSERT INTO DEPT_test VALUES (98, 'it', 'daejeon', 0);

DELETE FROM dept_test
WHERE empcnt = (SELECT count(*)
                FROM emp
                HAVING count(*) = 0);
                
DELETE FROM dept_test
WHERE deptno NOT IN (SELECT * FROM emp);

DELETE FROM dept_test
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE emp.deptno = dept.deptno);

SELECT *
FROM dept_test;
 
 
 
 SELECT *
 FROM emp_test;
 
 rollback;
-- =========================================================================
-- 서브쿼리 [실습 3] /////////////////////////////////////////////////////////
-- =========================================================================  
 

UPDATE emp_test a SET sal = sal+200
WHERE sal < (SELECT AVG(sal)
              FROM emp_test b
              WHERE a.deptno = b.deptno);    
              
--emp, emp_test, emp 컬럼으로 같은 값끼리 조회
--emp.empno, emp.ename, emp.sal, emp_test.sal
 
 
 
 
SELECT empno, ename, sal, sal_1, a.deptno, TRUNC(b.sal_avg,2)sal_avg
FROM  
    (SELECT emp.deptno deptno, emp.empno, emp.ename, emp.sal, emp_test.sal sal_1
     FROM emp JOIN emp_test ON (emp.empno = emp_test.empno))a
     
     JOIN (SELECT deptno, avg(sal) sal_avg FROM emp GROUP BY deptno)b ON(a.deptno = b.deptno);



 



