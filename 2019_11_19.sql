--

DROP table emp_test;

SELECT *
FROM emp_test;

-- multiple insert를 위한 테스트 테이블 생성
-- empno, ename 두 개의 컬럼을 갖는 emp_test, emp_test2 테이블을 emp 테이블로부터 생성한다.
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
-- 하나의 SQL 문장으로 여러테이블에 데이터를 입력 
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 1, 'sally' FROM dual;

SELECT *
FROM emp_test2;


rollback;
-- INSERT ALL 컬럼 정의

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
    ELSE    -- else:    조건을 만족하지 못했을 때 실행
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;


-- ===========================================================================
-- INSERT FIRST
-- 조건에 만족하는 첫번쨰 INSERT 구문만 실행
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
-- MERGE: 조건에 만족하는 데이터가 있으면 UPDATE
--        조건에 만족하는 데이터가 없으면 INSERT
ROLLBACK;

-- empno가 7369인 데이터를 emp테이블로부터 emp_test 테이블에 복사(insert)
INSERT INTO emp_test
    SELECT empno, ename
    FROM emp
    WHERE empno = 7369;
    
SELECT *
FROM emp_test;

-- emp테이블의 데이터 중 emp_test 테이블의 empno와
-- 같은 값을 갖는 데이터가 있을 경우 emp_test.ename = ename || '_merge' 값으로 UPDATE;
-- 데이터가 없을 경우에는 emp_test 테이블에 INSERT

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


-- 다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로 merge하는 경우
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno가 같은 값이 있으면 ename을 'brown'으로 업데이트
-- empno가 같은 값이 없으면 신규 INSERT

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

-- GROUP [실습 1] =============================================================
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
-- group by의 서브 그룹을 생성
-- GROUP BY ROLLUP( {col,})
-- 컬럼을 오른쪽에서부터 제거해가면서 나온 서브그룹을 GROUP BY하여 UNION한 것과 동일
-- ex: GROUP BY ROLLUP ( jpb, deptno)
--     GROUP BY job, deptno
--     UNION
--     GROUP BY jop
--     UNION
--     GROUP BY   --->> 총계(모든 행에 대해 그룹함수 적용)

SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT job, deptno, count(*) cnt, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


-- GROUPING SETS (col1, col2...)
-- GROUPING SETS의 나열된 항목이 각각 하나의 서브그룹으로 GROUP BY 절에 이용된다.
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
