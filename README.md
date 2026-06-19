# 🧹 Layoffs Data Cleaning Project using MySQL

![MySQL](https://img.shields.io/badge/MySQL-Data%20Cleaning-blue?logo=mysql)
![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Project Overview

This project focuses on cleaning and preparing a real-world layoffs dataset using **MySQL**. The dataset contains information about company layoffs across various industries and countries. Before performing analysis, the data was cleaned to improve quality, consistency, and reliability.

The project demonstrates practical SQL skills used by Data Analysts in real business environments.

---

## 📂 Dataset

**Source:** Kaggle Layoffs Dataset

https://www.kaggle.com/datasets/swaptr/layoffs-2022

The dataset contains:

* Company Name
* Location
* Industry
* Total Employees Laid Off
* Percentage Laid Off
* Date
* Company Stage
* Country
* Funds Raised

---

## 🎯 Objectives

* Identify and remove duplicate records
* Standardize inconsistent values
* Handle missing and null values
* Convert date formats
* Improve data quality for analysis
* Prepare an analysis-ready dataset

---

## 🛠️ Technologies Used

* MySQL
* MySQL Workbench
* SQL Window Functions
* Common Table Expressions (CTEs)
* Joins
* Data Transformation Techniques

---

## 🔍 Data Cleaning Process

### 1️⃣ Creating a Staging Table

A duplicate working table was created to preserve the original dataset.

```sql
CREATE TABLE layoffs_staging
LIKE layoffs;
```

### 2️⃣ Removing Duplicate Records

Used the `ROW_NUMBER()` window function to identify duplicate rows.

```sql
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
date, stage, country, funds_raised_millions
)
```

### 3️⃣ Standardizing Data

* Trimmed unnecessary spaces
* Standardized industry names
* Corrected country names

Example:

```sql
UPDATE layoffs_staging2
SET company = TRIM(company);
```

### 4️⃣ Handling Missing Values

* Replaced blank values with NULL
* Populated missing industries using self-joins

### 5️⃣ Date Conversion

Converted text dates into MySQL DATE format.

```sql
STR_TO_DATE(date, '%m/%d/%Y')
```

### 6️⃣ Removing Unnecessary Records

Deleted rows where critical layoff information was missing.

---

## 📊 SQL Concepts Demonstrated

✔ Window Functions

✔ ROW_NUMBER()

✔ CTEs (Common Table Expressions)

✔ Self Joins

✔ Data Validation

✔ Data Transformation

✔ UPDATE Statements

✔ DELETE Statements

✔ ALTER TABLE

✔ Data Cleaning Best Practices

---

## 📈 Project Workflow

Raw Dataset
↓
Create Staging Table
↓
Identify Duplicates
↓
Remove Duplicates
↓
Standardize Values
↓
Handle Missing Data
↓
Convert Date Formats
↓
Remove Invalid Records
↓
Final Clean Dataset

---

## 🚀 Key Skills Demonstrated

* Data Cleaning
* SQL Query Writing
* Data Transformation
* Data Validation
* Analytical Thinking
* Database Management
* Data Preparation for Analytics

---

## 📁 Repository Structure

```text
mysql-layoffs-data-cleaning
│
├── dataset
│   └── layoffs.csv
│
├── sql
│   └── data_cleaning.sql
│
│
└── README.md
```

---

## 💡 Business Impact

Data cleaning is a critical step in the analytics lifecycle. This project transformed a raw dataset into a reliable and analysis-ready dataset, improving accuracy and consistency for future reporting and decision-making.

---

## 👨‍💻 Author

**Sayyad Abuzarali**

M.Sc. Computer Science | Aspiring Data Analyst

GitHub: https://github.com/SDAbuzar
