library(quantmod)
library(dbnlearn)
library(bnviewer)
library(ggplot2)

pbr <- getSymbols("PBR", src = "yahoo", from = "2015-01-01", to = "2020-07-01", auto.assign = FALSE)


#Petrobras Prices Time Series
ts <- pbr$PBR.Open

#Time Series Preprocessing with time window = 30
X.ts = dbn.preprocessing(ts, window = 30)

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
       bayesianNetwork.enabled.interactive.mode = TRUE,
       edges.smooth = TRUE,
       bayesianNetwork.height = "500px",
       node.colors = list(background = "#f4bafd",
                          border = "#2b7ce9",
                          highlight = list(background = "#97c2fc",
                                           border = "#2b7ce9")),
       bayesianNetwork.layout = "layout_on_grid")

viewer(ts.learning,
       bayesianNetwork.width = "100%",
       bayesianNetwork.height = "100vh",
       bayesianNetwork.enabled.interactive.mode = TRUE,
       edges.smooth = FALSE,
       bayesianNetwork.layout = "layout_with_gem",
       node.colors = list(background = "#f4bafd",
                          border = "#2b7ce9",
                          highlight = list(background = "#97c2fc",
                                           border = "#2b7ce9")),

       clusters.legend.title = list(text = "Legend"),

       clusters.legend.options = list(

         list(label = "Target (t)",
              shape = "icon",
              icon = list(code = "f111", size = 50, color = "#e91e63")),

         list(label = "Time Window (t-n)",
              shape = "icon",
              icon = list(code = "f111", size = 50, color = "#f4bafd"))
       ),

       clusters = list(
         list(label = "Target",
              shape = "icon",
              icon = list(code = "f111", color = "#e91e63"),
              nodes = list("X_t")),
         list(label = "Time Window (t-n)",
              shape = "icon",
              icon = list(code = "f111", color = "#f4bafd"),
              nodes = list("X_t1"))
       )

)

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
       subtitle = "Petrobras Prices Time Series",
       colour = "Legend",
       x = "Time Index",
       y = "Values") + theme_minimal()
