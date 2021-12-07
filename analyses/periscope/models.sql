select
  [deployment_started_at:aggregation] as period
  , model
  , count(1) as deployment_count
from
  {{ ref('stg_dbt_model_deployments') }}
where
  [deployment_started_at=daterange]
group by
  1
  , 2
order by
  1 desc
  , 2
