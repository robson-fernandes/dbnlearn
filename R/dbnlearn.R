library(bnviewer)
library(bnlearn)

#'
#' @title Time Series Preprocessing with time window.
#'
#' @author Robson Fernandes
#'
#' @param ts Time Series.
#'
#' @param window Number of steps in the time window.
#'
#' @return Time Series Preprocessing
#'
#' @importFrom  methods is
#'
#' @export
#'
#' @examples
#'
#'  library(dbnlearn)
#'  library(bnviewer)
#'  library(ggplot2)
#'
#'  #Time Series AirPassengers
#'  ts <- AirPassengers
#'
#'  #Time Series Preprocessing with time window = 12
#'  X.ts = dbn.preprocessing(ts, window = 12)
#'
#'  #Define 70\% Train and 30\% Test Data Set
#'  percent = 0.7
#'  n = nrow(X.ts)
#'
#'  trainIndex <- seq_len(length.out = floor(x = percent * n))
#'  X.ts.train <- X.ts[trainIndex,]
#'  X.ts.test <- X.ts[-trainIndex,]
#'
#'  #Dynamic Bayesian Network Structure Learning
#'  ts.learning = dbn.learn(X.ts.train)
#'
#'  #Viewer Dynamic Bayesian Network
#'  viewer(ts.learning,
#'         edges.smooth = TRUE,
#'         bayesianNetwork.height = "400px",
#'         node.colors = list(background = "#f4bafd",
#'                            border = "#2b7ce9",
#'                            highlight = list(background = "#97c2fc",
#'                                             border = "#2b7ce9")),
#'         bayesianNetwork.layout = "layout_with_sugiyama")
#'
#'
#'  #Dynamic Bayesian Network Fit
#'  ts.fit = dbn.fit(ts.learning, X.ts.train)
#'
#'
#'  #Predict values
#'  prediction = dbn.predict(ts.fit, X.ts.test)
#'
#'
#'  #Plot Real vs Predict
#'  real = X.ts.test[, "X_t"]
#'  prediction = prediction
#'
#'  df.validation = data.frame(list(real = real, prediction = prediction))
#'
#'  ggplot(df.validation, aes(seq(1:nrow(df.validation)))) +
#'    geom_line(aes(y = real, colour="real")) +
#'    geom_line(aes(y = prediction, colour="prediction")) +
#'    scale_color_manual(values = c(
#'      'real' = 'deepskyblue',
#'      'prediction' = 'maroon1')) +
#'    labs(title = "Dynamic Bayesian Network",
#'         subtitle = "AirPassengers Time Series",
#'         colour = "Legend",
#'         x = "Time Index",
#'         y = "Values") + theme_minimal()
#'
dbn.preprocessing <- function(ts=NULL,window=12){

  sequence <- ts

  X = data.frame()

  for (i in seq(1:length(sequence)))
  {
    # find the end of this pattern
    end_ix = i + window - 1
    # check if we are beyond the sequence
    if (end_ix > length(sequence)-1){
      break
    }
    # gather input and output parts of the pattern
    seq_x = sequence[i:end_ix]
    seq_y = sequence[end_ix+1]

    l = list()
    for (k in seq(1:length(seq_x)))
    {
      l[paste("X_t",k,sep="")] = seq_x[k]
    }
    l["X_t"] = seq_y

    nRow <- data.frame(l)
    X <- rbind(X,nRow)
  }

  return(X)
}

