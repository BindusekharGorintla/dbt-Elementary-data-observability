

{% test comparison_min_max_dates(model,column_name,field_name,tbl_name) %}


with a as (
select '{{ tbl_name }}' as tbl_name,
 min({{ column_name }}) as a_min,
 max({{ column_name }}) as a_max
from {{ model }}

)
,b as (
select '{{ tbl_name }}' as tbl_name,
 min({{ field_name }}) as b_min,
 max({{ field_name }}) as b_max
from {{ var('oncology_src_catalog')}}.{{ var('oncology_src_schema')}}.{{ tbl_name }}
)
,c as (
select  a.tbl_name as tbl_name,a_min as oncology_min,b_min as oncology_min,
a_max as oncology_max,b_max as oncology_max
from a
inner join b on a.tbl_name=b.tbl_name
where (a_min<b_min or a_max<b_max )
)
,d as(
select cast(count(*) as string) as cnt from c
)
select cnt from d where cnt<>'0'

{% endtest %}
