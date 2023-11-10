library(doParallel)
library(tweedie) 
library(ggplot2)

simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 


# Assignment 2:  
MTweedieTests <-  
  function(N,M,sig){ 
    sum(replicate(M,simTweedieTest(N)) < sig)/M 
  } 


# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 


maxcores <- 6
# Detect number of cores
cores <- min(detectCores(), maxcores)

# Register parallel backend
cl <- makeCluster(cores)
registerDoParallel(cl)

# Parallelize the loop using foreach and %dopar%
df$share_reject <- foreach(i = 1:nrow(df), .combine = 'c') %dopar% {
  # Load the tweedie package within the parallelized block
  library(tweedie)
  MTweedieTests(df$N[i], df$M[i], 0.05)
}

# Stop parallel cluster
stopCluster(cl)

