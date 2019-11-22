-- h_2 �����ý��ۺ� ������ ���� �������� ��ȸ (dept0_02)

SELECT LEVEL lv, deptcd,
       LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


-- ����� ���� ����
-- Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴ�!)
-- ���������� �������� ���� �μ��� ��ȸ
-- �������� dept0_00_0
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

-- ========================================================================================
-- ���� ���� [�ǽ� 4] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT *
FROM h_sum;

SELECT LPAD(' ', (level-1)*3) || s_id AS s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;


-- ========================================================================================
-- ���� ���� [�ǽ� 5] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT LPAD(' ', (level-1)*4  , ' ') || org_cd AS org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;



-- prunung branch (����ġ��)
-- ������������ [WHERE]���� START WITH, CONNECT BY���� ���� ����� ���Ŀ� ����ȴ�.

--dept_h ���̺��� �ֻ��� ������ ��������� ��ȸ
SELECT deptcd, LPAD(' ', (level-1)*4, ' ') || deptnm AS deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--���������� �ϼ��� ���� WHERE���� ����ȴ�.
SELECT deptcd, LPAD(' ', (level-1)*4, ' ') || deptnm AS deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT deptcd, LPAD(' ', (level-1)*4, ' ') || deptnm AS deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
             AND deptnm != '������ȹ��';


-- ========================================================================================
-- CONNECT_BY_ROOT(col): col�� �ֻ��� ��� �÷� ��
-- SYS_CONNECT_BY_PATH(col, '������'): �÷��� �������� ������ �����ڷ� ���� ���
--      . LTRIM�� �̿��� �ֻ��� ��� ������ �����ڸ� �����ִ� ���°� �Ϲ���(�����ڰ� ���ʿ� ����!)
-- CONNECT_BY_ISLEAF: (�ش� row�� leaf node���� �Ǻ�( O -> 1, X -> 0)

SELECT LPAD(' ', (level-1)*4  , ' ') || org_cd AS org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'),'-') path_org_cd,
       CONNECT_BY_ISLEAF is_leaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- ========================================================================================
-- ���� ���� [�ǽ� 6] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--[��������: in���]
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test
START WITH seq IN (SELECT seq
                   FROM board_test
                   WHERE parent_seq IS NULL)
CONNECT BY PRIOR seq = parent_seq;

--[��������: exists ���]
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test a
START WITH EXISTS (SELECT 'x'
                   FROM board_test b
                   WHERE parent_seq IS NULL
                     AND a.seq = b.seq)
CONNECT BY PRIOR seq = parent_seq;


-- ========================================================================================
-- ���� ���� [�ǽ� 7, 8] /////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title, level lv
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq
    ORDER siblings BY seq desc;


-- ========================================================================================
-- ���� ���� [�ǽ� 9] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================

SELECT *
FROM
(SELECT rownum rn, seq, LPAD(' ', (level-1)*4, ' ') || title AS title
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq
    ORDER siblings BY seq desc)
ORDER BY rn, seq;   --rn�� ������ ���� ��� seq�� �� ����



SELECT*
FROM
(SELECT level lv, seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY lv desc, seq)
ORDER BY lv, seq;



SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title,
    DECODE(level, 1, seq, 0) temp1, DECODE(level, 1, 0, seq) temp2

FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY DECODE(level, 1, seq, 0);

-- ========================================================================================


SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title, level lv,
       CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1,
       CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END o2
       
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END desc,
               CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END;


-- ========================================================================================

SELECT *
FROM 
    (SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title,
            CONNECT_BY_ROOT(seq) r_seq
            FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq) a
ORDER BY r_seq DESC, seq;

-- ========================================================================================

SELECT *
FROm board_test;
-- �� �׷��ȣ �÷� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;


-- ========================================================================================
-- ////////////////////////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT a.ename, a.sal, b.sal
FROM
    (SELECT ename, sal, rownum rn
    FROM (SELECT *  FROM emp ORDER BY sal desc)) a, 
    (SELECT ename, sal, (rownum-1) rnM
    FROM (SELECT *  FROM emp ORDER BY sal desc)) b
WHERE a.rn = b.rnM(+);

SELECT a.ename, a.sal, b.sal
FROM
    (SELECT ename, sal, rownum rn FROM (SELECT *  FROM emp ORDER BY sal desc)) a
    LEFT OUTER JOIN
    (SELECT ename, sal, (rownum-1) rnM FROM (SELECT *  FROM emp ORDER BY sal desc)) b
    ON(a.rn = b.rnM);







