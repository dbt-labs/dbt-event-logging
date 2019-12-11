
test-postgres:
	dbt run --target postgres --full-refresh

test-redshift:
	dbt run --target redshift --full-refresh

test-snowflake:
	dbt run --target snowflake --full-refresh

test-all: test-postgres test-redshift test-snowflake
	echo "Completed successfully"
