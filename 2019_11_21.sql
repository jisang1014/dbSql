-- ��ü ������ �޿����: 2073.21

SELECT ROUNd(AVG(sal), 2)
FROM emp;

-- �μ��� ������ �޿� ���
-- 10: 2916.67 | 20: 2175 | 30: 1566.67
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUNd(AVG(sal), 2)
                  FROM emp);
                                 
                                 
-- ���� ���� WITH���� �����Ͽ� ������ �����Ѱ� ǥ���Ѵ�.
WITH dept_avg_sal AS (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
                      FROM emp
                      GROUP BY deptno)

SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUNd(AVG(sal), 2)
                  FROM emp);




-- =========================================================================
-- �޷� ����� ///////////////////////////////////////////////////////////////
-- ========================================================================= 
-- STEP1. �ش� ����� ���� �����
-- CONNECT BY LEVEL

-- 201911 
-- DATE + ���� = ���� ���ϱ� ����

SELECT 
       DECODE(d, 1, a.iw+1, a.iw) iw,
       MAX(DECODE (d, 1, dt)) sun, MAX(DECODE (d, 2, dt)) mon, MAX(DECODE (d, 3, dt)) tue,
       MAX(DECODE (d, 4, dt)) wed, MAX(DECODE (d, 5, dt)) thu, MAX(DECODE (d, 6, dt)) fri,
       MAX(DECODE (d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d
    FROM dual a
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY DECODE(d, 1, a.iw+1, a.iw)
ORDER BY DECODE(d, 1, a.iw+1, a.iw);


-- ==========================================================================================

SELECT *
FROM
    (SELECT 
           DECODE(d, 1, a.iw+1, a.iw) iw,
           MAX(DECODE (d, 1, dt)) sun, MAX(DECODE (d, 2, dt)) mon, MAX(DECODE (d, 3, dt)) tue,
           MAX(DECODE (d, 4, dt)) wed, MAX(DECODE (d, 5, dt)) thu, MAX(DECODE (d, 6, dt)) fri,
           MAX(DECODE (d, 7, dt)) sat
    FROM 
        (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw,
                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d
        FROM dual a
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
    GROUP BY DECODE(d, 1, a.iw+1, a.iw)
    ORDER BY DECODE(d, 1, a.iw+1, a.iw)) b;


-- =========================================================================
-- =========================================================================
-- /////////////////////////////////////////////////////////////////////////
-- =========================================================================
SELECT 
       MAX(DECODE(m_dt, 01, s_sales, 0)) jan,
       MAX(DECODE(m_dt, 02, s_sales, 0)) feb,
       MAX(DECODE(m_dt, 03, s_sales, 0)) mar,
       MAX(DECODE(m_dt, 04, s_sales, 0)) apr,
       MAX(DECODE(m_dt, 05, s_sales, 0)) may,
       MAX(DECODE(m_dt, 06, s_sales, 0)) jun
FROM 
    (SELECT TO_CHAR(dt, 'MM') m_dt, sum(sales) s_sales
    FROM sales
    GROUP BY TO_CHAR(dt, 'MM'));




SELECT NMAX(DECODE(TO_CHAR(dt, 'MM'), 01, sum(sales), 0)) jan,
        MAX(DECODE(TO_CHAR(dt, 'MM'), 02, sum(sales), 0)) jan,
        MAX(DECODE(TO_CHAR(dt, 'MM'), 03, sum(sales), 0)) jan,
        MAX(DECODE(TO_CHAR(dt, 'MM'), 04, sum(sales), 0)) jan,
        MAX(DECODE(TO_CHAR(dt, 'MM'), 05, sum(sales), 0)) jan,
        MAX(DECODE(TO_CHAR(dt, 'MM'), 06, sum(sales), 0)) jan
FROM sales
GROUP BY TO_CHAR(dt, 'MM');


-- =========================================================================
-- /////////////////////////////////////////////////////////////////////////
-- =========================================================================

create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

-- =========================================================================
-- /////////////////////////////////////////////////////////////////////////
-- =========================================================================

-- ��������
-- START WITH: ������ ���� �κ��� ����
-- CONNECT BY : ������ ���� ������ ����

-- ����İ��� ���� (���� �ֻ��� ���Ǻ��� ��� ������ Ž��)
SELECT dept_h.*, LEVEL, LPAD(' ',(LEVEL -1)*4, ' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0'  -- = START WITH p_deptcd IS NULL 
CONNECT BY PRIOR deptcd = p_deptcd; -- PRIOR: ���� ���� ������(�ش� ���������� �ֻ��� �ڵ��� xxȸ��: dept0)
   
   
SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*5, ' ') || dept_h.deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;





























