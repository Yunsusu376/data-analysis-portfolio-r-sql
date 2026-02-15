# r-basic-data-analysis

A small R portfolio of basic statistical analyses (exploratory analysis, correlation/regression, ANOVA, and chi-square independence tests).  
Scripts are written to be readable and reproducible, using clear sectioning and comments.

## Contents

This repository contains the following R scripts:

- `01_birthweight_exploratory_analysis.R`  
  Exploratory analysis (group summaries, distributions, normality checks, z-scores, and simple probability calculations).

- `02_birthweight_correlation_regression.R`  
  Relationship analysis (scatterplots, correlation tests, group comparisons, and simple linear regression).

- `03_pickuplines_anova_analysis.R`  
  One-way comparisons and factorial ANOVA workflow (assumption checks + interpretation + effect size where applicable).

- `04_chisq_independence_analysis.R`  
  Chi-square test of independence for two categorical variables (data cleaning, contingency table, assumption checks, and visualizations).  
  Note: the underlying dataset used for this script is not included due to data-sharing restrictions.

## How to run

1. Open the project in RStudio (recommended), or set your working directory to the repo root.
2. Make sure the required dataset(s) exist locally on your computer.
3. Run the script you want from top to bottom.

All scripts are designed to use reproducible, project-based workflow.  
If your dataset path differs, adjust the `read_csv()` / `read_dta()` line in the script.

## Data policy (important)

Some datasets used in these homework tasks are not allowed to be shared publicly.  
Therefore:
- This repository does not include restricted datasets.
- Scripts are provided as analysis templates and code examples.
- Any dataset files should be kept locally and not committed to a public repository unless permission is granted.

## Packages

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
