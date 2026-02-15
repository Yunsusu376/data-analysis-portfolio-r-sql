# r-basic-data-analysis

A small portfolio of basic data analysis work, including **R statistical analysis** (EDA, correlation/regression, ANOVA, chi-square) and **SQL query practice**.  
Scripts are written to be readable and reproducible, using clear sectioning and comments.

## Contents

### R scripts

- `01_birthweight_exploratory_analysis.R`  
  Exploratory analysis: group summaries, distributions, Shapiro–Wilk normality checks, z-scores, and simple probabilities.

- `02_birthweight_correlation_regression.R`  
  Relationship analysis: scatterplots + fitted lines, correlation tests, group comparisons, and simple linear regression.

- `03_pickuplines_anova_analysis.R`  
  One-way comparisons and factorial ANOVA workflow (assumption checks + interpretation + effect size where applicable).

- `04_chisq_independence_analysis.R`  
  Chi-square test of independence for two categorical variables (data cleaning, contingency table, assumption checks, and visualizations).  
  Note: the underlying dataset used for this script is not included due to data-sharing restrictions.

### SQL

- `05_basic_sql_queries.sql`  
  Basic SQL homework queries (Q1–Q10). Queries only; dataset/database not included.

## How to run (R)

1. Open the project in RStudio (recommended), or set your working directory to the repo root.
2. Make sure the required dataset(s) exist locally on your computer.
3. Run the script you want from top to bottom.

If your dataset path differs, adjust the `read_csv()` / `read_dta()` line in the script.

## How to use (SQL)

1. Open `05_basic_sql_queries.sql`.
2. Copy the query for the question you want.
3. Run it in your SQL environment (e.g., PostgreSQL / MySQL) against the corresponding database schema.

## Data policy (important)

Some datasets used in these homework tasks are not allowed to be shared publicly. Therefore:

- This repository does not include restricted datasets.
- Scripts are provided as analysis templates and code examples.
- Any dataset files should be kept locally and not committed to a public repository unless permission is granted.

## Packages (R)

Common packages used across scripts:

- `readr`
- `haven`
- `dplyr`
- `ggplot2`
- `car`
- `effectsize`

Install if needed:

```r
install.packages(c("readr", "haven", "dplyr", "ggplot2", "car", "effectsize"))
