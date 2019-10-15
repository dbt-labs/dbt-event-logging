{% macro log_target_create_audit_log_table() %}
  {%- if target.name == 'prod' -%}

    {{ logging.create_audit_log_table() }}

  {%- endif -%}
{% endmacro %}


{% macro log_target_create_audit_schema() %}
  {%- if target.name == 'prod' -%}

    {{ logging.create_audit_schema() }}

  {%- endif -%}
{% endmacro %}


{% macro log_model_target_start_event() %}
  {%- if target.name == 'prod' -%}

    {{logging.log_audit_event(
        'model deployment started', this.schema, this.name
        )}}

  {%- else -%}

    select 1 as test

  {%- endif -%}
{% endmacro %}


{% macro log_model_target_end_event() %}
  {%- if target.name == 'prod' -%}

    {{logging.log_audit_event(
        'model deployment completed', this.schema, this.name
        )}}

  {%- else -%}

    select 1 as test

  {%- endif -%}
{% endmacro %}


{% macro log_run_target_start_event() %}
  {%- if target.name == 'prod' -%}


    {{logging.log_audit_event('run started')}}

  {%- else -%}

    select 1 as test

  {%- endif -%}
{% endmacro %}


{% macro log_run_target_end_event() %}
  {%- if target.name == 'prod' -%}

    {{logging.log_audit_event('run completed')}}; commit;

  {%- else -%}

    select 1 as test

  {%- endif -%}
{% endmacro %}

