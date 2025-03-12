## Validate imputed SVs by variants

1. Generate BED files from vcf file of all imputed SVs. [00.1.make_all_sample_bed_imp.sh](00.1.make_all_sample_bed_imp.sh)

2. Intersect each sample between imputation and WGS data (WGS data are generated from by_sample steps). [00.2.intersect_imp_wgs.sh](00.2.intersect_imp_wgs.sh)

3. Merge all WGS sample together. [00.3.make_all_smaple_bed.wgs.R](00.3.make_all_smaple_bed.wgs.R)

4. Generate BED file that have consensus SVs for imputation and WGS datasets. [00.4.make_consensus_beds.R](00.4.make_consensus_beds.R)

5. Compare genotypes by [01.Run_compare_gt.sh](01.Run_compare_gt.sh) and [compare_gt.py](compare_gt.py)
