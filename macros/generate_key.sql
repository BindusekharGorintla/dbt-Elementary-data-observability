

{% macro generate_key(table_name, key_type) %}

    {%- if key_type not in ['natural', 'unique'] -%}
        {{ exceptions.raise_compiler_error("Invalid key_type provided. Must be 'natural' or 'unique'. Got: " ~ key_type) }}
    {%- endif -%}

    {% set key_query %}
        SELECT DISTINCT
            table_name,
            {{ key_type }}_key_name AS key_name,
            {{ key_type }}_key_columns AS key_columns
        FROM
            {{ ref('all_keys') }}
        WHERE
            table_name = '{{ table_name }}'
    {% endset %}

    {% set results = run_query(key_query) %}
    {% if execute %}
        {% set rows = results.rows %}
        {%- if rows | length == 0 -%}
            {{ exceptions.raise_compiler_error("No keys found for table '" ~ table_name ~ " with key_type '" ~ key_type ~"'. Please check your metadata.") }}
        {%- else -%}
            {% set key_name = rows[0].key_name %}
            {% set key_columns_str = rows[0].key_columns | lower %}
            {% set key_columns = key_columns_str.split(',') %}
        {%- endif -%}
    {% endif %}

    {% set normalized_columns = strip_whitespace(key_columns) | sort %}

    {# Construct the key expression #}
    {% set key_expr_parts = [] %}
    {% for column in normalized_columns %}
        {% if column %}
            {% set expr = "COALESCE(" ~ 
                ("CAST(TO_DATE(" ~ column ~ ") AS STRING)" 
                if "_datetime" in column 
                else column) ~ 
                ", '')" %}
            {% do key_expr_parts.append(expr) %}
        {% endif %}
    {% endfor %}
    {% set key_expr = key_expr_parts | join(', ') %}
    
    {% set sha_expr = "UPPER(SHA2(CONCAT(" ~ key_expr ~ "), 256)) AS " ~ key_name %}
    
    {{ return(sha_expr) }}

{% endmacro %}
