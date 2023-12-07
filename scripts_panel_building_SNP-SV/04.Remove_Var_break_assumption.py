import gzip
import re
import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument("infile")
parser.add_argument("outfile")
args = parser.parse_args()
PATH = args.infile
OUT  = args.outfile

#PATH="/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/vcfs/phased/chr1/chr1:900001-2000000.phased.vcf.gz"
#PATH="/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/vcfs/phased/chr1/chr1:1-1000000.phased.vcf.gz"

# check In and out path are not identical
if PATH == OUT:
    print("Error : In and out filename sould not be identical!")
    sys.exit(0)

# get file name
try:
    match = re.match(".+/(.+:([0-9]+)-[0-9]+.+\.vcf\.gz)", PATH)
    print(f"file name :  {match.group(1)}")
    print(f"start pos :  {match.group(2)}")
    
    start_pos = int(match.group(2))
    
except AttributeError:
    print("File name format is wrong: {PATH}")

    

# read file
print("Read file")
text = []
with gzip.open(PATH, 'r') as file:
    for line in file:
        text.append(line.decode('utf-8'))
 
# remove Variants not in overlap region
def check_break_assumption(text, start_pos):
    for line in text:
        if (line[0] != "#"):
            Var = line.replace("\n","").split("\t")
            if int(Var[1]) < start_pos: 
                # if Variant position small than start position return True
                return(True)
                break
            else:
                return(False)
                break

def remove_line_break_assuption(text, start_pos):
    text_modified = []

    for line in text:
        if (line[0] != "#"):
            Var = line.replace("\n","").split("\t")
            if int(Var[1]) < start_pos: 
                pass
            else:
                text_modified.append(line)
        else:
            text_modified.append(line)
    return(text_modified)


## Run the process
print("Run main process")
print(f"Break Assuption : {check_break_assumption(text, start_pos)}")
if check_break_assumption(text, start_pos):
    print("Removing lines break assuption.")
    text_modified = remove_line_break_assuption(text, start_pos)
    
    # output file
    print("Writing files")
    with gzip.open(OUT, 'wt') as f:
        for line in text_modified:
            f.write(line)

    print(f"file was saved at : {OUT}")
    sys.exit(0)

else:
    print("This file do not break assuption.")
    sys.exit(1)


