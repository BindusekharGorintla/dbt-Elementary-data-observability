<p align="center">
<img alt="Logo" src="https://raw.githubusercontent.com/elementary-data/elementary/master/static/github_banner.png"/ width="1000">
</p>

# [dbt-native data observability](https://www.elementary-data.com/)

<p align="center">
<a href="https://join.slack.com/t/elementary-community/shared_invite/zt-uehfrq2f-zXeVTtXrjYRbdE_V6xq4Rg"><img src="https://img.shields.io/badge/join-Slack-ff69b4"/></a>
<a href="https://docs.elementary-data.com/quickstart"><img src="https://img.shields.io/badge/docs-quickstart-orange"/></a>
<img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-ff69b4"/>
<img alt="Downloads" src="https://static.pepy.tech/personalized-badge/elementary-lineage?period=total&units=international_system&left_color=grey&right_color=orange"&left_text=Downloads/>
</p>

## What is Elementary?

This dbt-native package powers **Elementary**, helping data and analytics engineers **detect data anomalies** and build **rich metadata tables** from their dbt runs and tests. Gain immediate visibility into data quality trend and uncover potential issues, all within dbt.



The **Elementary dbt package** is designed to enhance data observability within your dbt workflows. It includes two core components:



Example of an Elementary test config in `schema.yml`:

```

models:
  - name: all_events
    config:
      elementary:
        timestamp_column: 'loaded_at'
    columns:
      - name: event_count
        tests:
          - elementary.column_anomalies:
              column_anomalies:
                - average
              where_expression: "event_type in ('event_1', 'event_2') and country_name != 'unwanted country'"
              anomaly_sensitivity: 2
              time_bucket:
                period: day
                count:1

```

Elementary tests include:

### **Anomaly Detection Tests**

- **Volume anomalies -** Monitors the row count of your table over time per time bucket.
- **Freshness anomalies -** Monitors the freshness of your table over time, as the expected time between data updates.
- **Event freshness anomalies -** Monitors the freshness of event data over time, as the expected time it takes each event to load - that is, the time between when the event actually occurs (the **`event timestamp`**), and when it is loaded to the database (the **`update timestamp`**).
- **Dimension anomalies -** Monitors the count of rows grouped by given **`dimensions`** (columns/expressions).
- **Column anomalies -** Executes column level monitors on a certain column, with a chosen metric.
- **All columns anomalies** - Executes column level monitors and anomaly detection on all the columns of the table.

### **Schema Tests**

- **Schema changes -** Alerts on a deleted table, deleted or added columns, or change of data type of a column.
- **Schema changes from baseline** - Checks for schema changes against baseline columns defined in a source’s or model’s configuration.
- **JSON schema** - Allows validating that a string column matches a given JSON schema.
- **Exposure validation test -** Detects changes in your models’ columns that break downstream exposure.

Read more about the available [Elementary tests and configuration](https://docs.elementary-data.com/data-tests/introduction).

## Elementary Tables - Run Results and dbt Artifacts

The **Elementary dbt package** automatically stores **dbt artifacts and run results** in your data warehouse, creating structured tables that provide visibility into your dbt runs and metadata.


## Quickstart - dbt Package

1. Add to your `packages.yml`:

```
packages:
  - package: elementary-data/elementary
    version: 0.20.1
    ## Docs: <https://docs.elementary-data.com>

```

2. Run `dbt deps`
3. Add to your `dbt_project.yml`:

```
models:
  ## elementary models will be created in the schema '<your_schema>_elementary'
  ## for details, see docs: <https://docs.elementary-data.com/>
  elementary:
    +schema: "elementary"

```

4. Run `dbt run --select elementary`

Check out the [full documentation](https://docs.elementary-data.com/).

## Community & Support

- [Slack](https://join.slack.com/t/elementary-community/shared_invite/zt-uehfrq2f-zXeVTtXrjYRbdE_V6xq4Rg) (Talk to us, support, etc.)
- [GitHub issues](https://github.com/elementary-data/elementary/issues) (Bug reports, feature requests)

## Contributions

Thank you :orange_heart: Whether it's a bug fix, new feature, or additional documentation - we greatly appreciate contributions!

Check out the [contributions guide](https://docs.elementary-data.com/oss/general/contributions) and [open issues](https://github.com/elementary-data/elementary/issues) in the main repo.
