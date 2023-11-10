library(parallel)
library(tweedie) 
library(ggplot2)

simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 


# Parallelized version of MTweedieTests
MTweedieTestsParallel <- function(N, M, sig) {
  maxcores <- 6
  # Detect number of cores
  cores <- min(detectCores(), maxcores)
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  
  
  pvalues <- foreach(i = 1:M, .combine = 'c') %dopar% {
    #simTweedieTest(N)
  }
  
  stopCluster(cl)
  sum(unlist(pvalues) < sig) / M
}


# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 


for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 
