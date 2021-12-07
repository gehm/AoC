#!/usr/bin/env python
# AoC 2020 Day 7
import re


with open("input/day7.txt") as fh:
    infile = fh.read().splitlines()
fh.close()

rules = []
my_bag = "shiny gold"
count = 0
for line in infile:
    bag, rest = line.split(' bags contain ')
    contains = re.findall(r'(\d+)\s(\w*\s\w*)', rest)
    this_bag = [bag, contains]
    rules.append(this_bag)

for i in rules:
    print(i)
    for c in i[1]:
        if my_bag in c:
            count += 1
        else:
            

print(count)


