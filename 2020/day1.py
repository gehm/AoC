# AoC 2020 Day 1

infile = open("input/day1.txt", "r")
inlist = [line.rstrip('\n') for line in infile]
inlist = list(map(int, inlist))
year = 2020

def match(x,y,z=1):
    if (y in inlist):
        return x * y * z

for i in inlist:
    solo = year - i
    if match(i, solo):
        two_elements = match(i, solo)
    else:
        for j in inlist:
            if not i == j:
                trible = year - i - j
                if match(j, trible):
                    three_elements = match(j, trible, i)


print("Zwilling: ", two_elements, "Drilling: ", three_elements)
