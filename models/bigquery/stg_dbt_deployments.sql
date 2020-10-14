with events as (

    select * from {{ref('stg_dbt_audit_log')}}

),

aggregated as (

    select

        invocation_id,
        event_target as target,
        event_is_full_refresh as is_full_refresh,

        min(case
            when event_name = 'run started' then event_timestamp
            end) as deployment_started_at,

        min(case
            when event_name = 'run completed' then event_timestamp
            end) as deployment_completed_at,

        count(distinct case
            when event_name like '%model%' then event_model
            end) as models_deployed

    from events

    {{ dbt_utils.group_by(n=3) }}

)

select * from aggregated
