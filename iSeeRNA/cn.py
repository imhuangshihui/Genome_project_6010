with open('lncRNA.gff', 'r') as fh:
    output = open('newnc.gff', 'w')
    for line in fh:
        line = line.split('\t')
        line[0] = 'chr' + line[0]
        # print(line[0])
        line_str = '\t'.join(line)
        print(line_str)
        output.write(line_str)
    output.close()
