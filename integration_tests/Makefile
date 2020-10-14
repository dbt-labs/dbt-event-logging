
test-postgres:
	dbt run-operation drop_audit_schema --target postgres
	dbt run --target postgres --full-refresh
	dbt run --target postgres

	dbt run-operation drop_audit_schema --target postgres
	dbt run-operation create_legacy_audit_table --target postgres
	dbt run --target postgres --full-refresh
	dbt run --target postgres

test-redshift:
	dbt run-operation drop_audit_schema --target redshift
	dbt run --target redshift --full-refresh
	dbt run --target redshift

	dbt run-operation drop_audit_schema --target redshift
	dbt run-operation create_legacy_audit_table --target redshift
	dbt run --target redshift --full-refresh
	dbt run --target redshift


test-snowflake:
	dbt run-operation drop_audit_schema --target snowflake
	dbt run --target snowflake --full-refresh
	dbt run --target snowflake


	dbt run-operation drop_audit_schema --target snowflake
	dbt run-operation create_legacy_audit_table --target snowflake
	dbt run --target snowflake --full-refresh
	dbt run --target snowflake


test-bigquery:
	dbt run-operation drop_audit_schema --target bigquery
	dbt run --target bigquery --full-refresh
	dbt run --target bigquery


	dbt run-operation drop_audit_schema --target bigquery
	dbt run-operation create_legacy_audit_table --target bigquery
	dbt run --target bigquery --full-refresh
	dbt run --target bigquery

test-all: test-postgres test-redshift test-snowflake test-bigquery
	echo "Completed successfully"

test-cloud: test-redshift test-snowflake
	echo "Completed successfully"
