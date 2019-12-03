
-- �͸� ���
set serveroutput on;

DECLARE 
    -- ��� �̸��� ������ ��Į�� ����(1���� ��)
    V_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp;
     -- ��ȸ ����� ���� ���ε�, ��Į�� ����(1��)�� ���� �����Ϸ� �Ѵ�.
     -- --> ����!
     
     --�߻� ����, �߻� ���ܸ� Ư������ ���� ���� OTHERS(java: Exception)
     EXCEPTION 
        WHEN others THEN
            dbms_output.put_line('Exeption others');
END;
/


-- ========================================================================================
-- ����� ���� ����
-- ========================================================================================

DECLARE
    -- emp ���̺� ��ȸ�� ����� ���� ��� �߻���ų ����� ���� ����
    -- ���ܸ� EXCEPTION; -- ������ - ����Ÿ��(����Ÿ�� ��� exception�̶�� Ű���尡 ��
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN

    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = 9999;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN dbms_output.put_line('������ ������');
            -- �����ڰ� ������ ����� ���� ���ܸ� ����
            RAISE NO_EMP;
    END;
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('NO_EMP Exception');

END;
/


-- ========================================================================================
-- �Լ�(function)
-- ========================================================================================


-- �����ȣ�� �����ϰ�, �ش� �����ȣ�� �ش��ϴ� ����̸��� �����ϴ� �Լ�(function)

CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2
IS
    -- �����
    ret_ename emp.ename%TYPE;
BEGIN
    -- ����
    SELECT ename
    INTO ret_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN ret_ename;
END;
/


SELECT getEmpName(7369)
FROM dual;


-- ========================================================================================

CREATE OR REPLACE FUNCTION getdeptname(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2
IS
    v_dname dept.dname%TYPE;
BEGIN

    SELECT dname
    INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/

SELECT getdeptname(10)
FROM dual;

SELECT deptno, dname, getdeptname(deptno)
FROM dept;


-- ========================================================================================

CREATE OR REPLACE FUNCTION indent(p_pad VARCHAR2, p_level NUMBER, p_bypad NUMBER, p_deptnm dept_h.deptnm%TYPE)
RETURN VARCHAR2
IS
    v_return VARCHAR2(40);
BEGIN
    SELECT LPAD(p_pad, (p_level-1)*p_bypad, p_pad) || p_deptnm
    INTO v_return
    FROM dual;
    
    return v_return;
END;
/

SELECT deptcd, indent('-', level, 4, deptnm) deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;



-- ========================================================================================
-- Ʈ����
-- ========================================================================================

CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

-- users ���̺��� pass�÷��� ����� ��� users_history�� ������ pass�� �̷����� ����� Ʈ����

CREATE OR REPLACE TRIGGER make_history  
    BEFORE UPDATE ON users -- users ���̺��� ������Ʈ�ϱ� ���� ����
    FOR EACH ROW    -- ������� ����
    
    BEGIN
        -- :NEW.�÷��� -> UPDATE������ �ۼ��� ��
        -- :OLD.�÷��� -> ���� ���̺� ��
        IF :NEW.pass != :OLD.pass THEN
            INSERT INTO users_history
                   VALUES (:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
    END;
    /

UPDATE users SET pass = 'newpass';

SELECT *
FROM users_history;


-- ========================================================================================
-- ibatis(2.x) --> mybatis(3.x)
-- ========================================================================================

 
    











