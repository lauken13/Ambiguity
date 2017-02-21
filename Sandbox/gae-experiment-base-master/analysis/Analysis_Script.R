library(dplyr)
library(ggplot2)
library(tidyr)
load("~/GitHub/Ambiguity_Bias_Adults_Exp/Take2/gae-experiment-base-master/analysis/gae_data.RData")

data<-parsed_gae_data

data.clean<-data.frame(AmbiguityCondition=rep('A',nrow(data)))
data.clean$AmbiguityCondition<-as.character(data.clean$AmbiguityCondition)
data.clean$AmbiguityCondition[data$condition==0]<-rep('No Ambiguity',sum(data$condition==0))
data.clean$AmbiguityCondition[data$condition==8]<-'50% Neutral Ambiguity'
data.clean$AmbiguityCondition[data$condition==10]<-'25% Positive Ambiguity'
data.clean$AmbiguityCondition[data$condition==18]<-'25% Negative Ambiguity'
data.clean$AmbiguityCondition[data$condition==20]<-'Full Ambiguity'

data.clean$socialCond<-as.factor(data$socialCond)
data.clean$condition<-as.factor(data$condition)
data.clean$gender<-as.factor(data$gender)
data.clean$AmbiguityConditon<-as.factor(data.clean$AmbiguityCondition)
data.clean$BlueEstimate<-as.numeric(data$EstBlue)
data.clean$RedEstimate<-as.numeric(data$EstRed)
data.clean$OtherColours<-as.factor(data$OtherColors)
data.clean$OtherEstimate<-as.numeric(data$EstOther)
data.clean$Ambiguity<-rep(-1,nrow(data.clean))
data.clean$Ambiguity[data$ambiguous=="Y"]<-rep(1,sum(data$ambiguous=="Y"))
data.clean$Ambiguity[data$ambiguous=="N"]<-rep(1,sum(data$ambiguous=="N"))

str(data.clean)

#Visualise the data
data.grouped<-data.clean %>%
  group_by(socialCond, AmbiguityCondition) %>%
  summarise(AmbiguityProp=sum(Ambiguity)/n())%>%
  ungroup()

ggplot(data=data.grouped, aes(x=AmbiguityCondition, y=AmbiguityProp, fill=AmbiguityCondition)) +
  geom_bar(colour="black", stat="identity") +
  guides(fill=FALSE)+theme_bw()+facet_grid(.~socialCond)

data.AmbiguousOnly<-data.clean %>%
  filter(AmbiguityCondition!='No Ambiguity')%>%
  group_by(socialCond, AmbiguityCondition) %>%
  summarise(BlueEstimate=sum(BlueEstimate)/n(),RedEstimate=sum(RedEstimate)/n())%>%
  ungroup()

dataAmbigOnlyLong <- gather(data.AmbiguousOnly, ColourEstimate,Estimate, BlueEstimate,RedEstimate)
dataAmbigOnlyLong$Estimate<-as.factor(dataAmbigOnlyLong$Estimate)
dataAmbigOnlyLong$AmbiguityCondition<-as.factor(dataAmbigOnlyLong$AmbiguityCondition)

ggplot(dataAmbigOnlyLong, aes(x=AmbiguityCondition, y=Estimate, fill=ColourEstimate)) +
  geom_bar(stat="identity") +
  guides(fill=FALSE)+theme_bw()+facet_grid(.~socialCond)


model <- glm(Ambiguity ~AmbiguityCondition*socialCond,family=binomial(link='logit'),data=data.clean)
summary(model)
