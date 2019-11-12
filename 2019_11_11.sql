
--SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ

SELECT *
FROM emp
WHERE deptno in (10, 20);

SELECT *
FROM emp
WHERE deptno = 10
  AND deptno = 20;
  
SELECT *
FROM emp
WHERE deptno in (SELECT deptno FROM emp WHERE ename IN(:name1, :name2));
   
   
-- ==========================================================================
  
  
-- ANY : set�߿� �����ϴ� �� �ϳ��� ������ �� (ũ���)
-- SMITH, WARD �� ����� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE sal < any(SELECT sal -- 800, 1250
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
-- SMITH, WARD ���� �޿��� ���� ���� ��ȸ
-- SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
FROM emp;
WHERE sal > ALL(SELECT sal -- 800, 1250
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));               


-- ==========================================================================

-- NOT IN

--�������� ��������
-- 1. �������� ����� ��ȸ
--  . mgr �÷��� ���� ������ ����
SELECT DISTINCT mgr
FROM emp;

-- � ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN(7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                FROM emp);
-- ������ ������ ���� �ʴ� ���� ���� ��ȸ
-- �� NOT IN ������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
-- NULLó�� �Լ��� WHERE��(IS NOT NULL)�� ���� NULL���� ó���� �� ���
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp
                    WHERE mgr IS NOT NULL);

SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);


-- ==========================================================================
  
  
-- pair wise (������ ���ÿ� ����)

-- ��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
-- �����߿� �����ڿ� �μ���ȣ�� (7698,30) �̰ų� (7839,10)�� ���
-- mgr, deptno �÷��� [����]�� ������Ű�� ���� ���� ��ȸ
SELECT mgr, deptno
FROM emp
WHERE (mgr, deptno) IN ( SELECT mgr, deptno
                         FROM emp
                         WHERE empno IN(7499, 7782));

SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
             FROM emp
             WHERE empno IN(7499, 7782))
  AND deptno IN(SELECT deptno
                FROM emp
                WHERE empno IN(7499, 7782));


-- ==========================================================================


-- SCALAR SUBQUERY: SELECT ���� �����ϴ� ���� ����(��, ���� �ϳ��� ��, �ϳ��� �÷�)
-- ������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;
-- �̷��� ������ �ۼ��ϸ� 15�� �����...


-- �������� [�ǽ� 4] ==========================================================
-- ������ ����

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT (SELECT deptno
                             FROM dept   
                             WHERE deptno = emp.deptno) deptno 
                     FROM emp);
                     
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);


-- �������� [�ǽ� 5] ==========================================================
SELECT *
FROM cycle;  -- cid pid day cnt
SELECT *
FROM product;  -- pid pnm
SELECT *
FROM customer;  -- cid cnm


SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);


-- �������� [�ǽ� 6] ==========================================================
SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid
              FROM cycle
              WHERE cid = 2);


-- �������� [�ǽ� 7] ==========================================================
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM cycle JOIN product ON(cycle.pid = product.pid)
           JOIN customer ON(cycle.cid = customer.cid)
WHERE cycle.cid = 1
  AND cycle.pid IN (SELECT pid
                    FROM cycle
                    WHERE cid = 2);

-- ==========================================================================

-- EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
-- �����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������, ���ɸ鿡�� ����

-- MGR�� �����ϴ� ���� ��ȸ

SELECT *
FROM emp mainQ
WHERE NOT EXISTS (SELECT '.'
                  FROM emp subQ
                  WHERE subQ.empno = mainQ.mgr);
              
SELECT *
FROM emp mainQ
WHERE EXISTS (SELECT '.'
              FROM emp subQ
              WHERE subQ.empno = mainQ.mgr);
                  
                  
-- �������� [�ǽ� 8] ==========================================================
SELECT *
FROM emp
WHERE mgr IS NOT NULL;


-- �μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ (exists)
SELECT *
FROM dept
WHERE EXISTS (SELECT '.'
              FROM emp
              WHERE emp.deptno = dept.deptno);
              
--IN
SELECT *
FROM dept
WHERE deptno in (SELECT deptno
                 FROM emp);


-- �������� [�ǽ� 9] //����// ==================================================

SELECT *
FROM product
WHERE NOT EXISTS (SELECT '.'
                  FROM cycle
                  WHERE cycle.pid = product.pid
                  AND cid = 1);


-- ==========================================================================


-- ���տ���
-- UNION: ������. �ߺ��� ����
--        DBMS������ �ߺ��� �����ϱ����� �����͸� ����(�뷮�� �����Ϳ� ���� ���Ľ� ����)
-- UNION ALL: UNION�� ���� ����. �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���ո� �Ѵ�. => �ߺ�����
--            �� �Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ� UNION �����ں��� ���ɸ鿡�� ����


-- ����� 7566 �Ǵ� 7698�� ���(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
-- ����� 7369, 7499�� ��� ��ȸ ( ���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;


-- UNION ALL(�ߺ� ���, �� �Ʒ� ������ ��ġ�⸸ �Ѵ�.)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
-- ����� 7369, 7499�� ��� ��ȸ ( ���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;

-- ==========================================================================

-- INTERSECT(������: �� �Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

INTERSECT

-- ����� 7369, 7499�� ��� ��ȸ ( ���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);

-- ==========================================================================

-- MINUS(������: �� ���տ��� �Ʒ� ������ ����)
-- ������ ����
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

MINUS

-- ����� 7369, 7499�� ��� ��ȸ ( ���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);

-- ==========================================================================


SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369);


-- ==========================================================================


























