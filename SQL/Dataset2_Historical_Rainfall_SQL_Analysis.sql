USE rainfall_analysis;

-- =====================================================
-- Q1. HISTORICAL RAINFALL DATASET OVERVIEW
-- =====================================================
SELECT
    COUNT(*) AS Total_Records,
    MIN(`YEAR`) AS First_Year,
    MAX(`YEAR`) AS Last_Year,
    ROUND(AVG(ANNUAL), 2) AS Average_Rainfall
FROM india_historical_rainfall;

-- =====================================================
-- Q2. TOP 10 WETTEST YEARS
-- =====================================================
SELECT `YEAR`, ANNUAL
FROM india_historical_rainfall
ORDER BY ANNUAL DESC
LIMIT 10;

-- =====================================================
-- Q3. TOP 10 DRIEST YEARS
-- =====================================================
SELECT `YEAR`, ANNUAL
FROM india_historical_rainfall
ORDER BY ANNUAL ASC
LIMIT 10;

-- =====================================================
-- Q4. AVERAGE SEASONAL RAINFALL
-- =====================================================
SELECT
    ROUND(AVG(`Jan-Feb`), 2) AS Winter,
    ROUND(AVG(`Mar-May`), 2) AS Pre_Monsoon,
    ROUND(AVG(`Jun-Sep`), 2) AS Monsoon,
    ROUND(AVG(`Oct-Dec`), 2) AS Post_Monsoon
FROM india_historical_rainfall;

-- =====================================================
-- Q5. AVERAGE MONTHLY RAINFALL
-- =====================================================
SELECT
    ROUND(AVG(JAN), 2) AS January,
    ROUND(AVG(FEB), 2) AS February,
    ROUND(AVG(MAR), 2) AS March,
    ROUND(AVG(APR), 2) AS April,
    ROUND(AVG(MAY), 2) AS May,
    ROUND(AVG(JUN), 2) AS June,
    ROUND(AVG(JUL), 2) AS July,
    ROUND(AVG(AUG), 2) AS August,
    ROUND(AVG(SEP), 2) AS September,
    ROUND(AVG(OCT), 2) AS October,
    ROUND(AVG(NOV), 2) AS November,
    ROUND(AVG(`DEC`), 2) AS December
FROM india_historical_rainfall;

-- =====================================================
-- Q6. YEARS ABOVE AND BELOW AVERAGE RAINFALL
-- =====================================================
SELECT
    COUNT(*) AS Total_Years,
    SUM(CASE WHEN ANNUAL > avg_data.avg_rainfall THEN 1 ELSE 0 END) AS Above_Average_Years,
    SUM(CASE WHEN ANNUAL < avg_data.avg_rainfall THEN 1 ELSE 0 END) AS Below_Average_Years
FROM india_historical_rainfall
CROSS JOIN (
    SELECT AVG(ANNUAL) AS avg_rainfall
    FROM india_historical_rainfall
) AS avg_data;

-- =====================================================
-- Q7. TOP 10 MONSOON RAINFALL YEARS
-- =====================================================

SELECT
    `YEAR`,
    `Jun-Sep` AS Monsoon_Rainfall
FROM india_historical_rainfall
ORDER BY `Jun-Sep` DESC
LIMIT 10;

-- =====================================================
-- Q8. HIGHEST MONSOON CONTRIBUTION YEARS
-- =====================================================

SELECT
    `YEAR`,
    ANNUAL,
    `Jun-Sep` AS Monsoon_Rainfall,
    ROUND((`Jun-Sep` / ANNUAL) * 100, 2) AS Monsoon_Contribution_Percentage
FROM india_historical_rainfall
WHERE ANNUAL > 0
ORDER BY Monsoon_Contribution_Percentage DESC
LIMIT 10;

-- =====================================================
-- Q9. SEASONAL RAINFALL VARIABILITY
-- =====================================================

SELECT
    ROUND(STDDEV_POP(`Jan-Feb`) / AVG(`Jan-Feb`) * 100, 2) AS Winter_CV,
    ROUND(STDDEV_POP(`Mar-May`) / AVG(`Mar-May`) * 100, 2) AS Pre_Monsoon_CV,
    ROUND(STDDEV_POP(`Jun-Sep`) / AVG(`Jun-Sep`) * 100, 2) AS Monsoon_CV,
    ROUND(STDDEV_POP(`Oct-Dec`) / AVG(`Oct-Dec`) * 100, 2) AS Post_Monsoon_CV
FROM india_historical_rainfall;

-- =====================================================
-- Q10. DECADE-WISE RAINFALL VARIABILITY
-- =====================================================

SELECT
    Decade,
    COUNT(*) AS Number_Of_Years,
    ROUND(STDDEV_POP(ANNUAL), 2) AS Rainfall_Std_Deviation
FROM (
    SELECT
        FLOOR((`YEAR` - 1) / 10) * 10 + 1 AS Decade,
        ANNUAL
    FROM india_historical_rainfall
) AS Yearly_Data
GROUP BY Decade
ORDER BY Decade;
