{% snapshot ledger_monthly_snapshot %}

{{
    config(
		unique_key='unique_key',
      	strategy='check',
      	check_cols=['net_amount'],
    )
}}

WITH grouped AS (
	select
		year(date) as year
		, month(date) as month
		, reason
		, sum(case when debit is not null then -debit else credit end) as net_amount
		, count(*) as transaction_count
	from {{ ref('ledger') }} l
	where account = 'Stride Activity'
	and SUBSTR(date, 0, 7) = '{{ var("snapshot_year_month") }}'
	group by 1, 2, 3
	order by 1, 2, 3
)

select
	year
	, month
	, reason
	, (year || '_' || month || '_' || reason) as unique_key
	, net_amount
	, transaction_count
from grouped

{% endsnapshot %}
