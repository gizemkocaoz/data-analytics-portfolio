# 📊 GA4 E-commerce Funnel Analysis

## 📖 Project Overview

This project analyzes the Google Analytics 4 (GA4) Sample E-commerce dataset using BigQuery.

The objective is to explore user behavior throughout the e-commerce funnel by extracting event-level data, identifying traffic sources, and measuring conversion performance from sessions to purchases.

---

## 🛠 Technologies

- BigQuery
- SQL (Google Standard SQL)
- Google Analytics 4 (GA4)

---

## 📁 Project Structure

```
ga4-ecommerce-funnel-analysis/
│
├── README.md
├── images/
│   ├── extract_events_result.png
│   └── funnel_analysis_result.png
└── sql/
    ├── 01_extract_events.sql
    └── 02_funnel_analysis.sql
```

---

## 📄 SQL Files

### 📌 01_extract_events.sql

Extracts event-level data from the GA4 Sample E-commerce dataset, including:

- Event timestamp
- User ID
- Event name
- Country
- Device category
- Session ID
- Traffic source
- Medium
- Campaign

### 📌 02_funnel_analysis.sql

Builds a conversion funnel by aggregating GA4 events and calculating:

- User Sessions
- Add to Cart
- Begin Checkout
- Purchases

Results are grouped by:

- Date
- Source
- Medium
- Campaign

---

## 📷 Query Results

### Event Extraction

![Event Extraction](images/extract_events_result.png)

This query extracts event-level data from the GA4 e-commerce dataset, including session information, traffic source, campaign, country, and device category.

---

### Funnel Analysis

![Funnel Analysis](images/funnel_analysis_result.png)

This query aggregates GA4 events to measure user sessions and conversion funnel performance across traffic sources and campaigns.

---

## 🎯 Key Skills Demonstrated

- Google BigQuery
- Google Analytics 4 (GA4)
- SQL
- Event-level data analysis
- Funnel analysis
- Traffic source analysis
- Session analysis
- Data aggregation