#'
#' @title Dynamic Bayesian Network Structure Learning
#'
#' @author Robson Fernandes
#'
#' @param ts Time Series.
#'
#' @return Dynamic Bayesian Network Structure Learning
#'
#' @importFrom  methods is
#'
#' @export
#'
#' @examples
#'
#'  library(dbnlearn)
#'  library(bnviewer)
#'  library(ggplot2)
#'
#'  #Time Series AirPassengers
#'  ts <- AirPassengers
#'
#'  #Time Series Preprocessing with time window = 12
#'  X.ts = dbn.preprocessing(ts, window = 12)
#'
#'  #Define 70\% Train and 30\% Test Data Set
#'  percent = 0.7
#'  n = nrow(X.ts)
#'
#'  trainIndex <- seq_len(length.out = floor(x = percent * n))
#'  X.ts.train <- X.ts[trainIndex,]
#'  X.ts.test <- X.ts[-trainIndex,]
#'
#'  #Dynamic Bayesian Network Structure Learning
#'  ts.learning = dbn.learn(X.ts.train)
#'
#'  #Viewer Dynamic Bayesian Network
#'  viewer(ts.learning,
#'         edges.smooth = TRUE,
#'         bayesianNetwork.height = "400px",
#'         node.colors = list(background = "#f4bafd",
#'                            border = "#2b7ce9",
#'                            highlight = list(background = "#97c2fc",
#'                                             border = "#2b7ce9")),
#'         bayesianNetwork.layout = "layout_with_sugiyama")
#'
#'
#'  #Dynamic Bayesian Network Fit
#'  ts.fit = dbn.fit(ts.learning, X.ts.train)
#'
#'
#'  #Predict values
#'  prediction = dbn.predict(ts.fit, X.ts.test)
#'
#'
#'  #Plot Real vs Predict
#'  real = X.ts.test[, "X_t"]
#'  prediction = prediction
#'
#'  df.validation = data.frame(list(real = real, prediction = prediction))
#'
#'  ggplot(df.validation, aes(seq(1:nrow(df.validation)))) +
#'    geom_line(aes(y = real, colour="real")) +
#'    geom_line(aes(y = prediction, colour="prediction")) +
#'    scale_color_manual(values = c(
#'      'real' = 'deepskyblue',
#'      'prediction' = 'maroon1')) +
#'    labs(title = "Dynamic Bayesian Network",
#'         subtitle = "AirPassengers Time Series",
#'         colour = "Legend",
#'         x = "Time Index",
#'         y = "Values") + theme_minimal()
#'
dbn.learn <- function(ts=NULL){

  X = ts
  full_dependency = TRUE
  formule = ""
  if (full_dependency == TRUE) {

    for (k in seq(1:(length(X)-1))) {
      last = paste("X_t",k+1,sep="")
      if (k < length(X)-1){
        formule = paste(formule, "X_t",k," -> ", last, "; ",sep="")
      }
    }

    for (k in seq(1:(length(X)-1))) {
      formule = paste(formule, "X_t",k," -> ", " X_t;",sep="")
    }

  } else {
    for (k in seq(1:(length(X)-1))) {
      formule = paste(formule, "X_t",k, " -> ", " X_t; ",sep="")

    }
  }

  structure.learn = bnviewer::model.to.structure(formule)
  return(structure.learn)
}


#'
#' @title Dynamic Bayesian Network Fit
#'
#' @author Robson Fernandes
#'
#' @param dbn.learn Dynamic Bayesian Network Learning.
#'
#' @param ts Time Series.
#'
#' @return Dynamic Bayesian Network Fit
#'
#' @importFrom  methods is
#'
#' @export
#'
#' @examples
#'
#'  library(dbnlearn)
#'  library(bnviewer)
#'  library(ggplot2)
#'
#'  #Time Series AirPassengers
#'  ts <- AirPassengers
#'
#'  #Time Series Preprocessing with time window = 12
#'  X.ts = dbn.preprocessing(ts, window = 12)
#'
#'  #Define 70\% Train and 30\% Test Data Set
#'  percent = 0.7
#'  n = nrow(X.ts)
#'
#'  trainIndex <- seq_len(length.out = floor(x = percent * n))
#'  X.ts.train <- X.ts[trainIndex,]
#'  X.ts.test <- X.ts[-trainIndex,]
#'
#'  #Dynamic Bayesian Network Structure Learning
#'  ts.learning = dbn.learn(X.ts.train)
#'
#'  #Viewer Dynamic Bayesian Network
#'  viewer(ts.learning,
#'         edges.smooth = TRUE,
#'         bayesianNetwork.height = "400px",
#'         node.colors = list(background = "#f4bafd",
#'                            border = "#2b7ce9",
#'                            highlight = list(background = "#97c2fc",
#'                                             border = "#2b7ce9")),
#'         bayesianNetwork.layout = "layout_with_sugiyama")
#'
#'
#'  #Dynamic Bayesian Network Fit
#'  ts.fit = dbn.fit(ts.learning, X.ts.train)
#'
#'
#'  #Predict values
#'  prediction = dbn.predict(ts.fit, X.ts.test)
#'
#'
#'  #Plot Real vs Predict
#'  real = X.ts.test[, "X_t"]
#'  prediction = prediction
#'
#'  df.validation = data.frame(list(real = real, prediction = prediction))
#'
#'  ggplot(df.validation, aes(seq(1:nrow(df.validation)))) +
#'    geom_line(aes(y = real, colour="real")) +
#'    geom_line(aes(y = prediction, colour="prediction")) +
#'    scale_color_manual(values = c(
#'      'real' = 'deepskyblue',
#'      'prediction' = 'maroon1')) +
#'    labs(title = "Dynamic Bayesian Network",
#'         subtitle = "AirPassengers Time Series",
#'         colour = "Legend",
#'         x = "Time Index",
#'         y = "Values") + theme_minimal()
#'
dbn.fit <- function(dbn.learn=NULL,ts=NULL){

  fit = bnlearn::bn.fit(dbn.learn,ts)
  return(fit)
}


