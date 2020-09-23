# ddCt
Simple script for ddCt analysis of qPCR data for pharmacologists. It calculates fold change based on raw CT values for reference gene and gene of interest for specific treatment groups and returns XLSX file containing summary statistics (including means, standard deviations, N, SEM, min, max and normality distributtion) and descriptive statistics from Tukey post-hoc analysis of between group differences. Seperate files include results of ANOVA analysis and JPEG image of scatterplot.  

# Features:
* summary and descriptive statistics - ANOVA and Tukey
* scatterplot
* mean calculation from duplicate values
* automatic outlier analysis and removal

# Requirements:
* JAVA
* library("beeswarm")
* library("yarrr")
* library("xlsx")

# How to:

1. Prepare you datafile following formatting in example file: exampleData.csv

| Col1: "treatment" | Col2: name of the refernce Gene, eg: "B2M"| Col3: name of the gene of interest, eg: "CCL17"  |
| ---------------- |:-----------------------------------------:| ------------------------------------------------:|
| VEHICLE     | 18,84 | 20,43 |
| TREATED     | 18,75 |   20,14 |

2. Type path for the data file in the first line of code
3. Run!
4. Type name of the vehicle group, which will serve as a reference to calculate fold change
5. Select if you want to remove outliers
6. Select if you want to calculate duplicate means first, if yes then data file should formatted as in: exampleDuplicates.csv

| Col1: "treatment" | Col2: name of the refernce Gene, eg: "B2M"| Col3: duplicate values of refernce gene, you can name it anything you want  | Col4: name of the gene of interest, eg: "CCL17"  |: Col3: duplicate values of refernce gene, you can name it anything you want| 
| ---------------- |:-----------------------------------------:| ------------------------------------------------:|------------------------------------------------:|------------------------------------------------:|
| VEHICLE     | 18,84 | 18,43 | 20,84 | 20,43 |
| TREATED     | 18,75 |   18,14 | 20,75 |   20,14 |
7. Results of you analysis are ready in myDocuments folder
