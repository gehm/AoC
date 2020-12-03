#!/usr/bin/env python
# AoC 2020 Day 3
trees = 0
answer = 1
run = 0
x_step = [1, 3, 5, 7, 1]
y_step = [1, 1, 1, 1, 2]


with open("input/day3.txt") as fh:
    local_map = fh.readlines()
local_map = [x.strip() for x in local_map]
fh.close()

while run < len(x_step):
    x_pos = 0
    y_pos = 0
    trees = 0
    while (y_pos + y_step[run]) < len(local_map):
        x_pos = x_pos + x_step[run]
        y_pos = y_pos + y_step[run]
        line = local_map[y_pos]

        if x_pos < len(line):
            if line[x_pos] == '#':
                trees = trees + 1
        else:
            x_pos = x_pos - len(line)
            if line[x_pos] == '#':
                trees = trees + 1
    print("Trees: ", trees, "in run ", run)
    run = run + 1
    answer = answer * trees


print("Answer: ", answer)



