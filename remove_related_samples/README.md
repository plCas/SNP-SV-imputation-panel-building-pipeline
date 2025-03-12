## Calculate IBD and PCA by PLINK
1. Generate bed file. [00.1.plink_make_bed.sh](00.1.plink_make_bed.sh)

2. Merge all chromosome togather. [00.2.plink_merge_bed.sh](00.2.plink_merge_bed.sh)

3. Calculate IBD. [01.plink_IBD.sh](01.plink_IBD.sh)

4. Generate related sample list [02.make_rm_sample_list.sh](02.make_rm_sample_list.sh): <br>
     a. remain sample pairs with PI_HAT > 0.4 <br>
     b. Select a sample with most related samples. Add the sample to the remove list and remove all pairs that include the sample. <br>
     c. Use the new file for step b. and repeat until there are no more samples related to more than one sample. <br>
     d. choose the half samples from the rest sample-pair file and add to the remove list for generate the final related sample list. <br>

5. Remove related sample from the whole sample list. [03.make_final_sample_list.sh](03.make_final_sample_list.sh)

## Calulate PCA
[plink_pca.sh](plink_pca.sh)
