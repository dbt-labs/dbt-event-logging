
{# create_legacy_audit_table creates the audit table with the columns defined in version 0.1.7 #}
{% macro create_legacy_audit_table() %}

    {{ logging.create_audit_schema() }}

    create table if not exists {{ logging.get_audit_relation() }}
    (
       event_name       {{ dbt.type_string() }},
       event_timestamp  {{ dbt.type_timestamp() }},
       event_schema     {{ dbt.type_string() }},
       event_model      {{ dbt.type_string() }},
       invocation_id    {{ dbt.type_string() }}
    )
    {% do dbt_utils.log_info("Created legacy audit table") %}
{% endmacro %}
