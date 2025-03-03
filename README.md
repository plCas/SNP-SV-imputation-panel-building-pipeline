# ADSP-Short-Var, ADSP-All-Var imputation panels

Pipeline Overview:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/142da040b92ab406bae589d64935c3663519cba9/Images/ADSP-Short_All-Var_panel_Workflow.png)

# Dependencies
[bcftools v 1.16](https://github.com/samtools/bcftools/tree/1.16) <br>
[bedtools v2.26](https://github.com/arq5x/bedtools2/tree/v2.26.0) <br>
[IMMerge](https://github.com/belowlab/IMMerge) <br>
[Minimac3 v 2.0.1](https://github.com/Santy-8128/Minimac3?tab=readme-ov-file) <br>
[Minimac4 v 4.1.0](https://github.com/statgen/Minimac4/tree/v4.1.0) <br>
[MetaMinimac2 v 1.0.0](https://github.com/yukt/MetaMinimac2) <br>
[aggRsquare](https://github.com/yukt/aggRSquare) <br>
[SHAPEIT4 v 4.2.2](https://github.com/odelaneau/shapeit4)<br>
[GENESIS](https://github.com/UW-GAC/GENESIS/tree/devel) <br>
[PLINK 1.9](https://www.cog-genomics.org/plink/1.9) <br>

# Build imputation panel <br>
  1.	[Remove_related_samples](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/remove_related_samples) <br>
  2.	Panel_building <br>
      a.	[ADSP-Short-Var](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/ce812fbfcaa5e8e900268f10505edfea39aec10e/panel_building/ADSP-Short-Var)<br>
    	b.	[ADSP-All-Var](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/ce812fbfcaa5e8e900268f10505edfea39aec10e/panel_building/ADSP-All-Var) <br>

# Analysis <br>
  1.	[Imputation](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/ce812fbfcaa5e8e900268f10505edfea39aec10e/imputation) <br>
  2.	[Meta-imputation](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/ce812fbfcaa5e8e900268f10505edfea39aec10e/meta-imputation) <br>
  3.	[WGS validation](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/ce812fbfcaa5e8e900268f10505edfea39aec10e/WGS%20validation) <br>
  4.	[Single variant association test](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/tree/ce812fbfcaa5e8e900268f10505edfea39aec10e/single%20variant%20association%20test) <br>
