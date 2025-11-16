
{% test tbl_records_not_empty_check(model) %}
{{ config(severity = 'warn') }}

with a as (

select  count(*) as cnt
from {{ model }} 
)
,b as (
select cast(cnt as string) as cnt from a
)
select cnt from b where cnt='0'

{% endtest %}
