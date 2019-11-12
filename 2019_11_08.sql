-- JOIN 복습
-- JOIN을 사용하는 이유: RDBMS의 특성상 데이터의 중복을 최대한 배재하고 설계를 해야한다.
-- EMP테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는 부서번호만 갖고있고, 부서번호를 통해 dept테이블과 조인을 통해 해당 부서의 정보를 가져올 수 있다.

-- 직원번호, 직원 이름, 직원의 소속 부서번호, 부서이름
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;


-- 부서번호, 부서명, 해당부서의 인원수 ======================================================================
-- COUNT(col): col 값이 존재하면 1, null: 0
--             행수가 궁금한 것이면 *


--[오라클]
SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

--[ANSI]
SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
GROUP BY emp.deptno, dname;


-- OUTER JOIN: join에 실패해도 기준이 되는 테이블의 뎅턴느 조회 결과가 출력되도록 하는 join형태
-- Left JOIN: JOIN KEYWORD 왼쪽에 위치한 테이블이 조회기준이 되도록 하는 형태
-- RIGHT OUTER JOINL: JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이 되도록 하는 형태
-- FULL OUTER JOIN: LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

-- 직원 정보, 해당 직원의 관리자 정보 outer join
-- 직원 번호, 직원이름 관리자번호 관리자이름


SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--ORACLE OUTER JOIN (left, right만 존재. fullouter는 지원하지 않음)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);


SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp  a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno)
WHERE b.deptno = 10;


--oracle outer 문법에서는 OUTER 테이블이 되는 모든 컬럼에 (+)를 붙여줘야 outer join이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
  AND b.deptno(+) = 10;


-- ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);



-- 데이터결합 [outer join 실습 1] =====================================================================
SELECT buy_date, buy_prod, prod_id, prod.prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON(prod.prod_id = buyprod.buy_prod 
                                  AND TO_CHAR(buy_date, 'YYMMDD') = '050125');


-- 데이터결합 [outer join 실습 2] =====================================================================
SELECT TO_DATE('05/01/25') buy_date, buy_prod, prod_id, prod.prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON(prod.prod_id = buyprod.buy_prod 
                                  AND TO_CHAR(buy_date, 'YYMMDD') = '050125');
                                 

-- 데이터결합 [outer join 실습 3] =====================================================================
SELECT TO_DATE('05/01/25') buy_date, buy_prod, prod_id, prod.prod_name, NVL(buy_qty, 0)
FROM prod LEFT OUTER JOIN buyprod ON(prod.prod_id = buyprod.buy_prod 
                                  AND TO_CHAR(buy_date, 'YYMMDD') = '050125');
                                  
                                  
-- 데이터결합 [outer join 실습 4] =====================================================================
--cycle: cid pid day cnt
--product: pid pnm
 
SELECT product.pid, pnm, NVL(cid,0) cid, NVL(day,0) day, NVL(cnt, 0) cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = 1);


-- 데이터결합 [outer join 실습 5] =====================================================================
SELECT a.pid, a.pnm, a.cid, NVL(cnm, 0) cnm ,a.day, a.cnt
FROM
    (SELECT product.pid, pnm, NVL(cid,0) cid, NVL(day,0) day, NVL(cnt, 0) cnt
     FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = 1)) a
     LEFT OUTER JOIN customer ON (a.cid = customer.cid);
                                  
                                  
-- 데이터결합 [cross join 실습 1] =====================================================================
SELECT cid, cnm, pid, pnm
FROM customer, product;



-- /////////////////////////////////////////////////////////////////////////////////
-- subquery: main쿼리에 속하는 부분 쿼리
-- 사용되는 위치:
-- SELECT - scalar subquery (하나의 행과, 하나의 컬럼만 조회되는 쿼리여야 한다.)
-- FROM - inline view (
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now   /*현재날짜*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now
FROM emp;


SELECT deptno       --20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno       --20
                FROM emp
                WHERE ename = 'SMITH');
                
SELECT *
FROM emp;


-- 서브쿼리 [실습 1] =====================================================================
SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);


-- 서브쿼리 [실습 2] =====================================================================
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
            
-- 서브쿼리 [실습 3] =====================================================================

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));





