SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE owner = 'DOREMI';


SELECT *
FROM doremi.V_EMP_DEPT;

-- doremi 계정에서 조회권한을 받은 V_EMP_DEPT view를 hr계정에서 조회하기위해서는 계정명.view이름 형식으로 기술을 해야한다.
-- 매번 계정명을 기술하기 귀찮으므로 시노님을 통해서 다른 별칭을 생성

CREATE SYNONYM V_EMP_DEPT FOR doremi.V_EMP_DEPT;

--doremi.V_EMP_DEPT ==> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- ============================================================================================
DROP SYNONYM V_EMP_DEPT;

-- hr계정 비밀번호: java
-- hr 계정 비밀번호 변경 hr

ALTER USER hr IDENTIFIED BY java;
-- ALTER USER doremi IDENTIFIED BY doremi; >> 본인 계정이 아니라 에러가 난다.


--============================================================================================

-- dictionary
-- 접두어 : USER - 사용자 소유 객체
--         All - 사용자가 사용가능한 객체
--         DBA - 관리자 관점의 전체 객체 (일반 사용자는 사용 불가)
--         V$ - 시스템과 관련된 view (일반 사용자는 사용 불가)


SELECT * 
FROM USER_TABLES;

SELECT * 
FROM ALL_TABLES;

SELECT * 
FROM DBA_TABLES
WHERE owner IN ('DOREMI', 'HR');


-- ===================================================================
-- 오라클에서 동일한 SQL이란?
-- 문자가 하나라도 틀리면 안된다.
-- 다음 sql들은 같은 결과를 만들어낼지 몰라도 DBMS에서는 서로 다른 SQL로 인신된다.
SELECT /*+ bind_test*/ * FROM emp;
Select /*+ bind_test*/ * FROM emp;
select /*+ bind_test*/ *   FROM emp;

select /*+ bind_test*/ * FROM emp WHERE empno = 9367;
select /*+ bind_test*/ * FROM emp WHERE empno = 7499;
select /*+ bind_test*/ * FROM emp WHERE empno = 7521;

select /*+ bind_test*/ * FROM emp WHERE empno = :empno;
--바인딩 변수: 불필요한 메모리를 차지하지 않기 위해 사용


SELECT *
FROM v$SQL;








