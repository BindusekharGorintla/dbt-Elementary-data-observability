

{% test column_values_to_not_be_in_set(model,column_name,input_value) %}

with a as (

select *
from {{ model }} 
where {{ column_name }}='{{ input_value }}'
)
,b as (
select cast(count(*) as string) as cnt from a
)
select cnt from b where cnt<>'0'

{% endtest %}
