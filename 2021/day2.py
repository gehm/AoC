#!/usr/bin/env python
# AoC 2021 Day 2

with open("input/day2.txt") as fh:
    infile = fh.read().splitlines()
fh.close()

x = 0
y = 0
z = 0
aim = 0

for line in infile:
    (dir, value) = line.split(' ')
    if dir == "forward":
        x = x + int(value)
        z = z + (aim * int(value))
    if dir == "down":
       #z = z + int(value)
        aim = aim + int(value)
    if dir == "up":
        #z = z - int(value)
        aim = aim - int(value)

final = x * z
print('The answer of the part is', final )