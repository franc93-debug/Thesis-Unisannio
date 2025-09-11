library(caret)
library(leaps)


train <- read.csv("C:/Users/user/Desktop/data/train_mod.csv", row.names = 1)
test  <- read.csv("C:/Users/user/Desktop/data/test_mod.csv",  row.names = 1)


if (is.factor(train$label)) {
  lev <- levels(train$label)
  train$label <- factor(train$label, levels = lev)
  test$label  <- factor(test$label,  levels = lev)
  positive <- tail(lev, 1)  
} else {
  lev <- c(0, 1)
  train$label <- factor(train$label, levels = lev)
  test$label  <- factor(test$label,  levels = lev)
  positive <- "1"
}

to_class <- function(p, lev, thr = 0.5) {
  factor(ifelse(p >= thr, lev[2], lev[1]), levels = lev)
}

accuratezza <- function(y_true, y_pred_prob, thr = 0.5, positive = positive) {
  y_true <- factor(y_true, levels = lev)
  y_pred <- to_class(y_pred_prob, lev = lev, thr = thr)
  m <- confusionMatrix(data = y_pred, reference = y_true, positive = positive)
  as.numeric(m$overall["Accuracy"])
}
## Modello completo: glm1
glm1 <- glm(label ~ ., family = binomial, data = train)
pred1_prob <- predict(glm1, newdata = test, type = "response")
pred1_cls  <- to_class(pred1_prob, lev = lev, thr = 0.5)
cm1 <- confusionMatrix(data = pred1_cls, reference = test$label, positive = positive)
acc1 <- as.numeric(cm1$overall["Accuracy"])

## Stepwise glm2
step1 <- stats::step(glm1, direction = "both", trace = 0)
glm2  <- step1  

pred2_prob <- predict(glm2, newdata = test, type = "response")
pred2_cls  <- to_class(pred2_prob, lev = lev, thr = 0.5)
cm2 <- confusionMatrix(data = pred2_cls, reference = test$label, positive = positive)
acc2 <- as.numeric(cm2$overall["Accuracy"])

## Best Subset Selection 
trms      <- terms(glm1)
MM_train  <- as.data.frame(model.matrix(trms, data = train))   
MM_test   <- as.data.frame(model.matrix(trms, data = test))

X_train   <- as.matrix(MM_train[, setdiff(names(MM_train), "(Intercept)"), drop = FALSE])


y_num <- if (is.factor(train$label)) as.numeric(train$label) - 1 else as.numeric(train$label)

nvmax <- min(44, ncol(X_train)) 
bss <- regsubsets(x = X_train, y = y_num, nvmax = nvmax)
bss

n.models <- nvmax
aic_vec  <- rep(NA_real_, n.models)

for (j in 1:n.models) {
  cj <- coef(bss, id = j)                         
  vars_j <- setdiff(names(cj), "(Intercept)")     
  
  # Data frame ridotto per glm 
  df_tr <- data.frame(label = train$label,
                      MM_train[, vars_j, drop = FALSE])
  fit_j <- glm(label ~ ., family = binomial, data = df_tr)
  aic_vec[j] <- AIC(fit_j)
}

idx_best <- which.min(aic_vec)
c_best   <- coef(bss, id = idx_best)
vars_best <- setdiff(names(c_best), "(Intercept)")

train_red <- data.frame(label = train$label,
                        MM_train[, vars_best, drop = FALSE])
test_red  <- data.frame(label = test$label,
                        MM_test[,  vars_best, drop = FALSE])

glm3 <- glm(label ~ ., family = binomial, data = train_red)
pred3_prob <- predict(glm3, newdata = test_red, type = "response")
pred3_cls  <- to_class(pred3_prob, lev = lev, thr = 0.5)
cm3 <- confusionMatrix(data = pred3_cls, reference = test$label, positive = positive)
acc3 <- as.numeric(cm3$overall["Accuracy"])

## Confronti
# AIC tra i tre modelli 
print(AIC(glm1, glm2, glm3))

# Accuracy
acc_table <- cbind(
  acc_glm1    = acc1,
  acc_step    = acc2,
  acc_bss     = acc3
)
print(acc_table)

#confusion matrix
cm1; cm2; cm3

# plot AIC 
n.models <- 44
errore <- rep(NA, n.models)

for (j in 1:n.models) {
  c <- coef(bss, id = j)
  coef_names <- names(c[-1])
  red <- cbind(label = train$label, train[coef_names])
  mod <- glm(label ~ ., family = binomial, data = red)
  errore[j] <- AIC(mod)
}
plot(1:n.models, errore, type = "b", pch = 19,
     xlab = "Numero di variabili nel sottoinsieme",
     ylab = "AIC",
     main = "AIC al variare del numero di variabili")
abline(v = which.min(errore), col = "red", lty = 2)
text(which.min(errore), min(errore),
     labels = paste("Best =", which.min(errore)), pos = 4, col = "red")

## grafico AIC (altro layout) 
library(ggplot2)

df <- data.frame(
  size = 1:n.models,
  aic  = errore
)

ggplot(df, aes(x = size, y = aic)) +
  geom_point(shape = 16, size = 2) +            
  labs(x = "size", y = "aic") +
  theme_grey()                                  
