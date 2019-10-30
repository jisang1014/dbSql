
-- SELECT : 조회할 컬럼 명시
--          - 전체 컬럼 조회: *
--          - 일부 컬럼: 해당 컬럼명 나열 (, 구분)
-- FROM : 조회할 테이블 명시
-- 쿼리를 여러줄에 나누어서 작성해도 상관 없다.
-- 단, keyword는 붙여서 작성


--모든 컬럼을 조회
SELECT * FROM prod;

SELECT prod_id, prod_name
FROM prod;


-- [실습 select1]
--1. lprod 테이블의 모든 컬럼 조회
SELECT *
FROM lprod;

--2. buyer 테이블에서 id, name 컬럼만 조회하는 쿼리를 작성하세요.
SELECT buyer_id, buyer_name
From buyer;

--3. cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요.
SELECT *
From cart;

--4. member 테이블에서 id, pass, name 컬럼만 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_pass, mem_name
From member;

--5번은 안해도 됨!


-- 연산자/날짜연산
-- date type + 정수: 일자를 더한다.
-- null을 포함한 연산의 결과는 항상 null이다.
SELECT userid, usernm, reg_dt,
       reg_dt+5 reg_dt_after5,
       reg_dt-5 as reg_dt_before5
FROM users;


--[실습 select2]
-- prod 테이블에서 id name 두 컬럼을 조회하는 쿼리를 작성하시오
--(단, prod_id -> id, prod_name -> name 으로 컬럼 별칭을 지정)
SELECT prod_id as id, prod_name as name
FROM prod;


--lprod 테이블에서 lprod_gu lprod_nm 두 컬럼을 조회하는 쿼리 작성
--(단, gu nm으로 별칭을 지정
SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;


--buyer 테이블에서 아이디, 네이 두 컬럼을 조회하는 쿼리를 작성하시오.
--(단, 아이디 -> 바이어아이디, 네이 -> 이름으로 컬럼 별칭을 지정)
SELECT buyer_id as 바이어아이디, buyer_name as 이름
FROM buyer;



-- 문자열 결합
-- jave + --> sql ||
-- concat(str, str) 함수
-- users 테이블의 userid, usernm;

SELECT userid, usernm,
       userid || usernm,
       CONCAT(userid, usernm)
FROM users;


--문자열 상수(컬럼에 담긴 데이터가 아니라, 개발자가 직접 입력한 문자열)
SELECT '사용자 아이디 : ' || userid ,
        CONCAT('사용자 아이디 : ', userid)
FROM users;


-- [실습 sel_con]
SELECT 'SELECT * FROM ' || table_name ||';' as query 
FROM user_tables;  --개발자가 가지고있는 테이블(의 수)을 조회할 수 있음



--desc table
--테이블에 정의된 컬럼을 알고 싶을 때 
-- 1. desc
-- 2. select* ......
desc emp;

SELECT *
FROM emp;


--WHERE절 조건연산자
--sql의 = 는 비교연산자
SELECT *
FROM users
WHERE userid = 'brown';






