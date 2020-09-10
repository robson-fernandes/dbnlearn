library(dbnlearn)
library(bnviewer)
library(ggplot2)

#Time Series AirPassengers
ts <- AirPassengers

#Time Series Preprocessing with time window = 12
X.ts = dbn.preprocessing(ts, window = 12)

#Define 70% Train and 30% Test Data Set
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
