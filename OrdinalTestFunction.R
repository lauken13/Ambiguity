#Models:
# 1: p1=p2=p3
# 2: p1<p2<p3
# 3: p1, p2, p3 independent

Ordinal.Test<-function(s1,s2,s3,f1,f2,f3){
  #s1 is number of successes in sample 1 etc
  #f1 is total number of failures in 1 etc
  #Model 1 (Simplest case)
  x_p.m1<-0
  p_m.m1-0
  x_m.m1<-0
  n.grid<-length(seq(0.01,.99,.01))
  for (p in seq(0.01,.99,.01)){
    x1_p<-dbinom(s1,f1+s1,p)
    x2_p<-dbinom(s2,s2+f2,p)
    x3_p<-dbinom(s3,s3+f3,p)
    
    x_p.m1<-x1_p*x2_p*x3_p
    p_m.m1<-1/length(seq(0.01,.99,.01))
    x_m.m1<-x_m.m1+x_p.m1*p_m.m1
  }
  #i.e. probability s1, s2, s3 drawn from model 1 is s_max
  
  
  #Model 2 (Middle case)
  x_p.m2<-0
  p_m.m2<-0
  x_m.m2<-0
  nCount<-166650
  for (p1 in seq(0.01,.99,.01)){
    for (p2 in seq(p1,.99,.01)){
      for (p3 in seq(p2,.99,.01)){
        x1_p1<-dbinom(s1,f1+s1,p1)
        x2_p2<-dbinom(s2,s2+f2,p2)
        x3_p3<-dbinom(s3,s3+f3,p3)
        nCount<-nCount+1
        x_p.m2<-x1_p1*x2_p2*x3_p3
        p_m.m2<-1/nCount
        x_m.m2<-x_m.m2+x_p.m2*p_m.m2
        
      }
    }
  }
  
  
  #Model 3 (Longest case)
  x_p.m3<-0
  p_m.m3<-c(0,0,0)
  x_m.m3<-0
  n.grid<-length(seq(0.01,.99,.01))^3
  x_full.m3<-array(0,c(99,99,99))
  for (p1 in seq(0.01,.99,.01)){
    for (p2 in seq(0.01,.99,.01)){
      for (p3 in seq(0.01,.99,.01)){
        x1_p1<-dbinom(s1,f1+s1,p1)
        x2_p2<-dbinom(s2,s2+f2,p2)
        x3_p3<-dbinom(s3,s3+f3,p3)
        
        x_p.m3<-x1_p1*x2_p2*x3_p3
        p_m.m3<-1/n.grid
        x_m.m3<-x_m.m3+x_p.m3*p_m.m3
      }
    }
  }
  print(paste("Bayesfactor Ordinal Compared to No Diff:",x_m.m2/x_m.m1))
  print(paste("Bayesfactor Ordinal Compared to all Free:",x_m.m2/x_m.m3))
  print(paste("Bayesfactor all Free Compared to No Diff:",x_m.m3/x_m.m1))
  return(c(x_m.m1,x_m.m2,x_m.m3))
}

