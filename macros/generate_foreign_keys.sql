/*
macro: generate_foreign_key

Purpose:
  Dynamically generates foreign key columns for a source table by hashing specified key fields, enabling robust key matching across sources with different key structures. It standardizes foreign key creation and ensures consistent key values for downstream joins, while handling source-specific logic for key generation.

Logic:
  1. For each foreign key in key_info, builds a SHA2 hash from the specified columns, optionally prefixing column names.
  2. For rows from the specified sources, generates the foreign key columns using the hash logic and includes them in the output.
  3. For rows not from the specified sources, sets the foreign key columns to NULL.
  4. Combines both sets of rows using UNION ALL, ensuring all output columns are present and ordered.
  5. When 'nullify_orphan_key' = true, any foreign key whose value does not exist in the parent table is set to NULL.

Usage Example:
  In a dbt model SQL file:
    {{ generate_foreign_key(ref('my_table'), {
        'pcc_key': {
            'key_list': ['patient_id', 'condition_group'],
            'foreign_table': ref('primary_cancer_condition_gold')
        }
      }, ['JBAT', 'IKM', 'NLP']
      , nullify_orphan_key=false) }}

Limitations & Assumptions:
  - Assumes key_list is a Python list or a comma-separated string of column names.
  - Assumes source_table contains all columns referenced in key_list.
  - Assumes source_system column exists in source_table for filtering.
  - Only supports SHA2 hashing for key generation.
  - Does not join to foreign_table; only generates key columns for later use.
  - The macro expects consistent column naming and types for hashing.

Outputs:
  - Returns a SQL query string that:
      - Adds foreign key columns (as SHA2 hashes) for specified sources.
      - Sets foreign key columns to NULL for other sources.
      - Preserves all original columns and adds the new foreign key columns.
      - Combines both sets of rows into a single output using UNION ALL.
*/
{% macro generate_foreign_key(source_table, key_info, sources, nullify_orphan_key=false, orphan_check_sources=none) %}
    {%- set key_exprs = [] -%}
    {%- set foreign_keys = key_info.keys() -%}
    {%- set cols = adapter.get_columns_in_relation(source_table) -%}
    {%- set ordered_columns = cols | map(attribute="name") | list -%}

    {%- for foreign_key, details in key_info.items() -%}
        {%- set key_list = strip_whitespace(details['key_list']) -%}
        {%- set sorted_key_list = key_list | sort -%}
        {%- set prefix = foreign_key.split('_')[0] -%}
        {%- set key_expr_parts = [] -%}

        -- Generate SHA2 key in the order provided, with prefix (except patient_id)
        {%- for column in sorted_key_list -%}
            {%- set full_column = column if column == 'patient_id' else prefix ~ '_' ~ column -%}
            {%- set expr = "COALESCE(" ~ 
                ("CAST(TO_DATE(src." ~ full_column ~ ") AS STRING)" if "_datetime" in column else "src." ~ full_column) ~ 
                ", '')" %}
            {%- do key_expr_parts.append(expr) -%}
        {% endfor %}

        {%- set fk_expr = "UPPER(SHA2(CONCAT(" ~ key_expr_parts | join(', ') ~ "), 256)) AS " ~ foreign_key -%}
        {% do key_exprs.append(fk_expr) %}
        -- Add WHERE clause for filtering based on matching keys in foreign tables
        {%- set source_filter -%}
            {%- for source in sources -%}
                '{{ source }}'{% if not loop.last %}, {% endif %}
            {%- endfor -%}
        {%- endset -%}

    {%- endfor -%}

    -- Define CTE for source in sources
    {%- set source_data_cte -%}
        WITH base_keys AS (
            SELECT src.* EXCEPT({{ foreign_keys | join(', ') }})
                {%- for expr in key_exprs %}
                    , {{ expr }}
                {%- endfor %}
            FROM {{ source_table }} AS src
            {%- if sources %}
                    WHERE source_system IN (
                {%- for source in sources %}
                        '{{ source }}'{% if not loop.last %}, {% endif %}
                {%- endfor %})
            {%- endif -%}
    )
    {%- if nullify_orphan_key -%},
        -- Define CTE to nullify orphan keys
        orphan_checked_keys AS (
            SELECT 
                bk.* EXCEPT({{ foreign_keys | join(', ') }}),

                {%- for foreign_key, details in key_info.items() %}
                    CASE
                        WHEN bk.source_system IN (
                            {%- if orphan_check_sources is not none and orphan_check_sources | length > 0 -%}
                                {%- for source in orphan_check_sources -%}
                                    '{{ source }}'{% if not loop.last %}, {% endif %}
                                {%- endfor -%}
                            {%- else -%}
                                'OC4'
                            {%- endif -%}
                        ) THEN
                            CASE
                                WHEN EXISTS (
                                    SELECT 1
                                    FROM {{ details['foreign_table'] }} AS fk
                                    WHERE fk.{{ foreign_key }} = bk.{{ foreign_key }}
                                    AND fk.{{ foreign_key }} IS NOT NULL
                                )
                                THEN bk.{{ foreign_key }}
                                ELSE NULL
                            END
                        ELSE 
                            bk.{{ foreign_key }}
                    END AS {{ foreign_key }}
                    {%- if not loop.last %},{%- endif %}
                {%- endfor %}
            FROM base_keys AS bk
        )
    {%- endif -%}

    {%- endset -%}

    -- Define query for non-specified sources
    {%- set non_filtered_query -%}
        SELECT * EXCEPT({{ foreign_keys | join(', ') }})
            {%- for key in foreign_keys %}
                , CAST(NULL AS STRING) AS {{key}}
            {%- endfor %}
        FROM {{ source_table }}
            {%- if sources %}
                WHERE source_system NOT IN (
                {%- for source in sources %}
                    '{{ source }}'{% if not loop.last %}, {% endif %}
                {%- endfor %})
            {%- endif -%}

    {%- endset -%}

    -- Combine using UNION ALL
    {%- set final_query -%}
        {{ source_data_cte }}
        SELECT {{ ordered_columns | join(', ') }} FROM {% if nullify_orphan_key %} orphan_checked_keys {% else %} base_keys {% endif %}
        UNION ALL
        SELECT {{ ordered_columns | join(', ') }} FROM ({{ non_filtered_query }})
    {%- endset -%}
    
    {{ return(final_query) }}
{% endmacro %}
