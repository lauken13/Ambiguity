
Tokens_HDI<-function(x,n.pts, n.unobs){
  #Model for CI
  jagsString1<-
    "model{
  a ~ dunif(0,10)
  b ~ dunif(0,10)
  p ~ dbeta(a,b)
  for (i in 1:n.pts){
  x[i] ~ dbinom(p,n.unobs[i])
  }
}"
  
  jagsData <- list(
    x = x,
    n.pts = n.pts,
    n.unobs = n.unobs
  )
  
  jagsModel <- jags.model(
    file = textConnection(jagsString1),
    data = jagsData,
    n.adapt = 1000,
    quiet =TRUE
  )
  
  samples <- jags.samples(
    model = jagsModel,
    variable.names = "p",
    n.iter = 5000,
    thin = 5
  )
  }

data.clean1<-data.clean[data.clean$AmbiguityCondition!='No Ambiguity',]

social.cond<-rep(0,nrow(data.clean1))  
social.cond[data.clean1$socialCond=="helpful"]=1
social.cond[data.clean1$socialCond=="malic"]=2
social.cond[data.clean1$socialCond=="neutral"]=3

ambig.cond<-rep(0,nrow(data.clean1))  
ambig.cond[data.clean1$AmbiguityCondition=="50% Neutral Ambiguity"]=1
ambig.cond[data.clean1$AmbiguityCondition=="75% Positive Ambiguity"]=2
ambig.cond[data.clean1$AmbiguityCondition=="75% Neutral Ambiguity"]=3
ambig.cond[data.clean1$AmbiguityCondition=="75% Negative Ambiguity"]=4
ambig.cond[data.clean1$AmbiguityCondition=="Full Ambiguity"]=5

x.obs<-rep(0,nrow(data.clean1))  
x.obs[ambig.cond==1]<-2
x.obs[ambig.cond==2]<-2
x.obs[ambig.cond==3]<-1
x.obs[ambig.cond==4]<-0
x.obs[ambig.cond==5]<-0

n.obs<-rep(0,nrow(data.clean1))  
n.obs[ambig.cond==1]<-4
n.obs[ambig.cond==2]<-2
n.obs[ambig.cond==3]<-2
n.obs[ambig.cond==4]<-2
n.obs[ambig.cond==5]<-0

n.unobs<-rep(0,nrow(data.clean1))  
n.unobs[ambig.cond==1]<-4
n.unobs[ambig.cond==2]<-6
n.unobs[ambig.cond==3]<-6
n.unobs[ambig.cond==4]<-6
n.unobs[ambig.cond==5]<-8

data.clean1$unobs<-n.unobs

data.clean1$obs<-x.obs

#First Figure, Group by Ambiguity and Decision

data.AmbiguousProp<-data.clean1 %>%
  filter(AmbiguityCondition %in% c('75% Neutral Ambiguity', '50% Neutral Ambiguity','Full Ambiguity')) %>%
  mutate(BlueEstimateProp=BlueEstimate/unobs) %>%
  group_by(AmbiguityCondition,Ambiguity,obs,unobs) %>%
  summarise(BlueEstimate=sum(BlueEstimateProp)/n())%>%
  ungroup()

data.AmbiguousProp$ci.low<-rep(0,nrow(data.AmbiguousProp))
data.AmbiguousProp$ci.high<-rep(0,nrow(data.AmbiguousProp))

for(i in 1:nrow(data.AmbiguousProp)){
  data.tmp<-data.clean1$BlueEstimate[data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i]]
  samples<-Tokens_HDI(data.tmp,length(data.tmp),data.clean1$unobs[data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i]])
  data.AmbiguousProp$ci.low[i]<-hdi(samples)$p[1]
  data.AmbiguousProp$ci.high[i]<-hdi(samples)$p[2]
}

data.AmbiguousProp$ci.low<-data.AmbiguousProp$ci.low*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$ci.high<-data.AmbiguousProp$ci.high*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$BlueEstimate<-data.AmbiguousProp$BlueEstimate*data.AmbiguousProp$unobs+data.AmbiguousProp$obs

data.AmbiguousProp$Ambiguity<-as.factor(data.AmbiguousProp$Ambiguity)
levels(data.AmbiguousProp$Ambiguity)<-c('Chose Non-Ambiguous','Chose Ambigouous')


