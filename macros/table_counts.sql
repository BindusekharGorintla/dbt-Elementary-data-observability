-- macros/table_counts.sql

{% macro table_counts(tables) %}
    {%- for table in tables %}
        select
            '{{ table }}' as table_name,
            count(*) as row_count
        from {{ ref(table) }}
        {%- if not loop.last %}
        union all
        {%- endif %}
    {%- endfor %}
{% endmacro %}
