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

## Community & Support

- [Slack](https://join.slack.com/t/elementary-community/shared_invite/zt-uehfrq2f-zXeVTtXrjYRbdE_V6xq4Rg) (Talk to us, support, etc.)
- [GitHub issues](https://github.com/elementary-data/elementary/issues) (Bug reports, feature requests)

## 👨‍💻 Contributing

Feel free to fork the repository, submit pull requests, or raise issues for improvements!

---

## 📧 Contact

For questions or support, reach out to **Bindusekhar Gorintla** at (gorintla.bindusekhar@gmail.com).
