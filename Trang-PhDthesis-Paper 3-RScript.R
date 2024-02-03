# Data analysis for Paper 3 (chapter 4)
# Load the library
library(seminr)
library(psych)
library(readr)
library(ggplot2)


##### 1. LOAD THE FOOD WASTE DATA########################################
# Test with food waste data
# Load the food waste data
food_waste_data <- read.csv(file = "data/foodwaste-r.csv", header = TRUE, sep = ",")
head(food_waste_data)


# 2. CHECKING CRONBACH'S ALPHA VALUES -----
library(psych)

# planning - 0.75
plan <- data.frame(food_waste_data$Q3_1, food_waste_data$Q3_2, 
                   food_waste_data$Q3_3)
class(plan) #check the class of plan
psych::alpha(plan) # 0.75

# shopping - 0.63
shop <- data.frame(food_waste_data$Q4_1, food_waste_data$Q4_2, 
                   food_waste_data$Q4_3, food_waste_data$Q4_4)
psych::alpha(shop, check.keys = TRUE)

# shopping- reverse Q4_3, remove Q4_4
shop1 <- data.frame(food_waste_data$Q4_1, food_waste_data$Q4_2, 
                    food_waste_data$Q4_3)
psych::alpha(shop1, keys="Q4_3")

cov.shop1 <- cov(shop1)
psych::alpha(cov.shop1, check.keys = TRUE)


# shopping-remove Q4_3
shop2 <- data.frame(food_waste_data$Q4_1, food_waste_data$Q4_2, food_waste_data$Q4_3)
psych::alpha(shop2, check.keys = TRUE)


# storing - 0.7
store <- data.frame(food_waste_data$Q5_1, food_waste_data$Q5_2, food_waste_data$Q5_3)
psych::alpha(store, check.keys = TRUE)

# prepare - 0.62
prepare <- data.frame(food_waste_data$Q7_1,food_waste_data$Q7_2, food_waste_data$Q7_3)
psych::alpha(prepare, check.keys = TRUE)
# prepare - with Q7_3r
prepare_1 <- data.frame(food_waste_data$Q7_1,food_waste_data$Q7_2, food_waste_data$Q7_3r)
psych::alpha(prepare_1)


# leftover
leftover <- data.frame(food_waste_data$Q9_1, food_waste_data$Q9_2)
psych::alpha(leftover, check.keys = TRUE)

# check cronbach's alpha value of gain construct when there are reserving items
gain <- data.frame(food_waste_data$Q15_1, food_waste_data$Q15_2r, 
                   food_waste_data$Q15_3r) # use the reversed score
psych::alpha(gain, check.keys = TRUE)
psych::alpha(gain)

# gain motivation- specify which items to reverse key by name -0.57
psych::alpha(gain, keys=c("food_waste_data$Q15_2","food_waste_data$Q15_3"))
cov.gain <- cov(gain)
psych::alpha(cov.gain, check.keys = TRUE)

# automatic reversal base upon first component
#alpha(gain, check.keys = TRUE)

# hedonic - motivation - 0.67
hedonic <- data.frame(food_waste_data$Q15_4, food_waste_data$Q15_5)
psych::alpha(hedonic, check.keys = TRUE) #0.67
psych::alpha(hedonic) #0.67 - similar to the summary(reliability

# normative - 0.67
normative <- data.frame(food_waste_data$Q15_6, food_waste_data$Q15_7, 
                        food_waste_data$Q15_8)
psych::alpha(hedonic, check.keys = TRUE)

# health and food safety concern - 0.72
health <- data.frame(food_waste_data$Q21F_1, food_waste_data$Q21F_2, 
                     food_waste_data$Q21F_3, food_waste_data$Q21F_4)
psych::alpha(health, check.keys = TRUE)


#####  Model 1_12- Run the last model 31/03/2023-------------------------------
# If clear the environment and console
# Set the directory
setwd("C:/Users/a1777963/Box/UNIVERSITY COMPUTER/A-TRANG/a-WORK-2019/a-PHD PROJECT/PUBLICATION/3-PAPER 3/Data analysis")
# Load the food waste data
food_waste_data <- read.csv(file = "data/foodwaste-r.csv", header = TRUE, sep = ",")
head(food_waste_data)

