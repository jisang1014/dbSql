-- GROUPING (cube, rollup ���� ���� �÷�(
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1
-- ������ ���� ��� 0


-- job �÷�
-- case1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--        job --> '�Ѱ�'
-- case else
--        job --> job
SELECT job, deptno,
    GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
        END job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '[�Ѱ�] ----'
            ELSE job
        END job, 
       CASE WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 0 THEN job || ' �Ұ�' 
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '-----------> '
            ELSE TO_CHAR(deptno)
        END deptno,
        SUM(sal) sal, GROUPING(job) gjob, GROUPING(deptno) gdeptno
FROM emp
GROUP BY ROLLUP(job, deptno);



-- =========================================================================
-- GROUP BY ROLLUP [�ǽ� 4] /////////////////////////////////////////////////
-- =========================================================================
SELECT dname, job, sum(sal) sal
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
GROUP BY rollup(dname, job)
ORDER BY dname, job desc;


-- =========================================================================
-- GROUP BY ROLLUP [�ǽ� 5] /////////////////////////////////////////////////
-- =========================================================================
SELECT CASE WHEN GROUPING(dname) = 1 AND GROUPING(job) = 1 THEN '����'
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
-- XX : GROUP BY -- ��� �����Ϳ� ���ؼ�

-- GROUP BY CUBE(job, deptno, mgr) **����� ���� 2�� (�ݷ�����)������ �þ


SELECT job, deptno, sum(sal)
FROM emp
GROUP BY CUBE(job, deptno);


-- ======================================================================
-- subquery�� ���� ������Ʈ
DROP TABLE emp_test;

-- emp���̺��� �����͸� �����ؼ� ��� �÷��� emp_test���̺�� ����
CREATE TABLE emp_test AS 
    SELECT *
    FROM emp;


--emp_test ���̺��� dept���̺��� �����ǰ� �ִ� dname�÷�(VARCHAR2(14)�� �߰�
SELECT *
FROM emp_test;

ALTER TABLE emp_test ADD ( dname VARCHAR2(14));


--emp_test ���̺��� dname �÷��� dept���̺��� dname �÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = ( SELECT dname
                              FROM dept
                              WHERE dept.deptno = emp_test.deptno );
commit;


-- =========================================================================
-- �������� [�ǽ� 1] /////////////////////////////////////////////////////////
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
-- �������� [�ǽ� 2] /////////////////////////////////////////////////////////
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
-- �������� [�ǽ� 3] /////////////////////////////////////////////////////////
-- =========================================================================  
 

UPDATE emp_test a SET sal = sal+200
WHERE sal < (SELECT AVG(sal)
              FROM emp_test b
              WHERE a.deptno = b.deptno);    
              
--emp, emp_test, emp �÷����� ���� ������ ��ȸ
--emp.empno, emp.ename, emp.sal, emp_test.sal
 
 
 
 
SELECT empno, ename, sal, sal_1, a.deptno, TRUNC(b.sal_avg,2)sal_avg
FROM  
    (SELECT emp.deptno deptno, emp.empno, emp.ename, emp.sal, emp_test.sal sal_1
     FROM emp JOIN emp_test ON (emp.empno = emp_test.empno))a
     
     JOIN (SELECT deptno, avg(sal) sal_avg FROM emp GROUP BY deptno)b ON(a.deptno = b.deptno);



 