ggplot(data.AmbiguousProp, aes(x=Ambiguity, y=BlueEstimate)) +
  geom_bar(stat="identity",colour="black") +theme_bw()+facet_grid(.~AmbiguityCondition)+
  scale_fill_manual(name="",values=c("#525252","#969696","#d9d9d9"))+
  labs(x='Choice Made',y='Average Estimated Proportion of Blue tokens')+
  geom_hline(yintercept=4,linetype="dashed", size=1.5)+
  geom_errorbar(aes(ymax=ci.high,ymin=ci.low),width=.25,size=1)+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=15,face="bold"),
        legend.text=element_text(size=22),
        strip.text.x = element_text(size = 20,face='bold'))+scale_y_continuous(breaks=seq(0,8,1),limits=c(0,8))
ggsave(file='Amy_Figure1.png')

#Second Figure, , Group by Ambiguity and Decision

data.AmbiguousProp<-data.clean1 %>%
  filter(AmbiguityCondition %in% c('75% Negative Ambiguity', '75% Neutral Ambiguity','75% Positive Ambiguity')) %>%
  mutate(BlueEstimateProp=BlueEstimate/unobs) %>%
  group_by(AmbiguityCondition,Ambiguity,obs, unobs) %>%
  summarise(BlueEstimate=sum(BlueEstimateProp)/n())%>%
  ungroup()

data.AmbiguousProp$ci.low<-rep(0,nrow(data.AmbiguousProp))
data.AmbiguousProp$ci.high<-rep(0,nrow(data.AmbiguousProp))

for(i in 1:nrow(data.AmbiguousProp)){
  data.tmp<-data.clean1$BlueEstimate[data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i]]
  samples<-Tokens_HDI(data.tmp,length(data.tmp),data.clean1$unobs[data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i]])
  data.AmbiguousProp$ci.low[i]<-hdi(samples)$p[1]
  data.AmbiguousProp$ci.high[i]<-hdi(samples)$p[2]
}


data.AmbiguousProp$ci.low<-data.AmbiguousProp$ci.low*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$ci.high<-data.AmbiguousProp$ci.high*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$BlueEstimate<-data.AmbiguousProp$BlueEstimate*data.AmbiguousProp$unobs+data.AmbiguousProp$obs


data.AmbiguousProp$Ambiguity<-as.factor(data.AmbiguousProp$Ambiguity)
levels(data.AmbiguousProp$Ambiguity)<-c('Chose Non-Ambiguous','Chose Ambigouous')


ggplot(data.AmbiguousProp, aes(x=Ambiguity, y=BlueEstimate)) +
  geom_bar(stat="identity",colour="black") +theme_bw()+facet_grid(.~AmbiguityCondition)+
  scale_fill_manual(name="",values=c("#525252","#969696","#d9d9d9"))+
  labs(x='Choice Made',y='Average Estimated Proportion of Blue tokens')+
  geom_hline(yintercept=4,linetype="dashed", size=1.5)+
  geom_errorbar(aes(ymax=ci.high,ymin=ci.low),width=.25,size=1)+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=15,face="bold"),
        legend.text=element_text(size=22),
        strip.text.x = element_text(size = 20,face='bold'))+scale_y_continuous(breaks=seq(0,8,1),limits=c(0,8))
ggsave(file='Amy_Figure2.png')

#Third Figure, Group by Ambiguity, Social Condition and Decision

data.AmbiguousProp<-data.clean1 %>%
  filter(AmbiguityCondition %in% c('50% Neutral Ambiguity','75% Neutral Ambiguity','Full Ambiguity')) %>%
mutate(BlueEstimateProp=BlueEstimate/unobs) %>%
  group_by(socialCond, AmbiguityCondition,Ambiguity,obs, unobs) %>%
  summarise(BlueEstimate=sum(BlueEstimateProp)/n())%>%
  ungroup()

data.AmbiguousProp$ci.low<-rep(0,nrow(data.AmbiguousProp))
data.AmbiguousProp$ci.high<-rep(0,nrow(data.AmbiguousProp))

for(i in 1:nrow(data.AmbiguousProp)){
  data.tmp<-data.clean1$BlueEstimate[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i] & data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i]]
  samples<-Tokens_HDI(data.tmp,length(data.tmp),data.clean1$unobs[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i]& data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i]])
  data.AmbiguousProp$ci.low[i]<-hdi(samples)$p[1]
  data.AmbiguousProp$ci.high[i]<-hdi(samples)$p[2]
}


