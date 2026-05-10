# **Data Analytics Project**
# Introduction
LGS is an established UK-based online gift retailer that has struggled to grow despite having years of customer transaction data available. The core problem is not a lack of data, but it's a lack of insight. All things considered, without a dedicated analytics capability, the marketing team has been unable to identify trends, understand their customer base, or make data-driven decisions about campaigns and promotions. This project aims to bridge that gap by building a lightweight analytics solution that turns raw transaction records into meaningful business intelligence.

As a Data Analyst, the goal was to analyze LGS transactional data from December 2009 to December 2011 and provide actionable insights to support targeted marketing campaigns such as email promotions, events, and personalized offers. With that being said, I was responsible for the full analytics delivery.

### Features and Tools
The project was implemented using the following technologies and tools:

* **Python**: primary programming language for all data processing and analytics
* **Jupyter Notebook**: interactive development environment used to write, run, and present analytics
* **Pandas**: core library for data loading, cleaning, transformation, and aggregation
* **NumPy**: used for numerical operations and array-based calculations
* **Matplotlib & Seaborn**: used for data visualization including histograms, line charts, bar charts, and box plots
* **SQLAlchemy & psycopg2**: used to connect to and query the PostgreSQL data warehouse from Python
* **PostgreSQL**: data warehouse provisioned via Docker to store and query the retail transaction data
* **Docker**: used to provision and manage both the PostgreSQL and Jupyter Notebook containers in isolated environments

# Implementation
## Project Architecture
Rather than building a complex enterprise system, the architecture for this PoC was deliberately designed to be lightweight and reproducible. Since the transactional data already exist within LGS's SQL Server, the focus was on creating an isolated analytics environment where sanitized data could be safely analyzed independently of production systems.

![Data Analysis Architecture](https://github.com/jarviscanada/jarvis_data_eng_ShelbyHall/blob/feature/python_data_wrangling/python_data_analytics/assets/DataAnalysis.png?raw=true)

#### **Architecture Overview**
* A lightweight ETL process exports sanitized invoice data for analytics.
* The sanitized data is loaded into a local PostgreSQL data warehouse ```jrvs-psql``` running in Docker.
* PostgreSQL serves as the OLAP layer for downstream analytics.


#### **Analytics Environment**

A second Docker container ```jrvs-jupyter``` hosts the analytics stack:

* Python 3.8
* Jupyter Notebook
* Pandas
* NumPy
* Matplotlib
* Seaborn
* SQLAlchemy

Both containers communicate through the shared Docker bridge network ```jarvis-net```, allowing Jupyter notebooks to query PostgreSQL directly using the container hostname.

## Data Analytics and Wrangling

My goal is to design a new marketing strategy with the data I was provided in order to create a business solution.

| **Data** | **Trend** | **Solution** |
| --- | --- | --- |
|**Invoice distribution data** | The majority of typical transactions fall between £0 and £724, with a mean of £359, meaning most customers are mid-range spenders | promotional bundles or upsell offers targeting the £300–£700 range would have the highest chance of moving customers toward larger basket sizes |
| **Monthly orders analysis** | cancellations remain consistently low relative to placed orders | high-volume promotional campaigns during peak months without worrying about a spike in returns eating into revenue |
| **Monthly sales data** | two consistent revenue peaks in November of both 2010 and 2011, reaching over £1.4 million | confirms a strong seasonal pattern that LGS team should exploit by launching pre-holiday campaigns in September to October to capture early buyers before the November rush|
| **Sales growth analysis** | the steepest drops happen in January and December | counter these predictable downwards trends with post-holiday clearance promotions and New Year loyalty incentives to retain customers |
| **Active users** | revenue problem is tied to customer acquisition and retention rather than spend per customer | Investing in campaigns that bring in new buyers or re-engage dormant ones would have a direct impact on revenue |
| **New vs existing user** | New customer acquisition slowed significantly by late 2011, with existing users driving nearly all activity | dedicated acquisition strategy such as referral programs, social media campaigns, or wholesale outreach to grow the customer base rather than relying solely on repeat buyers |


**Key Segment insights:** 
* **Loyal Customers** (712 customers) - highest frequency (avg 22 invoices) and monetary value (avg £9,610). Through analyzing these records, we know these are the most valuable customers and should be prioritized for retention through exclusive rewards and early access to new products.
* **Potential Loyalists** (893 customers) - averaging about 4 purchases and £1,314 in spend, these customers are high-priority for the next quarter. Converting even half of them into Loyal Customers (who average £9,610) through a targeted loyalty programs/memberships would generate significant incremental revenue.
* **Hibernating Customers** (1,133 customers) - have the highest recency and the lowest frequency and spend, averaging 2 purchases and £408 in spend. A solution tailored to addressing these records would be to add "win-back" emails, seasonal promotions and discounts, which could re-engage this large segment.

# Improvements 
Several improvements can be made to the PoC in future iterations to optimize its functions:
* **Automated data pipeline** - currently data is loaded manually via a SQL dump file. An automated ETL pipeline using tools like Apache Airlfow could schedule regular data pulls from the LGS SQL Server directly into the data warehouse.
* **Real-time dashboard** - the current Jupyter Notebook delivery is static, therefore I believe building an interactive dashboard using tools like Tableau, or Power BI would allow the LGS marketing team to explore the data themselves without needing technical assistance.
* **Expanded RFM segmentation** - the current RFM model uses fixed date-based recency. A rolling window approach that recalculates RFM monthly would give the marketing team more up-to-date segment assignments for campaign targeting.
