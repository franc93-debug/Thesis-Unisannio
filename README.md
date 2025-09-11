# Thesis-Unisannio
my final work for master's degree

# classificazione semantica dei testi mendiante tecniche di text mining e NLP
Questa repository contiene lo sviluppo e l'applicazione di alcuni modelli di Machine Learning utili al rilevamento e alla classificazione semantica di testi. 
Verranno esplorate alcune tecniche di apprendimento automatico per classificazre in questo caso articoli di giornale e tweet in base alle loro caratteristiche, utilizzando sia linguaggio r che python mediante il software r-studio e la piattaforma google colab.
I risultati e le conclusioni vengono esposti nel pdf allegato

## contenuto delle cartelle

### Scripts
- **analisi_esplorativa.R**: script di r per l'EDA a partire dal dataset pre processato che si trova nel file csv "model_data1"
- **models.py**: Python script containing the models used for classification and prediction.
- **NLP.py**: Python script focused on natural language processing aspects of the project.

### Dati
tutti i vari csv utilizzati per le analisi sono scaricabili dal seguente link:



### Report
- **Tesi_2.pdf**: la tesi completa con le analisi e i risultati commentati

## modelli utilizzati
regressione logistica, decision trees, random forests, gradient boosting

### Python Dependencies
nel file "pacchetti python da installare" sono presenti i pacchetti necessari per far girare i codici

### R Dependencies

 **Installare Pacchetti necessari su R:**
   - install.packages(c("package1", "package2", "package3"))
     sostituisci `"package1"`, `"package2"`, etc. con i pacchetti indicati nel file `pacchetti_r'

1. **EDA (Exploratory Data Analysis):**
     file "analisi esplorativa.R"
     dove troverete anche l'acp delle bag of words e la rappresentazione t-sne
  `

3. **NLP**
   - 

4. **Model Training and Evaluation:**
   - Finally, run the script for model training and evaluation:
     ```bash
     python models.py
     ```
