# Data Pipeline — Claude Code Instructions

## Project type
Batch or streaming data processing pipeline (ETL, analytics, ML feature engineering).

## Stack defaults
- **Batch**: Python + pandas/polars, Apache Spark, dbt
- **Streaming**: Apache Kafka, Flink, or Python + asyncio consumers
- **Orchestration**: Airflow, Prefect, or cron + custom scheduler
- **Storage**: PostgreSQL, ClickHouse, S3/GCS, Delta Lake
- **Monitoring**: Prometheus + Grafana, or Datadog

## Agents to invoke
- `backend-dev` — pipeline logic, transformations, connectors
- `test-engineer` — data quality tests, schema validation, idempotency tests
- `devops-engineer` — containerization, orchestration config, monitoring alerts
- `security-reviewer` — PII handling, credential management, data access controls

## Critical patterns
- **Idempotency**: every pipeline run must produce the same output for the same input
- **Backfill**: design for historical reprocessing from day one
- **Schema evolution**: use schema registry or explicit migration strategy
- **Dead letter queue**: failed records must go somewhere, never silently dropped
- **Checkpointing**: resume from last known good state after failure
- **PII**: identify and handle personal data — anonymize, encrypt, or exclude at source
- **Monitoring**: alert on lag, error rate, and data volume anomalies

## Memory files to maintain
- `memory/stack.md` — ingestion, processing, storage, orchestration stack
- `memory/architecture.md` — pipeline DAG, data flow diagram
- `memory/domain/` — data schema, field definitions, PII classification
- `memory/decisions/` — idempotency strategy, schema evolution approach

## End-of-session rule
Before closing: update `memory/progress.md` with pipeline stages implemented.
