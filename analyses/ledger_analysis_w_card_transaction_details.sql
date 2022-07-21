WITH ledger_entries AS (
    SELECT
        JOURNAL_ID AS id,
        account,
        reason
    FROM {{ ref('ledger') }}
)

SELECT
    l.id,
    l.reason,
    ct.EVENTFUNCTION,
    ct.EVENTSTATEREASON,
    ct.EVENTTYPE
FROM {{ ref('card_transactions') }} ct
RIGHT JOIN ledger_entries l ON ct.id = l.id
