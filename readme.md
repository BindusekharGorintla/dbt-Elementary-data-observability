<p align="center">
<img alt="Logo" src="https://res.cloudinary.com/do5hrgokq/image/upload/v1764493013/github_banner_zp5l2o.png" width="1000">
</p>
<p align="center">
<a href="https://join.slack.com/t/elementary-community/shared_invite/zt-uehfrq2f-zXeVTtXrjYRbdE_V6xq4Rg"><img src="https://img.shields.io/badge/join-Slack-ff69b4"/></a>
<a href="https://docs.elementary-data.com/oss/quickstart/quickstart-cli-package"><img src="https://img.shields.io/badge/docs-quickstart-orange"/></a>
<img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-ff69b4"/>
<img alt="Downloads" src="https://static.pepy.tech/personalized-badge/elementary-data?period=month&units=international_system&left_color=grey&right_color=orange"&left_text=Downloads/>
</p>

<h2 align="center">
Elementary OSS: dbt-native data observability
</h2>

<div align="center">

[Docs »](https://docs.elementary-data.com/) | [Join the Elementary Community »](https://www.elementary-data.com/community)

</div>
</br>

Elementary OSS is the open-source CLI for dbt-native data observability. It works with the [Elementary dbt package](https://github.com/elementary-data/dbt-data-reliability) to generate the basic Elementary observability report and send alerts to Slack and Microsoft Teams.

For teams that need data reliability at scale, we offer **[Elementary Cloud](https://www.elementary-data.com/)**, a full Data & AI Control Plane with automated ML monitoring, column-level lineage from source to BI, a built-in catalog, and AI agents that scale reliability workflows for both engineers and business users.

- **Elementary OSS**  
  **A self-maintained, open-source CLI** that integrates seamlessly with your dbt project and the Elementary dbt package. It **enables alerting and provides the self-hosted Elementary data observability report**, offering a comprehensive view of your dbt runs, all dbt test results, data lineage, and test coverage. Quickstart [here](https://docs.elementary-data.com/oss/quickstart/quickstart-cli), and our team and community can provide great support on [Slack](https://www.elementary-data.com/community) if needed.
- **Elementary Cloud**  
  A managed, AI-driven control plane for observability, quality, governance, and discovery. It includes automated ML monitoring, column-level lineage from source to BI, a built-in catalog, and AI agents that scale reliability workflows. Cloud supports both engineers and business users, enabling technical depth and simple self-service in one place. To learn more, [book a demo](https://cal.com/maayansa/elementary-intro-github-package) or [start a trial](https://www.elementary-data.com/signup).

<kbd align="center">
<a href="https://storage.googleapis.com/elementary_static/elementary_demo.html"><img align="center" style="max-width:300px;" src="https://raw.githubusercontent.com/elementary-data/elementary/master/static/report_ui.gif"> </a>
</kbd>


Example of an Elementary test config in `source.yml`:

```

 - name: oncology_databricks
    catalog: "{{ var('oncology_src_catalog')}}"
    schema: "{{ var('oncology_src_schema')}}"
    tables:
      - name: onc_patients
        config: 
          tags: ["oncology"]
        columns:
        - name: pat_id
          description: "pat_id"
          tests:
            - duplicates_check

```


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

## Features

- **Anomaly detection tests** - Collect data quality metrics and detect anomalies, as native dbt tests.
- **Automated monitors** - Out-of-the-box cloud monitors to detect freshness, volume and schema issues.
- **End-to-End Data Lineage** - Enriched with the latest test results, for impact and root cause analysis of data issues. Elementary Cloud offers **Column-Level-Lineage from ingestion to BI**.
- **Data quality dashboard** - Single interface for all your data monitoring and test results.
- **Models performance** - Monitor models and jobs run results and performance over time.
- **Configuration-as-code** - Elementary configuration is managed in your dbt code.
- **Alerts** - Actionable alerts including custom channels and tagging of owners.
- **Data catalog** - Explore your datasets information - descriptions, columns, datasets health, etc.
- **dbt artifacts uploader** - Save metadata and run results as part of your dbt runs.
- **AI-Powered Data Tests & Unstructured Data Validations** - Validate and monitor data using AI powered tests to validate both structured and unstructured data

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request
4. Follow code review process
