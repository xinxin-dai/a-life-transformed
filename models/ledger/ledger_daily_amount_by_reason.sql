/*
    Aggregate ledger transactions by date and reason,
   

*/

 SELECT
    date(date) as day,
    reason,
    account,
    SUM(credit) as credit,
    SUM(debit) as debit
FROM {{ ref('ledger') }}
GROUP BY day, reason, account
ORDER BY day, reason, account
