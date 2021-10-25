with open('rn6.fa', 'r') as f:
    d = f.read()
    data = [i for i in d.split('>')]

output = open("rn6.filter.fa", "w")

for i in data:
    ch = i.split('_')
    if len(ch) == 1:
            output.write('>')
            output.write(i)



