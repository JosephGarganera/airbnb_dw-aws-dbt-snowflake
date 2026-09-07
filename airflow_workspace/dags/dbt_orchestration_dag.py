from datetime import datetime, timedelta
from pathlib import Path
from airflow import DAG

# Added RenderConfig and InvocationMode to the imports
from cosmos import (
    DbtTaskGroup,
    ProjectConfig,
    ProfileConfig,
    ExecutionConfig,
    RenderConfig,
    InvocationMode,
)
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

DBT_PROJECT_PATH = Path("/opt/airflow/dbt_snowflake_project")

profile_config = ProfileConfig(
    profile_name="airbnb_snowflake_profile",
    target_name="prod",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_default",
        profile_args={"database": "AIRBNB", "schema": "GOLD"},
    ),
)

default_args = {
    "owner": "JAGSNOW01",
    "retries": 1,
    "retry_delay": timedelta(minutes=2),
    "execution_timeout": timedelta(minutes=45),
}

with DAG(
    dag_id="airbnb_data_platform_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    tags=["dbt", "snowflake", "airbnb"],
) as dag:

    dbt_execution_group = DbtTaskGroup(
        group_id="airbnb_dbt_pipeline",
        project_config=ProjectConfig(dbt_project_path=DBT_PROJECT_PATH),
        profile_config=profile_config,
        render_config=RenderConfig(invocation_mode=InvocationMode.SUBPROCESS),
        execution_config=ExecutionConfig(
            dbt_executable_path="/home/airflow/.local/bin/dbt"
        ),
    )

    dbt_execution_group
