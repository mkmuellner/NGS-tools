"C://Users//Markus//Dropbox (Phoremost)//PhoreMost_External_Informatics//Ras Synthetic Lethality Screen//Processed reads//" -> path

setwd(path)

list.files() -> A

#load all the files from Ras screen

read.table(A[1], stringsAsFactor = F) -> one
read.table(A[2], stringsAsFactor = F) -> two
read.table(A[3], stringsAsFactor = F) -> three
read.table(A[4], stringsAsFactor = F) -> four
read.table(A[5], stringsAsFactor = F) -> five
read.table(A[6], stringsAsFactor = F) -> six

## create a unique list from all files
unique(c(one[,1],two[,1],three[,1],four[,1],five[,1],six[,1])) -> uid #create masterlist of identifiers

# create bins
as.numeric(unlist(strsplit(uid, split = "-"))[c(FALSE,TRUE)]) -> num
unlist(strsplit(uid, split = "-"))[c(TRUE,FALSE)] -> genome
data.frame(genone=genome, pos=num, pos_s=num-5, pos_e=num +5) -> out

#split by genome
unique(out[,1]) -> genomelist

# process by genome
# this creates a list of bins
# takes quite a while to run through and generate that list though (about 20h or so)

collect <- data.frame(genome = genomelist[q],st=NA,en=NA)

for(q in 1:length(genomelist)){
print(as.character(genomelist[q]))
subset(out, out[,1] == genomelist[q]) -> sset

newstart <- sset[1,2]
for(z in 1:(nrow(sset)-1)){
sstart <- sset[z,3]
eend <- sset[z,4]
current <- sset[z,2]
nnext <- sset[z+1,2]

if(!(nnext < eend) & (nnext > sstart)) {
rbind(collect, data.frame(genome = genomelist[q], st = newstart, en = current)) -> collect
newstart <- nnext
}
}
}
write.table(collect[-1,], file = "binstable_Ras.txt") #save the file just to be sure
read.table(file = "binstable_Ras.txt", stringsAsFactors = F, header = T) -> collect

###############################
## now go through the files one by one and put reads into bins
## incredibly slow and unelegant probably needs a speed up

proc <- NULL
one -> proc
out <- NULL
num <- NULL

as.numeric(unlist(strsplit(proc[,1], split = "-"))[c(FALSE,TRUE)]) -> num
unlist(strsplit(proc[,1], split = "-"))[c(TRUE,FALSE)] -> genome
data.frame(genone=genome, pos=num, counts=proc[,2]) -> out

#output <- data.frame(genome = genomelist[q],pos=NA,counts = NA, bin=NA)

output <- data.frame(genome = genomelist[q],st=NA,en = NA, V4=NA)

for(q in 1:length(genomelist)){
print(as.character(genomelist[q]))
subset(out, out[,1] == as.character(genomelist[q])) -> sset #select one subset (one genome)
subset(collect, collect[,1] == as.character(genomelist[q])) -> colset #select the comparison table with the bins for the same genome


#for(i in 1:nrow(sset)){
#rbind(output, data.frame(genome = genomelist[q], pos = sset[i,2], counts = sset[i,3], bin = paste(colset[which.min(abs(sset[i,2] - colset[,2])),] ,collapse =""))) -> output
#}

values_df1 <- sset[,2]
df2 <- colset

result_list = lapply(values_df1, function(x){
  c(subset(df2, st <= x & en >= x),x)
})
result_df = data.frame(do.call(rbind, result_list))
output <- rbind(output, result_df)

}





