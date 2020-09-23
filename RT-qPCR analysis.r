#Import table
rawTable<-read.table("C:/Users/xxx/type_your_file_path.csv",header=T,sep = ";", dec=",")						
attach(rawTable)			
na.rm=TRUE	
rawTable

#name vehicle group
veh<-readline(prompt="Enter name of reference group: ")
outAnalysis <- readline(prompt="Do you want to remove outliers? type YES or NO?: ")
duplicates <- readline(prompt="Do you want to calculate mean of duplicates? type YES or NO: ")

##OPTIONAL calculate means of duplicates
if (duplicates == "YES"){
geneOfInterest <- names(rawTable[2])
geneReference <- names(rawTable[4])
meanReferenceGene<-data.frame(rawTable[[2]],rawTable[[3]])
meanReferenceGene<-rowMeans(meanReferenceGene, na.rm=TRUE	)
meanGeneOfInterest<-data.frame(rawTable[[4]],rawTable[[5]])
meanGeneOfInterest<-rowMeans(meanGeneOfInterest, na.rm=TRUE)
newNames <- c("treatment", geneOfInterest, geneReference)
rawTable<-data.frame(rawTable[[1]], meanReferenceGene, meanGeneOfInterest)
names(rawTable)<-newNames
}
rawTable

#Asign target and reference gene
referenceGene <- c(rawTable[[2]])
targetGene <- c(rawTable[[3]])

#Calculate dCT
dCT=targetGene-referenceGene
rawTable=cbind(rawTable,dCT)

#Mean dCT for reference gene
y <- rawTable$treatment==veh
dCTmean<- rawTable[y,]
dCTmean<- c(dCTmean$dCT)
dCTmean <- mean(dCTmean)

#calculate ddCT
x<-c(rawTable$dCT)
ddCT<-x-dCTmean
rawTable=cbind(rawTable,ddCT)

#calculate fold change
y<-c(rawTable$ddCT)
foldChange<-2^(-y)
rawTable=cbind(rawTable,foldChange)

#Defining variables for group analysis - fold change and statistics 
groups<-unique(rawTable$treatment)
mean_Fold_Change=c()
sd_Fold_Change=c()
N=c()
SEM=c()
min=c()
max=c()
normality_P=c()
analysedTable<-rawTable
tableLength<-1:length(rawTable$foldChange)

#Calculate outliers
outlier=c()
outlierPosition=c()
for (name in groups){
y <- rawTable$treatment==name
x <- rawTable[y,]
out <- boxplot(x$foldChange, plot=FALSE)$out
out_ind <- which(rawTable$foldChange %in% out)
outlierPosition<-append(outlierPosition, out_ind)
}
for (i in tableLength){
if (i %in% outlierPosition){
outlier <- append(outlier, TRUE)
} else {
outlier <- append(outlier, FALSE)
}
} 

analysedTable<-cbind(analysedTable, outlier)
#OPTIONAL remove outliers
if (outAnalysis=="YES"){
outName="_outlier"
rawTable<-subset(analysedTable, outlier==FALSE)
} else{
outName=""
}

for (name in groups){
y <- rawTable$treatment==name
x <- rawTable[y,]
mean_Fold_Change<-append(mean_Fold_Change, mean(x$foldChange))
sd_Fold_Change<-append(sd_Fold_Change, sd(x$foldChange))
N<-append(N, length(x$foldChange))
SEM<-append(SEM, sd(x$foldChange)/sqrt(length(x$foldChange)))
min<-append(min, min(x$foldChange))
max<-append(max,max(x$foldChange))
shapiro=shapiro.test(x$foldChange)
normality_P<-append(normality_P, shapiro$p.value)
}
DT<-data.frame(groups,mean_Fold_Change,SEM, N, min, max, sd_Fold_Change, normality_P)

#calculate ANOVA
foldChangeStat<-aov(foldChange~treatment)
anova<-summary(foldChangeStat)
fileNameAnova=paste(names(rawTable[3]),"_ANOVA",outName,".txt",sep="")
capture.output(anova, file = fileNameAnova)

#calculate Tukey
tukey=TukeyHSD(foldChangeStat)
tukey<-data.frame(tukey$treatment)
tukey

#make graph
maxY=max(rawTable$foldChange)
fileNameJpg=paste(names(rawTable[3]),outName,".jpeg",sep="")
library(beeswarm)					
jpeg(file=fileNameJpg)					
beeswarm(rawTable$foldChange~rawTable$treatment, method="center", col=yarrr::piratepal("southpark"), pch=16, ylab="Fold Change", ylim = c(0, maxY+1),  xlab="")
axis(1, labels=FALSE)
title(main=names(rawTable[3]))					
dev.off()
			
#write XLSX
library(xlsx)
xlsName<-paste(names(rawTable[3]),outName,"_analysis",".xlsx",sep="")
write.xlsx(analysedTable, xlsName, sheetName = "ddCT", 
  col.names = TRUE, row.names = TRUE, append = TRUE)
write.xlsx(DT, xlsName, sheetName = "results", 
  col.names = TRUE, row.names = TRUE, append = TRUE)
write.xlsx(tukey, xlsName, sheetName = "tukey", 
  col.names = TRUE, row.names = TRUE, append = TRUE)

