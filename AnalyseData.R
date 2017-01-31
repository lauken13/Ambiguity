data.clean1<-data.clean[data.clean$AmbiguityCondition!='No Ambiguity',]
data.clean1$AmbiguityCondition<-droplevels(data.clean1$AmbiguityCondition)
#####Analysis 1#####

analysis_1<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity',]
analysis_1$AmbiguityCondition<-droplevels(analysis_1$AmbiguityCondition)

table1<-table(analysis_1$socialCond,analysis_1$Ambiguity)
chisq.test(table1)

#####Analysis 2#####
#positive
analysis_2<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity' & data.clean1$socialCond=='helpful',]
analysis_2$AmbiguityCondition<-droplevels(analysis_2$AmbiguityCondition)

table2<-table(analysis_2$Ambiguity)
t2<-chisq.test(table2)
p2<-t2$p.value

#neutral
analysis_3<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity' & data.clean1$socialCond=='neutral',]
analysis_3$AmbiguityCondition<-droplevels(analysis_3$AmbiguityCondition)

table3<-table(analysis_3$Ambiguity)
t3<-chisq.test(table3)
p3<-t3$p.value

#malic
analysis_4<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity' & data.clean1$socialCond=='malic',]
analysis_4$AmbiguityCondition<-droplevels(analysis_4$AmbiguityCondition)

table4<-table(analysis_4$Ambiguity)
t4<-chisq.test(table4)
p4<-t4$p.value
p.adjust(p=c(p2,p3,p4),method='holm')

#####Analysis 3##### Are the neutral and neg conditions showinf the same level on ambiguity aversion? YES
#positive
analysis_3<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity' & data.clean1$socialCond!='helpful',]
analysis_3$AmbiguityCondition<-droplevels(analysis_3$AmbiguityCondition)
analysis_3$socialCond<-droplevels(analysis_3$socialCond)


table3<-table(analysis_3$socialCond,analysis_3$Ambiguity)
t3<-chisq.test(table3)

#####Analysis 4##### Does Ambiguity impact social condition?
#neutral
analysis_4b<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity' & data.clean1$socialCond=='neutral',]
analysis_4b$AmbiguityCondition<-droplevels(analysis_4b$AmbiguityCondition)
analysis_4b$socialCond<-droplevels(analysis_4b$socialCond)


table4b<-table(analysis_4b$AmbiguityCondition,analysis_4b$Ambiguity)
table4b
t4b<-chisq.test(table4b)
#malic
analysis_4c<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity' & data.clean1$socialCond=='malic',]
analysis_4c$AmbiguityCondition<-droplevels(analysis_4c$AmbiguityCondition)
analysis_4c$socialCond<-droplevels(analysis_4c$socialCond)


table4c<-table(analysis_4c$AmbiguityCondition,analysis_4c$Ambiguity)
table4c
t4c<-chisq.test(table4c)
t4c

#####Analysis 5#####
#positive
analysis_5<-data.clean1[data.clean1$AmbiguityCondition!='75% Positive Ambiguity' & data.clean1$AmbiguityCondition!='75% Negative Ambiguity' & data.clean1$socialCond=='helpful',]
analysis_5$AmbiguityCondition<-droplevels(analysis_5$AmbiguityCondition)
analysis_5$socialCond<-droplevels(analysis_5$socialCond)


table5<-table(analysis_5$Ambiguity,analysis_5$AmbiguityCondition)
Ordinal.Test(17,14,12,8,5,1)
#####Analysis 6######

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

data.clean1$infer<-data.clean1$obs+data.clean1$BlueEstimate

