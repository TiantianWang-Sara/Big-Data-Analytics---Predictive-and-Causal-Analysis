# Load Packages (Total about 20 to 25 minutes)
library(dplyr)
library(tidyverse)
library(tidymodels)
library(glmnet)
library(gbm)
library(psych)

# Set Directory
setwd("~/Desktop/UIUC/Academic Courses/Fall 2023/Fin 550 Big Data/Project")

# Disable Scientific Notation
options(scipen = 999)

# Read Data
df_pro <- read_csv("historic_property_data.csv")
pre <- read_csv("predict_property_data.csv")

# Training Variables Selection
df <- Filter(function(x)!any(is.na(x)), df_pro)
df$geo_school_elem_district <- df_pro$geo_school_elem_district
df$geo_school_hs_district <- df_pro$geo_school_hs_district
df$econ_midincome <- df_pro$econ_midincome
df$char_frpl <- df_pro$char_frpl
df$char_bldg_sf_square <- (df$char_bldg_sf)^2
df$char_type_resd <- df_pro$char_type_resd
df$char_air <- df_pro$char_air 
df$char_age_square <- (df$char_age)^2
df$char_hd_sf_square <- (df$char_hd_sf)^2
df$char_ext_wall <- df_pro$char_ext_wall
df$char_bsmt <- df_pro$char_bsmt

# Converting Categorical Variables in Historical Data
df$meta_class <- as.factor(df$meta_class)
df$meta_town_code <- as.factor(df$meta_town_code)
df$meta_nbhd <- as.factor(df$meta_nbhd)
df$meta_deed_type <- as.factor(df$meta_deed_type)
df$ind_large_home <- as.factor(df$ind_large_home)
df$ind_arms_length <- as.factor(df$ind_arms_length)
df$geo_school_elem_district <- as.factor(df$geo_school_elem_district)
df$geo_school_hs_district <- as.factor(df$geo_school_hs_district)
df$char_type_resd <- as.factor(df$char_type_resd)
df$char_air <- as.factor(df$char_air)
df$char_ext_wall <- as.factor(df$char_ext_wall)
df$char_bsmt <- as.factor(df$char_bsmt)

# Summary of Variables in Historical Data
Historical_Summary <- describe(df, quant = c(0.25,0.75))
Historical_Summary <- Historical_Summary[,c(2,3,14,5,15,8,9,10)]
Historical_Summary <- round(Historical_Summary)

# Drop NA Value for Model Training and Testing
df <- drop_na(df)

# Split the Historical Data into Training Data and Test Data
set.seed(675256138)
train_index <- sample(nrow(df),0.7*nrow(df))
train_data <- df[train_index,]
test_data <- df[-train_index,]

# Predict Data Preparation
pre$char_bldg_sf_square <- (pre$char_bldg_sf)^2
pre$char_age_square <- (pre$char_age)^2
pre$char_hd_sf_square <- (pre$char_hd_sf)^2
pre <- pre[c("pid",names(df)[-1])]

pre$meta_class <- as.factor(pre$meta_class)
pre$meta_town_code <- as.factor(pre$meta_town_code)
pre$meta_nbhd <- as.factor(pre$meta_nbhd)
pre$meta_deed_type <- as.factor(pre$meta_deed_type)
pre$ind_large_home <- as.factor(pre$ind_large_home)
pre$ind_arms_length <- as.factor(pre$ind_arms_length)
pre$geo_school_elem_district <- as.factor(pre$geo_school_elem_district)
pre$geo_school_hs_district <- as.factor(pre$geo_school_hs_district)
pre$char_type_resd <- as.factor(pre$char_type_resd)
pre$char_air <- as.factor(pre$char_air)
pre$char_ext_wall <- as.factor(pre$char_ext_wall)
pre$char_bsmt <- as.factor(pre$char_bsmt)

# Break Predict Data Based on NA
pre_no_na <- drop_na(pre)
pre_na <- anti_join(pre,pre_no_na)

# Lasso Model Training and Testing
x <- model.matrix(sale_price~0+., data = train_data)
y <- train_data$sale_price

set.seed(675256138)
fit <- cv.glmnet(x=x, y=y, nfolds=20)

new_x <- model.matrix(sale_price~0+., data = test_data)
predictions <- predict(fit, newx=new_x, s = "lambda.min")
mean((predictions-test_data$sale_price)^2)

# Boosting Tree Training and Testing
set.seed(675256138)
gbm_model <- gbm(sale_price~. , data = train_data, n.trees = 1000, interaction.depth = 1, shrinkage = 0.1, cv.folds = 50, distribution ="gaussian")

predictions <- predict(gbm_model, newdata = test_data, n.trees = 1000)
mean((predictions-test_data$sale_price)^2)

# Predict Values for Properties without NA Values
new_x2 <- model.matrix(pid~0+., data = pre_no_na)
## Match Categorical Variables Levels
new_x3 <- plyr::rbind.fill(data.frame(new_x),data.frame(new_x2))
new_x3[is.na(new_x3)] <- 0
new_x3 <- new_x3[-c(1:14945),]

new_x <- as.matrix(new_x3)
pre_no_na$assessed_value <- predict(fit, newx=new_x, s = "lambda.min")

# Predict Values for Properties with NA Values
pre_na$assessed_value <- predict(gbm_model, newdata = pre_na, n.trees = 1000)

# Combine Dataframe and Convert Negative Outcomes to Zero
pre <- rbind(pre_no_na,pre_na) %>%
  arrange(pid) 

pre$assessed_value[pre$assessed_value<0] <- 0

## Summary of Variables in Predicted Data
Predicted_Summary <- describe(pre[,-1],quant = c(0.25,0.75))
Predicted_Summary <- Predicted_Summary[,c(2,3,14,5,15,8,9,10)]
Predicted_Summary <- round(Predicted_Summary)

pre <- select(pre,"pid","assessed_value")

# Summary of Predicted Data
summary(pre$assessed_value)

# Output CSV
write.csv(pre, "assessed_value.csv")
