-- h_2 정보시스템부 하위의 조직 계층구조 조회 (dept0_02)

SELECT LEVEL lv, deptcd,
       LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


-- 상향식 계층 쿼리
-- 특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아님!)
-- 디자인팀을 시작으로 상위 부서를 조회
-- 디자인팀 dept0_00_0
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

-- ========================================================================================
-- 계층 쿼리 [실습 4] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT *
FROM h_sum;

SELECT LPAD(' ', (level-1)*3) || s_id AS s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;


-- ========================================================================================
-- 계층 쿼리 [실습 5] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT LPAD(' ', (level-1)*4  , ' ') || org_cd AS org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;



-- prunung branch (가지치기)
-- 계층쿼리에서 [WHERE]절은 START WITH, CONNECT BY절이 전부 적용된 이후에 실행된다.

--dept_h 테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, LPAD(' ', (level-1)*4, ' ') || deptnm AS deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--계층쿼리가 완성된 이후 WHERE절이 적용된다.
SELECT deptcd, LPAD(' ', (level-1)*4, ' ') || deptnm AS deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT deptcd, LPAD(' ', (level-1)*4, ' ') || deptnm AS deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
             AND deptnm != '정보기획부';


-- ========================================================================================
-- CONNECT_BY_ROOT(col): col의 최상위 노드 컬럼 값
-- SYS_CONNECT_BY_PATH(col, '구분자'): 컬럼의 계층구조 순서를 구분자로 이은 경로
--      . LTRIM을 이용해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적(구분자가 왼쪽에 찍힘!)
-- CONNECT_BY_ISLEAF: (해당 row가 leaf node인지 판별( O -> 1, X -> 0)

SELECT LPAD(' ', (level-1)*4  , ' ') || org_cd AS org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'),'-') path_org_cd,
       CONNECT_BY_ISLEAF is_leaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- ========================================================================================
-- 계층 쿼리 [실습 6] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--[서브쿼리: in사용]
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test
START WITH seq IN (SELECT seq
                   FROM board_test
                   WHERE parent_seq IS NULL)
CONNECT BY PRIOR seq = parent_seq;

--[서브쿼리: exists 사용]
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title
FROM board_test a
START WITH EXISTS (SELECT 'x'
                   FROM board_test b
                   WHERE parent_seq IS NULL
                     AND a.seq = b.seq)
CONNECT BY PRIOR seq = parent_seq;


-- ========================================================================================
-- 계층 쿼리 [실습 7, 8] /////////////////////////////////////////////////////////////////////
-- ========================================================================================
SELECT seq, LPAD(' ', (level-1)*4, ' ') || title AS title, level lv
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq
    ORDER siblings BY seq desc;


-- ========================================================================================
-- 계층 쿼리 [실습 9] ///////////////////////////////////////////////////////////////////////
-- ========================================================================================

SELECT *
FROM
(SELECT rownum rn, seq, LPAD(' ', (level-1)*4, ' ') || title AS title
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq
    ORDER siblings BY seq desc)
ORDER BY rn, seq;   --rn에 동일한 값이 없어서 seq가 안 먹힘



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
-- 글 그룹번호 컬럼 추가
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







