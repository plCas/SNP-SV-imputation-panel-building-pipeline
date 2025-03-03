# ADSP-Short-Var, ADSP-All-Var imputation panels

Pipeline Overview:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/142da040b92ab406bae589d64935c3663519cba9/Images/ADSP-Short_All-Var_panel_Workflow.png)

# Dependencies
Bcftools <br>
Bedtools <br>
IMMerge <br>
Minimac3 <br>
Minmac4 <br>
Metaminimac2 <br>
aggRsquare <br>
SHAPEIT4 <br>
GENESIS <br>
Plink 1.9 <br>

# Build imputation panel <br>
  1.	[Remove_related_samples](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/f1f555d145959f1ec4505cc48e1cb0e5fd262614/remove_related_samples) <br>
  2.	Panel_building <br>
      a.	[ADSP-Short-Var](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/4e8553b194b417d1f173e7e1e237cd93618ed9d0/panel_building/ADSP-Short-Var)<br>
    	b.	[ADSP-All-Var](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/4e8553b194b417d1f173e7e1e237cd93618ed9d0/panel_building/ADSP-All-Var) <br>

# Analysis <br>
  1.	Imputation <br>
  2.	Meta-imputation <br>
  3.	WGS validation <br>
  4.	Single variant association test <br>
