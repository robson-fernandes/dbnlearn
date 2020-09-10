\name{dbnlearn-package}
\alias{dbnlearn-package}
\alias{dbnlearn}
\docType{package}
\title{Dynamic Bayesian Network Structure Learning, Parameter Learning and Forecasting}
\description{

   Dynamic Bayesian Network Structure Learning, Parameter Learning and Forecasting.
   This package implements a model of Gaussian Dynamic Bayesian Networks with temporal
   windows, based on collections of linear regressors for Gaussian nodes.
   The package allows learning the structure of univariate time series,
   learning parameters and forecasting.

}
\details{

  \tabular{ll}{

    Package: \tab dbnlearn-package\cr
    Type: \tab Package\cr
    Version: \tab 0.1.0\cr
    Date: \tab 2020-07-17\cr
    License: \tab MIT + file LICENSE

  }

}
\author{

  Robson Fernandes\cr
  Institute of Mathematical and Computer Sciences\cr
  University of Sao Paulo - ICMC-USP

  Maintainer: Robson Fernandes \email{robson.fernandes@usp.br}

}

\references{

  Koller D, Friedman N (2009). \emph{Probabilistic Graphical Models: Principles
    and Techniques}. MIT Press.

  Korb K, Nicholson AE (2010). \emph{Bayesian Artificial Intelligence}.
    Chapman & Hall/CRC, 2nd edition.

  Pearl J (1988). \emph{Probabilistic Reasoning in Intelligent Systems:
    Networks of Plausible Inference}. Morgan Kaufmann.

  Nagarajan R, Scutari M, Lebre S (2013). \emph{Bayesian Networks in R with
    Applications in Systems Biology}. Springer.
}

\examples{
library(dbnlearn)
library(bnviewer)
library(ggplot2)

#Time Series AirPassengers
ts <- AirPassengers

#Time Series Preprocessing with time window = 12
X.ts = dbn.preprocessing(ts, window = 12)

#Define 70\% Train and 30\% Test Data Set
percent = 0.7
n = nrow(X.ts)

trainIndex <- seq_len(length.out = floor(x = percent * n))
X.ts.train <- X.ts[trainIndex,]
X.ts.test <- X.ts[-trainIndex,]

#Dynamic Bayesian Network Structure Learning
ts.learning = dbn.learn(X.ts.train)

#Viewer Dynamic Bayesian Network
viewer(ts.learning,
       edges.smooth = TRUE,
       bayesianNetwork.height = "400px",
       node.colors = list(background = "#f4bafd",
                          border = "#2b7ce9",
                          highlight = list(background = "#97c2fc",
                                           border = "#2b7ce9")),
       bayesianNetwork.layout = "layout_with_sugiyama")


#Dynamic Bayesian Network Fit
ts.fit = dbn.fit(ts.learning, X.ts.train)


#Predict values
prediction = dbn.predict(ts.fit, X.ts.test)


#Plot Real vs Predict
real = X.ts.test[, "X_t"]
prediction = prediction

df.validation = data.frame(list(real = real, prediction = prediction))

ggplot(df.validation, aes(seq(1:nrow(df.validation)))) +
  geom_line(aes(y = real, colour="real")) +
  geom_line(aes(y = prediction, colour="prediction")) +
  scale_color_manual(values = c(
    'real' = 'deepskyblue',
    'prediction' = 'maroon1')) +
  labs(title = "Dynamic Bayesian Network",
      subtitle = "AirPassengers Time Series",
      colour = "Legend",
      x = "Time Index",
      y = "Values") + theme_minimal()

}
\keyword{package}
