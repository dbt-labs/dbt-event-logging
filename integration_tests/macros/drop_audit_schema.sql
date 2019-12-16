{% macro drop_audit_schema() %}
    {% set audit_schema=logging.get_audit_schema() %}

    {% if adapter.check_schema_exists(target.database, audit_schema) %}
        {% do drop_schema(target.database, audit_schema) %}
        {% do run_query("commit;") %}
        {{ dbt_utils.log_info("Audit schema dropped")}}

    {% else %}
        {{ dbt_utils.log_info("Audit schema does not exist so was not dropped") }}
    {% endif %}

{% endmacro %}
