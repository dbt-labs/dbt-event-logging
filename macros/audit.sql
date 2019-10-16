{% macro get_audit_relation() %}
    {%- set audit_table =
        api.Relation.create(
            identifier='dbt_audit_log',
            schema='logging',
            type='table'
        ) -%}
    {{ return(audit_table) }}
{% endmacro %}


{% macro get_audit_schema() %}
    {% set audit_table = logging.get_audit_relation() %}
    {{ return(audit_table.include(schema=True, identifier=False)) }}
{% endmacro %}


{% macro log_audit_event(event_name, schema, relation) %}

    insert into {{ logging.get_audit_relation() }} (
        event_name,
        event_timestamp,
        event_schema,
        event_model,
        invocation_id
        )

    values (gs
        '{{ event_name }}',
        {{dbt_utils.current_timestamp_in_utc()}},
        {% if variable != None %}'{{ schema }}'{% else %}null::varchar(512){% endif %},
        {% if variable != None %}'{{ relation }}'{% else %}null::varchar(512){% endif %},
        '{{ invocation_id }}'
        )

{% endmacro %}


{% macro create_audit_schema() %}
  {%- if target.name == 'prod' -%}
    create schema if not exists {{ logging.get_audit_schema() }}
  {%- endif -%}
{% endmacro %}


{% macro create_audit_log_table() %}
  {%- if target.name == 'prod' -%}
    create table if not exists {{ logging.get_audit_relation() }}
    (
       event_name       varchar(512),
       event_timestamp  {{dbt_utils.type_timestamp()}},
       event_schema     varchar(512),
       event_model      varchar(512),
       invocation_id    varchar(512)
    )
  {%- endif -%}
{% endmacro %}


{% macro log_run_start_event() %}
  {%- if target.name == 'prod' -%}
    {{logging.log_audit_event('run started')}}

      {%- else -%}

    select 1 as return_value

  {%- endif -%}
{% endmacro %}


{% macro log_run_end_event() %}
  {%- if target.name == 'prod' -%}
    {{logging.log_audit_event('run completed')}}; commit;

  {%- else -%}

    select 1 as return_value

  {%- endif -%}
{% endmacro %}


{% macro log_model_start_event() %}
  {%- if target.name == 'prod' -%}
    {{logging.log_audit_event(
        'model deployment started', this.schema, this.name
        )}}

  {%- else -%}

    select 1 as return_value

  {%- endif -%}
{% endmacro %}


{% macro log_model_end_event() %}
  {%- if target.name == 'prod' -%}
    {{logging.log_audit_event(
        'model deployment completed', this.schema, this.name
        )}}

  {%- else -%}

    select 1 as return_value

  {%- endif -%}
{% endmacro %}
