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


{% macro log_audit_event(event_name, schema, relation) %}

    insert into {{ logging.get_audit_relation() }} (
        event_name,
        event_timestamp,
        event_schema,
        event_model,
        invocation_id
        )

    values (
        '{{ event_name }}',
        getdate(),
        {% if variable != None %}'{{ schema }}'{% else %}null::varchar(512){% endif %},
        {% if variable != None %}'{{ relation }}'{% else %}null::varchar(512){% endif %},
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
       invocation_id    varchar(512)
    )
  {% else %}
    select 1
  {% endif %}

{% endmacro %}


{% macro log_run_start_event(run_dbt_logging=False) %}
  {% if run_dbt_logging %}
    {{logging.log_audit_event('run started')}}
  {% else %}
    select 1
  {% endif %}
{% endmacro %}


{% macro log_run_end_event(run_dbt_logging=False) %}
  {% if run_dbt_logging %}
    {{logging.log_audit_event('run completed')}}
  {% else %}
    select 1
  {% endif %}
{% endmacro %}


{% macro log_model_start_event() %}
    {{logging.log_audit_event(
        'model deployment started', this.schema, this.name
        )}}
{% endmacro %}


{% macro log_model_end_event() %}
    {{logging.log_audit_event(
        'model deployment completed', this.schema, this.name
        )}}
{% endmacro %}

{% macro unload_to_s3(run_dbt_logging=False, unload_to_s3=False) %}

  {% if run_dbt_logging %}
    {% if unload_to_s3 %}
      unload ('select dil.* from dbt_spectrum_redshift.dbt_invocation_logs dil union select d.* from {{ logging.get_audit_relation() }} d') to 's3://redshift-dbt-logs/dbt_invocation_logs/dbt_invocation_logs_' iam_role '{{ var('dbt_iam_role') }}' manifest delimiter as ',' null as '' escape allowoverwrite
    {% else %}
      select 1
    {% endif %}
  {% else %}
    select 1
  {% endif %}
{% endmacro %}
