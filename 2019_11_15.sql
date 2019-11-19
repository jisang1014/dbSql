-- emp���̺� empno�÷��� �������� PRIMARY KEY�� ����
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE => �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7367;

SELECT *
FROM TABLE(dbms_xplan.display);


-- ==============================================================================
-- empno �÷����� �ε����� �����ϴ� ��Ȳ���� �ٸ� �÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);


-- ==============================================================================
-- �ε��� ���� �÷��� SELECT���� ����� ��� ���̺� ������ �ʿ� ����.
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;



-- ==============================================================================

-- �÷��� �ߺ��� ������ non-unique �ε��� ���� �� unique index���� �����ȹ ��
-- PRIMARY KEY �������� ���� (unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--=========================================================================================
-- NON-UNIQUE   //////////////////////////////////////////////////////////////////////////
--=========================================================================================

------------------------------------------------------------------------------------------
| Id  | Operation        | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
-----------------------------------------------------------------------------------------
   2 - access("EMPNO"=7782)
   
--========================================================================================
--///////////////////////////////////////////////////////////////////////////////////////
--========================================================================================

-- emp ���̺� jpb �÷����� �� ��° �ε��� ����
-- jpb �÷��� �ٸ� �ο��� jop �÷��� �ߺ��� ������ �÷��̴�.
CREATE INDEX idx_emp_02 ON emp(job);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--========================================================================================

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--=========================================================================================
-- NON-UNIQUE + [OPTION]  ////////////////////////////////////////////////////////////////
--=========================================================================================
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
--========================================================================================
--///////////////////////////////////////////////////////////////////////////////////////
--========================================================================================


CREATE INDEX idx_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--=========================================================================================
-- NON-UNIQUE + [OPTION]  ////////////////////////////////////////////////////////////////
--=========================================================================================
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')

--========================================================================================
--///////////////////////////////////////////////////////////////////////////////////////
--========================================================================================


-- emp ���̺� ename, job �÷����� non-unique �ε��� ����
CREATE INDEX idx_emp_04 ON emp(ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

--=========================================================================================
-- NON-UNIQUE + [OPTION]+ �÷� ������ �߿伺 ////////////////////////////////////////////////  
--=========================================================================================
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
------------------------------------------------------------------------------------------
 
   1 - filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
   2 - access("JOB"='MANAGER')
--========================================================================================
--///////////////////////////////////////////////////////////////////////////////////////
--========================================================================================


-- HINT�� ����� ����

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_03 ) */ *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);


-- index [�ǽ� 1] =========================================================================
CREATE TABLE dept_test2 AS SELECT *
                          FROM dept
                          WHERE 1 = 1;

CREATE UNIQUE INDEX UQidx_dept_test_001 ON dept_test(deptno);
CREATE INDEX idx_dept_test_001 ON dept_test(dname);
CREATE INDEX idx_dept_test_002 ON dept_test(deptno, dname);


-- index [�ǽ� 2] =========================================================================                   
DROP INDEX  UQidx_dept_test_001;
DROP INDEX  idx_dept_test_001;
DROP INDEX  idx_dept_test_002;


SELECT *
FROM dept_test;



DROP index IDX_EMP_04;


CREATE UNIQUE INDEX u_emp_empno ON emp(empno);
CREATE INDEX idx_emp_001 ON emp(ename);
CREATE INDEX idx_emp_002 ON emp(deptno);

-- index [�ǽ� 3] =========================================================================
-- 1. 
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7298;

SELECT *
FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = 'SCOTT';
SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE sal BETWEEN 500 AND 700
AND deptno = 20;

SELECT *
FROM TABLE(dbms_xplan.display);



EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno = 10
  ANd emp.empno LIKE '72%';
  
  SELECT *
FROM TABLE(dbms_xplan.display);



EXPLAIN PLAN FOR
SELECT B.*
FROM emp A, emp B
WHERE A.mgr = B.empno
  AND A.deptno = 30;
  
  SELECT *
FROM TABLE(dbms_xplan.display);


-- 1. ����ũ �ε���: empno
-- 2. �� ����ũ: ename
-- 3. �� ����ũ: deptno, mgr


