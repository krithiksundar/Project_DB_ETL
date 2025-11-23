SET HEADING ON
SET FEEDBACK OFF
SET PAGESIZE 50000
SET LINESIZE 300
SET TERMOUT OFF
SET COLSEP ','
SPOOL ts_usage.csv

SELECT
    df.tablespace_name,
    ROUND((df.total_mb - NVL(fs.free_mb, 0)), 2) AS used_mb,
    ROUND(NVL(fs.free_mb, 0), 2) AS free_mb,
    ROUND(df.total_mb, 2) AS total_mb
FROM
    (
        SELECT
            tablespace_name,
            SUM(bytes)/1024/1024 AS total_mb
        FROM dba_data_files
        GROUP BY tablespace_name
    ) df
LEFT JOIN
    (
        SELECT
            tablespace_name,
            SUM(bytes)/1024/1024 AS free_mb
        FROM dba_free_space
        GROUP BY tablespace_name
    ) fs
ON df.tablespace_name = fs.tablespace_name
ORDER BY df.tablespace_name;

SPOOL OFF;
