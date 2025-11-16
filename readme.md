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

 - name: hi_edw_x_databricks
    catalog: "{{ var('hi_edw_x_src_catalog')}}"
    schema: "{{ var('hi_edw_x_src_schema')}}"
    tables:
      - name: g1g2_rpt_patients
        config: 
          tags: ["hi_edw_x"]
        columns:
        - name: patient_id
          description: "patient_id"
          meta:
            test_group: "RWDA-TC-9,10,11,12,52"
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

## Community & Support

- [Slack](https://join.slack.com/t/elementary-community/shared_invite/zt-uehfrq2f-zXeVTtXrjYRbdE_V6xq4Rg) (Talk to us, support, etc.)
- [GitHub issues](https://github.com/elementary-data/elementary/issues) (Bug reports, feature requests)

## Contributions

Thank you :orange_heart: Whether it's a bug fix, new feature, or additional documentation - we greatly appreciate contributions!

Check out the [contributions guide](https://docs.elementary-data.com/oss/general/contributions) and [open issues](https://github.com/elementary-data/elementary/issues) in the main repo.
