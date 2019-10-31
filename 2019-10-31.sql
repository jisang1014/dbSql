--테이블에서 데이터 조회

/*

    SELECT 컬럼 ｜ express(문자열 상수) [as] 별칭
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건(condition)

*/

--내가 어떤 테이블을 가지고 있는지 확인하기
DESC user_tables;

SELECT table_name, 'SELECT * FROM ' || table_name || ';' select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
--  전체건수 -1

SELECT *
FROM user_tables;



-- 숫자비교 연산
-- 부서번호가 30번보다 크거나 같은 부서에 속한 직원
SELECT *
FROM emp
WHERE deptno >= 30;

--부서번호가 30번보다 작은 부서에 속한 직원 조회

SELECT *
FROM emp
WHERE deptno < 30;

SELECT *
FROM dept;

--입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
fROm emp
WHERE hiredate < '82/01/01';
-- WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD'); --11명
-- WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); --3명


-- col BETWEEN x AND y 연산
-- 컬럼의 값이 x보다 크거나 같고, y보다 작거나 같은 데이터
-- 급여(sal)가 1000보다 크거나 같고, 2000보다 작거나 같은 데이터를 조회

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;


-- 위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다.
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000
AND deptno = 30;



-- [실습]
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');


--[실습2]
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
  AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');


-- IN 연산자
-- COL IN (calues...)
-- 부서번호가 10 혹은 20인 직원 조회
SELECT *
FROM emp
WHERE deptno in (10, 20);

-- IN 연산자는 OR 연산자로 표현 할 수 있다.
SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;


--[실습 3]
SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid in ('brown', 'cony', 'sally');


-- LIKE 'S%'
-- col의 값이 대문자 S로 시작하는 모든 값
-- col LIKE 'S____'
-- col의 값이 대문자 s로 시작하고 이어서 4개의 문자열이 존재하는 값

--emp 테이블에서 직원이름이 s로 시작하는 모든 직원 조회

SELECT *
FROM emp
WHERE ename LIKE 'S_____%';



--[실습 4]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE ('신%');

--[실습 5]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE ('%진%');

--WHERE mem_name LIKE('%이%'); -> 문자열 안에 이가 들어가는 데이터
--WHERE mem_name LIKE('이%'); -> mem_name이 이로 시작하는 데이터


-- NULL 비교
-- col IS NULL
-- EMP 테이블에서 MGR 정보가 없는 사람(NULL)조회
SELECT *
FROM emp
WHERE mgr IS NULL;
    --WHERE MGR != NULL;        null비교가 실패한다.
    
-- 소속부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != '10';
-- = / !=
-- is null /  is not null


--[실습 6]
--emp테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오.
SELECT *
FROM emp
WHERE comm IS NOT NULL;

--AND / OR
--관리자(mgr) 사번이 7698이고 급여가 1000 이상인 사람
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal >= 1000;


--emp 테이블에서 관리자(mgr) 사번이 7698이거나, 급여(sal)rk 1000이상인 직원 조회
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal >= 1000;
   
   
--emp테이블에서 관리자(mgr)사번이 7698dl dkslrh, 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839); -- IN --> OR

--위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;

--IN, NOT IN 연산자의  NULL처리
--emp 테이블에서 관리자(mgr)사번이 7698, 7839 Ehsms null이 아닌 직원들 조회

SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
  AND mgr IS NOT NULL;
   
-- IN 연산자에서 결과값에 NULL이 있을 경우, 의도하지 않은 동작을 한다.


--[실습 7]
-- emp 테이블에서 job이 salesman이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.

SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD');


--[실습 8]
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
--(in, NOT IN 연산자 사용 금지)

SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--[실습 9]
-- (NOT IN 사용)
SELECT *
FROM emp
WHERE deptno NOT IN(10)
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--[실습 10]
-- emp 테이블에서 부서번호가 10이 아니고, 입사일자가 81 6 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
--(부서는 10 20 30만 있다고 가정하고 IN 연산자를 사용)

SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate >=  TO_DATE('1981/06/01', 'YYYY/MM/DD');


--[실습 11]

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >=  TO_DATE('1981/06/01', 'YYYY/MM/DD');


--[실습 12]

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE('78%');
  













