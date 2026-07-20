# 📊 Chicago Crime & Weather Analysis

An end-to-end Data Analytics project that analyzes **1.45M+ Chicago crime records (2018–2023)** by integrating crime, weather, and community datasets. The project combines **PostgreSQL** for business-focused SQL analysis
and **Python** for exploratory data analysis (EDA) and visualization to uncover crime trends, seasonal patterns, 
weather relationships, and community-level insights.



## 📌 Project Overview

Understanding crime patterns helps law enforcement agencies and city planners allocate resources effectively and develop data-driven public safety strategies.

This project investigates:

- Crime trends across six years
- Most common crime categories
- Community-wise crime distribution
- Weather influence on crime
- Arrest patterns
- Seasonal and temporal crime behavior

The analysis is performed using **PostgreSQL** for querying and **Python (Pandas & Matplotlib)** for data cleaning, feature engineering, and visualization.

---

## 📂 Dataset

This project uses publicly available Chicago datasets compiled and shared by **Jaime M. Shaker**.

### Dataset Includes

- Chicago Crime Data (2018–2023)
- Chicago Weather Data
- Chicago Community Area Information

### Dataset Size

- **1,450,979+ Crime Records**
- **2,191 Weather Records**
- **77 Community Areas**

### Dataset Credit

The datasets used in this project were provided by:

**Jaime M. Shaker**

- 🌐 Website: https://www.shaker.dev
- 💼 LinkedIn: https://www.linkedin.com/in/jaime-shaker/

> **Acknowledgment:** The datasets and original database resources were provided by Jaime M. Shaker. All SQL queries,
>  business analysis, Python-based exploratory data analysis (EDA), visualizations, insights, documentation, and GitHub p
> roject structure presented in this repository were developed independently as part of this data analytics project.
# 🛠️ Tech Stack

### Languages

- PostgreSQL
- Python

### Libraries

- Pandas
- NumPy
- Matplotlib

### Tools

- PostgreSQL
- Jupyter Notebook
- Git
- GitHub

---

# 📋 Project Workflow

```text
Data Collection
        ↓
Data Cleaning
        ↓
Feature Engineering
        ↓
SQL Business Analysis
        ↓
Python EDA
        ↓
Visualization
        ↓
Business Insights
```

---

# 🧹 Data Preparation

### SQL

- Joined crime, weather, and community datasets
- Used CTEs
- Window Functions
- CASE statements
- Aggregate Functions
- Date Functions

### Python

- Combined yearly datasets
- Removed duplicate records
- Handled missing values
- Converted date columns
- Created Month, Day, Hour, and Day Name features

---

# 🗃 SQL Analysis

The SQL portion focuses on answering business questions using advanced SQL concepts.

## Topics Covered

- Crime frequency analysis
- Top crime categories
- Community-wise crime distribution
- Crime trends by year and month
- Seasonal crime analysis
- Weather impact analysis
- Arrest analysis
- Population and density analysis
- Time-series analysis
- Growth analysis using LAG()

## SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- INNER JOIN
- CASE
- CTEs
- Window Functions
- ROW_NUMBER()
- LAG()
- Aggregate Functions
- Date Functions

---

# 📈 Python Exploratory Data Analysis (EDA)

Python was used to clean the data, engineer new features, and visualize crime trends.

### Univariate Analysis

- Top 10 Crime Types
- Crimes by Year
- Crimes by Month
- Crimes by Day of Week
- Arrest Distribution

### Bivariate Analysis

- Crime Count vs Temperature
- Correlation Matrix
- Rain vs No Rain
- Population vs Crime Count
- Population Density vs Crime Count
- Top Communities by Crime Count
- Domestic Crimes vs Arrest

---

# 📊 Key Insights

### Crime Trends

- Theft was the most frequently reported crime.
- Battery ranked second among all crime categories.
- Crime declined during 2020–2021 before increasing again in 2022–2023.

### Seasonal Trends

- Crime activity increased during warmer months.
- July and August recorded the highest crime counts.

### Weather Analysis

- Crime count showed a **moderate positive correlation (~0.43)** with temperature.
- Rainfall showed almost no linear relationship with daily crime count.

### Community Analysis

- Austin reported the highest crime count.
- Communities with larger populations generally reported more crimes.
- Population density alone was not a strong predictor of crime.

### Arrest Analysis

- Approximately **84.2%** of reported crimes did not result in an arrest.
- Only **15.8%** resulted in an arrest.

---

# 📸 Visualizations

The project includes visualizations such as:

- Crime Type Distribution
- Yearly Crime Trend
- Monthly Crime Trend
- Day-wise Crime Analysis
- Arrest Distribution
- Crime vs Temperature
- Correlation Heatmap
- Rain vs No Rain
- Population vs Crime
- Population Density vs Crime
- Community Crime Analysis

# 🚀 Future Improvements

- Develop predictive machine learning models for crime forecasting.
- Build an interactive Power BI dashboard.
- Create a Streamlit web application.
- Perform geospatial hotspot analysis.

---

# 🎯 Skills Demonstrated

- SQL
- PostgreSQL
- Python
- Pandas
- NumPy
- Matplotlib
- Data Cleaning
- Feature Engineering
- Exploratory Data Analysis (EDA)
- Data Visualization
- Window Functions
- Common Table Expressions (CTEs)
- Time-Series Analysis
- Business Analytics
- Statistical Analysis




---

## ⭐ If you found this project interesting, feel free to star the repository!
