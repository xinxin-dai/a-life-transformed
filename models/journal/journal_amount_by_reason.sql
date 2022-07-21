/*
    Aggregate journal transactions by reason, and separate out debit and credit.
*/

SELECT
    reason,
    SUM(IFF(amount < 0, ABS(amount), 0)) as debit,
    SUM(IFF(amount >= 0, ABS(amount), 0)) as credit
FROM {{ ref('journal') }}
GROUP BY reason
