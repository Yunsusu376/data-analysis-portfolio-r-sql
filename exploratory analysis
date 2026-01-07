# ------------------------------------------------------------
# Title: Birthweight dataset - exploratory analysis
# Description:
#   - Compare birthweight and gestational age between
#     smoking and non-smoking mothers
#   - Explore head circumference and length
#   - Check normality with Shapiro–Wilk test
#   - Compute Z-scores, ranges and simple probabilities
# ------------------------------------------------------------

# 0. Setup ---------------------------------------------------------------

library(readr)

# NOTE: adjust the path below to where Birthweight.csv is stored on your machine.
# For portfolio use, a relative path like "data/Birthweight.csv" is preferred.
Birthweight <- read_csv("Desktop/business analysis/data analyst program-M/Group A/Datasets/Birthweight.csv")

# Create subsets for smoking / non-smoking mothers
Birthweight_non_smoking <- Birthweight[Birthweight$smoker == 0, ]
Birthweight_smoking     <- Birthweight[Birthweight$smoker == 1, ]


# 1. Basic summaries -----------------------------------------------------

## Q1. What is the mean birth weight for babies of non-smoking mothers?
mean_bw_non_smoking <- mean(Birthweight_non_smoking$Birthweight, na.rm = TRUE)
mean_bw_non_smoking
# This returns the mean birthweight (kg) in the non-smoking group.


## Q2. What is the mean birth weight for babies of smoking mothers?
mean_bw_smoking <- mean(Birthweight_smoking$Birthweight, na.rm = TRUE)
mean_bw_smoking
# This returns the mean birthweight (kg) in the smoking group.


## Q3. What is the mean head circumference for babies of non-smoking mothers?
mean_head_non_smoking <- mean(Birthweight_non_smoking$Headcirc, na.rm = TRUE)
mean_head_non_smoking
# This returns the mean head circumference (cm) in the non-smoking group.


## Q4. What is the mean gestational age at birth for babies of smoking mothers?
mean_gest_smoking <- mean(Birthweight_smoking$Gestation, na.rm = TRUE)
mean_gest_smoking
# This returns the mean gestational age (weeks) in the smoking group.


## Q5. What is the maximum head circumference for babies of non-smoking mothers?
max_head_non_smoking <- max(Birthweight_non_smoking$Headcirc, na.rm = TRUE)
max_head_non_smoking
# This returns the maximum head circumference (cm) in the non-smoking group.


## Q6. What is the minimum gestational age at birth for babies of smoking mothers?
min_gest_smoking <- min(Birthweight_smoking$Gestation, na.rm = TRUE)
min_gest_smoking
# This returns the minimum gestational age (weeks) in the smoking group.


## Q7. Which is a better bet:
##  - Pregnancy period in smoking mothers is shorter
##  - Pregnancy period in non-smoking mothers is shorter
mean_gest_smoking     <- mean(Birthweight_smoking$Gestation, na.rm = TRUE)
mean_gest_non_smoking <- mean(Birthweight_non_smoking$Gestation, na.rm = TRUE)
mean_gest_smoking
mean_gest_non_smoking
# Interpretation:
# Compare the two means. In this dataset the mean gestational age
# for smoking mothers is slightly lower than for non-smoking mothers,
# so “pregnancy period in smoking mothers is shorter” is the better bet overall.


## Q8. Justify the above choice in a few words.
# The mean gestational age in the smoking group is lower than in the
# non-smoking group, so pregnancies among smoking mothers tend to be
# slightly shorter in this sample.


# 2. Ranges and interpretation ------------------------------------------

## Q9. What is the baby birthweight range for babies of smoking mothers?
range_bw_smoking <- range(Birthweight_smoking$Birthweight, na.rm = TRUE)
range_bw_smoking
range_bw_smoking_diff <- diff(range_bw_smoking)
range_bw_smoking_diff
# This shows the minimum and maximum birthweight in the smoking group
# and the total spread (max - min).


## Q10. Interpretation of the range for smoking vs non-smoking mothers
range_bw_non_smoking      <- range(Birthweight_non_smoking$Birthweight, na.rm = TRUE)
range_bw_non_smoking
range_bw_non_smoking_diff <- diff(range_bw_non_smoking)
range_bw_non_smoking_diff

# Interpretation (text, not a numeric “answer”):
# - The range describes the spread from the lightest to the heaviest baby.
# - The smoking group has a wider range and a lower minimum birthweight,
#   while the maximum birthweights are similar.
# - This suggests that birthweights in the smoking group are more variable
#   and can be noticeably lower than in the non-smoking group.


# 3. Normality checks (Shapiro–Wilk) -------------------------------------

## Q11. Are head circumference data for babies of smoking mothers normally distributed?
hist(
  Birthweight_smoking$Headcirc,
  main = "Head circumference (smoking mothers)",
  xlab = "Head circumference (cm)"
)
qqnorm(Birthweight_smoking$Headcirc)
qqline(Birthweight_smoking$Headcirc)

shapiro_head_smoking <- shapiro.test(Birthweight_smoking$Headcirc)
shapiro_head_smoking
# The p-value from shapiro_head_smoking tells us whether the data
# deviate significantly from normality (H0: data are normal).


