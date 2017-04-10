#Script para sacar la mediana de la cobertura
library(ggplot2)
library(parallel)
library(doMC)
registerDoMC(cores = 5)

Inputs<-commandArgs(trailingOnly=TRUE)

coverageFile <-read.delim(Inputs[1],header = F) #read.delim("/hpcfs/home/ciencias/biologia/docentes/a.reyes/Investigacion/Leonardo/MOAFT/19.cleanReads/Bowtie/samBam/readsBacteria.1.sorted.coverage", header=F) 
lengthFile <- read.delim(Inputs[2],header = F) #read.delim("/hpcfs/home/ciencias/biologia/docentes/a.reyes/Investigacion/Leonardo/MOAFT/19.cleanReads/splitBacteriaGenomes/lengthSeq.1", header =F)
colnames(coverageFile) <- c("genomeID","position","cov")
colnames(lengthFile) <- c("genomeID","len")

genomes <- c()
rank <- c()
coverage <-c()
contador <- 1
for (i in lengthFile$genomeID){
  print(i)
  if(i%in%coverageFile$genomeID){
    genome <- rep(i,lengthFile$len[contador])
    position <- data.frame(1:lengthFile$len[contador])
    colnames(position) <- "position"
    observedCoverage <- subset(coverageFile,coverageFile==i)
    totalCoverage <- merge(position, observedCoverage,by="position",all.x=T)
    nas <- which(is.na(totalCoverage$cov))
    totalCoverage$cov[nas]<- 0
    totalCoverage$cov <- sort(totalCoverage$cov,decreasing = T)
    genomes <- append(genome,genomes,after=0)
    rank <- append(position,genomes,after=0)
    coverage <- append(totalCoverage$cov,coverage,after=0)
    contador <- contador+1
  }
  else{
    genome <- rep(i,lengthFile$len[contador])
    position <- data.frame(1:lengthFile$len[contador])
    rank <- append(position,genomes,after=0)
    genomes <- append(genome,genomes,after=0)
    a <- rep(0,lengthFile$len[contador])
    coverage <- append(a,coverage,after=0)
    contador <- contador+1
  }
}

rank_coverage <- data.frame(genomes,coverage,rank)
colnames(rank_coverage) <- c("genomeID","Coverage","Rank")
write.table(rank_coverage,file = Inputs[3],row.names = F,col.names = F, quote = F, sep = "\t")

#Parte 2 
library(ggplot2)
catFiles <-

ggplot(rank_coverage,aes(rank,coverage,group=genomes)) + geom_line()  geom_line() +geom_point(size=0.3) + xlab("Rank")
ggplot(rank_coverage,aes(rank,coverage,group=genomes, colour=genomes)) + geom_line()  geom_line() +geom_point(size=0.3) + xlab("Rank")