--���̺��� ������ ��ȸ

/*

    SELECT �÷� �� express(���ڿ� ���) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ����(condition)

*/

--���� � ���̺��� ������ �ִ��� Ȯ���ϱ�
DESC user_tables;

SELECT table_name, 'SELECT * FROM ' || table_name || ';' select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
--  ��ü�Ǽ� -1

SELECT *
FROM user_tables;



-- ���ں� ����
-- �μ���ȣ�� 30������ ũ�ų� ���� �μ��� ���� ����
SELECT *
FROM emp
WHERE deptno >= 30;

--�μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ

SELECT *
FROM emp
WHERE deptno < 30;

SELECT *
FROM dept;

--�Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
fROm emp
WHERE hiredate < '82/01/01';
-- WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD'); --11��
-- WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); --3��


-- col BETWEEN x AND y ����
-- �÷��� ���� x���� ũ�ų� ����, y���� �۰ų� ���� ������
-- �޿�(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� �����͸� ��ȸ

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;


-- ���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����.
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000
AND deptno = 30;



-- [�ǽ�]
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');


--[�ǽ�2]
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
  AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');


-- IN ������
-- COL IN (calues...)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno in (10, 20);

-- IN �����ڴ� OR �����ڷ� ǥ�� �� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;


--[�ǽ� 3]
SELECT userid ���̵�, usernm �̸�, alias ����
FROM users
WHERE userid in ('brown', 'cony', 'sally');


-- LIKE 'S%'
-- col�� ���� �빮�� S�� �����ϴ� ��� ��
-- col LIKE 'S____'
-- col�� ���� �빮�� s�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

--emp ���̺��� �����̸��� s�� �����ϴ� ��� ���� ��ȸ

SELECT *
FROM emp
WHERE ename LIKE 'S_____%';



--[�ǽ� 4]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE ('��%');

--[�ǽ� 5]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE ('%��%');

--WHERE mem_name LIKE('%��%'); -> ���ڿ� �ȿ� �̰� ���� ������
--WHERE mem_name LIKE('��%'); -> mem_name�� �̷� �����ϴ� ������


-- NULL ��
-- col IS NULL
-- EMP ���̺��� MGR ������ ���� ���(NULL)��ȸ
SELECT *
FROM emp
WHERE mgr IS NULL;
    --WHERE MGR != NULL;        null�񱳰� �����Ѵ�.
    
-- �ҼӺμ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';
-- = / !=
-- is null /  is not null


--[�ǽ� 6]
--emp���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�.
SELECT *
FROM emp
WHERE comm IS NOT NULL;

--AND / OR
--������(mgr) ����� 7698�̰� �޿��� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal >= 1000;


--emp ���̺��� ������(mgr) ����� 7698�̰ų�, �޿�(sal)rk 1000�̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal >= 1000;
   
   
--emp���̺��� ������(mgr)����� 7698dl dkslrh, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839); -- IN --> OR

--���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;

--IN, NOT IN ��������  NULLó��
--emp ���̺��� ������(mgr)����� 7698, 7839 Ehsms null�� �ƴ� ������ ��ȸ

SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
  AND mgr IS NOT NULL;
   
-- IN �����ڿ��� ������� NULL�� ���� ���, �ǵ����� ���� ������ �Ѵ�.


--[�ǽ� 7]
-- emp ���̺��� job�� salesman�̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.

SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD');


--[�ǽ� 8]
--emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
--(in, NOT IN ������ ��� ����)

SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--[�ǽ� 9]
-- (NOT IN ���)
SELECT *
FROM emp
WHERE deptno NOT IN(10)
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--[�ǽ� 10]
-- emp ���̺��� �μ���ȣ�� 10�� �ƴϰ�, �Ի����ڰ� 81 6 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
--(�μ��� 10 20 30�� �ִٰ� �����ϰ� IN �����ڸ� ���)

SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate >=  TO_DATE('1981/06/01', 'YYYY/MM/DD');


--[�ǽ� 11]

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >=  TO_DATE('1981/06/01', 'YYYY/MM/DD');


--[�ǽ� 12]

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE('78%');
  













