# ------------------------------------------------------------
# Title: PickUpLines dataset - ANOVA / factorial analysis
# Description:
#   - Q1: One-way comparison of Receptivity by PickUp type (2 groups)
#   - Q2: One-way comparison of Receptivity by Scent (2 groups)
#   - Q3: Two-way ANOVA (PickUp × Scent) + assumption checks + effect size
# Notes:
#   - Use relative path for GitHub/portfolio (e.g., "data_raw/PickUpLines.csv")
#   - Run this script from the project root (RStudio Project recommended)
# ------------------------------------------------------------

# 0. Setup ---------------------------------------------------------------

library(readr)

# Optional packages (install once if needed):
# install.packages("car")
# install.packages("effectsize")
library(car)         # leveneTest()
library(effectsize)  # eta_squared()

# Load data (relative path preferred)
PickUpLines <- read_csv("data_raw/PickUpLines.csv")

# Quick check: structure and missingness (optional)
# str(PickUpLines)
# colSums(is.na(PickUpLines))


# 1. Q1: Receptivity by PickUp type (1 = Cute Direct, 2 = Direct Direct) --

# 1.1 Visual check: outliers / spread
boxplot(
  Receptivity ~ factor(PickUp),
  data = PickUpLines,
  xlab = "PickUp (1=Cute Direct, 2=Direct Direct)",
  ylab = "Receptivity"
)

# 1.2 Create groups
g_pickup_1 <- subset(PickUpLines, PickUp == 1)$Receptivity  # Cute Direct
g_pickup_2 <- subset(PickUpLines, PickUp == 2)$Receptivity  # Direct Direct

# 1.3 Normality checks (Shapiro–Wilk + Q-Q plot)
# H0: sample comes from a normal distribution
shapiro.test(g_pickup_1)
shapiro.test(g_pickup_2)

qqnorm(g_pickup_1, main = "Q-Q Plot: PickUp=1 (Cute Direct)"); qqline(g_pickup_1)
qqnorm(g_pickup_2, main = "Q-Q Plot: PickUp=2 (Direct Direct)"); qqline(g_pickup_2)

# Histograms (optional)
hist(g_pickup_1, main = "Receptivity - PickUp=1 (Cute Direct)", xlab = "Receptivity")
hist(g_pickup_2, main = "Receptivity - PickUp=2 (Direct Direct)", xlab = "Receptivity")

# 1.4 Group means (useful for interpreting direction of effects)
tapply(PickUpLines$Receptivity, PickUpLines$PickUp, mean, na.rm = TRUE)
mean(g_pickup_1, na.rm = TRUE)  # Mean (PickUp=1)
mean(g_pickup_2, na.rm = TRUE)  # Mean (PickUp=2)

# 1.5 Homogeneity of variance (Levene’s test)
# H0: group variances are equal
leveneTest(Receptivity ~ factor(PickUp), data = PickUpLines, center = mean)

# 1.6 One-way ANOVA (equivalent to comparing 2 group means)
# Model: Receptivity ~ PickUp
m1 <- aov(Receptivity ~ factor(PickUp), data = PickUpLines)
anova(m1)

# Note:
# For 2 groups, ANOVA F-test and (pooled) t-test are closely related.
# You can also run:
# t.test(Receptivity ~ factor(PickUp), data = PickUpLines)


# 2. Q2: Receptivity by Scent (1 = Spray, 2 = No Spray) ------------------

# 2.1 Visual check
boxplot(
  Receptivity ~ factor(Scent),
  data = PickUpLines,
  xlab = "Scent (1=Spray, 2=No Spray)",
  ylab = "Receptivity"
)

# 2.2 Create groups
g_scent_spray  <- subset(PickUpLines, Scent == 1)$Receptivity
g_scent_nospray <- subset(PickUpLines, Scent == 2)$Receptivity

# 2.3 Normality checks
shapiro.test(g_scent_spray)
shapiro.test(g_scent_nospray)

qqnorm(g_scent_spray, main = "Q-Q Plot: Spray"); qqline(g_scent_spray)
qqnorm(g_scent_nospray, main = "Q-Q Plot: No Spray"); qqline(g_scent_nospray)

# 2.4 Homogeneity of variance (Levene)
leveneTest(Receptivity ~ factor(Scent), data = PickUpLines, center = mean)

# 2.5 Group means (direction)
mean(g_scent_spray, na.rm = TRUE)
mean(g_scent_nospray, na.rm = TRUE)

# 2.6 One-way test (Welch) if variances differ / safer default
# H0: means are equal across Scent groups
oneway.test(
  Receptivity ~ factor(Scent),
  data = PickUpLines,
  var.equal = FALSE
)


# 3. Q3: Two-way ANOVA (PickUp × Scent) ----------------------------------

# 3.1 Create labeled factors (better for plots / interpretation)
PickUpLines$PickUp_f <- factor(PickUpLines$PickUp, levels = c(1, 2),
                               labels = c("CuteDirect", "DirectDirect"))
PickUpLines$Scent_f  <- factor(PickUpLines$Scent, levels = c(1, 2),
                               labels = c("Spray", "NoSpray"))

# Cell factor for the 2×2 design (for plotting)
PickUpLines$Cell <- interaction(PickUpLines$PickUp_f, PickUpLines$Scent_f)

# 3.2 Visual check by cell
boxplot(
  Receptivity ~ Cell,
  data = PickUpLines,
  xlab = "Cell (PickUp × Scent)",
  ylab = "Receptivity"
)

# 3.3 Normality checks within each cell (small n may reduce test power)
c11 <- subset(PickUpLines, PickUp == 1 & Scent == 1)$Receptivity  # Cute + Spray
c12 <- subset(PickUpLines, PickUp == 1 & Scent == 2)$Receptivity  # Cute + NoSpray
c21 <- subset(PickUpLines, PickUp == 2 & Scent == 1)$Receptivity  # Direct + Spray
c22 <- subset(PickUpLines, PickUp == 2 & Scent == 2)$Receptivity  # Direct + NoSpray

shapiro.test(c11)
shapiro.test(c12)
shapiro.test(c21)
shapiro.test(c22)

# Q-Q plots for each cell (optional)
par(mfrow = c(2, 2))
qqnorm(c11, main = "Cute + Spray");    qqline(c11)
qqnorm(c12, main = "Cute + NoSpray");  qqline(c12)
qqnorm(c21, main = "Direct + Spray");  qqline(c21)
qqnorm(c22, main = "Direct + NoSpray");qqline(c22)
par(mfrow = c(1, 1))

# 3.4 Homogeneity of variance across cells (Levene)
# H0: variances are equal across the 4 cells
leveneTest(
  Receptivity ~ interaction(factor(PickUp), factor(Scent)),
  data = PickUpLines,
  center = mean
)

# Quick variance ratio check (rule of thumb; not a formal test)
cell_vars <- tapply(
  PickUpLines$Receptivity,
  interaction(PickUpLines$PickUp, PickUpLines$Scent),
  var
)
cell_vars
max(cell_vars, na.rm = TRUE) / min(cell_vars, na.rm = TRUE)

# 3.5 Two-way ANOVA with interaction
# Model: Receptivity ~ PickUp + Scent + PickUp:Scent
m3 <- aov(Receptivity ~ factor(PickUp) * factor(Scent), data = PickUpLines)
summary(m3)

# Interpretation:
# - Main effect PickUp: average difference between PickUp types
# - Main effect Scent: average difference between Spray vs NoSpray
# - Interaction: whether the PickUp effect depends on Scent (or vice versa)

# 3.6 Effect size (partial eta squared)
eta_squared(m3, partial = TRUE)
