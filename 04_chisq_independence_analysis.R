# ------------------------------------------------------------
# Title: YLT (NI) - Gender × Importance of religious identity
# Research question:
#   Does gender play a role in the importance of religious identity
#   among 16-year-olds in Northern Ireland?
#
# Analysis plan (why this analysis):
#   - Both variables are categorical (Gender; Importance categories).
#   - We test whether the distribution of “importance” differs by gender.
#   - Therefore, we use a Chi-square test of independence on a contingency table.
#
# Output:
#   - Frequency table + within-gender percentages
#   - Chi-square test result (X-squared, df, p-value)
#   - Assumption checks (independence; expected cell counts)
#   - Visualizations (counts; proportions; mosaic plot)
# ------------------------------------------------------------

# 0. Setup ---------------------------------------------------------------

# Install once if needed:
# install.packages(c("haven", "dplyr", "ggplot2"))

library(haven)   # read_dta()
library(dplyr)   # data wrangling
library(ggplot2) # plotting

# NOTE:
# - For GitHub/portfolio: avoid file.choose() (not reproducible).
# - Put the dataset in data_raw/ and use a relative path.
# - Replace the filename below with your actual .dta filename.
ylt <- read_dta("data_raw/YLT.dta")


# 1. Keep variables + clean special missing codes ------------------------
# Why we do this:
# - Statistical tests should not treat special missing codes (e.g., 99/999) as real categories.
# - We convert those special codes to NA so they are excluded properly.

# Variables used:
# - respondentID: unique identifier (supports the independence assumption)
# - rsex: gender/sex (here code 99 = missing)
# - relidimp: importance of religious identity (here 9/99/999 = missing)

ylt_genderandreligion <- ylt %>%
  select(respondentID, rsex, relidimp) %>%
  mutate(
    rsex = na_if(rsex, 99),
    relidimp = ifelse(relidimp %in% c(9, 99, 999), NA, relidimp)
  )

# Quick frequency checks after cleaning:
# - This confirms the variables look reasonable (and shows how many NAs exist).
table(ylt_genderandreligion$rsex, useNA = "ifany")
table(ylt_genderandreligion$relidimp, useNA = "ifany")


# 2. Data integrity check (independence support) -------------------------
# Why this matters:
# - Chi-square assumes observations are independent.
# - If the same respondent appears multiple times, independence is violated.
# - A practical check: respondentID should be unique (1 row = 1 person).

nrow(ylt_genderandreligion) == n_distinct(ylt_genderandreligion$respondentID)


# 3. Recode to readable factors ------------------------------------------
# Why we do this:
# - The test works on counts, but readable labels make interpretation and plots easier.
# - Also ensures both variables are treated as categorical in output/plots.
#
# Important:
# - The mapping of numeric codes to labels MUST match the dataset codebook.
# - If the codebook uses different meanings, update the labels below.

ylt_gender <- ylt_genderandreligion %>%
  mutate(
    rsex = factor(rsex, levels = c(1, 2), labels = c("Male", "Female")),
    relidimp = factor(
      relidimp,
      levels = c(1, 2, 3, 4, 5, 6),
      labels = c(
        "Very important",
        "Important",
        "Neither important nor unimportant",
        "Not very important",
        "Not at all important",
        "I don't have a religious identity"
      )
    )
  )

# Readable frequency checks:
table(ylt_gender$rsex, useNA = "ifany")
table(ylt_gender$relidimp, useNA = "ifany")


# 4. Cross-tabulation + within-gender percentages ------------------------
# Why we do this:
# - The contingency table (counts) is the direct input to the chi-square test.
# - Row percentages help interpretation:
#   “Within each gender, how are responses distributed across importance categories?”

tab_n <- table(ylt_gender$rsex, ylt_gender$relidimp)
tab_n

tab_per <- prop.table(tab_n, 1) * 100
tab_per


# 5. Chi-square test of independence -------------------------------------
# Hypotheses:
# - H0 (null): Gender and religious identity importance are independent
#              (the distribution of relidimp is the same for Male/Female).
# - H1 (alternative): Gender and religious identity importance are associated
#                     (the distribution differs by gender).
#
# What the test reports:
# - X-squared: how far observed counts deviate from expected counts under H0
# - df: degrees of freedom = (rows-1)*(cols-1)
# - p-value: probability of seeing a deviation this large (or larger) if H0 were true

chi_ylt <- chisq.test(tab_n)
chi_ylt

# Interpretation guide:
# - If p-value < 0.05: evidence of association (gender relates to importance in this sample).
# - If p-value >= 0.05: insufficient evidence of association (no clear relationship detected).


# 6. Assumption checks ----------------------------------------------------
# 6.1 Independence (repeat check on final dataset object)
nrow(ylt_gender) == n_distinct(ylt_gender$respondentID)

# 6.2 Variable type checks (should be factors)
class(ylt_gender$rsex)
class(ylt_gender$relidimp)
levels(ylt_gender$rsex)
levels(ylt_gender$relidimp)

# 6.3 Expected cell counts (chi-square approximation validity)
# Rule of thumb (commonly taught):
# - All expected counts should be >= 1
# - At least 80% of expected counts should be >= 5
#
# If violated:
# - Consider combining rare categories, or
# - Use Fisher’s exact test (only feasible for small tables), or
# - Use Monte Carlo simulation with chisq.test(..., simulate.p.value = TRUE)

min(chi_ylt$expected)          # smallest expected count
mean(chi_ylt$expected >= 5)    # proportion of expected counts >= 5


# 7. Visualization --------------------------------------------------------
# Why plots help:
# - Counts plot: compares sample sizes and absolute differences.
# - Proportion plot: focuses on within-gender composition (most relevant for the RQ).
# - Mosaic plot: visualizes association pattern based on contingency table.

plot_df <- as.data.frame(tab_n)
colnames(plot_df) <- c("Gender", "RelImp", "N")

# 7.1 Counts by gender (absolute numbers)
ggplot(plot_df, aes(x = Gender, y = N, fill = Gender)) +
  geom_col() +
  ylab("Count") +
  xlab("Gender")

# 7.2 Within-gender composition (proportions)
ggplot(plot_df, aes(x = Gender, y = N, fill = RelImp)) +
  geom_col(position = "fill") +
  ylab("Proportion (within gender)") +
  xlab("Gender")

# 7.3 Mosaic plot (base R)
mosaicplot(
  tab_n,
  main = "Gender × Importance of religious identity",
  xlab = "Gender",
  ylab = "Religious identity importance"
)

# Optional: improve label readability for long category names
par(mar = c(5, 10, 4, 2))
mosaicplot(
  tab_n,
  main = "Gender × Importance of religious identity",
  xlab = "Gender",
  ylab = "Religious identity importance",
  las = 2,
  cex.axis = 0.7
)

# 8. Optional: what to report in your write-up ---------------------------
# Suggested reporting (APA-style idea, adjust to your course requirements):
# 1) Briefly describe variables and sample size (after cleaning).
# 2) Report Chi-square result: X^2(df) = ..., p = ...
# 3) Mention assumption check result (expected counts rule-of-thumb).
# 4) Use row percentages to explain direction/pattern of differences.
