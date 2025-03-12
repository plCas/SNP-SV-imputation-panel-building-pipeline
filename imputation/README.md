## Imputation
perform imputation by [01.impute.sh](01.impute.sh) <br>
Notice: let "--meta" ON to generate weighted file for meta-imputation

## Merge all cohorts by IMMerge
1. Make file list [02.1.make_imputed_genotypes_list.sh](02.1.make_imputed_genotypes_list.sh).

2. Remain only GT in vcf files to decrease file size.[02.2.bcftools_remain_gt.sh](02.2.bcftools_remain_gt.sh)

3. Make file list of genotype only vcfs. [02.3.make_imputed_genotypes_list_gt.sh](02.3.make_imputed_genotypes_list_gt.sh)

4. Make info file for each vcf file by IMMerge. [02.4.make_new.info.sh](02.4.make_new.info.sh)

5. Can check are there any variants are removed by [02.5.check_var_numbers_info_records.sh](02.5.check_var_numbers_info_records.sh)

6. Merge all cohorts by IMMerge. [03.1.IMMerge.all.sh](03.1.IMMerge.all.sh)
