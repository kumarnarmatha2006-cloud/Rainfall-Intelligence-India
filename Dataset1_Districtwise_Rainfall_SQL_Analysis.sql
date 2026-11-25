USE rainfall_analysis;

-- =================================================
-- Q1. Which month recorded the highest total rainfall?
-- =================================================

SELECT
    CASE `Month`
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
    END AS Month_Name,
    ROUND(SUM(Daily_Actual), 2) AS Total_Actual_Rainfall
FROM rainfall_data
GROUP BY `Month`
ORDER BY Total_Actual_Rainfall DESC;

-- =====================================================
-- Q2. Which 10 districts recorded the highest
--     total actual rainfall?
-- =====================================================

SELECT
    District,
    ROUND(SUM(Daily_Actual), 2) AS Total_Actual_Rainfall
FROM rainfall_data
GROUP BY District
ORDER BY Total_Actual_Rainfall DESC
LIMIT 10;

-- =====================================================
-- Q3. Which 10 districts recorded the lowest
--     total actual rainfall?
-- =====================================================

SELECT
    District,
    ROUND(SUM(Daily_Actual), 2) AS Total_Actual_Rainfall
FROM rainfall_data
GROUP BY District
ORDER BY Total_Actual_Rainfall ASC
LIMIT 10;

-- =====================================================
-- Q4. How does actual rainfall compare with
--     normal rainfall across different months?
-- =====================================================

SELECT
    CASE `Month`
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
    END AS Month_Name,

    ROUND(SUM(Daily_Actual), 2) AS Actual_Rainfall,

    ROUND(SUM(Daily_Normal), 2) AS Normal_Rainfall,

    ROUND(
        (SUM(Daily_Actual) - SUM(Daily_Normal))
        / NULLIF(SUM(Daily_Normal), 0) * 100,
        2
    ) AS Departure_Percentage

FROM rainfall_data
GROUP BY `Month`
ORDER BY `Month`;

-- =====================================================
-- Q5. Which 10 states recorded the highest
--     average daily rainfall?
-- =====================================================

SELECT
    State,
    ROUND(AVG(Daily_Actual), 2) AS Average_Daily_Rainfall
FROM rainfall_data
GROUP BY State
ORDER BY Average_Daily_Rainfall DESC
LIMIT 10;

-- =====================================================
-- Q6. Which districts recorded the highest
--     single-day rainfall?
-- =====================================================

SELECT
    State,
    District,
    `Date`,
    Daily_Actual AS Daily_Rainfall
FROM rainfall_data
ORDER BY Daily_Actual DESC
LIMIT 10;

-- =====================================================
-- Q7. Which 10 districts recorded the highest
--     number of zero-rainfall days?
-- =====================================================

SELECT
    State,
    District,
    COUNT(*) AS Observed_Days,
    SUM(CASE
        WHEN Daily_Actual = 0 THEN 1
        ELSE 0
    END) AS Dry_Days,
    ROUND(
        SUM(CASE
            WHEN Daily_Actual = 0 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Dry_Day_Percentage
FROM rainfall_data
GROUP BY State, District
ORDER BY Dry_Days DESC, Dry_Day_Percentage DESC
LIMIT 10;

-- =====================================================
-- Q8. Which districts have the fewest
--     rainfall observation days?
-- =====================================================

SELECT
    State,
    District,
    COUNT(DISTINCT Date) AS Observed_Days
FROM rainfall_data
GROUP BY State, District
ORDER BY Observed_Days ASC
LIMIT 10;

-- =====================================================
-- Q9. Which 10 districts experienced the highest
--     daily rainfall variability?
-- =====================================================

SELECT
    State,
    District,
    ROUND(STDDEV_SAMP(Daily_Actual), 2) AS Rainfall_Variability
FROM rainfall_data
GROUP BY State, District
ORDER BY Rainfall_Variability DESC
LIMIT 10;

-- =====================================================
-- Q10. Which 10 districts recorded the highest
--      rainfall deficit compared with normal rainfall?
-- =====================================================

SELECT
    State,
    District,
    COUNT(DISTINCT Date) AS Observed_Days,

    ROUND(SUM(Daily_Actual), 2) AS Actual_Rainfall,

    ROUND(SUM(Daily_Normal), 2) AS Normal_Rainfall,

    ROUND(
        SUM(Daily_Actual) - SUM(Daily_Normal), 2
    ) AS Rainfall_Departure,

    ROUND(
        (SUM(Daily_Actual) - SUM(Daily_Normal))
        / NULLIF(SUM(Daily_Normal), 0) * 100,
        2
    ) AS Departure_Percentage

FROM rainfall_data
GROUP BY State, District
HAVING COUNT(DISTINCT Date) = 65
ORDER BY Departure_Percentage ASC
LIMIT 10;

-- =====================================================
-- Q11. What is the distribution of daily rainfall
--      categories?
-- =====================================================

SELECT
    Daily_Category,
    COUNT(*) AS Total_Records,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM rainfall_data),
        2
    ) AS Percentage
FROM rainfall_data
GROUP BY Daily_Category
ORDER BY Total_Records DESC;

-- =====================================================
-- Q12. Which 10 districts recorded the highest average
--      rainfall on rainy days?
-- =====================================================

SELECT
    State,
    District,
    COUNT(CASE WHEN Daily_Actual > 0 THEN 1 END) AS Rainy_Days,
    ROUND(
        AVG(CASE
            WHEN Daily_Actual > 0 THEN Daily_Actual
        END), 2
    ) AS Average_Rainfall_On_Rainy_Days
FROM rainfall_data
GROUP BY State, District
HAVING COUNT(DISTINCT Date) = 65
   AND COUNT(CASE WHEN Daily_Actual > 0 THEN 1 END) > 0
ORDER BY Average_Rainfall_On_Rainy_Days DESC
LIMIT 10;

-- =====================================================
-- Q13. How many districts received rainfall on
--      each date?
-- =====================================================

SELECT
    `Date`,
    COUNT(*) AS Total_Districts_Reported,
    SUM(
        CASE
            WHEN Daily_Actual > 0 THEN 1
            ELSE 0
        END
    ) AS Districts_With_Rainfall,
    ROUND(
        SUM(CASE WHEN Daily_Actual > 0 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Rainfall_Affected_District_Percentage
FROM rainfall_data
GROUP BY `Date`
ORDER BY `Date`;

-- =====================================================
-- Q14. Which states recorded rainfall on the highest
--      proportion of district observation days?
-- =====================================================

SELECT
    State,
    COUNT(*) AS Total_Observations,

    COUNT(
        CASE
            WHEN Daily_Actual > 0 THEN 1
        END
    ) AS Rainfall_Observations,

    ROUND(
        COUNT(
            CASE
                WHEN Daily_Actual > 0 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Rainfall_Occurrence_Percentage

FROM rainfall_data
GROUP BY State
ORDER BY Rainfall_Occurrence_Percentage DESC;

-- =====================================================
-- Q15. Which 10 districts recorded the highest number
--      of high-rainfall days?
-- =====================================================

SELECT
    State,
    District,
    COUNT(*) AS High_Rainfall_Days,
    ROUND(MAX(Daily_Actual), 2) AS Maximum_Daily_Rainfall
FROM rainfall_data
WHERE Daily_Actual >= 64.5
GROUP BY State, District
ORDER BY High_Rainfall_Days DESC,
         Maximum_Daily_Rainfall DESC
LIMIT 10; 

