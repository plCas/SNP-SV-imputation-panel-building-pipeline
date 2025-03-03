# ADSP-Short-Var, ADSP-All-Var imputation panels

Pipeline Overview:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/142da040b92ab406bae589d64935c3663519cba9/Images/ADSP-Short_All-Var_panel_Workflow.png)

# Dependencies
Bcftools
Bedtools
IMMerge
Minimac3
Minmac4
Metaminimac2
aggRsquare
SHAPEIT4
GENESIS
Plink 1.9

# Build imputation panel
  1.	[Remove_related_samples](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/f1f555d145959f1ec4505cc48e1cb0e5fd262614/remove_related_samples)
  2.	Panel_building\n
      a.	[ADSP-Short-Var](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/4e8553b194b417d1f173e7e1e237cd93618ed9d0/panel_building/ADSP-Short-Var)\n
    	b.	[ADSP-All-Var](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/4e8553b194b417d1f173e7e1e237cd93618ed9d0/panel_building/ADSP-All-Var)

# Analysis
  1.	Imputation
  2.	Meta-imputation
  3.	WGS validation
  4.	Single variant association test
