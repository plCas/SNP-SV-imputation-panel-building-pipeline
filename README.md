# SNP-SV-imputation-panel-building-pipeline

Pipeline Overview:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/main/Images/Overview.png?raw=true "Title")


Step1 Remove related samples, calculate PCA and HWE before filtering variants:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/main/Images/Step1.png?raw=true "Title")

Scripts are in scripts_calculate_IBD_PCA folder 


Step2 for building SNP-only reference panel :
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/main/Images/Step2_SNP-only.png?raw=true "Title")
Scripts labeled with "*" denote dependent script but do not need to run it directly. However, some paths in these scripts should also be specified if needed.


Step2 for building SNP-SV reference panel:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/main/Images/Step2_SNP-SV.png?raw=true "Title")
