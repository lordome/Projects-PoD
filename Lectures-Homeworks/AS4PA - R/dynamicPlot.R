library(tidyverse)
library(lubridate)
library(gridExtra)
library(grid)
library(ggplot2)
library(lattice)
vecp <- rep(1/6,6)
vecp
vboxs <- c(0,1/5, 2/5, 3/5, 4/5, 5/5)
out <- matrix(NA, nrow=0, ncol=6)
iter <- 1
iter
n1 <- -1
n1
while(!(n1 == 1 || n1 == 0)){
    n1<-as.integer(readline(prompt="Enter box number 0 Black - 1 White - 999 to quit:" ))
    if(n1 == 999){
break
  }
    message(n1)
    norm <- 0
    for (i in 1:6){
    norm <- norm + vecp[i]*(vboxs[i] * n1 + (1-n1)*(1-vboxs[i]))
    } 
    for (i in 1:6){
    vecp[i] <- vecp[i]*(vboxs[i] * n1 + (1-n1)*(1-vboxs[i]))/ norm 
    }
    message("The probabilities for each box:", vecp)
    out <- rbind(out, vecp)
    n1 <- -1
	
	par(mfrow = c(2, 3))
	options(repr.plot.width=15, repr.plot.height=10)
	xs = seq(1,length(out[,1]))
	colors = c("blue", "red", "purple", "firebrick", "black", "green")
	for (i in 1:6){
		plot(xs, out[,i], xlab = "Extraction number", ylab = paste0("Probability of H", i-1), ylim = c(0,1), col = colors[i], pch="+", cex = 3)
	}	
}
out
par(mfrow = c(2, 3))
options(repr.plot.width=15, repr.plot.height=10)
xs = seq(1,length(out[,1]))
colors = c("blue", "red", "purple", "firebrick", "black", "green")
for (i in 1:6){
    plot(xs, out[,i], xlab = "Extraction number", ylab = paste0("Probability of H", i-1), ylim = c(0,1), col = colors[i], pch="+", cex = 3)
}
q()
