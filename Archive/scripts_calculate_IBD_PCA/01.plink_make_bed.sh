CHR=$1
DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build
OUT=$DIR/bed_file
mkdir -p $OUT

plink=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/plink1.9/plink

bi=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/datasets/36K_preview_release_merged-CHR-files/gcad.preview.compact.r4.wgs.36361.GATK.2022.08.15.biallelic.genotypes.chr$CHR.ALL.vcf.bgz

$plink  --double-id \
        --vcf $bi \
        --out $OUT/chr$CHR.bi \
        --make-bed \
        --set-missing-var-ids @:#:\$1:\$2 \
        --maf 0.05
