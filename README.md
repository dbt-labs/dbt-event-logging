# ***Archival Notice***
This repository has been archived.

As a result all of its historical issues and PRs have been closed.

Please *do not clone* this repo without understanding the risk in doing so:
- It may have unaddressed security vulnerabilities
- It may have unaddressed bugs

<details>
   <summary>Click for historical readme</summary>

## dbt Event Logging

&gt; ⛔🏚️ This package is obsolete and no longer developed; use [dbt_artifacts](https://hub.getdbt.com/brooklyn-data/dbt_artifacts/latest/) for a higher performance and richer view into your project.

&gt; :warning: **ADDING THIS PACKAGE TO YOUR DBT PROJECT CAN SIGNIFICANTLY SLOW
&gt; DOWN YOUR DBT RUNS**. This is due to the number of insert statements executed by
&gt; this package, especially as a post-hook. Please consider if this package is
&gt; appropriate for your use case before using it.

Requires dbt &gt;= 0.18.0

This package provides out-of-the-box functionality to log events for all dbt
invocations, including run start, run end, model start, and model end. It
outputs all data and models to schema `[target.schema]_meta`. There are three
convenience models to make it easier to parse the event log data.

### Setup

1. Include this package in your `packages.yml` -- check [here](https://hub.getdbt.com/dbt-labs/logging/latest/)
   for installation instructions.
2. Include the following in your `dbt_project.yml` directly within your
   `models:` block (making sure to handle indenting appropriately):

```YAML
# dbt_project.yml
...

models:
  ...
  pre-hook: &quot;{{ logging.log_model_start_event() }}&quot;
  post-hook: &quot;{{ logging.log_model_end_event() }}&quot;
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

#### Customising audit database

It's possible to customise the audit database for any project by adding a macro named: `get_audit_database` into your DBT project.

For example to always log into a specific database, say `META`, regardless of DBT database, you can include the following in your project:

```sql
-- your_dbt_project/macros/get_audit_database.sql
{% macro get_audit_database() %}

   {{ return('META') }}

{% endmacro %}
```

### Adapter support

This package is currently compatible with dbt's BigQuery&lt;sup&gt;1&lt;/sup&gt;, Snowflake, Redshift, and
Postgres integrations.

&lt;sup&gt;1&lt;/sup&gt; BigQuery support may only work when 1 thread is set in your `profiles.yml` file. Anything larger may result in &quot;quota exceeded&quot; errors.

### Migration guide

#### v0.1.17 -&gt; v0.2.0

New columns were added in v0.2.0:

- **event_user as user** - `varchar(512)`the user who ran the model
- **event_target as target** - `varchar(512)` the target used when running DBT
- **event_is_full_refresh as is_full_refresh** - `boolean` whether the DBT run was a full refresh

These will be added to your existing audit table automatically in the `on-run-start` DBT hook, and added to the staging tables deployed by this table when they are ran. The existing `event_schema` column will also be propagated into to `stg_dbt_model_deployments` as `schema`.

### Contributing

Additional contributions to this repo are very welcome! Check out [this](https://discourse.getdbt.com/t/contributing-to-an-external-dbt-package/657) post on the best workflow for contributing to a package. All PRs should only include functionality that is contained within all Segment deployments; no implementation-specific details should be included.