# Load the library
library(seminr)
library(psych)
library(readr)
library(ggplot2)

# Define measurement model
food_waste_mm1_12 <- constructs(
  composite("PLAN", multi_items("Q3_", 1:3)),
  composite("SHOP", multi_items("Q4_", 1:2)),
  composite("STORE", multi_items("Q5_", 1:3)),
  composite("PREPARE", multi_items("Q7_", 1:2)),
  composite("LEFTOVER", multi_items("Q9_", 1:2)),
  composite("GAIN", c("Q15_1", "Q15_2r", "Q15_3r")),
  composite("HEDONIC", multi_items("Q15_", 4:5)),
  composite("NORMATIVE", multi_items("Q15_", 6:8)),
  composite("COMP", c("Q21F_1", "Q21F_2", "Q21F_4")),
  composite("FW", single_item("Q10_avoidable"))
)
# Define structural model
food_waste_sm1_12 <- relationships(
  paths(from = "GAIN", to = c("HEDONIC", "PLAN", "SHOP", "STORE", "PREPARE", "LEFTOVER")),
  paths(from = "HEDONIC", to = c("PLAN", "SHOP", "STORE", "PREPARE", "LEFTOVER")),
  paths(from = "NORMATIVE", to = c("HEDONIC", "PLAN", "SHOP", "STORE", "PREPARE", "LEFTOVER")),
  paths(from = "COMP", to = c("PLAN", "SHOP", "STORE", "PREPARE", "LEFTOVER")),
  paths(from = "PLAN", to = "FW"),
  paths(from = "SHOP", to = "FW"),
  paths(from = "STORE", to = "FW"),
  paths(from = "PREPARE", to = "FW"),
  paths(from = "LEFTOVER", to = "FW")
)
# Estimate the model
food_waste_model1_12 <- estimate_pls(
  data = food_waste_data,
  measurement_model = food_waste_mm1_12,
  structural_model = food_waste_sm1_12
)
# Summarize the model results
summary_food_waste_model1_12 <- summary(food_waste_model1_12)


### EVALUATION OF THE MEASUREMENT MODEL
# Inspect the Iterations to converge
summary_food_waste_model1_12$iterations
# Inspect the outer model (indicator) loadings
summary_food_waste_model1_12$loadings
# Inspect the indicator reliability - loading ^2
summary_food_waste_model1_12$loadings^2
# Inspect the composite reliability
summary_food_waste_model1_12$reliability
#plot the reliabilities of constructs
plot(summary_food_waste_model1_12$reliability)
# table of the FL criteria
summary_food_waste_model1_12$validity$fl_criteria
# HTMT criterion
summary_food_waste_model1_12$validity$htmt
# Test the confidence intervals of HTMT
# Bootstrap the model
boot_food_waste_model1_12 <- bootstrap_model(seminr_model = food_waste_model1_12,
                                             nboot = 10000, seed = 123)
#store the summary of the bootstrapped model
sum_boot_food_waste_model1_12 <- summary(boot_food_waste_model1_12, alpha = 0.1)
# extract the bootstrapped HTMT
sum_boot_food_waste_model1_12$bootstrapped_HTMT

### EVALUATION OF THE STRUCTURAL MODEL
# inspect the structural model collinearity VIF, lower than 3
summary_food_waste_model1_12$vif_antecedents
# inspect the structural paths
sum_boot_food_waste_model1_12$bootstrapped_paths
# inspect the total effect
sum_boot_food_waste_model1_12$bootstrapped_total_paths
# Inspect the model's path coefficients and the R^2 values
summary_food_waste_model1_12$paths
# Inpsect the effect sizes
summary_food_waste_model1_12$fSquare
# Plot the bootstrapped model
plot(boot_food_waste_model1_12, title='Model 1.12')
#save_plot("model1_12_2023-05-18.pdf")
