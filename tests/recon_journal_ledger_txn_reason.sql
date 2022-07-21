With ledger AS (
    SELECT
        journal_id,
        reason,
        date
    FROM {{ ref('ledger') }}
)

SELECT
    j.id AS id,
    l.reason AS ledger_reason,
    j.reason AS journal_reason,
    j.date AS date
FROM {{ ref('journal') }} j
JOIN ledger l ON l.journal_id = j.id AND l.date = j.date
WHERE j.reason != l.reason