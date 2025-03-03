# ADSP-Short-Var, ADSP-All-Var imputation panels

Pipeline Overview:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/142da040b92ab406bae589d64935c3663519cba9/Images/ADSP-Short_All-Var_panel_Workflow.png)

# Dependencies
[bcftools v 1.16](https://github.com/samtools/bcftools/tree/1.16) <br>
[bedtools v2.26](https://github.com/arq5x/bedtools2/tree/v2.26.0) <br>
[IMMerge](https://github.com/belowlab/IMMerge) <br>
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
  1.	[Imputation](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/06945fbe22f1a1939a5014f5b1a60596c6d4dbb4/imputation) <br>
  2.	[Meta-imputation](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/06945fbe22f1a1939a5014f5b1a60596c6d4dbb4/meta-imputation) <br>
  3.	[WGS validation](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/06945fbe22f1a1939a5014f5b1a60596c6d4dbb4/WGS%20validation) <br>
  4.	[Single variant association test](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/06945fbe22f1a1939a5014f5b1a60596c6d4dbb4/single%20variant%20association%20test) <br>
