USE rainfall_analysis;

SELECT COUNT(*) AS Total_Records
FROM district_rainfall_normal;

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT `STATE/UT`) AS Total_States_UTs,
    ROUND(AVG(ANNUAL), 2) AS Average_Rainfall,
    MIN(ANNUAL) AS Minimum_Rainfall,
    MAX(ANNUAL) AS Maximum_Rainfall
FROM district_rainfall_normal;

-- =====================================================
-- QUESTION 1. TOP 10 WETTEST DISTRICTS
-- =====================================================

SELECT
    `STATE/UT`,
    DISTRICT,
    ANNUAL
FROM district_rainfall_normal
ORDER BY ANNUAL DESC
LIMIT 10;

-- =====================================================
-- QUESTION 2. TOP 10 DRIEST DISTRICTS
-- =====================================================

SELECT
    `STATE/UT`,
    DISTRICT,
    ANNUAL
FROM district_rainfall_normal
ORDER BY ANNUAL ASC
LIMIT 10;

-- =====================================================
-- QUESTION 3. STATE/UT-WISE AVERAGE RAINFALL
-- =====================================================

SELECT
    `STATE/UT`,
    ROUND(AVG(ANNUAL), 2) AS Average_Rainfall
FROM district_rainfall_normal
GROUP BY `STATE/UT`
ORDER BY Average_Rainfall DESC;

-- =====================================================
-- QUESTION 4. STATE/UT-WISE AVERAGE MONSOON RAINFALL
-- =====================================================

SELECT
    `STATE/UT`,
    ROUND(AVG(JJAS), 2) AS Average_Monsoon_Rainfall
FROM district_rainfall_normal
GROUP BY `STATE/UT`
ORDER BY Average_Monsoon_Rainfall DESC
LIMIT 10;

-- =====================================================
-- QUESTION 5. AVERAGE MONTHLY RAINFALL
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
FROM district_rainfall_normal;

-- QUESTION 6. AVERAGE SEASONAL RAINFALL

SELECT
    ROUND(AVG(`JAN+FEB`), 2) AS Winter,
    ROUND(AVG(MAM), 2) AS Pre_Monsoon,
    ROUND(AVG(JJAS), 2) AS Monsoon,
    ROUND(AVG(OND), 2) AS Post_Monsoon
FROM district_rainfall_normal;

-- QUESTION 7. MONSOON CONTRIBUTION BY STATE/UT

SELECT
    `STATE/UT`,
    ROUND(AVG(JJAS) / AVG(ANNUAL) * 100, 2) AS Monsoon_Contribution_Percentage
FROM district_rainfall_normal
GROUP BY `STATE/UT`
ORDER BY Monsoon_Contribution_Percentage DESC
LIMIT 10;

-- QUESTION 8. TOP 10 DISTRICTS BY MONSOON CONTRIBUTION

SELECT
    `STATE/UT`,
    DISTRICT,
    ROUND((JJAS / ANNUAL) * 100, 2) AS Monsoon_Contribution
FROM district_rainfall_normal
WHERE ANNUAL > 0
ORDER BY Monsoon_Contribution DESC
LIMIT 10;


