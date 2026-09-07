FROM apache/airflow:3.3.1

# Upgrade Cosmos to an Airflow 3 compatible version to resolve the circular import crash
RUN pip install --no-cache-dir \
    astronomer-cosmos==1.14.1 \
    dbt-snowflake==1.8.3
