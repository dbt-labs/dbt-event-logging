
{# create_legacy_audit_table creates the audit table with the columns defined in version 0.1.7 #}
{% macro create_legacy_audit_table() %}

    {{ logging.create_audit_schema() }}

    {% if adapter.type() == 'bigquery' %}
        {{ set string_type = 'string' }}
    {% else %}
        {{ set string_type = 'varchar(512)' }}
    {% endif %}

    create table if not exists {{ logging.get_audit_relation() }}
    (
       event_name       {{ string_type }},
       event_timestamp  {{ dbt_utils.type_timestamp() }},
       event_schema     {{ string_type }},
       event_model      {{ string_type }},
       invocation_id    {{ string_type }}
    )
    {{ dbt_utils.log_info("Created legacy audit table") }}
{% endmacro %}
