'''
usage: python find_transcript.py ID.txt annot.gff3 output
sys.argv[1]: ID.txt
sys.argv[2]: annot.gff3
sys.argv[3]: output
Author: Shihui HUANG
2021.10.24
'''
import sys

with open(sys.argv[1], 'r') as file1:
    # create an empty list to store ID
    ID = []
    for line in file1:
        line = line.strip('\n')
        ID.append(line)
        # print(ID)
with open(sys.argv[2], 'r') as file2:
    output = open(sys.argv[3], 'w')
    for line in file2:
        line = line.split('\t')
        t1 = line[-1].split(';')
        t2 = t1[0].split(':')
        t3 = t2[-1]
        #print(t3)
        line_str = '\t'.join(line)
        for _id in ID:
            if _id in t3:
            # line_str = '\t'.join(line)
                output.write(line_str)
    output.close()
