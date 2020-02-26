
{# create_legacy_audit_table creates the audit table with the columns defined in version 0.1.7 #}
{% macro create_legacy_audit_table() %}

    {{ logging.create_audit_schema() }}

    create table if not exists {{ logging.get_audit_relation() }}
    (
       event_name       varchar(512),
       event_timestamp  {{dbt_utils.type_timestamp()}},
       event_schema     varchar(512),
       event_model      varchar(512),
       invocation_id    varchar(512)
    )
    {{ dbt_utils.log_info("Created legacy audit table") }}
{% endmacro %}
