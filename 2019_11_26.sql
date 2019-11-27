SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;


--ana1
SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;


--no_ana2
--�μ��� �ο���
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT ename, empno, emp.deptno, b.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
           FROM emp
           GROUP BY deptno ) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;


--�м��Լ��� ���� �μ��� ������ (COUNT)
SELECT ename, empno, deptno, 
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--�μ��� ����� �޿� �հ�
--SUM �м��Լ�
SELECT ename, empno, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--ana2
SELECT empno, ename, sal, deptno, /*�μ��� �޿���� �Ҽ��� ���ڸ�����*/
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;


-- no_ana [�ǽ� 3] ===================================================================
SELECT a_1.empno, a_1.ename, a_1.sal, sum(b_1.sal) c_sum
FROM
    (SELECT a.*, rownum a_rn FROM(SELECT empno, ename, sal FROM emp ORDER BY sal, empno) a) a_1,
    (SELECT rownum b_rn, b.* FROM (SELECT sal FROM emp ORDER BY sal, empno) b) b_1
WHERE a_1.a_rn >= b_1.b_rn(+)
GROUP BY a_1.empno, a_1.ename, a_1.sal
ORDER BY a_1.sal, a_1.emono;



SELECT a_1.empno, a_1.ename, a_1.sal, sum(b_1.sal), NVL(a_1.sal+b_1.sal, a_1.sal) c_sum
FROM
    (SELECT a.*, rownum a_rn FROM(SELECT empno, ename, sal FROM emp ORDER BY sal, empno) a) a_1,
    (SELECT rownum b_rn, b.* FROM (SELECT sal FROM emp ORDER BY sal, empno) b) b_1
WHERE a_1.a_rn >= b_1.b_rn(+)
ORDER BY a_1.sal;


-- WINDOWING
-- UNBOUNDED PRECEDING: ���� ���� �������� �����ϴ� ��� ��
-- CURRENT ROW: ���� ��
-- UNBOUNDED FOLLOWING: ���� ���� �������� �����ϴ� ��� ��
-- N(����) PRECEDING: ���� ���� �������� �����ϴ� N���� ��
-- N(����) FOLLOWING: ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
                      
       SUM(sal) OVER (ORDER BY sal, empno
                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
    
       SUM(sal) OVER (ORDER BY sal, empno
                      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal2
FROM emp;



-- ana [�ǽ�7] ======================================================================================
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;


SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
       
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;




















