
-- 익명 블록
set serveroutput on;

DECLARE 
    -- 사원 이름을 저장할 스칼라 변수(1개의 값)
    V_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp;
     -- 조회 결과는 여러 건인데, 스칼라 변수(1개)에 값을 저장하려 한다.
     -- --> 에러!
     
     --발생 예외, 발생 예외를 특정짓기 힘들 때는 OTHERS(java: Exception)
     EXCEPTION 
        WHEN others THEN
            dbms_output.put_line('Exeption others');
END;
/


-- ========================================================================================
-- 사용자 정의 예외
-- ========================================================================================

DECLARE
    -- emp 테이블 조회시 결과가 없을 경우 발생시킬 사용자 정의 예외
    -- 예외명 EXCEPTION; -- 변수명 - 변수타입(변수타입 대신 exception이라는 키워드가 들어감
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN

    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = 9999;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN dbms_output.put_line('데이터 미존재');
            -- 개발자가 생성한 사용자 정의 예외를 생성
            RAISE NO_EMP;
    END;
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('NO_EMP Exception');

END;
/


-- ========================================================================================
-- 함수(function)
-- ========================================================================================


-- 사원번호를 인지하고, 해당 사원번호에 해당하는 사원이름을 리턴하는 함수(function)

CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2
IS
    -- 선언부
    ret_ename emp.ename%TYPE;
BEGIN
    -- 로직
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
-- 트리거
-- ========================================================================================

CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

-- users 테이블의 pass컬럼이 변경될 경우 users_history에 변경전 pass를 이력으로 남기는 트리거

CREATE OR REPLACE TRIGGER make_history  
    BEFORE UPDATE ON users -- users 테이블을 업데이트하기 전에 실행
    FOR EACH ROW    -- 행단위로 적용
    
    BEGIN
        -- :NEW.컬럼명 -> UPDATE쿼리시 작성한 값
        -- :OLD.컬럼명 -> 현재 테이블 값
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

 
    











