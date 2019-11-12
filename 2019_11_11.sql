
--SMITH, WARD가 속하는 부서의 직원들 조회

SELECT *
FROM emp
WHERE deptno in (10, 20);

SELECT *
FROM emp
WHERE deptno = 10
  AND deptno = 20;
  
SELECT *
FROM emp
WHERE deptno in (SELECT deptno FROM emp WHERE ename IN(:name1, :name2));
   
   
-- ==========================================================================
  
  
-- ANY : set중에 만족하는 게 하나라도 있으면 참 (크기비교)
-- SMITH, WARD 두 사람의 급여보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM emp
WHERE sal < any(SELECT sal -- 800, 1250
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
-- SMITH, WARD 보다 급여가 높은 직원 조회
-- SMITH보다도 급여가 높고 WARD보다도 급여가 높은 사람(AND)
SELECT *
FROM emp;
WHERE sal > ALL(SELECT sal -- 800, 1250
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));               


-- ==========================================================================

-- NOT IN

--관리자의 직원정보
-- 1. 관리자인 사람만 조회
--  . mgr 컬럼에 값이 나오는 직원
SELECT DISTINCT mgr
FROM emp;

-- 어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN(7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                FROM emp);
-- 관리자 역할을 하지 않는 평사원 정보 조회
-- 단 NOT IN 연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
-- NULL처리 함수나 WHERE절(IS NOT NULL)을 통해 NULL값을 처리한 후 사용
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp
                    WHERE mgr IS NOT NULL);

SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);


-- ==========================================================================
  
  
-- pair wise (조건을 동시에 만족)

-- 사번 7499, 7782인 직원의 관리자, 부서번호 조회
-- 직원중에 관리자와 부서번호가 (7698,30) 이거나 (7839,10)인 사람
-- mgr, deptno 컬럼을 [동시]에 만족시키는 직원 정보 조회
SELECT mgr, deptno
FROM emp
WHERE (mgr, deptno) IN ( SELECT mgr, deptno
                         FROM emp
                         WHERE empno IN(7499, 7782));

SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
             FROM emp
             WHERE empno IN(7499, 7782))
  AND deptno IN(SELECT deptno
                FROM emp
                WHERE empno IN(7499, 7782));


-- ==========================================================================


-- SCALAR SUBQUERY: SELECT 절에 등장하는 서브 쿼리(단, 값이 하나의 행, 하나의 컬럼)
-- 직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;
-- 이렇게 쿼리를 작성하면 15번 실행됨...


-- 서브쿼리 [실습 4] ==========================================================
-- 데이터 생성

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT (SELECT deptno
                             FROM dept   
                             WHERE deptno = emp.deptno) deptno 
                     FROM emp);
                     
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);


-- 서브쿼리 [실습 5] ==========================================================
SELECT *
FROM cycle;  -- cid pid day cnt
SELECT *
FROM product;  -- pid pnm
SELECT *
FROM customer;  -- cid cnm


SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);


-- 서브쿼리 [실습 6] ==========================================================
SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid
              FROM cycle
              WHERE cid = 2);


-- 서브쿼리 [실습 7] ==========================================================
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM cycle JOIN product ON(cycle.pid = product.pid)
           JOIN customer ON(cycle.cid = customer.cid)
WHERE cycle.cid = 1
  AND cycle.pid IN (SELECT pid
                    FROM cycle
                    WHERE cid = 2);

-- ==========================================================================

-- EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
-- 만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에, 성능면에서 유리

-- MGR가 존재하는 직원 조회

SELECT *
FROM emp mainQ
WHERE NOT EXISTS (SELECT '.'
                  FROM emp subQ
                  WHERE subQ.empno = mainQ.mgr);
              
SELECT *
FROM emp mainQ
WHERE EXISTS (SELECT '.'
              FROM emp subQ
              WHERE subQ.empno = mainQ.mgr);
                  
                  
-- 서브쿼리 [실습 8] ==========================================================
SELECT *
FROM emp
WHERE mgr IS NOT NULL;


-- 부서에 소속된 직원이 있는 부서 정보 조회 (exists)
SELECT *
FROM dept
WHERE EXISTS (SELECT '.'
              FROM emp
              WHERE emp.deptno = dept.deptno);
              
--IN
SELECT *
FROM dept
WHERE deptno in (SELECT deptno
                 FROM emp);


-- 서브쿼리 [실습 9] //과제// ==================================================

SELECT *
FROM product
WHERE NOT EXISTS (SELECT '.'
                  FROM cycle
                  WHERE cycle.pid = product.pid
                  AND cid = 1);


-- ==========================================================================


-- 집합연산
-- UNION: 합집합. 중복을 제거
--        DBMS에서는 중복을 제거하기위해 데이터를 정렬(대량의 데이터에 대해 정렬시 부하)
-- UNION ALL: UNION과 같은 개념. 중복을 제거하지 않고, 위 아래 집합을 결합만 한다. => 중복가능
--            위 아래 집합에 중복되는 데이터가 없다는 것을 확신하면 UNION 연산자보다 성능면에서 유리


-- 사번이 7566 또는 7698인 사원(사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
-- 사번이 7369, 7499인 사번 조회 ( 사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;


-- UNION ALL(중복 허용, 위 아래 집합을 합치기만 한다.)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
-- 사번이 7369, 7499인 사번 조회 ( 사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;

-- ==========================================================================

-- INTERSECT(교집합: 위 아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

INTERSECT

-- 사번이 7369, 7499인 사번 조회 ( 사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);

-- ==========================================================================

-- MINUS(차집합: 위 집합에서 아래 집합을 제거)
-- 순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

MINUS

-- 사번이 7369, 7499인 사번 조회 ( 사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);

-- ==========================================================================


SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369);


-- ==========================================================================


























