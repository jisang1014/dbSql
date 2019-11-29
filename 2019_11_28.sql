 

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
-- ROWTYPE: 테이블 한 행의 데이터를 담을 수 있는 참조 타입

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
--복합변수: record

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

-- 복합변수: tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    -- java: 타입 변수명;
    -- pl/sql: 변수명 타입;
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
-- FOR 인덱스 변수 IN 시작값..종료값 LOOP
-- END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_Line('i: ' || i);
    END LOOP;
END;
/


-- ==============================================================================
-- LOOP: 계속 실행 판단 로직을 LOOP 안에서 제어
-- java: while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_Line('i = ' || i);
        i := i+1;
        --loop 진행 여부 판단
        EXIT WHEN i >= 5;
    END LOOP;
END;
/


-- 간경 평균: 5 일

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
    dbms_output.put_Line('간격 평균: ' || avgdate || '일' );
END;
/

EXEC avgdt;


-- =========================================================================
SELECT avg(avg1)
FROM
(SELECT dt - LEAD(dt) OVER (ORDER BY DT desc) avg1
FROM dt);

-- =========================================================================
-- 분석함수를 사용하지 못하는 환경에서의 계산    
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
    -- 커서 선언
    CURSOR dept_cursor IS 
            SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    OPEN dept_cursor; -- 커서 열기
    
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_Line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; --더이상 읽어올 데이터가 없을 때 종료
    END LOOP;
END;
/


-- FOR LOOP CURSOR 결합 
-- java로 비유하면 향상된 for문

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

-- 파라미터가 있는 명시적 커서
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



   





