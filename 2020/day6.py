#!/usr/bin/env python
# AoC 2020 Day 6

with open("input/day6.txt") as fh:
    infile = fh.read().splitlines()
fh.close()
group_answers = []
answers = ""
all_answers = []

for line in infile:
    if line == '':
        group_answers.append(answers)
        answers = ""
    else:
        for i in line:
            if i not in answers:
                answers = answers + i

group_answers.append(answers)

count = 0
for i in group_answers:
    count += len(i)

print(count)