data.AmbiguousProp$ci.low<-data.AmbiguousProp$ci.low*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$ci.high<-data.AmbiguousProp$ci.high*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$BlueEstimate<-data.AmbiguousProp$BlueEstimate*data.AmbiguousProp$unobs+data.AmbiguousProp$obs


data.AmbiguousProp$Ambiguity<-as.factor(data.AmbiguousProp$Ambiguity)
levels(data.AmbiguousProp$Ambiguity)<-c('Chose Non-Ambiguous','Chose Ambigouous')

data.AmbiguousProp$socialCond=factor(data.AmbiguousProp$socialCond, levels = c("helpful","neutral","malic"))
levels(data.AmbiguousProp$socialCond) <-c('Helpful','Neutral', 'Malicious')


ggplot(data.AmbiguousProp, aes(x=Ambiguity, y=BlueEstimate,group=socialCond,fill=socialCond)) +
  geom_bar(stat="identity",position=position_dodge(),colour="black") +theme_bw()+facet_grid(.~AmbiguityCondition)+
  scale_fill_manual(name="",values=c("#525252","#969696","#d9d9d9"))+
  labs(x='Choice Made',y='Average Estimated Proportion of Blue tokens')+
  geom_hline(yintercept=4,linetype="dashed", size=1.5)+
  geom_errorbar(aes(ymax=ci.high,ymin=ci.low),width=.25,size=1,position=position_dodge(width=.9))+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=15,face="bold"),
        legend.text=element_text(size=22),
        strip.text.x = element_text(size = 20,face='bold'))+scale_y_continuous(breaks=seq(0,8,1),limits=c(0,8))
ggsave(file='Amy_Figure3.png')

#Fourth Figure, Group by Social Condition and Decision

data.AmbiguousProp<-data.clean1 %>%
  mutate(BlueEstimateProp=BlueEstimate/unobs) %>%
  group_by(socialCond, Ambiguity) %>%
  summarise(BlueEstimate=sum(BlueEstimateProp)/n())%>%
  ungroup()

data.AmbiguousProp$ci.low<-rep(0,nrow(data.AmbiguousProp))
data.AmbiguousProp$ci.high<-rep(0,nrow(data.AmbiguousProp))

for(i in 1:nrow(data.AmbiguousProp)){
  data.tmp<-data.clean1$BlueEstimate[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i]]
  samples<-Tokens_HDI(data.tmp,length(data.tmp),data.clean1$unobs[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$Ambiguity==data.AmbiguousProp$Ambiguity[i]])
  data.AmbiguousProp$ci.low[i]<-hdi(samples)$p[1]
  data.AmbiguousProp$ci.high[i]<-hdi(samples)$p[2]
}

data.AmbiguousProp$Ambiguity<-as.factor(data.AmbiguousProp$Ambiguity)
levels(data.AmbiguousProp$Ambiguity)<-c('Chose Non-Ambiguous','Chose Ambigouous')


ggplot(data.AmbiguousProp, aes(x=Ambiguity, y=BlueEstimate)) +
  geom_bar(stat="identity",colour="black") +theme_bw()+facet_grid(.~socialCond)+
  scale_fill_manual(name="",values=c("#525252","#969696","#d9d9d9"))+
  labs(x='Choice Made',y='Average Estimated Proportion of Blue tokens')+
  geom_hline(yintercept=.5,linetype="dashed", size=1.5)+
  geom_errorbar(aes(ymax=ci.high,ymin=ci.low),width=.25,size=1)+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=15,face="bold"),
        legend.text=element_text(size=22),
        strip.text.x = element_text(size = 20,face='bold'))+scale_y_continuous(breaks=seq(0,1,.1),limits=c(0,1))
ggsave(file='Amy_Figure4.png')

#Fifth Figure, Group by Ambiguity, Social Condition

data.AmbiguousProp<-data.clean1 %>%
  filter(AmbiguityCondition %in% c('50% Neutral Ambiguity','75% Neutral Ambiguity','Full Ambiguity')) %>%
  mutate(BlueEstimateProp=BlueEstimate/unobs) %>%
  group_by(socialCond, AmbiguityCondition,obs, unobs) %>%
  summarise(BlueEstimate=sum(BlueEstimateProp)/n())%>%
  ungroup()

data.AmbiguousProp$ci.low<-rep(0,nrow(data.AmbiguousProp))
data.AmbiguousProp$ci.high<-rep(0,nrow(data.AmbiguousProp))

