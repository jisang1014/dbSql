SELECT *
FROM no_emp;

--===============================================================================
--///////////////////////////////////////////////////////////////////////////////
--===============================================================================
   
--1. leaf node ã��
SELECT LPAD(' ', (LEVEL-1)*4, ' ') || org_cd AS org_cd, LEVEL, s_emp
FROM 
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
        (SELECT org_cd, parent_org_cd,
               SUM(no_emp/org_cnt) OVER (PARTITION BY gr
                                         ORDER BY rn 
                                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
            (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr,
             COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
             FROM
                (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, CONNECT_BY_ISLEAF leaf
                 FROM no_emp
                 START WITH parent_org_cd IS NULL
                 CONNECT BY PRIOR org_cd = parent_org_cd) a
             START WITH leaf = 1
             CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;



--===============================================================================
-- [ PL/SQL ]  //////////////////////////////////////////////////////////////////
--===============================================================================
-- �Ҵ� ���� ->  :=
-- System.out.println("") --> dbms_out.put_line('');
-- set serverouput on;  ==��� ����� Ȱ��ȭ

-- ==============================================================================
-- PL/SQL
-- Declare: ����, ��� ����
-- Begin: ���� ����
-- Exception: ���� ó��

SET SERVEROUTPUT ON;

DECLARE
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN 
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    -- INTO: ������ ���� 1���� ��
    
    -- SELECT���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname: ' || dname || '(' || deptno || ')');
END;
/   


SET SERVEROUTPUT ON;
DECLARE
    -- �������� ����(���̺� �÷�Ÿ���� ����Ǿ pl/sql ������ ������ �ʿ䰡 ����.)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN 
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    -- INTO: ������ ���� 1���� ��
    
    -- SELECT���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname: ' || dname || '(' || deptno || ')');
END;
/

-- 10�� �μ��� �μ� �̸��� LOC������ ȭ�鿡 ����ϴ� ���ν���
-- printdept
CREATE OR REPLACE PROCEDURE printdept
IS
    --���� ����
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
      INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname, loc = ' || dname || ', ' || loc);
END;
/

EXEC printdept;


CREATE OR REPLACE PROCEDURE printdept_p (p_deptno IN dept.deptno%TYPE)
IS
    --���� ����
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
      INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname, loc = ' || dname || ', ' || loc);
END;
/

EXEC printdept_p(30);

--===========================================================================
CREATE OR REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE)
IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
      INTO ename, dname
    FROM emp JOIN dept ON (emp.deptno = dept.deptno)
    WHERE empno = p_empno;
      
     dbms_output.put_line('ename, dname = ' || ename || ', ' || dname);
END;
/
    
EXEC printemp(7839);

SELECT empno, ename, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;



CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE)
IS
BEGIN
    INSERT INTO dept_test
    VALUES (p_deptno, p_dname, p_loc);
END;
/

EXEC registdept_test(99, 'choco', 'chocoMilk');
SELECT *
FROM dept_test;


CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE)
IS
    var_deptno dept.deptno%TYPE := p_deptno;
    var_dname dept.dname%TYPE := p_dname;
    var_loc dept.loc%TYPE := p_loc;
BEGIN
    INSERT INTO dept_test
    VALUES (p_deptno, p_dname, p_loc);
    COMMIT;
END;
/

EXEC registdept_test(98, 'ddit', 'daejeon');


