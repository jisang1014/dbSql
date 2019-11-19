SELECT *
FROM fastfood;

-- 버거킹 + 맥도날드 + KFC  / 롯데리아
-- 205개



SELECT*
FROM Jdbc_Board;


-- ==========================================================================================================================
-- ==========================================================================================================================

SELECT sido, sigungu FROM fastfood GROUP BY sido, sigungu;

SELECT a.sido,a.sigungu, bking, mc, kfc, lotte, NVL(TRUNC((bking+ mc+ kfc)/DECODE(lotte, 0, null, lotte),1), 0) resultsum
FROM
    (SELECT basic.sido, basic.sigungu, NVL(sum(bking), 0) bking
    FROM (SELECT sido, sigungu FROM fastfood GROUP BY sido, sigungu) basic
          LEFT OUTER JOIN (SELECT sido, sigungu, COUNT(*) bking  FROM fastfood WHERE GB = '버거킹' GROUP BY sido, sigungu) a
          ON (a.sigungu = basic.sigungu AND a.sido = basic.sido)
    GROUP BY basic.sido, basic.sigungu)a,

    (SELECT basic.sido, basic.sigungu, NVL(sum(mc), 0) mc
    FROM (SELECT sido, sigungu FROM fastfood GROUP BY sido, sigungu) basic
          LEFT OUTER JOIN (SELECT sido, sigungu, COUNT(*) mc  FROM fastfood WHERE GB = '맥도날드' GROUP BY sido, sigungu) a
          ON (a.sigungu = basic.sigungu AND a.sido = basic.sido)
    GROUP BY basic.sido, basic.sigungu)b,

   (SELECT basic.sido, basic.sigungu, NVL(sum(kfc), 0) kfc
    FROM (SELECT sido, sigungu FROM fastfood GROUP BY sido, sigungu) basic
          LEFT OUTER JOIN (SELECT sido, sigungu, COUNT(*) kfc  FROM fastfood WHERE GB = 'KFC' GROUP BY sido, sigungu) a
          ON (a.sigungu = basic.sigungu AND a.sido = basic.sido)
    GROUP BY basic.sido, basic.sigungu)c,

  (SELECT basic.sido, basic.sigungu, NVL(sum(lotte), 0) lotte
    FROM (SELECT sido, sigungu FROM fastfood GROUP BY sido, sigungu) basic
          LEFT OUTER JOIN (SELECT sido, sigungu, COUNT(*) lotte  FROM fastfood WHERE GB = '롯데리아' GROUP BY sido, sigungu) a
          ON (a.sigungu = basic.sigungu AND a.sido = basic.sido)
    GROUP BY basic.sido, basic.sigungu)d
WHERE a.sido = b.sido AND a.sigungu = b.sigungu
  AND b.sido = c.sido AND b.sigungu = c.sigungu
  AND c.sido = d.sido AND c.sigungu = d.sigungu
ORDER BY resultsum desc;

-- ==========================================================================================================================
-- ==========================================================================================================================

SELECT a.sido, a.sigungu, bking, mc, kfc, lotte, NVL(TRUNC((bking+mc+kfc)/lotte,1),0) result
FROM (SELECT sido, sigungu FROM fastfood) a,
     (SELECT sido, sigungu, COUNT(*) bking FROM fastfood  WHERE GB = '버거킹' GROUP BY sido, sigungu) b,
     (SELECT sido, sigungu, count(*) mc   FROM fastfood  WHERE GB = '맥도날드' GROUP BY sido, sigungu) c,
     (SELECT sido, sigungu, count(*) kfc FROM fastfood  WHERE GB = 'KFC'  GROUP BY sido, sigungu)d,
     (SELECT sido, sigungu, COUNT(*)lotte FROM fastfood WHERE GB = '롯데리아' GROUP BY sido, sigungu)e
WHERE a.sigungu = b.sigungu(+) AND a.sido = b.sido(+)
  AND a.sigungu = c.sigungu(+) AND a.sido = c.sido(+)
  AND a.sigungu = d.sigungu(+) AND a.sido = d.sido(+)
  AND a.sigungu = e.sigungu(+) AND a.sido = e.sido(+)
GROUP BY a.sido, a.sigungu, bking, mc, kfc, lotte, NVL(TRUNC((bking+mc+kfc)/lotte,1),0)
ORDER BY result desc;



SELECT burger.sido, burger.sigungu, burger.point, burger.b_id,
       b.salnum s_id, b.sido, b.sigungu, b.sal
FROM 
    (SELECT burger.*, rownum b_id 
     FROM
        (SELECT a.sido, a.sigungu, TRUNC(a.cnt/b.cnt, 2) point
         FROM 
            (SELECT sido, sigungu, count(*) cnt  FROM fastfood  WHERE gb IN ('버거킹', '맥도날드','KFC') GROUP BY sido, sigungu) a,
            (SELECT sido, sigungu, count(*) cnt  FROM fastfood  WHERE gb = '롯데리아'                   GROUP BY sido, sigungu) b
         WHERE a.sido = b.sido AND a.sigungu = b.sigungu
         GROUP BY a.sido, a.sigungu, TRUNC(a.cnt/b.cnt, 2)
         ORDER BY point desc) burger) burger,
        
        (SELECT rownum salnum, b.* FROM (SELECT id, sido, sigungu, sal FROM tax ORDER BY sal desc) b) b
WHERE burger.b_id = b.salnum   
ORDER BY s_id; 


--시도, 시군구, 버거지수, + 시도, 시군구, 연말정산 납입액

SELECT *
FROM tax;












