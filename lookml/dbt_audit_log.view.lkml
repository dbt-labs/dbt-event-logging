view: dbt_audit_log {
  sql_table_name: ANALYTICS_META.STG_DBT_AUDIT_LOG ;;
  label: "dbt Audit Log"

  dimension: event_id {
    type: string
    sql: ${TABLE}.EVENT_ID ;;
    primary_key: yes
    hidden: yes
  }

  dimension: event_model {
    type: string
    sql: ${TABLE}.EVENT_MODEL ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.EVENT_NAME ;;
  }

  dimension: event_schema {
    type: string
    sql: ${TABLE}.EVENT_SCHEMA ;;
  }

  dimension: event_user {
    type: string
    sql: ${TABLE}.EVENT_USER ;;
  }

  dimension: event_target {
    type: string
    sql: ${TABLE}.EVENT_TARGET ;;
  }

  dimension: event_is_full_refresh {
    type: boolean
    sql: ${TABLE}.EVENT_IS_FULL_REFRESH ;;
  }

  dimension_group: event_timestamp {
    type: time
    timeframes: [
      month,
      week,
      date,
      hour,
      minute
      ]
    datatype: datetime
    convert_tz: yes
    sql: ${TABLE}.EVENT_TIMESTAMP ;;
  }

  dimension: invocation_id {
    type: string
    sql: ${TABLE}.INVOCATION_ID ;;
  }

  measure: count {
    type: count
  }
}
