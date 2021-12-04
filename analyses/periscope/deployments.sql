select
  [deployment_started_at:aggregation] as period
  , sum(datediff('minute', deployment_started_at, deployment_completed_at)) as total_runtime_m
  , avg(datediff('minute', deployment_started_at, deployment_completed_at)) as avg_runtime_m
  , sum(models_deployed) as models_deployed
from
  {{ ref('stg_dbt_deployments') }}
where
  [deployment_started_at=daterange]
group by
  1
order by
  1 desc
