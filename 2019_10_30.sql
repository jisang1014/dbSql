
-- SELECT : ��ȸ�� �÷� ���
--          - ��ü �÷� ��ȸ: *
--          - �Ϻ� �÷�: �ش� �÷��� ���� (, ����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� ��� ����.
-- ��, keyword�� �ٿ��� �ۼ�


--��� �÷��� ��ȸ
SELECT * FROM prod;

SELECT prod_id, prod_name
FROM prod;


-- [�ǽ� select1]
--1. lprod ���̺��� ��� �÷� ��ȸ
SELECT *
FROM lprod;

--2. buyer ���̺��� id, name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT buyer_id, buyer_name
From buyer;

--3. cart ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT *
From cart;

--4. member ���̺��� id, pass, name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT mem_id, mem_pass, mem_name
From member;

--5���� ���ص� ��!


-- ������/��¥����
-- date type + ����: ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�.
SELECT userid, usernm, reg_dt,
       reg_dt+5 reg_dt_after5,
       reg_dt-5 as reg_dt_before5
FROM users;


--[�ǽ� select2]
-- prod ���̺��� id name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--(��, prod_id -> id, prod_name -> name ���� �÷� ��Ī�� ����)
SELECT prod_id as id, prod_name as name
FROM prod;


--lprod ���̺��� lprod_gu lprod_nm �� �÷��� ��ȸ�ϴ� ���� �ۼ�
--(��, gu nm���� ��Ī�� ����
SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;


--buyer ���̺��� ���̵�, ���� �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--(��, ���̵� -> ���̾���̵�, ���� -> �̸����� �÷� ��Ī�� ����)
SELECT buyer_id as ���̾���̵�, buyer_name as �̸�
FROM buyer;



-- ���ڿ� ����
-- jave + --> sql ||
-- concat(str, str) �Լ�
-- users ���̺��� userid, usernm;

SELECT userid, usernm,
       userid || usernm,
       CONCAT(userid, usernm)
FROM users;


--���ڿ� ���(�÷��� ��� �����Ͱ� �ƴ϶�, �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid ,
        CONCAT('����� ���̵� : ', userid)
FROM users;


-- [�ǽ� sel_con]
SELECT 'SELECT * FROM ' || table_name ||';' as query 
FROM user_tables;  --�����ڰ� �������ִ� ���̺�(�� ��)�� ��ȸ�� �� ����



--desc table
--���̺� ���ǵ� �÷��� �˰� ���� �� 
-- 1. desc
-- 2. select* ......
desc emp;

SELECT *
FROM emp;


--WHERE�� ���ǿ�����
--sql�� = �� �񱳿�����
SELECT *
FROM users
WHERE userid = 'brown';






