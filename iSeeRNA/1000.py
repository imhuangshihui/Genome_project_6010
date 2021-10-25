with open("mRNA.gff", "r") as file:
    rna_num = 0
    count = 0
    for line in file:
        line = line.split("\t")
        for word in line:
            if word == "mRNA":
                rna_num += 1
        if rna_num == 1001:
            break
        count += 1
print("rna_num: ", rna_num)
print("line_num: ", count)
