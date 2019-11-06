--�׷��Լ�
--multi row function : �������� ���� �Է����� �ϳ��� ��� ���� ����
-- sum, max, nim, avg, count
-- GROUP BY col | express
-- SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����

-- ������ ���� ���� �޿� ��ȸ
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

-- �μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;


--[�ǽ� 3]
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


--FUNCTION group function [�ǽ�4]
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');


--FUNCTION group function [�ǽ�5]
SELECT TO_CHAR(hiredate,'YYYY') hire_YYYY, count(hiredate)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');


--FUNCTION group function [�ǽ�5]
SELECT count(*) cnt
FROM dept;


-- //////////////////////////////////////////////////////////////////////////


-- JOIN
-- emp ���̺��� dname �÷��� ����. --> �μ���ȣ(deptno)�ۿ� ����

-- emp���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
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


--ansi natural join : ���̺��� �÷����� ���� �÷��� �������� join
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

--from ���� join ��� ���̺� ����
--where ���� join ���� ���

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

    --jobd�� sales�� ����� ������� ��ȸ
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
  AND emp.deptno = dept.deptno;

    --jobd�� sales�� ����� ������� ��ȸ
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN';


--JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- SELF JOIN: ���� ���̺��� join
-- emp���̺��� mgr ������ �����ϱ� ���ؼ� emp���̺�� join�� �ؾ��Ѵ�.
-- a: ���� ����, b: ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno)
WHERE a.empno between 7367 AND 7698;


SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno between 7367 AND 7698;

-- ũ�ν� join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = '7367';
 
 
 -- non-equijoing (��� join�� �ƴ� ���)
 SELECT *
 FROM salgrade; --�޿����
 
 --������ �޿� �����????
 SELECT *
 FROM emp;
 
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
 
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);


--[�ǽ� 0]
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
ORDER BY emp.deptno;
 
 
 --[�ǽ� 0_1]
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE emp.deptno IN(10,30);
 
 
 
 
 
 
 
 
 
 












