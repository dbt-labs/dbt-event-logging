{% macro drop_audit_schema() %}
    {% set audit_schema=logging.get_audit_schema() %}

    {% if adapter.check_schema_exists(target.database, audit_schema) %}
        {% set audit_schema_relation = api.Relation.create(database=target.database, schema=audit_schema).without_identifier() %}
        {% do drop_schema(audit_schema_relation) %}
        {% if adapter.type() != 'bigquery' %}
            {% do run_query("commit;") %}
        {% endif %}
        {{ dbt_utils.log_info("Audit schema dropped")}}

    {% else %}
        {{ dbt_utils.log_info("Audit schema does not exist so was not dropped") }}
    {% endif %}

{% endmacro %}
