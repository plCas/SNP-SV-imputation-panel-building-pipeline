## Validate imputed SVs by sample
1. Turn vcf of imputed SVs into BED format for each sample. [01.make_sample_bed_imp.sh](01.make_sample_bed_imp.sh)

2. Turn vcf of WGS SVs into BED format for each sample. [02.make_sample_bed_wgs.sh](02.make_sample_bed_wgs.sh)

3. Compare SV genotypes. [03.compare_gt.sh](03.compare_gt.sh)
