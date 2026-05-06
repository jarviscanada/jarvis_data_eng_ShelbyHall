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
Rather than building a complex enterprise system, the architecture for this PoC was deliberately kept simple and reproducible. The transactional data already existed in LGS's SQL Server, so the focus was on creating an accessible copy of that data that Jarvis could work with safely and independently. This file was loaded into a local PostgreSQL data warehouse provisioned via Docker, serving as the OLAP layer for analysis.

* The tech stack used for this PoC includes Python 3.8, Jupyter Notebook, Pandas, NumPy, Matplotlib, Seaborn, SQLAlchemy, and PostgreSQL, all running inside Docker containers connected via a shared bridge network ```(jarvis-net)```. 
* The two Docker containers used are ```jrvs-psql``` for the PostgreSQL data warehouse and ```jrvs-jupyter``` for the Jupyter Notebook analytics environment.
* Both containers are connected via the ```jarvis-net``` bridge network, allowing the Jupyter notebook to query the PostgreSQL database using the container name as the hostname. This keeps the setup portable and easy to reproduce on any developer's local environment.

## Data Analytics and Wrangling

**Key Segment insights:** 
| Segment | Avg Recency | Avg Frequency | Avg Monetary|
| --- | --- | --- | --- |
| Loyal Customers | 5,284 days | 22.82 | £9,610.46 |
| At Risk | 5,539 days | 7.86 | £2241.89 |
| Need Attention | 5314 days | 5.43 | £1671.96 |
| Potential Loyalists | 5271 days | 4.40 | £1314.66 |
| About to Sleep | 5314 days | 1.88 | £639.32 |
| Hibernating | 5675 days | 1.62 | £408.11 |
| Promising | 5273 days | 1.01 | £344.55 |

* **Loyal Customers** (712 customers) - highest frequency (avg 22 invoices) and monetary value (avg £9,610). Using these statistics, these are the most valuable customers and should be prioritized for retention through exclusive rewards and early access to new products.
* **Potential Loyalists** (893 customers) - averaging about 4 purchases and £1,314 in spend. These customers are high-priority for the next quarter, therefore loyalty bonuses, memberships, and/or exclusive perks could secure them as loyal or champion customers.
* **Hibernating Customers** (1,133 customers) - have the highest recency and the lowest frequency and spend, averaging 2 purchases and £408 in spend. A solution tailored to addressing these statistics would be to add "win-back" emails, seasonal promotions and discounts, which could re-engage this large segment.

# Improvements 
Several improvements can be made to the PoC in future iterations to optimize its functions:
* **Automated data pipeline** - currently data is loaded manually via a SQL dump file. An automated ETL pipeline using tools like Apache Airlfow could schedule regular data pulls from the LGS SQL Server directly into the data warehouse.
* **Real-time dashboard** - the current Jupyter Notebook delivery is static, therefore I believe building an interactive dashboard using tools like Tableau, or Power BI would allow the LGS marketing team to explore the data themselves without needing technical assistance.
* **Expanded RFM segmentation** - the current RFM model uses fixed date-based recency. A rolling window approach that recalculates RFM monthly would give the marketing team more up-to-date segment assignments for campaign targeting.
