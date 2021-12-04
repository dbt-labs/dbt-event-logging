select
  model
  , cast(min(deployment_started_at) as date) as first
  , max(deployment_started_at) as last
from
  {{ ref('stg_dbt_model_deployments') }}
where
  [deployment_started_at=daterange]
group by
  1
order by
  3 asc
