-- Q1; bulletpoint 1; Answer: 8

SELECT COUNT (DISTINCT utm_campaign)
FROM page_visits;

-- Q1; bulletpoint 2; Answer: 6

SELECT COUNT (DISTINCT utm_source)
FROM page_visits;

-- Q1; bulletpoint 3; Answer in ppt

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

-- Q2; Answer in ppt

SELECT DISTINCT page_name
FROM page_visits;

SELECT COUNT (DISTINCT page_name)
FROM page_visits;

-- Q3; First Touch Attribution Query

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
    ft_attr AS(
SELECT ft.user_id,
		ft.first_touch_at,
   	pv.utm_source,
    		pv.utm_campaign
	FROM first_touch AS ft
	JOIN page_visits AS pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
      )
 SELECT ft_attr.utm_source AS 'Source',
       ft_attr.utm_campaign AS 'Campaign',
       COUNT(*)
FROM ft_attr
GROUP BY ft_attr.utm_source, ft_attr.utm_campaign
ORDER BY COUNT(*) DESC;

-- Q4; Last Touch Attribution Query

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
    lt_attr AS(
SELECT lt.user_id,
		lt.last_touch_at,
   	pv.utm_source,
    		pv.utm_campaign
	FROM last_touch AS lt
	JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
      )
 SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*)
FROM lt_attr
GROUP BY lt_attr.utm_source, lt_attr.utm_campaign
ORDER BY COUNT(*) DESC;

-- Q5; Answer: 361

SELECT COUNT (DISTINCT user_id)
FROM page_visits
WHERE page_name LIKE '4 - purchase';

-- Q6; Answer in ppt (difference = WHERE clause)

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  WHERE page_name = '4 - purchase'
    GROUP BY user_id),
    lt_attr AS(
SELECT lt.user_id,
		lt.last_touch_at,
   	pv.utm_source,
    		pv.utm_campaign
	FROM last_touch AS lt
	JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
      )
 SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*)
FROM lt_attr
GROUP BY lt_attr.utm_source, lt_attr.utm_campaign
ORDER BY COUNT(*) DESC;