analysis_6<-data.clean1[(data.clean1$AmbiguityCondition=='50% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='Full Ambiguity' | data.clean1$AmbiguityCondition=='75% Neutral Ambiguity') & data.clean1$socialCond=='helpful',]
analysis_6$AmbiguityCondition<-droplevels(analysis_6$AmbiguityCondition)
analysis_6$socialCond<-droplevels(analysis_6$socialCond)
t.test(analysis_6$infer,mu=4)


analysis_6b<-data.clean1[(data.clean1$AmbiguityCondition=='50% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='Full Ambiguity' | data.clean1$AmbiguityCondition=='75% Neutral Ambiguity') & data.clean1$socialCond=='neutral',]
analysis_6b$AmbiguityCondition<-droplevels(analysis_6b$AmbiguityCondition)
analysis_6b$socialCond<-droplevels(analysis_6b$socialCond)
t.test(analysis_6b$infer,mu=4)


analysis_6c<-data.clean1[(data.clean1$AmbiguityCondition=='50% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='Full Ambiguity' | data.clean1$AmbiguityCondition=='75% Neutral Ambiguity') & data.clean1$socialCond=='malic',]
analysis_6c$AmbiguityCondition<-droplevels(analysis_6c$AmbiguityCondition)
analysis_6c$socialCond<-droplevels(analysis_6c$socialCond)
t.test(analysis_6c$infer,mu=4)

#####Analysis 7########


analysis_7a<-data.clean1[(data.clean1$AmbiguityCondition=='50% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='Full Ambiguity') & data.clean1$socialCond=='helpful',]
analysis_7a$AmbiguityCondition<-droplevels(analysis_7a$AmbiguityCondition)
analysis_7a$socialCond<-droplevels(analysis_7a$socialCond)

table_7a<-table(analysis_7a$Ambiguity,analysis_7a$AmbiguityCondition)
t_7a<-chisq.test(table_7a,simulate.p.value = TRUE)
t_7a
test_7b<-t.test(infer~AmbiguityCondition, data=analysis_7a)

#####Analysis 8######## Does Distribution Information matter in positive?t
analysis_8<-data.clean1[(data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity' | data.clean1$AmbiguityCondition=='75% Neutral Ambiguity') & data.clean1$socialCond=='helpful',]
analysis_8$AmbiguityCondition<-droplevels(analysis_8$AmbiguityCondition)
analysis_8$socialCond<-droplevels(analysis_8$socialCond)


table8<-table(analysis_8$Ambiguity,analysis_8$AmbiguityCondition)
t8<-chisq.test(table8)

analysis_8b<-data.clean1[(data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity' | data.clean1$AmbiguityCondition=='75% Neutral Ambiguity') & data.clean1$socialCond=='malic',]
analysis_8b$AmbiguityCondition<-droplevels(analysis_8b$AmbiguityCondition)
analysis_8b$socialCond<-droplevels(analysis_8b$socialCond)


table8b<-table(analysis_8b$Ambiguity,analysis_8b$AmbiguityCondition)
t8b<-chisq.test(table8b)


analysis_8c<-data.clean1[(data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity' | data.clean1$AmbiguityCondition=='75% Neutral Ambiguity') & data.clean1$socialCond=='neutral',]
analysis_8c$AmbiguityCondition<-droplevels(analysis_8c$AmbiguityCondition)
analysis_8c$socialCond<-droplevels(analysis_8c$socialCond)


table8c<-table(analysis_8c$Ambiguity,analysis_8c$AmbiguityCondition)
t8c<-chisq.test(table8c)
Ordinal.Test(9,11,13,19,14,7)

######Table 9###### #Does inferred numbers increase with social condition?

analysis_9a<-data.clean1[(data.clean1$AmbiguityCondition=='75% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity') & c(data.clean1$socialCond=='helpful'),]
analysis_9a$AmbiguityCondition<-droplevels(analysis_9a$AmbiguityCondition)
analysis_9a$socialCond<-droplevels(analysis_9a$socialCond)

test_9a<-lm(infer~AmbiguityCondition, data=analysis_9a)


analysis_9b<-data.clean1[(data.clean1$AmbiguityCondition=='75% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity') & c(data.clean1$socialCond=='neutral'),]
analysis_9b$AmbiguityCondition<-droplevels(analysis_9b$AmbiguityCondition)
analysis_9b$socialCond<-droplevels(analysis_9b$socialCond)

test_9b<-lm(infer~AmbiguityCondition, data=analysis_9b)


analysis_9c<-data.clean1[(data.clean1$AmbiguityCondition=='75% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity') & c(data.clean1$socialCond=='malic'),]
analysis_9c$AmbiguityCondition<-droplevels(analysis_9c$AmbiguityCondition)
analysis_9c$socialCond<-droplevels(analysis_9c$socialCond)

test_9c<-lm(infer~AmbiguityCondition, data=analysis_9c)

###Test 10# Effect of cover story
analysis_10a<-data.clean1[(data.clean1$AmbiguityCondition=='75% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity') & c(data.clean1$socialCond=='helpful' | data.clean1$socialCond=='neutral'),]
analysis_10a$AmbiguityCondition<-droplevels(analysis_10a$AmbiguityCondition)
analysis_10a$socialCond<-droplevels(analysis_10a$socialCond)
summary(analysis_10a)

t.test(infer~socialCond, data=analysis_10a)


analysis_10b<-data.clean1[(data.clean1$AmbiguityCondition=='75% Neutral Ambiguity' | data.clean1$AmbiguityCondition=='75% Positive Ambiguity' | data.clean1$AmbiguityCondition=='75% Negative Ambiguity') & c(data.clean1$socialCond=='helpful' | data.clean1$socialCond=='malic'),]
analysis_10b$AmbiguityCondition<-droplevels(analysis_10b$AmbiguityCondition)
analysis_10b$socialCond<-droplevels(analysis_10b$socialCond)
summary(analysis_10b)

t.test(infer~socialCond, data=analysis_10b)
