# ------------------------------------------------------------
# Title: Birthweight dataset - correlation & regression analysis
# Description:
#   - Explore linear relationships (scatterplots + correlations)
#   - Compare birthweight by smoking status (boxplot + t-test)
#   - Examine correlations among Birthweight, Length, Headcirc
#   - Fit simple linear regression models and check residuals
# ------------------------------------------------------------

# 0. Setup ---------------------------------------------------------------

library(readr)  # read_csv()

# NOTE:
# - For portfolio/GitHub, avoid absolute paths like Desktop/...
# - Keep data inside the repo and use a relative path.
# - Run this script from the project root (RStudio Project recommended).
Birthweight <- read_csv("data_raw/Birthweight.csv")

# 1. Relationship: father's age vs birthweight ---------------------------

## Q1–Q5. Scatterplot + fitted regression line
plot(
  Birthweight$fage, Birthweight$Birthweight,
  xlab = "Father's age (years)",
  ylab = "Birthweight (kg)"
)

# Add a simple linear regression line: Birthweight ~ fage
abline(lm(Birthweight$Birthweight ~ fage, data = Birthweight), lty = 2)

## Pearson correlation test
# H0: correlation = 0 (no linear relationship)
# H1: correlation ≠ 0 (linear relationship exists)
cor_fage_pearson <- cor.test(Birthweight$Birthweight, Birthweight$fage, method = "pearson")
cor_fage_pearson
# Interpretation:
# - If p-value < 0.05: evidence of a linear association in this sample.
# - If p-value >= 0.05: insufficient evidence of a linear association.

## Spearman correlation test
# Spearman tests monotonic association and is more robust to outliers/non-normality.
cor_fage_spearman <- cor.test(Birthweight$Birthweight, Birthweight$fage, method = "spearman")
cor_fage_spearman


# 2. Birthweight differences: smoking vs non-smoking ---------------------

## Q6. Pearson correlation with binary variable (smoker = 0/1)
# With smoker coded 0/1, Pearson correlation is related to group mean differences,
# but the two-sample t-test below is the standard method for comparing groups.
cor_smoker_pearson <- cor.test(Birthweight$Birthweight, Birthweight$smoker, method = "pearson")
cor_smoker_pearson

## Boxplot for comparing distributions between the two groups
boxplot(
  Birthweight$Birthweight ~ Birthweight$smoker,
  xlab = "Mother smokes (0 = no, 1 = yes)",
  ylab = "Birthweight (kg)"
)

## Two-sample t-test (Welch by default)
# H0: mean birthweight (smoker=0) = mean birthweight (smoker=1)
# H1: means are different
ttest_bw_smoker <- t.test(Birthweight$Birthweight ~ Birthweight$smoker)
ttest_bw_smoker
# Interpretation:
# If p-value < 0.05, there is evidence of a difference in mean birthweight
# between smoking vs non-smoking mothers in this dataset.


# 3. Relationship: baby length vs birthweight ----------------------------

## Q9–Q10. Scatterplot + fitted regression line
plot(
  Birthweight$Length, Birthweight$Birthweight,
  xlab = "Baby length (cm)",
  ylab = "Birthweight (kg)"
)

# Add regression line: Birthweight ~ Length
abline(lm(Birthweight$Birthweight ~ Length, data = Birthweight), lty = 2)

## Pearson correlation test
# H0: correlation = 0
# H1: correlation ≠ 0
cor_length_bw <- cor.test(Birthweight$Length, Birthweight$Birthweight, method = "pearson")
cor_length_bw
# Interpretation:
# Positive correlation suggests heavier babies tend to be longer in this sample.


# 4. Correlations among Birthweight, Length, Head circumference ----------

## Q12. Correlation matrix (Pearson)
# use="complete.obs" excludes rows with missing values in any of the variables used.
cor_matrix <- cor(
  Birthweight[, c("Birthweight", "Length", "Headcirc")],
  method = "pearson",
  use = "complete.obs"
)
cor_matrix

## Pairwise correlation tests (gives p-values + confidence intervals)
cor.test(Birthweight$Birthweight, Birthweight$Length)
cor.test(Birthweight$Birthweight, Birthweight$Headcirc)
cor.test(Birthweight$Length, Birthweight$Headcirc)

## Pairwise scatterplots + fitted lines (visual check of linearity)
plot(
  Birthweight$Birthweight, Birthweight$Length,
  xlab = "Birthweight (kg)",
  ylab = "Length (cm)"
)
abline(lm(Length ~ Birthweight, data = Birthweight), lty = 2)

plot(
  Birthweight$Birthweight, Birthweight$Headcirc,
  xlab = "Birthweight (kg)",
  ylab = "Head circumference (cm)"
)
abline(lm(Headcirc ~ Birthweight, data = Birthweight), lty = 2)

plot(
  Birthweight$Length, Birthweight$Headcirc,
  xlab = "Length (cm)",
  ylab = "Head circumference (cm)"
)
abline(lm(Headcirc ~ Length, data = Birthweight), lty = 2)


# 5. Data check ----------------------------------------------------------

## Q19. Check for duplicate IDs
# anyDuplicated() returns the index of the first duplicate, or 0 if none.
anyDuplicated(Birthweight$ID)


# 6. Simple linear regression: Length ~ mother's height ------------------

## Q20. Fit model
# Model: Length = intercept + beta * mheight + error
model_mheight <- lm(Length ~ mheight, data = Birthweight)

## Residual plot (diagnostic)
# Purpose:
# - Check if residuals are randomly scattered around 0 (linearity + constant variance).
plot(
  model_mheight$fitted.values, resid(model_mheight),
  xlab = "Fitted values",
  ylab = "Residuals"
)
abline(h = 0, lty = 2)

## Model summary (coefficients, R^2, p-values)
summary(model_mheight)
# Interpretation:
# - The p-value for mheight tests H0: beta = 0 (no linear relationship).
# - If p < 0.05, mheight is statistically associated with Length in this sample.

## Range of mheight in the dataset (useful for sensible prediction)
min(Birthweight$mheight, na.rm = TRUE)
max(Birthweight$mheight, na.rm = TRUE)

## Q28. Prediction at mheight = 170
# This gives the model-estimated mean Length for a mother height of 170 cm.
predict(model_mheight, newdata = data.frame(mheight = 170))


# 7. Optional model: Length ~ father's age --------------------------------

## Q30. Fit a second model to explore whether father's age relates to baby length
model_fage <- lm(Length ~ fage, data = Birthweight)
summary(model_fage)
# Interpretation:
# Check p-value for fage to see whether it is associated with Length in this dataset.
