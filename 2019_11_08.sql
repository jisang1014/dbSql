-- JOIN ����
-- JOIN�� ����ϴ� ����: RDBMS�� Ư���� �������� �ߺ��� �ִ��� �����ϰ� ���踦 �ؾ��Ѵ�.
-- EMP���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ������� �μ���ȣ�� �����ְ�, �μ���ȣ�� ���� dept���̺�� ������ ���� �ش� �μ��� ������ ������ �� �ִ�.

-- ������ȣ, ���� �̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;


-- �μ���ȣ, �μ���, �ش�μ��� �ο��� ======================================================================
-- COUNT(col): col ���� �����ϸ� 1, null: 0
--             ����� �ñ��� ���̸� *


--[����Ŭ]
SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

--[ANSI]
SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
GROUP BY emp.deptno, dname;


-- OUTER JOIN: join�� �����ص� ������ �Ǵ� ���̺��� ���ϴ� ��ȸ ����� ��µǵ��� �ϴ� join����
-- Left JOIN: JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ������ �ǵ��� �ϴ� ����
-- RIGHT OUTER JOINL: JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ����
-- FULL OUTER JOIN: LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

-- ���� ����, �ش� ������ ������ ���� outer join
-- ���� ��ȣ, �����̸� �����ڹ�ȣ �������̸�


SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--ORACLE OUTER JOIN (left, right�� ����. fullouter�� �������� ����)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);


SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp  a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno)
WHERE b.deptno = 10;


--oracle outer ���������� OUTER ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ���� outer join�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
  AND b.deptno(+) = 10;


-- ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);



-- �����Ͱ��� [outer join �ǽ� 1] =====================================================================
SELECT buy_date, buy_prod, prod_id, prod.prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON(prod.prod_id = buyprod.buy_prod 
                                  AND TO_CHAR(buy_date, 'YYMMDD') = '050125');


-- �����Ͱ��� [outer join �ǽ� 2] =====================================================================
SELECT TO_DATE('05/01/25') buy_date, buy_prod, prod_id, prod.prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON(prod.prod_id = buyprod.buy_prod 
                                  AND TO_CHAR(buy_date, 'YYMMDD') = '050125');
                                 

-- �����Ͱ��� [outer join �ǽ� 3] =====================================================================
SELECT TO_DATE('05/01/25') buy_date, buy_prod, prod_id, prod.prod_name, NVL(buy_qty, 0)
FROM prod LEFT OUTER JOIN buyprod ON(prod.prod_id = buyprod.buy_prod 
                                  AND TO_CHAR(buy_date, 'YYMMDD') = '050125');
                                  
                                  
-- �����Ͱ��� [outer join �ǽ� 4] =====================================================================
--cycle: cid pid day cnt
--product: pid pnm
 
SELECT product.pid, pnm, NVL(cid,0) cid, NVL(day,0) day, NVL(cnt, 0) cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = 1);


-- �����Ͱ��� [outer join �ǽ� 5] =====================================================================
SELECT a.pid, a.pnm, a.cid, NVL(cnm, 0) cnm ,a.day, a.cnt
FROM
    (SELECT product.pid, pnm, NVL(cid,0) cid, NVL(day,0) day, NVL(cnt, 0) cnt
     FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = 1)) a
     LEFT OUTER JOIN customer ON (a.cid = customer.cid);
                                  
                                  
-- �����Ͱ��� [cross join �ǽ� 1] =====================================================================
SELECT cid, cnm, pid, pnm
FROM customer, product;



-- /////////////////////////////////////////////////////////////////////////////////
-- subquery: main������ ���ϴ� �κ� ����
-- ���Ǵ� ��ġ:
-- SELECT - scalar subquery (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �������� �Ѵ�.)
-- FROM - inline view (
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now   /*���糯¥*/
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


-- �������� [�ǽ� 1] =====================================================================
SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);


-- �������� [�ǽ� 2] =====================================================================
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
            
-- �������� [�ǽ� 3] =====================================================================

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));





