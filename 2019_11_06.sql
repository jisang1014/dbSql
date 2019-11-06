--그룹함수
--multi row function : 여러개의 행을 입력으로 하나의 결과 행을 생성
-- sum, max, nim, avg, count
-- GROUP BY col | express
-- SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능

-- 직원중 가장 높은 급여 조회
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

-- 부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;


--[실습 3]
SELECT case
        when deptno = 30 then 'ACCOUNTING'
        when deptno = 20 then 'RESEARCH'
        when deptno = 10 then 'SALES'
        end dname,
       max_sal, min_sal, avg_sal,sum_sal, count_SAL,count_mgr,count_ALL
FROM
    (SELECT 
           deptno,
           MAX(sal) max_sal,
           MIN(sal) min_sal,
           ROUND(AVG(sal),2) avg_sal,
           SUM(sal) sum_sal,
           COUNT(sal) count_SAL,
           COUNT(mgr) count_mgr,
           COUNT(*) count_ALL
    FROM emp
    GROUP BY deptno);


--FUNCTION group function [실습4]
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');


--FUNCTION group function [실습5]
SELECT TO_CHAR(hiredate,'YYYY') hire_YYYY, count(hiredate)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');


--FUNCTION group function [실습5]
SELECT count(*) cnt
FROM dept;


-- //////////////////////////////////////////////////////////////////////////


-- JOIN
-- emp 테이블에는 dname 컬럼이 없다. --> 부서번호(deptno)밖에 없음

-- emp테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
alter TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO = 20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO = 30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN dname;

SELECT *
FROM emp;


--ansi natural join : 테이블의 컬럼명이 같은 컬럼을 기준으로 join
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;


--ORACOM join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;


--ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from 절에 join 대상 테이블 나열
--where 절에 join 조건 기술

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

    --jobd이 sales인 사람만 대상으로 조회
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
  AND emp.deptno = dept.deptno;

    --jobd이 sales인 사람만 대상으로 조회
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN';


--JOIN with ON (개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- SELF JOIN: 같은 테이블끼리 join
-- emp테이블의 mgr 정보를 참고하기 위해서 emp테이블과 join을 해야한다.
-- a: 직원 정보, b: 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno)
WHERE a.empno between 7367 AND 7698;


SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno between 7367 AND 7698;

-- 크로스 join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = '7367';
 
 
 -- non-equijoing (등식 join이 아닌 경우)
 SELECT *
 FROM salgrade; --급여등급
 
 --직원의 급여 등급은????
 SELECT *
 FROM emp;
 
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
 
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);


--[실습 0]
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
ORDER BY emp.deptno;
 
 
 --[실습 0_1]
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE emp.deptno IN(10,30);
 
 
 
 
 
 
 
 
 
 












