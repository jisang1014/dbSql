--년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제

--한 달 더한 후 원래 값을 빼면 = 일수
--마지막날짜를 구한 후 --> DD만 추출
SELECT TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')),'DD') AS DT
FROM dual;

SELECT :YYYYMM PARAM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD') AS DAYCNT
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE empno = 7300+'69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

------------------------------------------

SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.99') sal_fmt
FROM emp;



--function null
--NVL(coll, coll이 null일 경우 대체할 값) <- 파라미터임
SELECT empno, ename, sal, comm, NVL(comm, 0) nvl_comm,
       sal + comm, sal + NVL(comm, 0)
FROM emp;


--NVL2(coll, coll이 null이 아닐 경우 표현되는 값, coll이 null일 경우 표현되는 값)
SELECT empno, ename, sal, comm,
       NVL2(comm, comm,  0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 같으면 null
--else : expr1
SELECT empno, ename, sal, comm
FROM emp;


--COALESCE(expr1, expr2......)
--함수 인자 중 null이 아닌 첫번째 인자
SELECT empno, ename, sal, comm, COALESCE(comm, sal)
FROM emp;


-- null [실습] fn4
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n,
                          NVL2(mgr, mgr, 9999) mgr_n1,
                          COALESCE(mgr, 9999) mgr_n2
FROM emp;


--FUNCTION null [실습] 5
--users테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오.
--reg_dt가 null일 경우 sysdate를 적용
SELECT userid, usernm, reg_dt, NVL(reg_dt,SYSDATE) n_reg_dt
FROM users;


--case when
SELECT empno, ename, job, sal,
       case
            when job = 'SALESMAN' then sal*1.05
            when job = 'MANAGER' then sal*1.10
            when job = 'PRESIDENT' then sal*1.20
            else sal
       end AS case_sal
FROM emp;

--decode(col, search1, return1, search2, return2....... default)
SELECT empno, ename, job, sal,
       decode(job, 'SALESMAN', sal*1.05,
                   'MANAGER', sal*1.10,
                   'PRESIDENT', sal*1.20,
                                        sal) AS decode_sal
FROM emp;



--FUNCTION condition [실습 1]

SELECT empno, ename,
       case
            when deptno = 10 then 'ACCOUNTING'
            when deptno = 20 then 'RESEARCH'
            when deptno = 30 then 'SALES'
            when deptno = 40 then 'OPERATIONS'
            else 'DDIT' 
       end AS dname
FROM emp;

SELECT empno, ename,
       decode(deptno, 10, 'ACCOUNTING',
                      20, 'RESEARCH',
                      30, 'SALES',
                      40, 'OPERATIONS',
                          'DDIT') dname
FROM emp;

--[실습]

--올해는 짝수인가? 홀수인가?
--1. 올해 년도 구하기 (date --> TO_CHAR(DATE, FORMAT)
--2. 올해 년도가 짝수인지 계산
--   어떤 수를 2로 나누면 나머지는 항상 2보다 작다.
--   2로 나눌 경우 나머지는 0, 1
SELECT MOD(TO_CHAR(sysdate, 'YY'),2)
FROM dual;


SELECT empno, ename,hiredate,
       case --case는 쉼표가 필요 없음
           when MOD(TO_CHAR(sysdate, 'YY'),2) = MOD(TO_CHAR(hiredate, 'YY'), 2)
           then '건강검진 대상자'
           else '건강검진 비대상자'
       end AS CONTACT_TO_DOCTOR
FROM emp;


--FUNCTION [실습 3]

SELECT userid, usernm, alias, reg_dt, 
    case
        when MOD(TO_CHAR(sysdate, 'YY'), 2) = MOD(TO_CHAR(reg_dt, 'YY'), 2)
        then '건강검진 대상자'
        else '건강검진 비대상자'
        end ContactToDoctor
FROM users;


-- 그룹함수 ( AVG, MAX, MIN, SUM, COUNT )
-- 그룹함수는 NULL값을 계산대상에서 제외한다.

--SUM(comm), COUNT(*), COUNT(mgr)
-- 직원 중 가장 높은 급여를 받는 사람의 급여
-- 직원 중 가장 낮은 급여를 받는 사람의 급여
SELECT MAX(sal) max_sal, MIN(sal) min_sal
FROM emp;

-- 부서별 가장 높은 급여를 받는 사람의 급여
-- GROUP BY 절에 기술되지 않은 컬럼이 SELECT 절에 기술될 경우 에러 발생
-- 직원의 급여 평균
-- 직원의 급여 합
-- 직원의 숫자
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--그룹화와 상관 없는 컬럼은 올 수 없지만, 그룹화와 상관 없는 임의의 문자열, 상수는 올 수 있다.
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;


--부서별 최대 급여

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;


--직원별 가장 높은 급여
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_SAL,
       COUNT(mgr) count_mgr,
       COUNT(*) count_ALL
FROM emp;


--부서기준
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_SAL,
       COUNT(mgr) count_mgr,
       COUNT(*) count_ALL
FROM emp
GROUP BY deptno;

--[실습 3]
SELECT 
    case
        when deptno = 30 then 'ACCOUNTING'
        when deptno = 20 then 'RESEARCH'
        when deptno = 10 then 'SALES'
    end dname,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_SAL,
       COUNT(mgr) count_mgr,
       COUNT(*) count_ALL
FROM emp
GROUP BY deptno;













