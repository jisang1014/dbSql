--����
--WHERE

--������
--��: =, !=, <>, >= >, <=, <

-- BETWEEN start AND end
-- IN (set)
-- Like 'S%' (%: �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �� ���� ��Ī)            -> ����ȭ�� ���Խ�
-- IS NULL  (!= NULL �δ� ���� �� ����)
-- AND, OR, NOT

--EMP ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� ���� ���� ��ȸ

SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD') AND TO_DATE('1986/12/31', 'YYYY/MM/DD');

SELECT *
FROM emp
WHERE hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD')
  AND hiredate < TO_DATE('1986/12/31', 'YYYY/MM/DD');
  
--emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
 
 
 
 --[where �ǽ� 13]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno = 78
   OR (empno >= 780 AND empno < 790)
   OR (empno >= 7800  AND empno < 7900);
   

---[where �ǽ� 14]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD') AND empno LIKE ('78%'));
 
 
-- order by �÷������Ī���÷��ε��� [ASC��DESC]
-- order by ������ HWERE�� ������ ���
-- WHERE���� ���� ��� FROM�� ������ ���
-- ename���̺��� �������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC: default
--ASC�� �� �ٿ��� �� ������ ������ ��ȸ�� ����
SELECT *
FROM emp
ORDER BY ename;

--�̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;


--job�� �������� ������������ ����, ���� job�� ���� ��� ���(empno)�� �������� ����

SELECT *
FROM emp
ORDER BY job DESC, empno;  --job�� ���� �����ϰ�, ',' ������ ���� �÷��� ����

--��Ī���� �����ϱ�
--�����ȣ(ename), �����(ename), ����(sal*12) as year_sal
-- year_sal ��Ī���� �������� ����
SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY year_sal ASC;


--select�� �÷� ���� �ε����� ����
 SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY 4;


-- [ order BY �ǽ� 1]

desc dept;

SELECT *
FROM dept
ORDER BY dname ASC;

SELECT *
FROM dept
ORDER BY loc DESC;


-- [ order by �ǽ� 2]
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;


-- [order by �ǽ� 3]
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;
 
 
 --[order by �ǽ� 4]
 SELECT *
 FROm emp
 WHERE deptno in(10,30)
   AND sal > 1500
ORDER BY ename DESC;


desc emp;
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10;   
-- 1~10���� ���ʷ� �д� �����ʹ�( <= 10 ) �ҷ��� �� ������,
-- ���� ó���� ��ġ�� 1�� �����ϰ� =2, =4 ������ ���� �پ�Ѱ� �߰� �����ͺ��ʹ� �ҷ��� �� ����


-- emp ���̺��� ���(empno), �̸�(ename)�� �޿��������� �������� �����ϰ�, ���ĵ� ��� ������ ROWNUM�� ����
SELECT ROWNUM, sal, empno, ename
FROM emp
ORDER BY sal;

-- row_1
SELECT ROWNUM, a.*
FROM
(SELECT sal, empno, ename
FROM emp 
ORDER BY sal) a; --��ȣ�� ������ �װ� �ϳ��� ���̺�� �ν��Ѵ�. emp = () * inline view


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
-- DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

-- ���ڿ� ��ҹ��� ���� �Լ�
-- LOWER, UPPER, INITCAP
SELECT LOWER('HELLO, WORLD'), UPPER('HELLO, WORLD'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';


--FUNCTION�� WHERE�������� ��� ����
SELECT *
FROM emp
WHERE ename = upper('smith');


SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
-- ������ sql ĥ������
-- 1. �º��� �������� ���ƶ� (���̺��� �÷�)
-- �º��� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
-- Function based Index -> FBI


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
       RPAD('HELLO, WORLD', 15, '*') rpad
       
FROM dual;


-- S




















 
 
