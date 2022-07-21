/*
 * The debit and credit of all accounts of a given day should reach zero
 */

With aggr AS (
    SELECT
        day as date,
        SUM(
            COALESCE(credit, 0) - COALESCE(debit, 0)
        ) as amount
    FROM {{ ref('ledger_daily_amount_by_reason') }}
    GROUP BY date
)

SELECT date FROM aggr
WHERE amount != 0