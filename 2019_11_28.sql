 

CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc IN dept.loc%TYPE)
IS
BEGIN
    UPDATE dept_test SET dname = p_dname,
                         loc = p_loc
                     WHERE deptno = p_deptno;
    COMMIT;
END;
/

EXEC UPDATEdept_test(99, 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;

-- ==============================================================================
-- ROWTYPE: ���̺� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��

set serveroutput on;
DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
      INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_Line(dept_row.deptno || ', ' || dept_row.dname || ', ' || dept_row.loc);
END;
/


-- ==============================================================================
--���պ���: record

DECLARE
    --UserVO userVo
    TYPE dept_row IS RECORD(
                    deptno NUMBER(2),
                    dname dept.dname%TYPE);
                    
    v_dname dept.dname%TYPE;
    v_row dept_row;
BEGIN
    SELECT deptno, dname
      INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_Line(v_row.deptno || ', ' || v_row.dname);
END;
/

-- ���պ���: tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    -- java: Ÿ�� ������;
    -- pl/sql: ������ Ÿ��;
    v_dept dept_tab;
BEGIN
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_Line(i|| ': ' || v_dept(i).dname);
    END LOOP;
END;
/


SELECT *
FROM dept;


-- ==============================================================================
-- IF
-- ELSE IF => ELSIF
-- END IF;

DECLARE
    ind BINARY_INTEGER;
    
BEGIN
    ind := 2;
     
    IF ind = 1 THEN
        dbms_output.put_Line('IF: ' || ind);
    ELSIF ind = 2 THEN
        dbms_output.put_Line('ELSE IF: ' || ind);
    ELSE
        dbms_output.put_Line('ELSE');
    END IF;
END;
/


-- ==============================================================================
-- FOR LOOP:
-- FOR �ε��� ���� IN ���۰�..���ᰪ LOOP
-- END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_Line('i: ' || i);
    END LOOP;
END;
/


-- ==============================================================================
-- LOOP: ��� ���� �Ǵ� ������ LOOP �ȿ��� ����
-- java: while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_Line('i = ' || i);
        i := i+1;
        --loop ���� ���� �Ǵ�
        EXIT WHEN i >= 5;
    END LOOP;
END;
/


-- ���� ���: 5 ��

SELECt *
FROM dt;

CREATE OR REPLACE PROCEDURE avgdt
IS
    TYPE v_copy IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    dt_copy v_copy;
    avgdate NUMBER := 0;
BEGIN
    SELECT *
    BULK COLLECT INTO dt_copy
    FROM dt
    ORDER BY dt;
   
    FOR i IN 1..dt_copy.count-1 LOOP
        avgdate := avgdate + (dt_copy(i+1).dt - dt_copy(i).dt);
    END LOOP;
    
    avgdate := avgdate/(dt_copy.count-1);
    dbms_output.put_Line('���� ���: ' || avgdate || '��' );
END;
/

EXEC avgdt;


-- =========================================================================
SELECT avg(avg1)
FROM
(SELECT dt - LEAD(dt) OVER (ORDER BY DT desc) avg1
FROM dt);

-- =========================================================================
-- �м��Լ��� ������� ���ϴ� ȯ�濡���� ���    
SELECT avg(b.dt - a.dt) avgdt
FROM
    (SELECT rownum rn, dt FROM (SELECT * FROM dt ORDER BY dt desc)) a
    LEFT OUTER JOIN
    (SELECT rownum rn, dt FROM (SELECT * FROM dt ORDER BY dt desc)) b
    ON(a.rn = b.rn+1);   
    
-- =========================================================================   
-- HALL OF HONOR
SELECT ((MAX(dt) - MIN(dt)) / (COUNT(*)-1)) avgdt
FROM dt;



DECLARE
    -- Ŀ�� ����
    CURSOR dept_cursor IS 
            SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    OPEN dept_cursor; -- Ŀ�� ����
    
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_Line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; --���̻� �о�� �����Ͱ� ���� �� ����
    END LOOP;
END;
/


-- FOR LOOP CURSOR ���� 
-- java�� �����ϸ� ���� for��

DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_Line(rec.deptno || ', ' ||rec.dname);
    END LOOP;
END;
/

-- �Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp 
        WHERE job = p_job;
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_Line(emp.empno || ', ' || emp.ename || ', ' ||  emp.job);
    END LOOP;
END;
/



   





