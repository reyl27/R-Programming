rankall <- function(outcome, num = "best") {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

  ## Check that outcome is valid:
  if (tolower(outcome) != "heart attack" && tolower(outcome) != "heart failure" && tolower(outcome) != "pneumonia") {
    stop("invalid outcome")
  }
  
  ## Initialize data frame:
  rankedHospitals <- data.frame(hospital = as.character(), state = as.character(), stringsAsFactors = FALSE)
  
  ## Get the death rates:
  if (tolower(outcome) == "heart attack") {
    deathRates <- suppressWarnings(as.numeric(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack))
  }
  else if (tolower(outcome) == "heart failure") {
    deathRates <- suppressWarnings(as.numeric(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure))
  }
  else {
    deathRates <- suppressWarnings(as.numeric(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia))
  }
  
  ## For each state, find the hospital of the given rank
  counter <- 0 ## Setting up row counter
  ## Get all unique states:
  states <- sort(as.character(unique(data$State)))
  for (state in states) {
    stateDeathRates <- deathRates[data$State == state]
    hospitals <- data$Hospital.Name[data$State == state]
    
    ## Get order permutation for lowest to highest, remove all NA:
    perm <- order(stateDeathRates, hospitals, na.last = NA, decreasing = FALSE)
    
    ## Note: num cannot change, made that mistake initially. Set N based on "num" input.
    if (num == "best") { N <- 1 }
    else if (num == "worst") { N <- length(perm) }
    else if (!is.numeric(num)) { N <- 0 }
    else { N <- num }
    
    if (length(stateDeathRates) < N || length(stateDeathRates) == 0 || N <= 0) {
      newRow <- c("<NA>", state) ## "<NA>" is based on the assignment requirement, could easily be something else.
    }
    else {
      newRow <- c(hospitals[perm[N]], state)
    }
    
    rankedHospitals[seq(counter + 1, nrow(rankedHospitals) + 1), ] <- newRow
    ## This sets the row name to be the state. There might be an easier way to do it, but it works.
    row.names(rankedHospitals)[counter + 1] <- state
    counter <- counter + 1
  }
  
  ## Return a data frame with the hospital names and the (abbreviated) state name
  rankedHospitals
}