#'
#' @title Dynamic Bayesian Network Predict
#'
#' @author Robson Fernandes
#'
#' @param dbn.fit Dynamic Bayesian Network Fit
#'
#' @param ts Time Series.
#'
#' @return Dynamic Bayesian Network Predict
#'
#' @importFrom  methods is
#'
#' @export
#'
#' @examples
#'
#'  library(dbnlearn)
#'  library(bnviewer)
#'  library(ggplot2)
#'
#'  #Time Series AirPassengers
#'  ts <- AirPassengers
#'
#'  #Time Series Preprocessing with time window = 12
#'  X.ts = dbn.preprocessing(ts, window = 12)
#'
#'  #Define 70\% Train and 30\% Test Data Set
#'  percent = 0.7
#'  n = nrow(X.ts)
#'
#'  trainIndex <- seq_len(length.out = floor(x = percent * n))
#'  X.ts.train <- X.ts[trainIndex,]
#'  X.ts.test <- X.ts[-trainIndex,]
#'
#'  #Dynamic Bayesian Network Structure Learning
#'  ts.learning = dbn.learn(X.ts.train)
#'
#'  #Viewer Dynamic Bayesian Network
#'  viewer(ts.learning,
#'         edges.smooth = TRUE,
#'         bayesianNetwork.height = "400px",
#'         node.colors = list(background = "#f4bafd",
#'                            border = "#2b7ce9",
#'                            highlight = list(background = "#97c2fc",
#'                                             border = "#2b7ce9")),
#'         bayesianNetwork.layout = "layout_with_sugiyama")
#'
#'
#'  #Dynamic Bayesian Network Fit
#'  ts.fit = dbn.fit(ts.learning, X.ts.train)
#'
#'
#'  #Predict values
#'  prediction = dbn.predict(ts.fit, X.ts.test)
#'
#'
#'  #Plot Real vs Predict
#'  real = X.ts.test[, "X_t"]
#'  prediction = prediction
#'
#'  df.validation = data.frame(list(real = real, prediction = prediction))
#'
#'  ggplot(df.validation, aes(seq(1:nrow(df.validation)))) +
#'    geom_line(aes(y = real, colour="real")) +
#'    geom_line(aes(y = prediction, colour="prediction")) +
#'    scale_color_manual(values = c(
#'      'real' = 'deepskyblue',
#'      'prediction' = 'maroon1')) +
#'    labs(title = "Dynamic Bayesian Network",
#'         subtitle = "AirPassengers Time Series",
#'         colour = "Legend",
#'         x = "Time Index",
#'         y = "Values") + theme_minimal()
#'
dbn.predict <- function(dbn.fit=NULL,ts=NULL){

  prediction = predict(dbn.fit, "X_t", ts)
  return(prediction)
}
