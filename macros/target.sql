{% macro logging_target_create_audit_log_table() %}
  {%- if target.name == 'prod' -%}

    {{ logging.create_audit_log_table() }}

  {%- endif -%}
{% endmacro %}


{% macro logging_target_create_audit_schema() %}
  {%- if target.name == 'prod' -%}

    {{ logging.create_audit_schema() }}

  {%- endif -%}
{% endmacro %}


{% macro logging_target_start() %}
  {%- if target.name == 'prod' -%}

    {{ logging.log_run_start_event() }}

  {%- endif -%}
{% endmacro %}


{% macro logging_target_end() %}
  {%- if target.name == 'prod' -%}

    {{ logging.log_run_end_event() }}

  {%- endif -%}
{% endmacro %}


{% macro log_model_target_start_event() %}
  {%- if target.name == 'prod' -%}

    {{logging.log_audit_event(
        'model deployment started', this.schema, this.name
        )}}

  {%- else -%}

    select 1 as test --need to return something

  {%- endif -%}
{% endmacro %}


{% macro log_model_target_end_event() %}
  {%- if target.name == 'prod' -%}

    {{logging.log_audit_event(
        'model deployment completed', this.schema, this.name
        )}}

  {%- else -%}

    select 1 as test --need to return something

  {%- endif -%}
{% endmacro %}


