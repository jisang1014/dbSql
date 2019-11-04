-- ���� where11
-- job�� salesman�̰ų� �Ի����ڰ� 1981�� 6�� ������ ���

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
   
   
--ROWNUM�� ���� ����
--ORDER BY���� SELECT�� ���Ŀ� ����
--ROWNUM �����÷��� ����ǰ� ���� ���ĵǱ� ������, �츮�� ���ϴ� ��� ù��° �����ͺ��� �������� ��ȣ�ο��� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY ���� ������ �ζ��� �並 ����
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;

-- ROWNUM : 1������ �о�� �ȴ�.
-- WHERE���� ORWNUM ���� �߰��� �д� �� �Ұ���
-- �Ұ����� ���̽�
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >=2

-- ������ ���̽�
-- WHERE ROWNUM = 1;
-- WHERE ROWNUM <= 10;

--����¡ ó���� ���� �ļ� RoWNUM�� ��Ī�� �ο�, �ش� SQL�� INLINE VIEW�� ���ΰ� ��Ī�� ���� ����¡ ó��
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
      (SELECT e.*
      FROM emp e
       ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;



-- 11/04 �� ����

-- CONCAT: ���ڿ� ���� - �� ���� ���ڿ��� �����ϴ� �Լ�
-- SUBSTR: ���ڿ��� �κ� ���ڿ� (java: String.substring)
-- LENGTH: ���ڿ��� ����
-- INSTR: ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
-- LPAD: ���ڿ��� Ư�� ���ڿ��� ����
SELECT CONCAT('HELLO', ', WORLD!') CONCAT
FROM dual;

SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD!') CONCAT,
       SUBSTR('HELLO, WORLD', 0, 5) substr,
       SUBSTR('HELLO, WORLD', 1, 5) substr,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       
       --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
       INSTR('HELLO, WORLD', 'O', 6) instr,
       
       --LPAD(���ڿ�, ��ü ���ڿ� ����, ���ڿ��� ��ü ���ڿ� ���̿� ��ġ�� ���� ��� �߰��� ����)
       LPAD('HELLO, WORLD', 15, '*') lpad,
       RPAD('HELLO, WORLD', 15, '*') rpad,
       -- REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���� ���ڿ�)
       REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
       TRIM('   HELLO, WORLD   ') trim,
       TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;


--ROUND(��� ����, �ݿø� ��� �ڸ���)
SELECT ROUND(105.54, 1) r1, --�Ҽ��� ��° �ڸ����� �ݿø�
       ROUND(105.55, 1) r2, --�Ҽ��� ��° �ڸ����� �ݿø�
       ROUND(105.55, 0) r3,  --�Ҽ��� ù° �ڸ����� �ݿø�
       ROUND(105.55, -1) r4 --���� ù° �ڸ����� �ݿø�
FROM dual;

--ROUND(��� ����, �ݿø� ��� �ڸ���)
SELECT TRUNC(105.54, 1) t1, --�Ҽ��� ��° �ڸ����� ����
       TRUNC(105.55, 1) t2, --�Ҽ��� ��° �ڸ����� ����
       TRUNC(105.55, 0) t3,  --�Ҽ��� ù° �ڸ����� ����
       TRUNC(105.55, -1) t4 --���� ù° �ڸ����� ����
FROM dual;


SELECT empno, ename,
       sal, sal/1000, /*ROUND(sal/1000) qutient,*/ MOD(sal,1000) reminder
FROM emp;


-- SYSDATE : ����Ѥ��� ��ġ�� ������ ���� ��¥ + �ð������� ����
-- ������ ���ڰ� ���� �Լ�

--TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
--��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE + (1/24/60)*30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;


--Function date �ǽ�1

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
--�⵵: YYYY, YY, RRRR, RR: 2�ڸ��� ����, 4�ڸ��� ���� �ٸ�
-- RR: 50���� Ŭ ��� ���ڸ��� 19, 50���� ���� ��� ���ڸ��� 20
-- YYYY == RRRR
-- D: ������ ���ڷ� ǥ��(�Ͽ���-1, ������-2, ȭ����-3 ..... �����-7)
-- �������̸� ��������� ǥ��
SELECT TO_CHAR(TO_DATE('35/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('55/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('35/03/01','YY/MM/DD'),'YYYY/MM/DD') y1,
       TO_CHAR(SYSDATE, 'D') d, -- ������ ������: 2
       TO_CHAR(SYSDATE, 'IW') iw, -- ����ǥ��
       TO_CHAR(TO_DATE('20191230','YYYYMMDD'),'IW') this_year
FROM dual;



--FUNCTION date �ǽ� 2
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') dt_dash,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') dt_dash_with_time,
       TO_CHAR(SYSDATE,'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;


-- ��¥�� �ݿø�(ROUND), ����(TRUNC)
-- ROUND(DATE, '����') YYYY, MM, DD
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


-- ��¥ ���� �Լ�
-- MONTHS_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
SELECT ename,
       TO_CHAR(hiredate,'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'),hiredate) months_between
FROM emp
WHERE ename='SMITH';

--ADD_MONTHS(DATE, ���� ��) : DATE�� ���� ���� ���� ��¥
--���� ���� ����� ��� �̷�, ������ ��� ����
SELECT ename,
       TO_CHAR(hiredate,'YYYY-MM-DD HH24:MI:SS') hiredate,
        ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename='SMITH';

--NEXT_DAY(SATE, ����): DATE ���� ù��° ������ ��¥
SELECT SYSDATE,
       NEXT_DAY(SYSDATE, 7) first_sat,     --���� ��¥ ���� ù ����� ��¥
       NEXT_DAY(SYSDATE, '�����') first_sat
FROM dual;


--Last_DAY(DATE) �ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
       LAST_DAY(ADD_MONTHS(SYSDATE, 1)) LLAST_DAY_12
FROM dual;


-- DATE + ���� = DATE���� ������ŭ ������ ��¥
-- D1, ���� = D2
-- �纯���� D2�� ����
-- D1 + ���� - D2 = D2 - D2
-- D1 + ���� - D2 = 0
-- D1 + ���� = D2
-- D1 + ���� - D1 = D2 - D1
-- ���� = d2 - d1
-- ��¥���� ��¥�� ���� ���ڰ� ���´�.
SELECT TO_DATE('20191104','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D1,
       TO_DATE('20191201','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D2,
       --201908 : 2019�� 8���� �ϼ� : 31
       ADD_MONTHS(TO_DATE('201908','YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') D3
FROM dual;

















