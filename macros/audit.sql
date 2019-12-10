{% macro get_audit_schema() %}

    {{ return(target.schema~'_meta') }}

{% endmacro %}

{% macro get_audit_relation() %}

    {%- set audit_schema=logging.get_audit_schema() -%}

    {%- set audit_table =
        api.Relation.create(
            database=target.database,
            schema=audit_schema,
            identifier='dbt_audit_log',
            type='table'
        ) -%}

    {{ return(audit_table) }}

{% endmacro %}


{% macro log_audit_event(run_audit) %}

    insert into {{ logging.get_audit_relation() }} (
        audit,
        audit_timestamp,
        invocation_id
    )

    values (
        '{{ run_audit }}',
        {{ dbt_utils.current_timestamp_in_utc() }},
        '{{ invocation_id }}'
        )

{% endmacro %}


{% macro create_audit_schema() %}
    create schema if not exists {{ logging.get_audit_schema() }}
{% endmacro %}


{% macro create_audit_log_table() %}

    create table if not exists {{ logging.get_audit_relation() }}
    (
       audit            varchar(max),
       audit_timestamp  {{ dbt_utils.type_timestamp() }},
       invocation_id    varchar(512)
    )

{% endmacro %}

{% macro log_run_end_event(results, flags, target) %}
    {% set run_audit=logging.get_run_audit(results, flags, target) %}
    {{ logging.log_audit_event(run_audit) }}; commit;
{% endmacro %}
