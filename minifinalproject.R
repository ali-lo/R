rm(list=ls())
# set working directory to file location
setwd("/Users/alilo/Desktop/Fall 2023")

# UCI dataset: https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients 

old_default_data = read.csv("defaultofcreditcardclients.csv")
View(default_data)

# need to remove the first row and have it import the second row as headers
default_data = read.csv("defaultofcreditcardclients.csv", skip=1, header=TRUE)
View(default_data)

#####################
####Cleaning Data####
#####################
head(default_data)

# shows that there are no NAs
summary(default_data)

# convert factor variables into factors
default_data$SEX[default_data$SEX == "Male"] == "1"
default_data$SEX[default_data$SEX == "Female"] == "2"
default_data$SEX = as.factor(default_data$SEX)

default_data$EDUCATION = as.factor(default_data$EDUCATION)

default_data$MARRIAGE = as.factor(default_data$MARRIAGE)

default_data$AGE = as.factor(default_data$AGE)

# Pay_0 through Pay_6 indicate the past monthly payment records 
# a negative number indicates an ON TIME payment over the time period
# a positive number indicates a MISSED payment over the time period
default_data$PAY_0 = as.factor(default_data$PAY_0)
default_data$PAY_2 = as.factor(default_data$PAY_2)
default_data$PAY_3 = as.factor(default_data$PAY_3)
default_data$PAY_4 = as.factor(default_data$PAY_4)
default_data$PAY_5 = as.factor(default_data$PAY_5)
default_data$PAY_6 = as.factor(default_data$PAY_6)

# whether they miss their next payment is a binary outcome (Yes=1, No=0)
default_data$default.payment.next.month[default_data$default.payment.next.month == "Missed"] == "1"
default_data$default.payment.next.month[default_data$default.payment.next.month == "Paid"] == "0"
default_data$default.payment.next.month = as.factor(default_data$default.payment.next.month)

# check factor variable outputs
table(default_data$default.payment.next.month)
table(default_data$SEX)
table(default_data$EDUCATION) # unexpected variable of 0, 5, 6
table(default_data$MARRIAGE) # unexpected variable of 0
table(default_data$PAY_0)
table(default_data$PAY_6) 

summary(default_data)

# You cannot use protected attributes such as sex, age, and marital status to predict default payments. 
# It would be unethical to use such predictors since it could lead to discrimination along those variables. 
# As a result, we will use the LIMIT_BAL, BILL_AMT1-6 PAY_AMT1-66 since those are indicators of the amount of debt that a person has.
# We will also use their most recent repayment history (Pay_1-6) since it can indicate whether or not they will make the upcoming payment.

#####################
#Regression Analysis#
#####################
# since it is a binary outcome, we will use a logit or probit models
# to see the best fit, we will compare the AIC scores 
library(ggplot2)
library("mfx")

# Here, I am testing it will all possible factors that I believe could impact a default payment.
# However, I do not believe that it is particularly ethical to include education. 
# Education is not a protected attribute. 
# But, including education discriminates against people with varying education backgrounds. 
# While education can be an indication of responsibility and/ or academic level. 
# I do believe that people have different strengths.
# There are responsible people who did not go to college and irresponsible people who did go. 

# logit model
logit_regression = glm(default.payment.next.month ~ LIMIT_BAL + EDUCATION + PAY_0 +
                         PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                         BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                         PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                         PAY_AMT6, family="binomial", data=default_data)
summary(logit_regression) # AIC: 26221 

# probit model
probit_regression = glm(default.payment.next.month ~ LIMIT_BAL + EDUCATION + PAY_0 +
                          PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                          BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                          PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                          PAY_AMT6, family=binomial(link="probit"), data=default_data)
# Warning message: glm.fit: fitted probabilities numerically 0 or 1 occurred 
predict(probit_regression, default_data, type="response") # to check the warning message 
summary(logit_regression) # AIC: 26221

# logit mod
no_education_logit_regression = glm(default.payment.next.month ~ LIMIT_BAL + PAY_0 +
                      PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                      BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                      PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                      PAY_AMT6, family="binomial", data=default_data)
summary(no_education_logit_regression) # AIC: 26260 

