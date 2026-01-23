-- macros/encrypt_column.sql

{% macro encrypt_column(column_name, method='sha256') %}
    {%- if method == 'md5' -%}
        md5({{ column_name }})
    {%- elif method == 'sha1' -%}
        sha1({{ column_name }})
    {%- elif method == 'sha256' -%}
        sha256({{ column_name }})
    {%- else -%}
        -- fallback: default to sha256
        sha256({{ column_name }})
    {%- endif -%}
{% endmacro %}
