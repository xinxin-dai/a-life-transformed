select
	year(date) as year
	, month(date) as month
	, reason
	, sum(case when debit is not null then -debit else credit end) as net_amount
	, count(*) as transaction_count
from {{ ref('ledger') }} l
where account = 'Stride Activity'
group by 1, 2, 3
order by 1, 2, 3