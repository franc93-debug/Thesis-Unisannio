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



### Report
- **report.pdf**: la tesi 

## modelli utilizzati
regressione logistica, decision trees, random forests, gradient boosting

### Python Dependencies
To install the required Python packages, ensure you have Python 3.8+ installed on your system, and then run the following command:
```bash
pip install -r requirementsPy.txt
```

### R Dependencies

To install the required R packages, follow these steps:

1. **Install R:**
   - If you haven't already, download and install R from the [R Project website](https://www.r-project.org/).

2. **Install Required Packages:**
   - Open R or RStudio.
   - Run the following command to install the required packages from CRAN:
     ```R
     install.packages(c("package1", "package2", "package3"))
     ```
     Replace `"package1"`, `"package2"`, etc. with the names of the R packages listed in the `requirementsR.txt` file.

3. **Verify Installation:**
   - Once the packages are installed, you can verify that they were installed correctly by loading them in R:
     ```R
     library(package1)
     library(package2)
     ```
   - If no error messages are displayed, the packages were successfully installed.


## Running the Project
To run the project, execute the following commands in the specified order:

1. **Exploratory Data Analysis (Optional):**
   - If you wish to generate the graphs reported in the report, execute:
     ```bash
     python explorative_analysis.py
     ```

2. **NLP Analysis:**
   - Execute the text mining analysis script:
     ```bash
     python NLP.py
     ```

3. **Model Training and Evaluation:**
   - Finally, run the script for model training and evaluation:
     ```bash
     python models.py
     ```

These commands will execute the Python scripts in the specified order, allowing you to perform exploratory data analysis, NLP analysis, and model training and evaluation for the project.

## Results
Detailed results can be viewed in the report.pdf, which includes discussion on methodology, model evaluation, and conclusions based on the analysis.

## Authors
Cecilia Peccolo
