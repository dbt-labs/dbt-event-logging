{% macro get_audit_relation() %}
    {%- set audit_table =
        api.Relation.create(
            identifier='dbt_audit_log',
            schema=target.schema~'_invocations',
            type='table'
        ) -%}
    {{ return(audit_table) }}
{% endmacro %}


{% macro get_audit_schema() %}
    {% set audit_table = logging.get_audit_relation() %}
    {{ return(audit_table.include(schema=True, identifier=False)) }}
{% endmacro %}


{% macro log_audit_event(event_name, schema, relation, is_full_refresh) %}

    insert into {{ logging.get_audit_relation() }} (
        event_name,
        event_timestamp,
        event_schema,
        event_model,
        is_full_refresh,
        invocation_id
        )

    values (
        '{{ event_name }}',
        getdate(),
        {% if variable != None %}'{{ schema }}'{% else %}null::varchar(512){% endif %},
        {% if variable != None %}'{{ relation }}'{% else %}null::varchar(512){% endif %},
        '{{ is_full_refresh }}',
        '{{ invocation_id }}'
        )

{% endmacro %}


{% macro create_audit_schema(run_dbt_logging=False) %}
  {% if run_dbt_logging %}
    create schema if not exists {{ logging.get_audit_schema() }}
  {% else %}
    select 1
  {% endif %}
{% endmacro %}


{% macro create_audit_log_table(run_dbt_logging=False) %}
  {% if run_dbt_logging %}
    create table if not exists {{ logging.get_audit_relation() }}
    (
       event_name       varchar(512),
       event_timestamp  {{dbt_utils.type_timestamp()}},
       event_schema     varchar(512),
       event_model      varchar(512),
       is_full_refresh  boolean,
       invocation_id    varchar(512)
    )
  {% else %}
    select 1
  {% endif %}

{% endmacro %}


{% macro log_run_start_event(run_dbt_logging=False) %}
  {% if run_dbt_logging %}
    {{logging.log_audit_event(
        event_name='run started', is_full_refresh=flags.FULL_REFRESH
        )}}
  {% else %}
    select 1
  {% endif %}
{% endmacro %}


{% macro log_run_end_event(run_dbt_logging=False) %}
  {% if run_dbt_logging %}
    {{logging.log_audit_event(
        event_name='run completed', is_full_refresh=flags.FULL_REFRESH
        )}}
  {% else %}
    select 1
  {% endif %}
{% endmacro %}


{% macro log_model_start_event() %}
    {{logging.log_audit_event(
        event_name='model deployment started', schema=this.schema, relation=this.name, is_full_refresh=flags.FULL_REFRESH
        )}}
{% endmacro %}


{% macro log_model_end_event() %}
    {{logging.log_audit_event(
        event_name='model deployment completed', schema=this.schema, relation=this.name, is_full_refresh=flags.FULL_REFRESH
        )}}
{% endmacro %}
