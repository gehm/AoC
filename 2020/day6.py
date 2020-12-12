#!/usr/bin/env python
# AoC 2020 Day 6
import string

with open("input/day6.txt") as fh:
    infile = fh.read().splitlines()
fh.close()
all_answers = []
group_answers = []


for line in infile:
    if line == '':
        all_answers.append(group_answers)
        group_answers = []
    else:
        group_answers.append(line)    # one filed per person

all_answers.append(group_answers)   # append last person

total_count = 0

for i in all_answers:
    count = 0
    size = len(i)
    for l in string.ascii_lowercase:
        if all(l in s for s in i):
            count += 1
    print("Group has ", size, "members. And has ", count, " common chars.")
    total_count += count

print("We have ", len(all_answers), "groups in total. And we have a total of", total_count, "common answers.")