for(i in 1:nrow(data.AmbiguousProp)){
  data.tmp<-data.clean1$BlueEstimate[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i]]
  samples<-Tokens_HDI(data.tmp,length(data.tmp),data.clean1$unobs[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i]])
  data.AmbiguousProp$ci.low[i]<-hdi(samples)$p[1]
  data.AmbiguousProp$ci.high[i]<-hdi(samples)$p[2]
}


data.AmbiguousProp$ci.low<-data.AmbiguousProp$ci.low*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$ci.high<-data.AmbiguousProp$ci.high*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$BlueEstimate<-data.AmbiguousProp$BlueEstimate*data.AmbiguousProp$unobs+data.AmbiguousProp$obs

data.AmbiguousProp$socialCond=factor(data.AmbiguousProp$socialCond, levels = c("helpful","neutral","malic"))
levels(data.AmbiguousProp$socialCond) <-c('Helpful','Neutral', 'Malicious')


head(data.AmbiguousProp)

ggplot(data.AmbiguousProp, aes(x=socialCond, y=BlueEstimate,fill=socialCond)) +
  geom_bar(stat="identity",colour="black") +theme_bw()+facet_grid(.~AmbiguityCondition)+
  scale_fill_manual(name="",values=c("#525252","#969696","#d9d9d9"))+
  labs(x='Social Condition',y='Average Estimated Proportion of Blue tokens')+
  geom_hline(yintercept=4,linetype="dashed", size=1.5)+
  geom_errorbar(aes(ymax=ci.high,ymin=ci.low),width=.25,size=1)+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=15,face="bold"),
        legend.text=element_text(size=22),
        strip.text.x = element_text(size = 20,face='bold'))+scale_y_continuous(breaks=seq(0,8,1),limits=c(0,8))
ggsave(file='Amy_Figure5.png')

#Sixth Figure, Group by Ambiguity, Social Condition

data.AmbiguousProp<-data.clean1 %>%
  filter(AmbiguityCondition %in% c('75% Negative Ambiguity','75% Neutral Ambiguity','75% Positive Ambiguity')) %>%
  mutate(BlueEstimateProp=BlueEstimate/unobs) %>%
  group_by(socialCond, AmbiguityCondition,obs, unobs) %>%
  summarise(BlueEstimate=sum(BlueEstimateProp)/n())%>%
  ungroup()

data.AmbiguousProp$ci.low<-rep(0,nrow(data.AmbiguousProp))
data.AmbiguousProp$ci.high<-rep(0,nrow(data.AmbiguousProp))

for(i in 1:nrow(data.AmbiguousProp)){
  data.tmp<-data.clean1$BlueEstimate[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i]]
  samples<-Tokens_HDI(data.tmp,length(data.tmp),data.clean1$unobs[data.clean1$socialCond==data.AmbiguousProp$socialCond[i] & data.clean1$AmbiguityCondition==data.AmbiguousProp$AmbiguityCondition[i]])
  data.AmbiguousProp$ci.low[i]<-hdi(samples)$p[1]
  data.AmbiguousProp$ci.high[i]<-hdi(samples)$p[2]
}

data.AmbiguousProp$ci.low<-data.AmbiguousProp$ci.low*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$ci.high<-data.AmbiguousProp$ci.high*data.AmbiguousProp$unobs+data.AmbiguousProp$obs
data.AmbiguousProp$BlueEstimate<-data.AmbiguousProp$BlueEstimate*data.AmbiguousProp$unobs+data.AmbiguousProp$obs

data.AmbiguousProp$socialCond=factor(data.AmbiguousProp$socialCond, levels = c("helpful","neutral","malic"))
levels(data.AmbiguousProp$socialCond) <-c('Helpful','Neutral', 'Malicious')


ggplot(data.AmbiguousProp, aes(x=socialCond, y=BlueEstimate,fill=socialCond)) +
  geom_bar(stat="identity",colour="black") +theme_bw()+facet_grid(.~AmbiguityCondition)+
  scale_fill_manual(name="",values=c("#525252","#969696","#d9d9d9"))+
  labs(x='Social Condition',y='Average Estimated Proportion of Blue tokens')+
  geom_hline(yintercept=4,linetype="dashed", size=1.5)+
  geom_errorbar(aes(ymax=ci.high,ymin=ci.low),width=.25,size=1)+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=15,face="bold"),
        legend.text=element_text(size=22),
        strip.text.x = element_text(size = 20,face='bold'))+scale_y_continuous(breaks=seq(0,8,1),limits=c(0,8))
ggsave(file='Amy_Figure6.png')


