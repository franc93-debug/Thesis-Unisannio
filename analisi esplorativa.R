rm(list=ls())
ls()

data <- read.csv("C:/Users/user/Desktop/data/model_data1.csv")
head(data)

#carichiamo pacchetti 
library(quanteda)
library(ggplot2)
library(Rtsne)
library(dplyr)
library(tidyr)
library(ggfortify)
library(forcats)
library(scales)
library(grid)
library(plotly)
### ANALISI SINTATTICA ###  

# Distribuzione Real e fake news 
tab <- table(factor(data$label, levels = c(0, 1)))
barplot(tab,
        names.arg = c("0 = REAL", "1 = FAKE"),
        col = c("orange", "steelblue"),
        ylab = "Frequenza",
        main = "Distribuzione di real e fake news")

# Testi inferiori a 250 parole
cols <- c("orange","steelblue")  # 0 = Real (arancio), 1 = Fake (blu)
barplot(prop.table(table(data$label[data$length<=250])), beside=T,
        main = "Testi inferiori a 250 parole", xlab = "0 = Real, 1 = Fake",col=cols)


# Frequenza di citazioni realvsfake
cols <- c("orange","steelblue")  
barplot(prop.table(table(data$label[data$quotes>0])), 
        xlab="Real = 0, Fake = 1", main="Frequenza di citazioni", col=cols)

# Frequenza testi lunghi 
barplot(prop.table(rbind(table(data$label[data$length>1000]),
table(data$label[data$length>2000]),
table(data$label[data$length>3000]),
table(data$label[data$length>5000])),1), beside=T,
names.arg = c("0 = REAL", "1 = FAKE"),
legend.text = c(">1000", ">2000", ">3000", ">5000"),
main = "Frequenza di testi lunghi")

# Documenti con parole lunghe 
cols <- c("orange","steelblue")

# Barplot: documenti con >20% di parole con >11 caratteri
ok  <- !is.na(data$label) & !is.na(data$perc11) & data$perc11 > 0.20
tab <- table(factor(data$label[ok], levels = c(0,1)))
barplot(prop.table(tab),
        names.arg = c("0","1"),
        xlab = "Real = 0, Fake = 1",
        ylab = "Frequenza",
        main = "Documenti con parole lunghe",
        col = cols)

data$label01 <- ifelse(tolower(data$label) == "fake", 1, 0)

# Boxplot percentuale parole >11 caratteri
boxplot(data$perc11 ~ data$label01,
        xlab = "Real=0, Fake=1",
        ylab = "parole con più di 11 caratteri",
        col = cols)

# Acp delle caratteristiche sintattiche dei documenti
 

# Seleziona le variabili sintattiche 
vars <- c("length","quotes","punct","perc5","perc11","av_words")
X <- data[, vars]

# imputa eventuali NA con la mediana della colonna
for (v in names(X)) X[[v]][is.na(X[[v]])] <- median(X[[v]], na.rm = TRUE)

# etichette (gestisce 0/1 oppure stringhe "real"/"fake")
lab <- ifelse(tolower(as.character(data$label)) %in% c("1","fake"), "fake", "real")
lab <- factor(lab, levels = c("fake","real"))

# PCA (centrata e scalata)
pca <- prcomp(X, center = TRUE, scale. = TRUE)
ve  <- pca$sdev^2
pc1 <- percent(ve[1] / sum(ve), accuracy = 0.01)
pc2 <- percent(ve[2] / sum(ve), accuracy = 0.01)

scores <- as.data.frame(pca$x[, 1:2])
names(scores) <- c("PC1","PC2")
scores$label <- lab

loadings <- as.data.frame(pca$rotation[, 1:2])
names(loadings) <- c("PC1","PC2")
loadings$var <- rownames(loadings)

scale_factor <- 0.9 * min(
  diff(range(scores$PC1)) / diff(range(loadings$PC1)),
  diff(range(scores$PC2)) / diff(range(loadings$PC2))
)
loadings$PC1 <- loadings$PC1 * scale_factor
loadings$PC2 <- loadings$PC2 * scale_factor

