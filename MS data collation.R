#Collate MS data from known directory

#If you copy-paste a path in here from windows, make sure you replace the normal "\" slash to a "//". ie C:\Windows\ becomes C://Windows//
#The directory can not contain csv files that are not from the MS run.

f <- "C://Users//Markus//Dropbox (Phoremost)//Phoremost_Common//01_B_Screening Platform//Site Secure//MS Data//6TG bands - November2016//"

setwd(f)
file_list <- list.files(f, pattern = "*.csv")

global <- data.frame("","")
colnames(global) <- c("protein","emPAI")

for(i in 1:length(file_list)){
r <- NULL
read <- NULL
out <- data.frame("","","")
colnames(out) <- c("file","protein","emPAI")

scan(file_list[i], what = character(), sep = "\n", blank.lines.skip = FALSE) -> r #find which line contains the data
which(grepl("prot_hit_num",r)) -> firstline
no_col <- max(count.fields(file = file_list[i], skip = firstline-1, sep = ","))

read.csv(file_list[i], skip = firstline-1, stringsAsFactors = FALSE, fill = TRUE, col.names = 1:no_col, header = FALSE) -> read #find which line contains the data

colnames(read) <- as.character(read[1,])
colnames(read)[(length(colnames(read))-1):length(colnames(read))]<- c("EMP1","EMP2")

data.frame(file_list[i], read$prot_acc, read$EMP2) -> out
out[complete.cases(out),] -> out
colnames(out) <- c("file","protein",as.character(out[1,1]))


merge(global, out[,-1], all = TRUE, by.x = "protein", by.y = "protein") -> global
}

global[-1,-2] -> global

write.csv(global, file = "output_MS_6TG_08_12_2016.csv")