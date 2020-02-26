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

  dimension: user {
    type: string
    sql: ${TABLE}.USER ;;
  }

  dimension: target {
    type: string
    sql: ${TABLE}.TARGET ;;
  }

  dimension: is_full_refresh {
    type: boolean
    sql: ${TABLE}.IS_FULL_REFRESH ;;
  }

  dimension: duration {
    type: duration
    dimension_group: dimension_group_name {
    sql_start: ${deployment_started_raw} ;;
    sql_end: ${deployment_completed_raw} ;;
    intervals: [second, minute]
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
