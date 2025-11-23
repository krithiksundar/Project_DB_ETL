SET FEEDBACK OFF
SET HEADING ON
SET PAGESIZE 50000
SET LINESIZE 500
SET TERMOUT OFF
SET VERIFY OFF
SET UNDERLINE OFF
SET COLSEP ','

SPOOL ts_usage.csv

-- Query with column aliases for CSV header
SELECT
        df.tablespace_name AS TABLESPACE_NAME,
        ROUND((df.total_mb - NVL(fs.free_mb, 0)), 2) AS USED_MB,
        ROUND(NVL(fs.free_mb, 0), 2) AS FREE_MB,
        ROUND(df.total_mb, 2) AS TOTAL_MB
FROM
        ( SELECT tablespace_name, SUM(bytes)/1024/1024 AS total_mb
          FROM dba_data_files
          GROUP BY tablespace_name
        ) df
LEFT JOIN
        ( SELECT tablespace_name, SUM(bytes)/1024/1024 AS free_mb
          FROM dba_free_space
          GROUP BY tablespace_name
        ) fs
ON df.tablespace_name = fs.tablespace_name
ORDER BY df.tablespace_name;

SPOOL OFF
/