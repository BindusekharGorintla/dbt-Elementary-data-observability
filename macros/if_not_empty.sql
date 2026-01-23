-- macros/if_not_empty.sql

{% macro if_not_empty(column_name) %}
    (
        {{ column_name }} is not null
        and trim({{ column_name }}) <> ''
    )
{% endmacro %}