## Q12. What is the significance value for the above Shapiro–Wilk test?
# Use: shapiro_head_smoking$p.value
# Interpretation:
# If p-value > 0.05, we do not reject normality – the data are consistent
# with a normal distribution.


# 4. Z-scores and skewness ----------------------------------------------

## Q13. What is the standard score (Z-score) for head circumference of 35.05
##     in non-smoking mothers?
mean_head_non_smoking <- mean(Birthweight_non_smoking$Headcirc, na.rm = TRUE)
sd_head_non_smoking   <- sd(Birthweight_non_smoking$Headcirc, na.rm = TRUE)

Z_head_35_05 <- (35.05 - mean_head_non_smoking) / sd_head_non_smoking
Z_head_35_05
# This returns the Z-score of 35.05 cm relative to the non-smoking group
# (how many standard deviations it is above or below the mean).


## Q14. How are birthweight data of non-smoking mothers skewed?
mean_bw_non_smoking   <- mean(Birthweight_non_smoking$Birthweight, na.rm = TRUE)
median_bw_non_smoking <- median(Birthweight_non_smoking$Birthweight, na.rm = TRUE)

mean_bw_non_smoking
median_bw_non_smoking
hist(
  Birthweight_non_smoking$Birthweight,
  main = "Birthweight (non-smoking mothers)",
  xlab = "Birthweight (kg)"
)

# Interpretation:
# If mean > median, the distribution tends to be right-skewed (positively skewed);
# if mean < median, it tends to be left-skewed. Here mean > median, so
# birthweights of non-smoking mothers are right-skewed in this sample.


## Q15. Are birthweight data for babies of smoking mothers normally distributed?
shapiro_bw_smoking <- shapiro.test(Birthweight_smoking$Birthweight)
shapiro_bw_smoking

# Interpretation:
# Again, check shapiro_bw_smoking$p.value.
# If p-value > 0.05, the birthweight data for babies of smoking mothers
# are consistent with a normal distribution.


## Q16. What is the significance value for the above Shapiro–Wilk test?
# Use: shapiro_bw_smoking$p.value
# The p-value is the significance level for the normality test.


# 5. ±1 SD and probabilities ---------------------------------------------

## Q17. Based on the dataset, how confident can we be that a baby’s birthweight
##      will be within ±1 SD from the mean?
mean_bw_all <- mean(Birthweight$Birthweight, na.rm = TRUE)
sd_bw_all   <- sd(Birthweight$Birthweight, na.rm = TRUE)

lower_sd <- mean_bw_all - sd_bw_all
upper_sd <- mean_bw_all + sd_bw_all

prop_within_1sd <- mean(
  Birthweight$Birthweight >= lower_sd &
    Birthweight$Birthweight <= upper_sd,
  na.rm = TRUE
)
prop_within_1sd
# Interpretation:
# prop_within_1sd gives the empirical proportion of babies whose birthweight
# lies within one standard deviation of the mean in this sample.


## Q18. Probability that the birthweight for a baby of a smoking mother
##      will be less than 4.2 kg
bw_smoking            <- Birthweight_smoking$Birthweight
count_lt_4_2_smoking  <- sum(bw_smoking < 4.2, na.rm = TRUE)
count_non_missing_sm  <- sum(!is.na(bw_smoking))
prob_lt_4_2_smoking   <- count_lt_4_2_smoking / count_non_missing_sm
prob_lt_4_2_smoking
# Interpretation:
# prob_lt_4_2_smoking is the sample-based estimate of
# P(birthweight < 4.2 kg | smoking mother).


# 6. Length of babies ----------------------------------------------------

## Q19. Are length data for babies of non-smoking mothers normally distributed?
shapiro_length_non_smoking <- shapiro.test(Birthweight_non_smoking$Length)
shapiro_length_non_smoking
# Check p-value: if > 0.05, the lengths are consistent with normality.


## Q20. What is the significance value for the above Shapiro–Wilk test?
# Use: shapiro_length_non_smoking$p.value
# This is the significance level for the normality test.


## Q21. What is the standard score for length = 48.5 cm for non-smoking mothers?
mean_length_non_smoking <- mean(Birthweight_non_smoking$Length, na.rm = TRUE)
sd_length_non_smoking   <- sd(Birthweight_non_smoking$Length, na.rm = TRUE)

Z_length_48_5 <- (48.5 - mean_length_non_smoking) / sd_length_non_smoking
Z_length_48_5
# This Z-score tells us how many standard deviations 48.5 cm
# is from the mean length of babies of non-smoking mothers.


## Q22. Probability that the length of a baby for non-smoking mothers
##      will be more than 55 cm
length_non_smoking          <- Birthweight_non_smoking$Length
count_length_gt_55          <- sum(length_non_smoking > 55, na.rm = TRUE)
count_length_non_smoking    <- sum(!is.na(length_non_smoking))
prob_length_gt_55_non_smoke <- count_length_gt_55 / count_length_non_smoking
prob_length_gt_55_non_smoke
# Interpretation:
# prob_length_gt_55_non_smoke is the estimated probability that the baby’s
# length exceeds 55 cm among non-smoking mothers in this dataset.
