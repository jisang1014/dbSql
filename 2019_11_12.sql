
INSERT INTO emp (ename, job)
VALUES ('brown', null);

rollback;

SELECT *
FROM emp;

SELECT*
FROM user_tab_columns
WHERE table_name = 'EMP';

-- ====================================================================================
INSERT INTO emp
VALUES (9999, 'BROWN', 'RANGER', null, SYSDATE, 2500, null, 40);
commit;


-- ====================================================================================
--SELECT 결과를 바로 INSERT하는 것이 가능

INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROm dept;


-- ====================================================================================
--UPDATE
--  UPDATE 테이블 SET 컬럼=값, 컬럼=값
--  WHERE condition

UPDATE dept SET dname='대덕IT', loc='ym'
 WHERE deptno = 99;

SELECT *
FROM emp;

-- ====================================================================================
-- DELETE
-- 사원번호가 9999인 직원을 emp테이블에서 삭제
DELETE emp
WHERE empno=9999;

-- 부서테이블을 이용해서 emp 테이블에 입력한 5건(4건)의 데이터를 삭제
-- 10 20 30 40 99 => empno < 100 | empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

--(미리 SELECT절로 삭제할 데이터를 조회)
SELECT *
FROM emp
WHERE empno < 100;
rollback;


-- ====================================================================================
DELETE emp
WHERE empno IN (SELECT deptno FROm dept);
commit;


-- ====================================================================================
-- 트랜잭션

-- LV1  => LV 3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

--DML 문장을 통해 트랜잭션 시작
INSERT INTO dept
VALUES  (99, 'ddit', 'daejeon');



-- ====================================================================================
-- [DDL] : AUTO COMMIT, ROLLBACK이 안 됨!
-- CLEATE

CREATE TABLE ranger_new(
    ranger_no NUMBER, -- 숫자 타입
    ranger_name VARCHAR2(50), -- 문자: [VARCHAR2], CHAR
    reg_dt DATE DEFAULT SYSDATE -- DEFAULT: SYSDATE
);
DESC ranger_new;

--DDL은 롤백이 안 됨..
ROLLBACK;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'BROWN');

SELECT *
FROM ranger_new;
commit;


-- ====================================================================================
-- 날짜 타입에서 특정 필드 가져오기 (EXTRACT)
-- ex: sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt,     
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(day FROM reg_dt) day
FROM ranger_new;


-- ====================================================================================

-- [제약조건]
-- DEPT 모방해서 DEPT_TEST 생성
CREATE TABLE dept_test(
    dept_no number(2) PRIMARY KEY, -- dept_no 컬럼을 식별자로 지정
    dname varchar2(14),            -- 식별자로 지정이 되면 값이 중복이 될 수 없으며, NULL일 수도 없다.
    loc varchar2(13)
);


-- primary key 제약 조건 확인
-- 1. dept_no컬럼에 null이 들어갈 수 없다.
-- 2. dept_no컬럼에 중복된 값

INSERT INTO dept_test(dept_no, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;


-- ====================================================================================
-- 사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno number(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname varchar2(14),
    loc varchar2(13)
);


-- TABLE CONSTRAINT
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno number(2),
    dname varchar(14),
    loc varchar(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon');

SELECT *
FROM dept_test;

ROLLBACK;


-- ====================================================================================
--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,
    dname varchar(14) NOT NULL,
    loc varchar(13)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2,  null, 'daejeon');


-- ====================================================================================
--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,
    dname varchar(14) UNIQUE,
    loc varchar(13)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon');
ROLLBACK;

