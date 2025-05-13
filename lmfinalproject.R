rm(list=ls())
# set working directory to file location
setwd("/Users/alilo/Desktop/Spring 2024/IMT 570")

esg_pe_data = read.csv("570esgpedata.csv", header=TRUE)
View(esg_pe_data)

#####################
####Cleaning Data####
#####################
head(esg_pe_data)
summary(esg_pe_data)

# convert into factors
esg_pe_data$BusinessModel = as.factor(esg_pe_data$BusinessModel)

esg_pe_data$Athletic_OutdoorRecreation = as.factor(esg_pe_data$Athletic_OutdoorRecreation)

esg_pe_data$CompanySize = as.factor(esg_pe_data$CompanySize)

esg_pe_data$ESGRiskClassification = as.factor(esg_pe_data$ESGRiskClassification)

#convert into integers
esg_pe_data$EstimateCompanySizeEmployees = as.integer(esg_pe_data$EstimateCompanySizeEmployees)

summary(esg_pe_data)


#####################
#Regression Analysis#
#####################
?lm

summary(lm(TrailingPE ~ ESGRiskRating, data=esg_pe_data))

summary(lm(X2024ActualPE ~ ESGRiskRating, data=esg_pe_data))

summary(lm(ForwardPE ~ ESGRiskRating, data=esg_pe_data))

plot(lm(ForwardPE ~ ESGRiskRating + EstimateCompanySizeEmployees, data=esg_pe_data))

plot(lm(ForwardPE ~ ESGRiskRating, data=esg_pe_data))

###########################################################
# ESG Risk Rating vs. Trailing PE Ratio linear regression #
####################### NAs as Median #####################
###########################################################
plot(x=esg_pe_data$ESGRiskRating, y=esg_pe_data$TrailingPE,
     xlab="ESG Risk Rating",
     ylab="Trailing PE Ratio",
     main="ESG Risk Rating vs. Trailing PE Ratio"
     )
# add trendline 
tpe_lm = lm(TrailingPE ~ ESGRiskRating, data=esg_pe_data)
summary(tpe_lm)
abline(tpe_lm, col="red")
# add R2 value
legend("topright", bty="n", legend=paste("R2 is", format(summary(tpe_lm)$adj.r.squared, digits=4))) #R2=-0.001633

###########################################################
# ESG Risk Rating vs. Trailing PE Ratio linear regression #
########################## No NAs #########################
###########################################################
plot(x=esg_pe_data_no_NA$ESGRiskRating, y=esg_pe_data_no_NA$TrailingPE,
     xlab="ESG Risk Rating",
     ylab="Trailing PE Ratio",
     main="ESG Risk Rating vs. Trailing PE Ratio"
)
# add trendline 
no_NA_tpe_lm = lm(TrailingPE ~ ESGRiskRating, data=esg_pe_data_no_NA)
summary(no_NA_tpe_lm)
abline(tpe_lm, col="orange")
# add R2 value
legend("topright", bty="n", legend=paste("R2 is", format(summary(no_NA_tpe_lm)$adj.r.squared, digits=4))) #R2=0.007008

###########################################################
# ESG Risk Rating vs. 2024 Actual PE Ratio lin regression #
####################### NAs as Median #####################
###########################################################
plot(x=esg_pe_data$ESGRiskRating, y=esg_pe_data$X2024ActualPE,
     xlab="ESG Risk Rating",
     ylab="2024 Actual PE Ratio",
     main="ESG Risk Rating vs. 2024 Actual PE Ratio"
)
# add trendline 
pe_lm = lm(X2024ActualPE ~ ESGRiskRating, data=esg_pe_data)
summary(pe_lm)
abline(pe_lm, col="green")
# add R2 value
legend("topright", bty="n", legend=paste("R2 is", format(summary(pe_lm)$adj.r.squared, digits=4))) #R2=-0.01561

###########################################################
# ESG Risk Rating vs. 2024 Actual PE Ratio lin regression #
########################## No NAs #########################
###########################################################
plot(x=esg_pe_data_no_NA$ESGRiskRating, y=esg_pe_data_no_NA$X2024ActualPE,
     xlab="ESG Risk Rating",
     ylab="2024 Actual PE Ratio",
     main="ESG Risk Rating vs. 2024 Actual PE Ratio"
)
# add trendline 
no_NA_pe_lm = lm(X2024ActualPE ~ ESGRiskRating, data=esg_pe_data_no_NA)
summary(no_NA_pe_lm)
abline(no_NA_pe_lm, col="purple")
# add R2 value
legend("topright", bty="n", legend=paste("R2 is", format(summary(no_NA_pe_lm)$adj.r.squared, digits=4))) #R2=-0.01744


###################
###################
# trying ggplot for ESG Risk Rating vs. Trailing PE Ratio linear regression
install.packages("ggplot2")
library(ggplot2)
plot = ggplot(esg_pe_data,aes(x=ESGRiskRating, y=TrailingPE))+
  geom_smooth(method="lm", color="blue") +
  ggtitle("ESG Risk Rating vs. Trailing PE Ratio")
plot(plot)
