# Thesis-Unisannio
my final work for master's degree

# classificazione semantica dei testi mediante tecniche di text mining e NLP
Questa repository contiene lo sviluppo e l'applicazione di alcuni modelli di Machine Learning utili al rilevamento e alla classificazione semantica di testi. 
Verranno esplorate alcune tecniche di apprendimento automatico per classificazre in questo caso articoli di giornale e tweet in base alle loro caratteristiche, utilizzando sia linguaggio r che python mediante il software r-studio e la piattaforma google colab.

### Report
- **Tesi_2.pdf**: I risultati e le conclusioni vengono esposti nel pdf a partire dal capitolo 5

## principali modelli utilizzati
regressione logistica, decision trees, random forests, gradient boosting

# Spiegazione dei dati utilizzati

# Preprocessing 

Il dataset originale **data.csv** contiene tre colonne:

- `title` → titolo della notizia  
- `text` → contenuto della notizia  
- `label` → etichetta (0 = notizia vera, 1 = fake news)  

Per preparare i dati all’addestramento di modelli di Machine Learning è stato creato un nuovo file:  
**`model_data1.csv`**

---

## Trasformazioni effettuate

1. **Informazioni generali sul testo**
   - `index` → indice della riga  
   - `label` → etichetta ereditata dal dataset originale  
   - `length` → lunghezza del testo (numero di parole)  
   - `perc5`, `perc11` → feature binarie/percentuali basate su soglie di lunghezza  
   - `av_words` → lunghezza media delle parole  
   - `punct` → percentuale di punteggiatura  
   - `quotes` → numero di virgolette  

2. **Feature emozionali** (estratte con dizionari ontologici basandosi sulla ruota delle emozioni di Plutchik)  
   - `fear, anger, trust, surprise, positive, negative, sadness, disgust, joy, anticipation`  
   → rappresentano la presenza o proporzione di termini legati a queste emozioni nel testo  

3. **Categorie tematiche** (parole chiave specifiche)  
   - `PoliticaEstera, Attualita, CampagnaTrump, Russia, Repubblicani, Arresti, InvestigazioneClinton, Societa`  

4. **Parole chiave rilevanti (bag-of-words mirato)**  
   - `trump, us, said, people, would, clinton, one, president, like, obama, election, donaldtrump, hillary, campaign, also, even, time, state, hillaryclinton, media`  
   → indicatori binari/frequenze della presenza di queste parole nel titolo o nel testo  

---

## Output finale

Il file **`model_data1.csv`** contiene le seguenti colonne: index,label,length,perc5,perc11,av_words,punct,quotes,
fear,anger,trust,surprise,positive,negative,sadness,disgust,joy,anticipation,
PoliticaEstera,Attualita,CampagnaTrump,Russia,Repubblicani,Arresti,InvestigazioneClinton,Societa,
trump,us,said,people,would,clinton,one,president,like,obama,election,donaldtrump,hillary,campaign,
also,even,time,state,hillaryclinton,media



### Scripts
- **analisi_esplorativa.R**: script di r per l'EDA a partire dal dataset pre processato che si trova nel file csv "model_data1"
- **applicazione metodi.R**: script di r per l'applicazione dei principali metodi utilizzati (confronto matrici di confusione e plot AIC)
- **Termfrequency+wordclouds.ipynb**: Python script che contiene la lista delle 25 parole più frequenti e le due wordcloud per real e fake news 
- **FakevsReal.ipynb**: Python script contiene sia l'EDA sia l'applicazione di alcuni modelli come la regressione logistica,gradient boosting, random forest e alberi di classificazione
- **Bert.ipynb**: Python script relativo all'applicazione del modello Bert
- **gini vs entropy.ipynb**: Python script relativo al confronto tra i due indici nell'albero di classificazione
- 


### Dati
tutti i vari csv utilizzati per le analisi sono scaricabili dal seguente link:





### Python Dependencies
!pip install 
nel file "pacchetti python da installare" sono presenti i pacchetti necessari per far girare i codici

### R Dependencies

 **Installare Pacchetti necessari su R:**
   - install.packages(c("package1", "package2", "package3"))
     sostituisci `"package1"`, `"package2"`, etc. con i pacchetti indicati nel file `pacchetti_r'


