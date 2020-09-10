library(dbnlearn)
library(bnviewer)
library(ggplot2)

#Fibonacci Sequence
ts <- c(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987)

#Time Series Preprocessing with time window = 2
X.ts = dbn.preprocessing(ts, window = 2)

#Define 70% Train and 30% Test Data Set
percent = 0.5
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
prediction = dbn.predict(ts.fit, X.ts.test[,c("X_t1","X_t2")])

#Plot Real vs Predict
real = X.ts.test[, "X_t"]

df.validation = data.frame(list(real = real, prediction = prediction))

ggplot(df.validation, aes(seq(1:nrow(df.validation)))) +
  geom_line(aes(y = prediction, colour="prediction"),size=3) +
  geom_line(aes(y = real, colour="real"),size=1) +
  scale_color_manual(values = c(
    'real' = 'deepskyblue',
    'prediction' = 'maroon1')) +
  labs(title = "Dynamic Bayesian Network",
       subtitle = "Fibonacci Time Series",
       colour = "Legend",
       x = "Time Index",
       y = "Values") + theme_minimal()
