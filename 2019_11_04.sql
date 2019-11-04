-- 복습 where11
-- job이 salesman이거나 입사일자가 1981년 6월 이후인 사람

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
   
   
--ROWNUM과 정렬 문제
--ORDER BY절은 SELECT절 이후에 동작
--ROWNUM 가사컬럼이 적용되고 나서 정렬되기 때문에, 우리가 원하는 대로 첫번째 데이터부터 순차적인 번호부여가 되지 않는다.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY 절을 포함한 인라인 뷰를 구성
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;

-- ROWNUM : 1번부터 읽어야 된다.
-- WHERE절에 ORWNUM 값을 중간만 읽는 건 불가능
-- 불가능한 케이스
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >=2

-- 가능한 케이스
-- WHERE ROWNUM = 1;
-- WHERE ROWNUM <= 10;

--페이징 처리를 위한 꼼수 RoWNUM에 별칭을 부여, 해당 SQL을 INLINE VIEW로 감싸고 별칭을 통해 페이징 처리
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
      (SELECT e.*
      FROM emp e
       ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;



-- 11/04 본 수업

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
       RPAD('HELLO, WORLD', 15, '*') rpad,
       -- REPLACE(원본문자열, 원본 문자열에서 변경하고자 하는 대상 문자열, 변경 문자열)
       REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
       TRIM('   HELLO, WORLD   ') trim,
       TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;


--ROUND(대상 숫자, 반올림 결과 자리수)
SELECT ROUND(105.54, 1) r1, --소수점 둘째 자리에서 반올림
       ROUND(105.55, 1) r2, --소수점 둘째 자리에서 반올림
       ROUND(105.55, 0) r3,  --소수점 첫째 자리에서 반올림
       ROUND(105.55, -1) r4 --정수 첫째 자리에서 반올림
FROM dual;

--ROUND(대상 숫자, 반올림 결과 자리수)
SELECT TRUNC(105.54, 1) t1, --소수점 둘째 자리에서 절삭
       TRUNC(105.55, 1) t2, --소수점 둘째 자리에서 절삭
       TRUNC(105.55, 0) t3,  --소수점 첫째 자리에서 절삭
       TRUNC(105.55, -1) t4 --정수 첫째 자리에서 절삭
FROM dual;


SELECT empno, ename,
       sal, sal/1000, /*ROUND(sal/1000) qutient,*/ MOD(sal,1000) reminder
FROM emp;


-- SYSDATE : 오라ㅡㄹ이 설치된 서버의 현재 날짜 + 시간정보를 리턴
-- 별도의 인자가 없는 함수

--TO_CHAR : DATE 타입을 문자열로 변환
--날짜를 문자열로 변환시에 포맷을 지정
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE + (1/24/60)*30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;


--Function date 실습1

SELECT TO_DATE('19/12/31', 'YY/MM/DD') lastday,
       TO_DATE('19/12/31', 'YY/MM/DD')-5 lastday_before5,
       SYSDATE now,
       SYSDATE-3 now_before3
FROM dual;


SELECT lastday, lastday-5 lastday_before5, now, now-3 now_before3
FROM
    (SELECT TO_DATE('19/12/31', 'YY/MM/DD') lastday,
            SYSDATE now
    FROM dual);


--date format
--년도: YYYY, YY, RRRR, RR: 2자리일 때랑, 4자리일 때랑 다름
-- RR: 50보다 클 경우 앞자리는 19, 50보다 작을 경우 앞자리는 20
-- YYYY == RRRR
-- D: 요일을 숫자로 표기(일요일-1, 월요일-2, 화요일-3 ..... 토요일-7)
-- 가급적이면 명시적으로 표현
SELECT TO_CHAR(TO_DATE('35/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('55/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('35/03/01','YY/MM/DD'),'YYYY/MM/DD') y1,
       TO_CHAR(SYSDATE, 'D') d, -- 오늘은 월요일: 2
       TO_CHAR(SYSDATE, 'IW') iw, -- 주차표기
       TO_CHAR(TO_DATE('20191230','YYYYMMDD'),'IW') this_year
FROM dual;



--FUNCTION date 실습 2
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') dt_dash,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') dt_dash_with_time,
       TO_CHAR(SYSDATE,'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;


-- 날짜의 반올림(ROUND), 절삭(TRUNC)
-- ROUND(DATE, '포맷') YYYY, MM, DD
desc emp;
SELECT ename,
       TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') AS hiredate,
       TO_CHAR(ROUND(hiredate, 'yyyy'), 'YYYY/MM/DD HH24:MI:SS') AS round_YYYY,
       TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS round_MM
FROM emp
WHERE ename = 'SMITH';


SELECT ename,
       TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') AS hiredate,
       TO_CHAR(TRUNC(hiredate, 'yyyy'), 'YYYY/MM/DD HH24:MI:SS') AS TRUNC_YYYY,
       TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS TRUNC_MM
FROM emp
WHERE ename = 'SMITH';


-- 날짜 연산 함수
-- MONTHS_BETWEEN(DATE, DATE) : 두 날짜 사이의 개월 수
SELECT ename,
       TO_CHAR(hiredate,'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'),hiredate) months_between
FROM emp
WHERE ename='SMITH';

--ADD_MONTHS(DATE, 개월 수) : DATE에 개월 수가 지난 날짜
--개월 수가 양수일 경우 미래, 음수일 경우 과거
SELECT ename,
       TO_CHAR(hiredate,'YYYY-MM-DD HH24:MI:SS') hiredate,
        ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename='SMITH';

--NEXT_DAY(SATE, 요일): DATE 이후 첫번째 요일의 날짜
SELECT SYSDATE,
       NEXT_DAY(SYSDATE, 7) first_sat,     --오늘 날짜 이후 첫 토요일 날짜
       NEXT_DAY(SYSDATE, '토요일') first_sat
FROM dual;


--Last_DAY(DATE) 해당 날짜가 속한 월의 마지막 일자
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
       LAST_DAY(ADD_MONTHS(SYSDATE, 1)) LLAST_DAY_12
FROM dual;


-- DATE + 정수 = DATE에서 정수만큼 이후의 날짜
-- D1, 정수 = D2
-- 양변에서 D2를 차감
-- D1 + 정수 - D2 = D2 - D2
-- D1 + 정수 - D2 = 0
-- D1 + 정수 = D2
-- D1 + 정수 - D1 = D2 - D1
-- 정수 = d2 - d1
-- 날짜에서 날짜를 빼면 일자가 나온다.
SELECT TO_DATE('20191104','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D1,
       TO_DATE('20191201','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D2,
       --201908 : 2019년 8월의 일수 : 31
       ADD_MONTHS(TO_DATE('201908','YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') D3
FROM dual;

















