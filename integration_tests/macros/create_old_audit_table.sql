
{# create_legacy_audit_table creates the audit table with the columns defined in version 0.1.7 #}
{% macro create_legacy_audit_table() %}

    {{ logging.create_audit_schema() }}

    create table if not exists {{ logging.get_audit_relation() }}
    (
       event_name       {{ dbt_utils.type_string() }},
       event_timestamp  {{ dbt_utils.type_timestamp() }},
       event_schema     {{ dbt_utils.type_string() }},
       event_model      {{ dbt_utils.type_string() }},
       invocation_id    {{ dbt_utils.type_string() }}
    )
    {% do dbt_utils.log_info("Created legacy audit table") %}
{% endmacro %}
