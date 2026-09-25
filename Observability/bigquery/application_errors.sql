-- Replace PROJECT with the Google Cloud project ID. Cloud Logging's BigQuery
-- sink creates one table per log stream, so this wildcard covers application
-- log tables written into the observability dataset.
SELECT
	TIMESTAMP_TRUNC(timestamp, HOUR) AS hour,
	COUNT(*) AS error_count
FROM `PROJECT.gke_observability.cloudaudit_googleapis_com_*`
WHERE severity IN ("ERROR", "CRITICAL", "ALERT", "EMERGENCY")
	AND timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
GROUP BY hour
ORDER BY hour;