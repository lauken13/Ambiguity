library(dplyr)
library(ggplot2)
library(tidyr)
library(HDInterval)
library(rjags)

load("~/Ambiguity Stuff/gae_data_AMT_2.RData")
data.AMT<-parsed_gae_data

data.AMT<-data.AMT%>%
  filter(age<100)%>%
  ungroup()

data.AMT<-data.AMT%>%
  filter(completionCode!='v4SXb#-Bs8RU' & 
         completionCode!='Ivar8#-mH4O5' & 
         completionCode!='YVwoP#-ZNNxC' & 
         completionCode!='sZTVU#-zxOZc' & 
         completionCode!='5odvC#-q7lu3' & 
         completionCode!='xbG3f#-iEZny' & 
         completionCode!='Yo8Sz#-JlBiG' & 
         completionCode!='sC1JW#-8FSe5' & 
         completionCode!='smBqn#-eYnvM' & 
         completionCode!='Mn42v#-7CrWi' & 
         completionCode!='VmBLT#-p41pf' & 
         completionCode!='dDtiD#-NNApx')%>%
  ungroup()

summary(data.AMT$age)
summary(as.factor((data.AMT$gender)))

load("~/Ambiguity Stuff/Students_ParsedGAEdata.RData")
data.students<-parsed_gae_data


data.students<-data.students%>%
  filter(age<100)%>%
  ungroup()

summary(data.students$age)
summary(as.factor(data.students$gender))

data.students<-data.students %>%
  select(EstBlue,        subjectID ,     testTrial ,     EstRed      ,   OtherColors ,  
          EstOther    ,   rt       ,      responseType   ,response  ,     experiment  ,  
         seenAmbig   ,  condition     ,
         ambiguous  ,    seenUnambig  ,  gender  ,       age         ,   completionCode,
         socialCond ,    country      ,  side  ,         block     ,     date,          
         key           )%>%
  ungroup()

data<-rbind(data.students, data.AMT)


data.clean<-data.frame(AmbiguityCondition=rep('A',nrow(data)))
data.clean$AmbiguityCondition<-as.character(data.clean$AmbiguityCondition)
data.clean$AmbiguityCondition[data$condition==0]<-rep('No Ambiguity',sum(data$condition==0))
data.clean$AmbiguityCondition[data$condition==8]<-'50% Neutral Ambiguity'
data.clean$AmbiguityCondition[data$condition==10]<-'75% Positive Ambiguity'
data.clean$AmbiguityCondition[data$condition==18]<-'75% Negative Ambiguity'
data.clean$AmbiguityCondition[data$condition==20]<-'Full Ambiguity'
data.clean$AmbiguityCondition[data$condition==14]<-'75% Neutral Ambiguity'

data.clean$socialCond<-as.factor(data$socialCond)
data.clean$condition<-as.factor(data$condition)
data.clean$gender<-as.factor(data$gender)
data.clean$age<-data$age
data.clean$AmbiguityCondition<-as.factor(data.clean$AmbiguityCondition)
data.clean$BlueEstimate<-as.numeric(data$EstBlue)
data.clean$RedEstimate<-as.numeric(data$EstRed)
data.clean$OtherColours<-as.factor(data$OtherColors)
data.clean$OtherEstimate<-as.numeric(data$EstOther)
data.clean$Ambiguity<-rep(-1,nrow(data.clean))
data.clean$Ambiguity[data$ambiguous=="Y"]<-rep(1,sum(data$ambiguous=="Y"))
data.clean$Ambiguity[data$ambiguous=="N"]<-rep(0,sum(data$ambiguous=="N"))

str(data.clean)

