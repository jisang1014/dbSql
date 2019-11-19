SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE owner = 'DOREMI';


SELECT *
FROM doremi.V_EMP_DEPT;

-- doremi �������� ��ȸ������ ���� V_EMP_DEPT view�� hr�������� ��ȸ�ϱ����ؼ��� ������.view�̸� �������� ����� �ؾ��Ѵ�.
-- �Ź� �������� ����ϱ� �������Ƿ� �ó���� ���ؼ� �ٸ� ��Ī�� ����

CREATE SYNONYM V_EMP_DEPT FOR doremi.V_EMP_DEPT;

--doremi.V_EMP_DEPT ==> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- ============================================================================================
DROP SYNONYM V_EMP_DEPT;

-- hr���� ��й�ȣ: java
-- hr ���� ��й�ȣ ���� hr

ALTER USER hr IDENTIFIED BY java;
-- ALTER USER doremi IDENTIFIED BY doremi; >> ���� ������ �ƴ϶� ������ ����.


--============================================================================================

-- dictionary
-- ���ξ� : USER - ����� ���� ��ü
--         All - ����ڰ� ��밡���� ��ü
--         DBA - ������ ������ ��ü ��ü (�Ϲ� ����ڴ� ��� �Ұ�)
--         V$ - �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)


SELECT * 
FROM USER_TABLES;

SELECT * 
FROM ALL_TABLES;

SELECT * 
FROM DBA_TABLES
WHERE owner IN ('DOREMI', 'HR');


-- ===================================================================
-- ����Ŭ���� ������ SQL�̶�?
-- ���ڰ� �ϳ��� Ʋ���� �ȵȴ�.
-- ���� sql���� ���� ����� ������ ���� DBMS������ ���� �ٸ� SQL�� �νŵȴ�.
SELECT /*+ bind_test*/ * FROM emp;
Select /*+ bind_test*/ * FROM emp;
select /*+ bind_test*/ *   FROM emp;

select /*+ bind_test*/ * FROM emp WHERE empno = 9367;
select /*+ bind_test*/ * FROM emp WHERE empno = 7499;
select /*+ bind_test*/ * FROM emp WHERE empno = 7521;

select /*+ bind_test*/ * FROM emp WHERE empno = :empno;
--���ε� ����: ���ʿ��� �޸𸮸� �������� �ʱ� ���� ���


SELECT *
FROM v$SQL;