# Plot
ggplot(scores, aes(PC1, PC2, color = label)) +
  geom_point(alpha = 0.8, size = 2) +
  geom_segment(data = loadings,
               aes(x = 0, y = 0, xend = PC1, yend = PC2),
               inherit.aes = FALSE, color = "red",
               arrow = arrow(length = unit(0.15, "cm"))) +
  geom_text(data = loadings, aes(x = PC1, y = PC2, label = var),
            inherit.aes = FALSE, color = "red", vjust = -0.3, size = 3) +
  scale_color_manual(values = c("fake" = "#F8766D", "real" = "#00BFC4")) +
  labs(x = paste0("PC1 (", pc1, ")"),
       y = paste0("PC2 (", pc2, ")"),
       color = "label") +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())



### Frequenza parole in ' Text News'  (già fatto su python) ###

# data: data.frame con 'text' e 'label'
data <- read.csv("C:/Users/user/Desktop/data/wprData.csv")

# mappa label 0/1 -> Real/Fake
data$NewsType <- ifelse(tolower(as.character(data$label)) %in% c("1","fake"), "Fake", "Real")

corp <- corpus(data, text_field = "text")
toks <- tokens(corp, remove_punct = TRUE, remove_numbers = TRUE) |>
  tokens_remove(stopwords("en")) |>
  tokens_keep(pattern = "^[a-z]{3,}$", valuetype = "regex") |>  # <— elimina token di 1–2 lettere
  tokens_ngrams(1:2)                 # unigrams + bigrams

dfm_all <- dfm(toks)
dfm_grp <- dfm_group(dfm_all, groups = data$NewsType)

mat <- as.matrix(dfm_grp)
total <- colSums(mat)
top_n <- 25
top_terms <- names(sort(total, decreasing = TRUE))[1:top_n]

plot_df <- data.frame(
  term = gsub("_", "", top_terms),                # unisci i bigrammi
  Real = as.numeric(mat["Real", top_terms]),
  Fake = as.numeric(mat["Fake", top_terms])
)

plot_long <- plot_df |>
  mutate(term = fct_reorder(term, Real + Fake)) |>
  pivot_longer(cols = c(Real, Fake), names_to = "NewsType", values_to = "Freq")

ggplot(plot_long, aes(Freq, fct_rev(term), fill = NewsType)) +
  geom_col(position = "dodge") +
  labs(title = "Frequency of Words in the Text of News",
       x = "Term Frequency of Words", y = "Top Words in Texts", fill = "News Type") +
  theme_minimal(base_size = 12)



# plot acp bag of words
X_bow <- as.matrix(data[,27:46])
pca_bow <- prcomp(X_bow, scale. = T)
autoplot(pca_bow, data = data, colour = "lab",
         loadings = TRUE, loadings.label = TRUE) +
  scale_color_manual(values = c("Fake" = "red", "Real" = "#00BFC4")) +
  labs(color = NULL)


# Rappresentazione t-SNE

set.seed(15)
X <- as.matrix(data[,-1, drop = FALSE])
y <- data[,1]
Xs <- scale(X)

tsne <- Rtsne(data, dims=2, perplexity = 5,check_duplicates = FALSE)

points <- data.frame(
  comp1 = tsne$Y[, 1],
  comp2 = tsne$Y[, 2],
  label = factor(data$label))

plot_ly(points, x = ~comp1, y = ~comp2, color = ~label,
        colors = c("0" = "#E45756", "1" = "#00BFC4")) %>%
  add_markers(marker = list(size = 5, line = list(width = 1, color = "white"),
                            opacity = 0.9)) %>%
  layout(title = "Proiezione T-SNE dei dati",
         xaxis = list(title = "comp1"),
         yaxis = list(title = "comp2"),
         legend = list(title = list(text = "")))

