connection: ""

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: dbt_deployments {

  label: "dbt Deployments"

  join: dbt_model_deployments {
    sql_on: ${dbt_deployments.invocation_id} = ${dbt_model_deployments.invocation_id} ;;
    relationship: one_to_many
    type: left_outer
  }
}
