--���� ������ �����ϴ� �������� view: USER_CONSTRAINS
--���� ������ �����ϴ� ���������� �÷� view: USER_CONS_COLUNMS

--FK_EMP_DEPT
SELECT *
FROm USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'PK_CYCLE';


-- ���̺� ������ �������� ��ȸ (VIEW JOIN)
-- ���̺�� / �������Ǹ� / �÷��� / �÷� ������

SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
  AND a.constraint_type = 'P' --PRIMARY KEY�� ��ȸ
ORDER BY a.table_name, b.position;


-- ========================================================================
-- ========================================================================
-- emp ���̺�� 8���� �÷� �ּ��ޱ�
-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

-- ���̺� �ּ� VIEW : USER_TAP_COMMENTS

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp ���̺� �ּ�
COMMENT ON TABLE emp IS '���';

-- emp ���̺� �÷� �ּ�
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ENAME IS '�̸�';
COMMENT ON COLUMN emp.JOB IS '������';
COMMENT ON COLUMN emp.MGR IS '������ ���';
COMMENT ON COLUMN emp.HIREDATE IS '�Ի�����';
COMMENT ON COLUMN emp.SAL IS '�޿�';
COMMENT ON COLUMN emp.COMM IS '��';
COMMENT ON COLUMN emp.DEPTNO IS '�ҼӺμ���ȣ';


-- comments [�ǽ� 1] ==============================================================================
SELECT a.table_name, a.table_type, a.comments tab_comment, column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name = b.table_name
ORDER BY a.comments;

SELECT a.table_name, a.table_type, a.comments tab_comment, b.column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name IN ('CYCLE', 'CUSTOMER', 'PRODUCT', 'DAIRY')
  AND a.table_name = b.table_name;


-- ===============================================================================================

-- [ VIEW ���� ]
-- emp���̺��� sla, comm �� ���� �÷��� �����Ѵ�.
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;


-- INLINE VIEW
SELECT *
FROM ( SELECT empno, ename, job, mgr, hiredate, deptno
       FROM emp );

-- VIEW (�� �ζ��κ�� �����ϴ�.)
SELECT *
FROM v_emp;

-- JOIN�� ���� ����� view�� ����: v_emp_dept
-- emp, dept: �μ���, �����ȣ, �����, ������, �Ի�����
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;


-- VIEW ����
DROP VIEW v_emp;


-- VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ�, VIEW���� ������ ����.
-- dept 30 - SALES
SELECT *
FROM dept;

SELECT *
FROM v_emp_dept;


-- dept���̺��� SALES --> MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;
rollback;


--HR �������� v_emp_dept VIEW ��ȸ ������ �ش�.
GRANT SELECT ON v_emp_dept TO hr;


-- ========================================================================
-- ========================================================================
-- SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post 
INCREMENT BY 1
START WITH 1;

SELECT seq_post.nextval, seq_post.currval
FROM dual;

SELECT seq_post.currval --���� ��� ���� ���� ���� �����ִ� ��!
FROM dual;


SELECT *
FROm post
WHERE reg_id = 'brown'
  AND title = '�������� ����ִ�'
  AND reg_dt = TO_DATE('2019/11/14 15:40:15, YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE post_id = 1;



-- =====================================================================
-- ������ ����
-- ������: �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
DROP TABLE emp_test;

CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(15)
);


CREATE SEQUENCE seq_emp_test;


INSERT INTO emp_test VALUES (seq_emp_test.nextval, 'brown');

SELECT *
FROM emp_test;

SELECT seq_emp_test.nextval
FROM dual;








-- ========================================================================
-- ========================================================================
-- [ INDEX ]

--index
--rowid: ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸� ������ ���̺� �����ϴ� ���� ����.

SELECT product.*, ROWID
FROM product
WHERE rowid = 'AAAFKoAAFAAAAFNAAB';

-- table: pid, pnm
-- pk_product: pid
SELECT pid
FROm product
WHERE rowid = 'AAAFKoAAFAAAAFNAAB';


-- �����ȹ�� ���� �ε��� ��뿩�� Ȯ��;
-- emp ���̺� empno�÷� �������� �ε����� ���� ��

ALTER TABLE emp DROP CONSTRAINT pk_emp_empno;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

-- �ε����� ���� ������ empno=7369�� �����͸� ã�� ���� emp���̺� ��ü�� ã�ƺ����Ѵ�.
-- => TABLE FULL SCAN

SELECT *
FROM TABLE(dbms_xplan.display);















