With ledger AS (
    SELECT
        day as date,
        reason,
        SUM(debit) AS debit,
        SUM(credit) AS credit
    FROM {{ ref('ledger_daily_amount_by_reason') }}
    GROUP BY date, reason
)

SELECT
    j.date,
    j.reason,
    (l.credit - l.debit) AS ledger_amount,
    (j.credit - j.debit) AS journal_amount
FROM
{{ ref('journal_amount_by_reason') }} j
JOIN ledger l ON j.reason = l.reason AND j.date = l.date
WHERE ledger_amount != journal_amount