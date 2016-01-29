-- For a day

SELECT repo.id, repo.name, COUNT(1) AS cnt
FROM [githubarchive:day.yesterday]
WHERE type IN ('WatchEvent', 'ForkEvent') AND cnt > 10
GROUP BY repo.id, repo.name
ORDER BY cnt DESC


-- For a week

SELECT repo.id, repo.name, COUNT(1) AS cnt
FROM
TABLE_DATE_RANGE_STRICT(
    githubarchive:day.events_,
    DATE_ADD(CURRENT_TIMESTAMP(), -7, 'DAY'),
    DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY')
)
WHERE type = 'WatchEvent'
GROUP BY repo.id, repo.name
ORDER BY cnt DESC
LIMIT 50


-- For a month

SELECT repo.id, repo.name, COUNT(1) AS cnt
FROM
TABLE_DATE_RANGE_STRICT(
    githubarchive:day.events_,
    DATE_ADD(CURRENT_TIMESTAMP(), -31, 'DAY'), -- could also be 28 days for easier math
    DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY')
)
WHERE type = 'WatchEvent'
GROUP BY repo.id, repo.name
ORDER BY cnt DESC
LIMIT 50