- dashboard: dbt_audit
  title: dbt Audit
  layout: newspaper
  elements:
  - title: dbt Deployments by Hour
    name: dbt Deployments by Hour
    model: dbt
    explore: dbt_deployments
    type: looker_line
    fields:
    - dbt_deployments.deployment_completed_hour
    - dbt_deployments.count
    fill_fields:
    - dbt_deployments.deployment_completed_hour
    sorts:
    - dbt_deployments.deployment_completed_hour desc
    limit: 500
    query_timezone: America/New_York
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 0
    col: 12
    width: 12
    height: 7
  - title: dbt Model Average Deployment Time
    name: dbt Model Average Deployment Time
    model: dbt
    explore: dbt_deployments
    type: table
    fields:
    - dbt_model_deployments.average_duration_in_m
    - dbt_model_deployments.model
    filters:
      dbt_model_deployments.average_duration_in_m: NOT NULL
      dbt_model_deployments.deployment_completed_date: 7 days
    sorts:
    - dbt_model_deployments.average_duration_in_m desc
    limit: 500
    query_timezone: America/New_York
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    series_types: {}
    row: 16
    col: 13
    width: 11
    height: 21
  - title: dbt Longest Running Models Trends
    name: dbt Longest Running Models Trends
    model: dbt
    explore: dbt_deployments
    type: looker_line
    fields:
    - dbt_model_deployments.average_duration_in_m
    - dbt_model_deployments.model
    - dbt_model_deployments.deployment_completed_hour
    pivots:
    - dbt_model_deployments.model
    filters:
      dbt_model_deployments.deployment_completed_date: 7 days
      dbt_model_deployments.duration_in_m: ">1"
      dbt_model_deployments.average_duration_in_m: NOT NULL
    sorts:
    - dbt_model_deployments.model 0
    - dbt_model_deployments.deployment_completed_hour desc
    limit: 500
    query_timezone: America/New_York
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: false
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hide_legend: false
    row: 7
    col: 0
    width: 24
    height: 9
  - title: dbt Deployment Duration (Full Run)
    name: dbt Deployment Duration (Full Run)
    model: dbt
    explore: dbt_deployments
    type: looker_line
    fields:
    - dbt_deployments.deployment_completed_hour
    - dbt_deployments.average_duration_in_m
    filters:
      dbt_deployments.deployment_completed_hour: 7 days
      dbt_deployments.models_deployed: ">=100"
    sorts:
    - dbt_deployments.deployment_completed_hour
    limit: 500
    query_timezone: America/New_York
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 0
    col: 0
    width: 12
    height: 7
  - title: dbt Most Recent Model Deployments
    name: dbt Most Recent Model Deployments
    model: dbt
    explore: dbt_deployments
    type: table
    fields:
    - dbt_model_deployments.model
    - dbt_model_deployments.most_recent_deployment_completed
    filters:
      dbt_model_deployments.model: "-NULL"
      dbt_model_deployments.deployment_completed_date: 7 days
    sorts:
    - most_recent_runtime_hours_ago desc
    limit: 500
    dynamic_fields:
    - table_calculation: most_recent_runtime_hours_ago
      label: Most Recent Runtime Hours Ago
      expression: diff_minutes(${dbt_model_deployments.most_recent_deployment_completed},
        now()) / 60
      value_format:
      value_format_name: decimal_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/New_York
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 16
    col: 0
    width: 13
    height: 21
