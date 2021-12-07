#!/usr/bin/env python
# AoC 2021 Day 1

def read_integers(filename):
    with open(filename) as f:
        return [int(x) for x in f]

list = read_integers("input/day1.txt")
x = list.pop(0)
counter = 0

for y in list:
    if int(x) < int(y):
        counter = counter + 1
    x = y


print('We have ', counter, ' increasing subs.')

print('Part two:')
list = read_integers("input/day1.txt")

tribles = []

while len(list) >= 3:

    x = list[1] + list[2] + list.pop(0)
    print(x)
    tribles.append(x)

x = tribles.pop(0)
counter = 0

for y in tribles:
    if int(x) < int(y):
        counter = counter + 1
    x = y


print('We have ', counter, ' increasing tribles.')

