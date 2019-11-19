--

DROP table emp_test;

SELECT *
FROM emp_test;

-- multiple insert�� ���� �׽�Ʈ ���̺� ����
-- empno, ename �� ���� �÷��� ���� emp_test, emp_test2 ���̺��� emp ���̺�κ��� �����Ѵ�.
CREATE table emp_test AS
    SELECT empno, ename
    FROM emp
    WHERE 1=2;

CREATE table emp_test2 AS
    SELECT empno, ename
    FROM emp
    WHERE 1=2;
    
-- ===========================================================================
--INSERT ALL
-- �ϳ��� SQL �������� �������̺� �����͸� �Է� 
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 1, 'sally' FROM dual;

SELECT *
FROM emp_test2;


rollback;
-- INSERT ALL �÷� ����

INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test2;

-- ===========================================================================
-- multiple insert (conditianal insert)
ROLLBACK;

INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE    -- else:    ������ �������� ������ �� ����
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;


-- ===========================================================================
-- INSERT FIRST
-- ���ǿ� �����ϴ� ù���� INSERT ������ ����
ROLLBACK;

INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;
    
-- ===========================================================================
-- MERGE: ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--        ���ǿ� �����ϴ� �����Ͱ� ������ INSERT
ROLLBACK;

-- empno�� 7369�� �����͸� emp���̺�κ��� emp_test ���̺� ����(insert)
INSERT INTO emp_test
    SELECT empno, ename
    FROM emp
    WHERE empno = 7369;
    
SELECT *
FROM emp_test;

-- emp���̺��� ������ �� emp_test ���̺��� empno��
-- ���� ���� ���� �����Ͱ� ���� ��� emp_test.ename = ename || '_merge' ������ UPDATE;
-- �����Ͱ� ���� ��쿡�� emp_test ���̺� INSERT

ALTER TABLE emp_test MODIFY (ename VARCHAR2 (20));


MERGE INTO emp_test
USING emp
   ON (emp.empno = emp_test.empno)

 WHEN MATCHED THEN
    UPDATE SET ename = emp.ename||'_merge'
 WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp. ename);

SELECT *
FROM emp_test;


-- �ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������ merge�ϴ� ���
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� ������Ʈ
-- empno�� ���� ���� ������ �ű� INSERT

MERGE INTO emp_test
USING dual
   ON (emp_test.empno = 1)
WHEN MATCHED THEN 
    UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (1, 'brown');

SELECT *
FROM emp_test;


-- ===========================================================================
-- ///////////////////////////////////////////////////////////////////////////
-- ===========================================================================

-- GROUP [�ǽ� 1] =============================================================
(SELECT deptno, sum(sal) sal 
FROM emp
GROUP BY deptno)
UNION ALL
(SELECT null, sum(sal)
FROM emp);

SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP (deptno);

-- rollup
-- group by�� ���� �׷��� ����
-- GROUP BY ROLLUP( {col,})
-- �÷��� �����ʿ������� �����ذ��鼭 ���� ����׷��� GROUP BY�Ͽ� UNION�� �Ͱ� ����
-- ex: GROUP BY ROLLUP ( jpb, deptno)
--     GROUP BY job, deptno
--     UNION
--     GROUP BY jop
--     UNION
--     GROUP BY   --->> �Ѱ�(��� �࿡ ���� �׷��Լ� ����)

SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT job, deptno, count(*) cnt, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


-- GROUPING SETS (col1, col2...)
-- GROUPING SETS�� ������ �׸��� ���� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�.
-- ||
-- GROUP BY col1
-- UNION ALL
-- GOUP BY col2

SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno UNION ALL

SELECT null deptno, job , sum(sal)
FROM emp
GROUP BY job;

SELECT sum(sal)
FROM emp
GROUP BY grouping sets (deptno, job);


SELECT deptno, job sum(sal)
FROM emp
GROUP BY GROUPING SETS (deptno job);
