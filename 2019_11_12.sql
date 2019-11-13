
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
--SELECT ����� �ٷ� INSERT�ϴ� ���� ����

INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROm dept;


-- ====================================================================================
--UPDATE
--  UPDATE ���̺� SET �÷�=��, �÷�=��
--  WHERE condition

UPDATE dept SET dname='���IT', loc='ym'
 WHERE deptno = 99;

SELECT *
FROM emp;

-- ====================================================================================
-- DELETE
-- �����ȣ�� 9999�� ������ emp���̺��� ����
DELETE emp
WHERE empno=9999;

-- �μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5��(4��)�� �����͸� ����
-- 10 20 30 40 99 => empno < 100 | empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

--(�̸� SELECT���� ������ �����͸� ��ȸ)
SELECT *
FROM emp
WHERE empno < 100;
rollback;


-- ====================================================================================
DELETE emp
WHERE empno IN (SELECT deptno FROm dept);
commit;


-- ====================================================================================
-- Ʈ�����

-- LV1  => LV 3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

--DML ������ ���� Ʈ����� ����
INSERT INTO dept
VALUES  (99, 'ddit', 'daejeon');



-- ====================================================================================
-- [DDL] : AUTO COMMIT, ROLLBACK�� �� ��!
-- CLEATE

CREATE TABLE ranger_new(
    ranger_no NUMBER, -- ���� Ÿ��
    ranger_name VARCHAR2(50), -- ����: [VARCHAR2], CHAR
    reg_dt DATE DEFAULT SYSDATE -- DEFAULT: SYSDATE
);
DESC ranger_new;

--DDL�� �ѹ��� �� ��..
ROLLBACK;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'BROWN');

SELECT *
FROM ranger_new;
commit;


-- ====================================================================================
-- ��¥ Ÿ�Կ��� Ư�� �ʵ� �������� (EXTRACT)
-- ex: sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt,     
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(day FROM reg_dt) day
FROM ranger_new;


-- ====================================================================================

-- [��������]
-- DEPT ����ؼ� DEPT_TEST ����
CREATE TABLE dept_test(
    dept_no number(2) PRIMARY KEY, -- dept_no �÷��� �ĺ��ڷ� ����
    dname varchar2(14),            -- �ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �� �� ������, NULL�� ���� ����.
    loc varchar2(13)
);


-- primary key ���� ���� Ȯ��
-- 1. dept_no�÷��� null�� �� �� ����.
-- 2. dept_no�÷��� �ߺ��� ��

INSERT INTO dept_test(dept_no, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;


-- ====================================================================================
-- ����� ���� �������Ǹ��� �ο��� PRIMARY KEY
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

