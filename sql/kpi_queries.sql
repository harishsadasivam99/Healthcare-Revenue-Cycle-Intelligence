-- Healthcare Revenue Cycle Intelligence Platform
-- KPI Queries

-- 1. Current Open Encounters
SELECT
    COUNT(DISTINCT encounter_id) AS current_open_encounters
FROM encounters
WHERE encounter_status = 'Open';

-- 2. Total Revenue / Collections At Risk
SELECT
    ROUND(SUM(estimated_collection_at_risk), 2) AS total_collection_at_risk
FROM vw_revenue_at_risk;

-- 3. Total wRVUs At Risk
SELECT
    ROUND(SUM(estimated_wrvu_at_risk), 2) AS total_wrvu_at_risk
FROM vw_revenue_at_risk;

-- 4. Average Charge Lag
SELECT
    ROUND(AVG(charge_lag_days), 2) AS average_charge_lag_days
FROM vw_charge_lag
WHERE charge_lag_days IS NOT NULL;

-- 5. Encounter Aging Distribution
SELECT
    aging_bucket,
    COUNT(DISTINCT encounter_id) AS encounter_count
FROM vw_encounter_aging
WHERE encounter_status = 'Open'
GROUP BY aging_bucket
ORDER BY encounter_count DESC;

-- 6. Open Encounters by Division
SELECT
    division_name,
    COUNT(DISTINCT encounter_id) AS open_encounters
FROM vw_encounter_aging
WHERE encounter_status = 'Open'
GROUP BY division_name
ORDER BY open_encounters DESC;

-- 7. Revenue At Risk by Division
SELECT
    division_name,
    ROUND(SUM(estimated_collection_at_risk), 2) AS collection_at_risk,
    ROUND(SUM(estimated_wrvu_at_risk), 2) AS wrvu_at_risk
FROM vw_revenue_at_risk
GROUP BY division_name
ORDER BY collection_at_risk DESC;

-- 8. Top 10 Providers by Open Encounters
SELECT
    provider_name,
    division_name,
    open_encounters,
    documentation_issues,
    documentation_issue_rate_percent
FROM vw_provider_performance
ORDER BY open_encounters DESC
LIMIT 10;

-- 9. Provider Resolution Rate
SELECT
    provider_name,
    division_name,
    total_encounters,
    resolved_encounters,
    resolution_rate_percent
FROM vw_provider_performance
ORDER BY resolution_rate_percent DESC;

-- 10. Documentation Issue Breakdown
SELECT
    issue_type,
    COUNT(*) AS issue_count
FROM documentation_issues
GROUP BY issue_type
ORDER BY issue_count DESC;

-- 11. Workflow Status Distribution
SELECT
    workflow_status,
    COUNT(*) AS status_count
FROM workflow_status
GROUP BY workflow_status
ORDER BY status_count DESC;

-- 12. Denied Charges
SELECT
    COUNT(*) AS denied_charge_count,
    ROUND(SUM(charge_amount), 2) AS denied_charge_amount
FROM charges
WHERE charge_status = 'Denied';

-- 13. Pending Charges
SELECT
    COUNT(*) AS pending_charge_count,
    ROUND(SUM(charge_amount), 2) AS pending_charge_amount
FROM charges
WHERE charge_status = 'Pending';

-- 14. Division Performance Summary
SELECT
    division_name,
    total_encounters,
    open_encounters,
    resolved_encounters,
    documentation_issues,
    ROUND(total_collection_at_risk, 2) AS total_collection_at_risk,
    ROUND(total_wrvu_at_risk, 2) AS total_wrvu_at_risk,
    avg_charge_lag_days
FROM vw_division_performance
ORDER BY total_collection_at_risk DESC;

-- 15. High-Risk and Critical Open Encounters
SELECT
    aging_bucket,
    COUNT(*) AS encounter_count
FROM vw_encounter_aging
WHERE encounter_status = 'Open'
  AND aging_bucket IN ('High Risk', 'Critical Risk')
GROUP BY aging_bucket
ORDER BY encounter_count DESC;