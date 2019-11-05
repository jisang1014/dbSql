--��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����

--�� �� ���� �� ���� ���� ���� = �ϼ�
--��������¥�� ���� �� --> DD�� ����
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
--NVL(coll, coll�� null�� ��� ��ü�� ��) <- �Ķ������
SELECT empno, ename, sal, comm, NVL(comm, 0) nvl_comm,
       sal + comm, sal + NVL(comm, 0)
FROM emp;


--NVL2(coll, coll�� null�� �ƴ� ��� ǥ���Ǵ� ��, coll�� null�� ��� ǥ���Ǵ� ��)
SELECT empno, ename, sal, comm,
       NVL2(comm, comm,  0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 ������ null
--else : expr1
SELECT empno, ename, sal, comm
FROM emp;


--COALESCE(expr1, expr2......)
--�Լ� ���� �� null�� �ƴ� ù��° ����
SELECT empno, ename, sal, comm, COALESCE(comm, sal)
FROM emp;


-- null [�ǽ�] fn4
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n,
                          NVL2(mgr, mgr, 9999) mgr_n1,
                          COALESCE(mgr, 9999) mgr_n2
FROM emp;


--FUNCTION null [�ǽ�] 5
--users���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�.
--reg_dt�� null�� ��� sysdate�� ����
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



--FUNCTION condition [�ǽ� 1]

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

--[�ǽ�]

--���ش� ¦���ΰ�? Ȧ���ΰ�?
--1. ���� �⵵ ���ϱ� (date --> TO_CHAR(DATE, FORMAT)
--2. ���� �⵵�� ¦������ ���
--   � ���� 2�� ������ �������� �׻� 2���� �۴�.
--   2�� ���� ��� �������� 0, 1
SELECT MOD(TO_CHAR(sysdate, 'YY'),2)
FROM dual;


SELECT empno, ename,hiredate,
       case --case�� ��ǥ�� �ʿ� ����
           when MOD(TO_CHAR(sysdate, 'YY'),2) = MOD(TO_CHAR(hiredate, 'YY'), 2)
           then '�ǰ����� �����'
           else '�ǰ����� ������'
       end AS CONTACT_TO_DOCTOR
FROM emp;


--FUNCTION [�ǽ� 3]

SELECT userid, usernm, alias, reg_dt, 
    case
        when MOD(TO_CHAR(sysdate, 'YY'), 2) = MOD(TO_CHAR(reg_dt, 'YY'), 2)
        then '�ǰ����� �����'
        else '�ǰ����� ������'
        end ContactToDoctor
FROM users;


-- �׷��Լ� ( AVG, MAX, MIN, SUM, COUNT )
-- �׷��Լ��� NULL���� ����󿡼� �����Ѵ�.

--SUM(comm), COUNT(*), COUNT(mgr)
-- ���� �� ���� ���� �޿��� �޴� ����� �޿�
-- ���� �� ���� ���� �޿��� �޴� ����� �޿�
SELECT MAX(sal) max_sal, MIN(sal) min_sal
FROM emp;

-- �μ��� ���� ���� �޿��� �޴� ����� �޿�
-- GROUP BY ���� ������� ���� �÷��� SELECT ���� ����� ��� ���� �߻�
-- ������ �޿� ���
-- ������ �޿� ��
-- ������ ����
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--�׷�ȭ�� ��� ���� �÷��� �� �� ������, �׷�ȭ�� ��� ���� ������ ���ڿ�, ����� �� �� �ִ�.
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;


--�μ��� �ִ� �޿�

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;


--������ ���� ���� �޿�
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_SAL,
       COUNT(mgr) count_mgr,
       COUNT(*) count_ALL
FROM emp;


--�μ�����
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

--[�ǽ� 3]
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













