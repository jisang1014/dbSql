--복습
--WHERE

--연산자
--비교: =, !=, <>, >= >, <=, <

-- BETWEEN start AND end
-- IN (set)
-- Like 'S%' (%: 다수의 문자열과 매칭, _ : 정확히 한 글자 매칭)            -> 간략화된 정규식
-- IS NULL  (!= NULL 로는 비교할 수 없음)
-- AND, OR, NOT

--EMP 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 정보 조회

SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD') AND TO_DATE('1986/12/31', 'YYYY/MM/DD');

SELECT *
FROM emp
WHERE hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD')
  AND hiredate < TO_DATE('1986/12/31', 'YYYY/MM/DD');
  
--emp 테이블에서 관리자(mgr)이 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
 
 
 
 --[where 실습 13]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno = 78
   OR (empno >= 780 AND empno < 790)
   OR (empno >= 7800  AND empno < 7900);
   

---[where 실습 14]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD') AND empno LIKE ('78%'));
 
 
-- order by 컬럼명｜별칭｜컬럼인덱스 [ASC｜DESC]
-- order by 구문은 HWERE절 다음에 기술
-- WHERE절이 없을 경우 FROM절 다음에 기술
-- ename테이블을 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC: default
--ASC를 안 붙여도 위 쿼리와 동일한 조회가 가능
SELECT *
FROM emp
ORDER BY ename;

--이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename DESC;


--job을 기준으로 내림차순으로 정렬, 만약 job이 같을 경우 사번(empno)로 오름차순 정렬

SELECT *
FROM emp
ORDER BY job DESC, empno;  --job을 먼저 정렬하고, ',' 다음에 오는 컬럼을 정렬

--별칭으로 정렬하기
--사원번호(ename), 사원명(ename), 연봉(sal*12) as year_sal
-- year_sal 별칭으로 오름차순 정렬
SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY year_sal ASC;


--select절 컬럼 순서 인덱스로 정렬
 SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY 4;


-- [ order BY 실습 1]

desc dept;

SELECT *
FROM dept
ORDER BY dname ASC;

SELECT *
FROM dept
ORDER BY loc DESC;


-- [ order by 실습 2]
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;


-- [order by 실습 3]
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;
 
 
 --[order by 실습 4]
 SELECT *
 FROm emp
 WHERE deptno in(10,30)
   AND sal > 1500
ORDER BY ename DESC;


desc emp;
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10;   
-- 1~10까지 차례로 읽는 데이터는( <= 10 ) 불러올 수 있지만,
-- 가장 처음에 위치한 1을 제외하고 =2, =4 식으로 앞을 뛰어넘고 중간 데이터부터는 불러올 수 없다


-- emp 테이블에서 사번(empno), 이름(ename)을 급여기준으로 오름차순 정렬하고, 정렬된 결과 순으로 ROWNUM을 적용
SELECT ROWNUM, sal, empno, ename
FROM emp
ORDER BY sal;

-- row_1
SELECT ROWNUM, a.*
FROM
(SELECT sal, empno, ename
FROM emp 
ORDER BY sal) a; --괄호로 묶으면 그걸 하나의 테이블로 인식한다. emp = () * inline view


--row_2
SELECT ROWNUM rn, a.*
FROM
    (SELECT empno, ename
    FROM emp 
    ORDER BY sal) a
WHERE ROWNUM <= 10;


SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
      (SELECT empno, ename
      FROM emp 
      ORDER BY sal) a)
 WHERE rn > 10;


    
    
-- FUNCTION
-- DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

-- 문자열 대소문자 관련 함수
-- LOWER, UPPER, INITCAP
SELECT LOWER('HELLO, WORLD'), UPPER('HELLO, WORLD'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';


--FUNCTION은 WHERE절에서도 사용 가능
SELECT *
FROM emp
WHERE ename = upper('smith');


SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
-- 개발자 sql 칠거지악
-- 1. 좌변을 가공하지 말아라 (테이블의 컬럼)
-- 좌변을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
-- Function based Index -> FBI


-- CONCAT: 문자열 결합 - 두 개의 문자열을 결합하는 함수
-- SUBSTR: 문자열의 부분 문자열 (java: String.substring)
-- LENGTH: 문자열의 길이
-- INSTR: 문자열에 특정 문자열이 등장하는 첫번째 인덱스
-- LPAD: 문자열에 특정 문자열을 삽입
SELECT CONCAT('HELLO', ', WORLD!') CONCAT
FROM dual;

SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD!') CONCAT,
       SUBSTR('HELLO, WORLD', 0, 5) substr,
       SUBSTR('HELLO, WORLD', 1, 5) substr,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       
       --INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
       INSTR('HELLO, WORLD', 'O', 6) instr,
       
       --LPAD(문자열, 전체 문자열 길이, 문자열이 전체 문자열 길이에 미치지 못할 경우 추가할 문자)
       LPAD('HELLO, WORLD', 15, '*') lpad,
       RPAD('HELLO, WORLD', 15, '*') rpad
       
FROM dual;


-- S




















 
 
