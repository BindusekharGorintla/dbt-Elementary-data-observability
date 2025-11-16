

{% test column_name_not_null(model,column_name) %}
{{ config(severity = 'warn') }}

with a as (

select source_system, count(*) as cnt
from {{ model }} 
where column_name is null
group by source_system
)
,b as (
select source_system,cast(cnt as string) as cnt from a 
)
select source_system,cnt from b where cnt<>'0'

{% endtest %}


{% test column_name_not_null_check_no_source(model,column_name) %}
{{ config(severity = 'warn') }}

with a as (

select  count(*) as cnt
from {{ model }} 
where column_name is null
)
,b as (
select cast(cnt as string) as cnt from a 
)
select cnt from b where cnt<>'0'

{% endtest %}

