-- emp테이블에는 부서번호(deftno)만 존재
-- emp 테이블에서 부서명을 조회하기 위해서는 dept 테이블과 join을 통해 부서명 조회

-- JOIN 문법
-- ANSI: 테이블 JOIN 테이블2 ON (테이블.COL = 테이블2.COL);
--       emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE : FROM 테이블, 테이블2
--          WHERE 테이블.COL = 테이블2.COL
            
--          FROM emp, dept
--          WHERE emp.deptno = dept.deptno



SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);


--데이터결합 [실습 0_2] =============================================================

SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE sal > 2500
ORDER BY deptno;

SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
  AND sal > 2500
ORDER BY deptno;

--데이터결합 [실습 0_3] =============================================================
SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE sal > 2500
  AND empno > 7600
ORDER BY deptno;

SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500
  AND empno > 7600
ORDER BY deptno;

--데이터 결합 [실습 0_4] =============================================================
SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE sal > 2500
  AND empno > 7600
  AND dname = 'RESEARCH'
ORDER BY deptno;

SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500
  AND empno > 7600
  AND dname = 'RESEARCH'
ORDER BY deptno;


SELECT *
FROM prod;

SELECT *
FROM lprod;

--데이터 결합 [실습 1] =============================================================
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod JOIN lprod ON(prod.prod_lgu = lprod.lprod_gu)
ORDER BY prod_id;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu
ORDER BY prod_id;

--데이터 결합 [실습 2] =============================================================
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON(prod.prod_buyer = buyer.buyer_id)
ORDER BY prod_id;


--데이터 결합 [실습 3] =============================================================
SELECT member.mem_id, member.mem_name, prod_id, prod_name, cart.cart_qty
FROM (member JOIN cart ON(member.mem_id = cart.cart_member))
      JOIN prod ON (cart_prod = prod.prod_id);

SELECT a.mem_id, a.mem_name, prod_id, prod_name, a.cart_qty
FROM
    (SELECT *
     FROM member JOIN cart ON(member.mem_id = cart.cart_member)) a
     JOIN prod ON(a.cart_prod = prod.prod_id);

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM cart, member, prod
WHERE member.mem_id = cart.cart_member
  AND cart_prod = prod.prod_id;



--데이터 결합 [실습 4] =============================================================
SELECT*
FROM customer;  --cid cnm(이름)

SELECT*
FROM cycle; --cid pid day cnt

SELECT*
FROM product;  --pid, pnm


SELECT customer.cid, customer.cnm,pid,day,cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid)
WHERE cnm IN('brown', 'sally');


--데이터 결합 [실습 5] =============================================================
SELECT customer.cid, customer.cnm, product.pnm, cycle.day, cycle.cnt
FROM (customer JOIN cycle ON(customer.cid = cycle.cid)) JOIN product ON(cycle.pid = product.pid)
WHERE cnm IN('brown', 'sally');


--데이터 결합 [실습 6] =============================================================

SELECT customer.cid, customer.cnm, product.pid, product.pnm, sum(cnt) AS cnt
FROM (customer JOIN cycle ON(customer.cid = cycle.cid)) JOIN product ON(cycle.pid = product.pid)
GROUP BY customer.cid, customer.cnm, product.pid, product.pnm;

GROUP BY cid, pid

SELECT *
FROM cycle;


--데이터 결합 [실습 7] =============================================================

SELECT cycle.pid, product.pnm, SUM(cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm;










