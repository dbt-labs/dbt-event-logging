## dbt Event Logging

> :warning: **ADDING THIS PACKAGE TO YOUR DBT PROJECT CAN SIGNIFICANTLY SLOW
> DOWN YOUR DBT RUNS**. This is due to the number of insert statements executed by
> this package, especially as a post-hook. Please consider if this package is
> appropriate for your use case before using it.

Requires dbt >= 0.18.0

This package provides out-of-the-box functionality to log events for all dbt
invocations, including run start, run end, model start, and model end. It
outputs all data and models to schema `[target.schema]_meta`. There are three
convenience models to make it easier to parse the event log data.

### Setup

1. Include this package in your `packages.yml` -- check [here](https://hub.getdbt.com/fishtown-analytics/logging/latest/)
   for installation instructions.
2. Include the following in your `dbt_project.yml` directly within your
   `models:` block (making sure to handle indenting appropriately):

```YAML
# dbt_project.yml
...

models:
  ...
  pre-hook: "{{ logging.log_model_start_event() }}"
  post-hook: "{{ logging.log_model_end_event() }}"
```

That's it! You'll now have a stream of events for all dbt invocations in your
warehouse.

#### Customising audit schema

It's possible to customise the audit schema for any project by adding a macro named: `get_audit_schema` into your DBT project.

For example to always log into a specific schema, say `analytics_meta`, regardless of DBT schema, you can include the following in your project:

```sql
-- your_dbt_project/macros/get_audit_schema.sql
{% macro get_audit_schema() %}

   {{ return('analytics_meta') }}

{% endmacro %}
```

### Adapter support

This package is currently compatible with dbt's BigQuery<sup>1</sup>, Snowflake, Redshift, and
Postgres integrations.

<sup>1</sup> BigQuery support may only work when 1 thread is set in your `profiles.yml` file. Anything larger may result in "quota exceeded" errors.  

### Migration guide

#### v0.1.17 -> v0.2.0

New columns were added in v0.2.0:

-   **event_user as user** - `varchar(512)`the user who ran the model
-   **event_target as target** - `varchar(512)` the target used when running DBT
-   **event_is_full_refresh as is_full_refresh** - `boolean` whether the DBT run was a full refresh

These will be added to your existing audit table automatically in the `on-run-start` DBT hook, and added to the staging tables deployed by this table when they are ran. The existing `event_schema` column will also be propagated into to `stg_dbt_model_deployments` as `schema`.

### Contributing
Additional contributions to this repo are very welcome! Check out [this](https://discourse.getdbt.com/t/contributing-to-an-external-dbt-package/657) post on the best workflow for contributing to a package. All PRs should only include functionality that is contained within all Segment deployments; no implementation-specific details should be included.
