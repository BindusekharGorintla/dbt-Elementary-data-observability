
{% test comparison_completion_rates_distinct_cnts (model,column_name,field_name,tbl_name) %}

with a as (
select '{{ tbl_name }}' as tbl_name,
count(*) as a_totalcount,
count(distinct {{ column_name }} ) as a_cnt
from {{ model }}
)
,b as (
select '{{ tbl_name }}' as tbl_name,
count(*) as b_totalcount,
count(distinct {{ field_name }} ) as b_cnt
from {{ var('oncology_src_catalog')}}.{{ var('ncology_src_schema')}}.{{ tbl_name }}
)
,c as (
select a.tbl_name as tbl_name,a_cnt/a_totalcount*100 oncology_cnt, b_cnt/b_totalcount*100 as oncology_src_cnt from
a 
inner join b on a.tbl_name=b.tbl_name
)
select * from c
where oncology_cnt<oncology_src_cnt

{% endtest %}