# probit model
no_education_probit_regression = glm(default.payment.next.month ~ LIMIT_BAL + PAY_0 +
                        PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                        BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                        PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                        PAY_AMT6, family=binomial(link="probit"), data=default_data)
# Warning message: glm.fit: fitted probabilities numerically 0 or 1 occurred 
summary(no_education_logit_regression) # AIC: 26260

# logit and probit had the same AIC scores 
# let's try it without the PAY_0-6 variable 

# logit model
no_pay_hist_logit_regression = glm(default.payment.next.month ~ LIMIT_BAL + BILL_AMT1 + 
                                  BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                                  PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                                  PAY_AMT6, family="binomial", data=default_data)
summary(no_pay_hist_logit_regression) # AIC: 30422 

# probit regression
no_pay_hist_probit_regression = glm(default.payment.next.month ~ LIMIT_BAL + BILL_AMT1 + 
                                    BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                                    PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                                    PAY_AMT6, family=binomial(link="probit"), data=default_data)
# Warning message: glm.fit: fitted probabilities numerically 0 or 1 occurred 
summary(no_pay_hist_logit_regression) # AIC: 30422

# There is also no difference between the AIC scores.
# However, the earlier model with the payment history was better. 
# I want to see if only including the most recent data points is a better indicator. 

# logit model
recent_logit_regression = glm(default.payment.next.month ~ LIMIT_BAL + PAY_6 + BILL_AMT6 + 
                              PAY_AMT6, family="binomial", data=default_data)
summary(recent_logit_regression) # AIC: 29641

# probit model
recent_probit_regression = glm(default.payment.next.month ~ LIMIT_BAL + PAY_6 + BILL_AMT6 + 
                               PAY_AMT6, family=binomial(link="probit"), data=default_data)
summary(recent_logit_regression) # AIC: 29641

# Overall, the models with the entire payment history and education produces the best model.
# However, the exclusing education does provide a fairly similar model.
# Both the logit and probit examples had the same AIC scores


#####################
#####Classifiers#####
#####################
library(caret)

# to make the data reproducible in cross-validation
# 5-fold and a tuneLength=10 was adequate for cross-validation
set.seed(0)
train_Control = trainControl(method = "cv", number = 5)

# this trains the knn model using the cross-validation splits
knn_caret_model = train(default.payment.next.month ~ LIMIT_BAL + PAY_0 +
                  PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                  BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                  PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                  PAY_AMT6, data=default_data, method="knn", 
                  trControl=train_Control, tuneLength=10)
knn_caret_model #k=21, accuracy=0.7771999, kappa=

# accuracy versus number of neighbors
plot(knn_caret_model)

# this trains the naive_bayes model using the cross validation splits 
library(naivebayes)
naive_bayes_model = train(default.payment.next.month ~ LIMIT_BAL + PAY_0 +
                    PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                    BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                    PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                    PAY_AMT6, data=default_data, method="naive_bayes", 
                    trControl=train_Control, tuneLength=10)
naive_bayes_model
# FALSE accuracy=0.7986333, kappa=0.2074535762
# TRUE accuracy=0.7787667, kappa=0.0001012184

# accuracy versus distribution type for fun
plot(naive_bayes_model)

# this trains the random forest model using the cross validation splits
library(randomForest)
rf_model = train(default.payment.next.month ~ LIMIT_BAL + PAY_0 +
                    PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                    BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                    PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                    PAY_AMT6, data=default_data, method="rf", 
                    trControl=train_Control, tuneLength=10)
rf_model # mtry=9, accuracy=0.8183334, kappa=0.3663391

# accuracy vs. randomly selected predictors
plot(rf_model)

# this trains the neural network model using cross-validation splits
library(nnet)
nnet_model = train(default.payment.next.month ~ LIMIT_BAL + PAY_0 +
                   PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + 
                   BILL_AMT2 + BILL_AMT3+ BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + 
                   PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4 + PAY_AMT5 + 
                   PAY_AMT6, data=default_data, method="nnet", 
                   trControl=train_Control, tuneLength=10)
nnet_model # size=7, accuracy=0.7788000, decay=1e-04

# accuracy vs. size (#hidden units)
plot(nnet_model)
