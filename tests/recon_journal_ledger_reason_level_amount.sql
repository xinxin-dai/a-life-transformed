With ledger AS (
    SELECT
        date,
        reason,
        SUM(debit) AS debit,
        SUM(credit) AS credit
    FROM {{ ref('ledger_amount_by_reason') }}
    GROUP BY date, reason
)

SELECT
    j.date,
    j.reason,
    (l.credit - l.debit) AS ledger_amount,
    j.amount AS journal_amount
FROM
{{ ref('journal_amount_by_reason') }} j
JOIN ledger l ON j.reason = l.reason AND j.date = l.date
WHERE ledger_amount != journal_amount