## Linear model
c(0,0,0,1,1,1) -> A #category variables (ie 0 = control, 1 = treatment)
c(100,150,270,1200,890,950) -> B #number of reads example for a hit (3 replicates)
c(100,150,270,110,140,300) -> C #number of reads example for a non-hit (3 replicates)

# note that for this analysis to be meaningful the basic assumption must be that treatment and control are the same for the majority of cases (normalisation).
cbind(A,B,C) -> df
as.data.frame(df)
summary(lm(A~df[,2:3]))$coefficients[,4] #calculates the p values #the p-value. access other parameters with names(summary(lm..))

