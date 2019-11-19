-- emp테이블에 empno컬럼을 기준으로 PRIMARY KEY를 생성
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE => 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7367;

SELECT *
FROM TABLE(dbms_xplan.display);


-- ==============================================================================
-- empno 컬럼으로 인덱스가 존재하는 상황에서 다른 컬럼 값으로 데이터를 조회하는 경우
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);


-- ==============================================================================
-- 인덱스 구성 컬럼만 SELECT절에 기술한 경우 테이블 접근이 필요 없다.
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;



-- ==============================================================================

-- 컬럼에 중복이 가능한 non-unique 인덱스 생성 후 unique index와의 실행계획 비교
-- PRIMARY KEY 제약조건 삭제 (unique 인덱스 삭제)
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

-- emp 테이블에 jpb 컬럼으로 두 번째 인덱스 생성
-- jpb 컬럼은 다른 로우의 jop 컬럼과 중복이 가능한 컬럼이다.
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


-- emp 테이블에 ename, job 컬럼으로 non-unique 인덱스 생성
CREATE INDEX idx_emp_04 ON emp(ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

--=========================================================================================
-- NON-UNIQUE + [OPTION]+ 컬럼 순서의 중요성 ////////////////////////////////////////////////  
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


-- HINT를 사용한 제어

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_03 ) */ *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);


-- index [실습 1] =========================================================================
CREATE TABLE dept_test2 AS SELECT *
                          FROM dept
                          WHERE 1 = 1;

CREATE UNIQUE INDEX UQidx_dept_test_001 ON dept_test(deptno);
CREATE INDEX idx_dept_test_001 ON dept_test(dname);
CREATE INDEX idx_dept_test_002 ON dept_test(deptno, dname);


-- index [실습 2] =========================================================================                   
DROP INDEX  UQidx_dept_test_001;
DROP INDEX  idx_dept_test_001;
DROP INDEX  idx_dept_test_002;


SELECT *
FROM dept_test;



DROP index IDX_EMP_04;


CREATE UNIQUE INDEX u_emp_empno ON emp(empno);
CREATE INDEX idx_emp_001 ON emp(ename);
CREATE INDEX idx_emp_002 ON emp(deptno);

-- index [실습 3] =========================================================================
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


-- 1. 유니크 인덱스: empno
-- 2. 논 유니크: ename
-- 3. 논 유니크: deptno, mgr


