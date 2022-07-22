
select
    day as date, account,
    SUM(COALESCE(credit,0) - COALESCE(debit,0)) as balance
from {{ ref('ledger_daily_amount_by_reason') }}
where account = 'Stride Activity'
group by date, account

