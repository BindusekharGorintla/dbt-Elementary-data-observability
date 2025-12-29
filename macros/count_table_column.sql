{%- macro count_table_column(table_name, column_name) -%}
    select count(*) from {{ table_name }} where {{ column_name }} is not null and cast({{ column_name }} as STRING) != ''
{%- endmacro %}
