-- CURSOR�� ��������� �������� �ʰ�, LOOP���� inline ���·� cursor ���

-- �͸���
set serveroutput on;
DECLARE 
    -- cursor ���� --> LOOP���� inline ����
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
    dbms_output.put_Line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

-- ==============================================================================

create or replace PROCEDURE avgdt2
IS 
    avgdateStart dt.dt%TYPE;
    avgdate NUMBER := 0;
    cnt NUMBER := 0;
BEGIN

    FOR i IN (SELECT dt FROM dt ORDER BY dt desc) LOOP

        IF cnt = 0 THEN avgdateStart := i.dt;
        ELSE avgdate := avgdateStart - i.dt;
        END IF;

        cnt := cnt +1;
    END LOOP;

    avgdate := avgdate / (cnt-1);
    dbms_output.put_Line('��� ��¥: ' || avgdate || '��');
END;
/


-- ==========================================================================================
-- //////////////////////////////////////////////////////////////////////////////////////////
-- ==========================================================================================


SELECT *
FROM daily;

SELECT *
FROM cycle;

-- ==========================================================================================

CREATE OR REPLACE PROCEDURE create_daily_sales(inputDate VARCHAR2)
IS
    CURSOR date_info IS
        SELECT TO_DATE(inputDate, 'YYYYMM') + (level-1) dt,
               TO_NUMBER(TO_CHAR(TO_DATE(inputDate, 'YYYYMM') + (level-1), 'D')) dayInfo
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(inputDate, 'YYYYMM')),'DD');
    
    CURSOR cycle_info IS
        SELECT cid, pid, day, cnt
        FROM cycle;
BEGIN

    --�����Ϸ��� �ϴ� ����� ���������͸� �����Ѵ�.
    
    DELETE daily
    WHERE dt LIKE inputDate || '%';
    
     FOR i IN date_info LOOP

        FOR j IN cycle_info LOOP
           IF i.dayInfo = j.day THEN 
                INSERT INTO daily VALUES (j.cid, j.pid, TO_CHAR(i.dt, 'YYYYMMDD'), j.cnt);
           END IF;
        END LOOP;
        
    END LOOP;
    COMMIT;
END;
/



EXEC create_daily_sales('201912');

SELECT *
FROM daily;

DELETE daily
WHERE cnt > 0;

DESC cycle;


INSERT INTO daily 
SELECT CYCLE.CID, CYCLE.PID, CAL.DT, CYCLE.CNT
FROM
    cycle,
    (SELECT TO_DATE(:inputDate, 'YYYYMM') + (level-1) dt,
           TO_NUMBER(TO_CHAR(TO_DATE(:inputDate, 'YYYYMM') + (level-1), 'D')) dayInfo
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:inputDate, 'YYYYMM')),'DD')) cal
WHERE cal.dayInfo = cycle.day;








