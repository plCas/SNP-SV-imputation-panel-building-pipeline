# ADSP-Short-Var, ADSP-All-Var imputation panels

## Pipeline Overview:
![alt text](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/142da040b92ab406bae589d64935c3663519cba9/Images/ADSP-Short_All-Var_panel_Workflow.png)

# Dependencies
[bcftools v1.16](https://github.com/samtools/bcftools/tree/1.16) <br>
[bedtools v2.26](https://github.com/arq5x/bedtools2/tree/v2.26.0) <br>
[IMMerge](https://github.com/belowlab/IMMerge) <br>
[Minimac3 v2.0.1](https://github.com/Santy-8128/Minimac3?tab=readme-ov-file) <br>
[Minimac4 v4.1.0](https://github.com/statgen/Minimac4/tree/v4.1.0) <br>
[MetaMinimac2 v1.0.0](https://github.com/yukt/MetaMinimac2) <br>
[aggRsquare](https://github.com/yukt/aggRSquare) <br>
[SHAPEIT4 v4.2.2](https://github.com/odelaneau/shapeit4)<br>
[RUTH](https://github.com/statgen/ruth)<br>
[GENESIS](https://github.com/UW-GAC/GENESIS/tree/devel) <br>
[PLINK 1.9](https://www.cog-genomics.org/plink/1.9) <br>

# Build imputation panel <br>
  1.	[remove_related_samples](remove_related_samples) <br>
  2.	Panel_building <br>
      a.	[ADSP-Short-Var](panel_building/ADSP-Short-Var)<br>
    	b.	[ADSP-All-Var](panel_building/ADSP-All-Var) <br>

# Analysis <br>
  1.	[Imputation](imputation) <br>
  2.	[Meta-imputation](meta-imputation) <br>
  3.	[WGS validation](WGS%20validation) <br>
  4.	[Single variant association test](single%20variant%20association%20test) <br>
