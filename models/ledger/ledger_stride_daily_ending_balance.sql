
{{
    config(
        materialized='incremental',
        unique_key=['date', 'account']
    )
}}

WITH prev AS (
    SELECT
        account,
        balance
    FROM {{ this }}
    WHERE account = 'Stride Activity'
    AND date = DATEADD(day, -1, DATE('{{ var("snapshot_date") }}'))
),
curr AS (
    select
        account,
        SUM(COALESCE(credit,0) - COALESCE(debit,0)) as amount
    from {{ ref('ledger_daily_amount_by_reason') }}
    where account = 'Stride Activity'
    and day = DATE('{{ var("snapshot_date") }}')
    group by account
)

SELECT
    DATE('{{ var("snapshot_date") }}') AS date,
    COALESCE(p.account, c.account) AS account,
    (COALESCE(p.balance, 0) + COALESCE(c.amount, 0)) AS balance
FROM prev p
FULL OUTER JOIN curr c ON p.account = c.account