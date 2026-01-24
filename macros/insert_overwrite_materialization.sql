-- dbt INSERT-OVERWRITE materialization macro
-- usage: {{ config(materialized='insert_overwrite') }}

{% materialization insert_overwrite, adapter='snowflake' %}

    {%- set target_relation = this.incorporate(type='table') -%}
    {%- set existing_relation = load_relation(this) -%}

    {{ run_hooks(pre_hooks, inside_transaction=False) }}
    {{ run_hooks(pre_hooks, inside_transaction=True) }}

    {% if existing_relation is none %}
        {% set build_sql %}
            create table {{ target_relation }} as (
                {{ sql }}
            )
        {% endset %}
        {% call statement('main') %}
            {{ build_sql }}
        {% endcall %}
    {% elif existing_relation.is_view %}
        {{ exceptions.raise_compiler_error("Cannot INSERT OVERWRITE into a view. Please drop the view first.") }}
    {% else %}
        {% set insert_sql %}
            insert overwrite into {{ target_relation }}
            {{ sql }}
        {% endset %}
        {% set recreate_sql %}
            create or replace table {{ target_relation }} as (
                {{ sql }}
            )
        {% endset %}
        {% do run_query("begin") %}
        {% set results = run_query(insert_sql) %}
        {% if results is none %}
            {% do run_query("rollback") %}
            {% call statement('main') %}
                {{ recreate_sql }}
            {% endcall %}
        {% else %}
            {% do run_query("commit") %}
        {% endif %}
    {% endif %}

    {{ run_hooks(post_hooks, inside_transaction=True) }}

    {% do persist_docs(target_relation, model) %}

    {{ run_hooks(post_hooks, inside_transaction=False) }}

    {{ return({'relations': [target_relation]}) }}

{% endmaterialization %}
