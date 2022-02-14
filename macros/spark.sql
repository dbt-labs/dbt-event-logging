{% macro spark__get_audit_relation() %}

    {%- set audit_schema=logging.get_audit_schema() -%}

    {%- set audit_table =
        api.Relation.create(
            schema=audit_schema,
            identifier='dbt_audit_log',
            type='table'
        ) -%}

    {{ return(audit_table) }}

{% endmacro %}


{% macro spark__log_audit_event(event_name, schema, relation, user, target_name, is_full_refresh) %}

    insert into {{ logging.get_audit_relation() }} (
        event_name,
        event_timestamp,
        event_schema,
        event_model,
        event_user,
        event_target,
        event_is_full_refresh,
        invocation_id
    )

    values (
        '{{ event_name }}',
        {{ dbt_utils.current_timestamp() }},
        {% if schema != None %}'{{ schema }}'{% else %}null::varchar(512){% endif %},
        {% if relation != None %}'{{ relation }}'{% else %}null::varchar(512){% endif %},
        {% if user != None %}'{{ user }}'{% else %}null::varchar(512){% endif %},
        {% if target_name != None %}'{{ target_name }}'{% else %}null::varchar(512){% endif %},
        {% if is_full_refresh %}TRUE{% else %}FALSE{% endif %},
        '{{ invocation_id }}'
    );


{% endmacro %}


{% macro spark__create_audit_schema() %}
    {%- set schema_name = logging.get_audit_schema() -%}
    {%- set schema_exists = adapter.check_schema_exists(database=target.database, schema=schema_name) -%}
    {% if schema_exists == 0 %}
        {% do create_schema(api.Relation.create(
            schema=schema_name)
        ) %}
    {% endif %}
{% endmacro %}


{% macro spark__create_audit_log_table() -%}

    {% set required_columns = [
       ["event_name", dbt_utils.type_string()],
       ["event_timestamp", dbt_utils.type_timestamp()],
       ["event_schema", dbt_utils.type_string()],
       ["event_model", dbt_utils.type_string()],
       ["event_user", dbt_utils.type_string()],
       ["event_target", dbt_utils.type_string()],
       ["event_is_full_refresh", "boolean"],
       ["invocation_id", dbt_utils.type_string()],
    ] -%}

    {% set audit_table = logging.get_audit_relation() -%}

    {% set audit_table_exists = adapter.get_relation(audit_table.database, audit_table.schema, audit_table.name) -%}


    {% if audit_table_exists -%}

        {%- set columns_to_create = [] -%}

        {# map to lower to cater for snowflake returning column names as upper case #}
        {%- set existing_columns = adapter.get_columns_in_relation(audit_table)|map(attribute='column')|map('lower')|list -%}

        {%- for required_column in required_columns -%}
            {%- if required_column[0] not in existing_columns -%}
                {%- do columns_to_create.append(required_column) -%}

            {%- endif -%}
        {%- endfor -%}


        {%- for column in columns_to_create -%}
            alter table {{ audit_table }}
            add column {{ column[0] }} {{ column[1] }}
            default null;
        {% endfor -%}

        {%- if columns_to_create|length > 0 %}
            commit;
        {% endif -%}

    {%- else -%}
        create table if not exists {{ audit_table }}
        (
        {% for column in required_columns %}
            {{ column[0] }} {{ column[1] }}{% if not loop.last %},{% endif %}
        {% endfor %}
        )
    {%- endif -%}

{%- endmacro %}

