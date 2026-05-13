# Olist Logistics ETL (Practice Project)

> **Note:** This is a personal practice project created to learn and demonstrate ETL (Extract, Transform, Load) workflows. It is not intended for commercial use or as a production-ready application.

## Project Overview
This repository contains a simple ETL pipeline built with Python and Pandas. The goal was to practice data cleaning, date manipulation, and merging multiple datasets using the Olist (Brazilian E-commerce) public data.

## ETL Process
1.  **Extract**: Loaded raw datasets from CSV files (`orders` and `customers`).
2.  **Transform**: 
    *   Converted date strings into Python `datetime` objects.
    *   Calculated delivery timeframes and identified logistical outliers.
    *   Merged datasets to analyze performance by Brazilian state.
3.  **Load**: Exported the processed data into `cleaned_olist_delivery_data.csv`.

## Learning Objectives
*   Mastering Pandas `groupby` and `merge` functions.
*   Handling date/time formats in data engineering.
*   Documenting a data pipeline for a GitHub portfolio.
