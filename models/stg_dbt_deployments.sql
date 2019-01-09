with events as (
select *
from {{ref('stg_dbt_audit_log')}}
),

aggregated as (
select
  invocation_id,
  min(case when event_name = 'run started' then event_timestamp end) as deployment_started_at,
  min(case when event_name = 'run completed' then event_timestamp end) as deployment_completed_at,
  datediff('seconds',deployment_started_at,deployment_completed_at) as deployment_time_seconds,
  count(distinct case when event_name ilike '%model%' then event_model end) as models_deployed,
  is_full_refresh
from events
group by invocation_id,is_full_refresh
)

select *
from aggregated
