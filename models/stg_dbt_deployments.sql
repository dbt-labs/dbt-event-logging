{{
    config(
        enabled=false
    )
}}

with events as (

    select * from {{ref('stg_dbt_audit_log')}}

),

aggregated as (

    select

        invocation_id,

        min(case
            when event_name = 'run started' then event_timestamp
            end) as deployment_started_at,

        min(case
            when event_name = 'run completed' then event_timestamp
            end) as deployment_completed_at,

        count(distinct case
            when event_name ilike '%model%' then event_model
            end) as models_deployed

    from events
    group by 1

)

select * from aggregated
