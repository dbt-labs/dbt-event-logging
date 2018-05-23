view: dbt_deployments {
  sql_table_name: ANALYTICS_META.STG_DBT_DEPLOYMENTS ;;
  label: "dbt Deployments"

  dimension: invocation_id {
    type: string
    sql: ${TABLE}.INVOCATION_ID ;;
    primary_key: yes
    hidden: yes
  }

  dimension_group: deployment_started {
    type: time
    timeframes: [
      month,
      week,
      date,
      hour,
      minute,
      time,
      raw
    ]
    datatype: datetime
    convert_tz: yes
    sql: ${TABLE}.DEPLOYMENT_STARTED_AT ;;
  }

  dimension_group: deployment_completed {
    type: time
    timeframes: [
      month,
      week,
      date,
      hour,
      minute,
      time,
      raw
    ]
    datatype: datetime
    convert_tz: yes
    sql: ${TABLE}.DEPLOYMENT_COMPLETED_AT ;;
  }

  dimension: models_deployed {
    type: number
    sql: ${TABLE}.models_deployed ;;
  }

  dimension: duration_in_s {
    type: number
    label: "Duration (seconds)"
    sql: datediff(s, ${deployment_started_time}, ${deployment_completed_time}) ;;
  }

  dimension: duration_in_m {
    type: number
    label: "Duration (minutes)"
    sql: ${duration_in_s}::float / 60 ;;
    value_format_name: decimal_2
  }

  measure: count {
    type: count
  }

  measure: average_duration_in_s {
    label: "Average Duration (seconds)"
    type: average
    sql: ${duration_in_s} ;;
  }

  measure: average_duration_in_m {
    label: "Average Duration (minutes)"
    type: average
    sql: ${duration_in_m} ;;
    value_format_name: decimal_2
  }
}
