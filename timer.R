library(tictoc)


printTicTocLog <-
  function() {
    tic.log() %>%
      unlist %>%
      tibble(logvals = .) %>%
      separate(logvals,
               sep = ":",
               into = c("Function type", "log")) %>%
      mutate(log = str_trim(log)) %>%
      separate(log,
               sep = " ",
               into = c("Seconds"),
               extra = "drop")
  }
tic.clearlog()

# Time the execution of the original script
tic("Original Script")
source("scripts/original.R")
toc(log = T)


# Time the execution of the parallel loop script
tic("Parallel Loop Script")
# Source the parallel loop script
source("scripts/parallel_loop.R")
toc(log = T)



# Time the execution of the parallel function script
tic("Parallel Function Script")
# Source the parallel function script
source("scripts/parallel_function.R")
toc(log = T)

printTicTocLog() %>% 
  knitr::kable()
