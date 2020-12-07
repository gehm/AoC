#!/usr/bin/env python
# AoC 2020 Day 5
from dataclasses import dataclass
from math import floor

@dataclass
class BoardingPass:
    row: int = None
    column: int = None
    def get_id(self):
        return int((self.row * 8) + self.column)


def calc(code,base):
    out = [0,base]
    for i in code:
        if (i == "F") or (i == "L"):
            out[1] = out[0] + floor((out[1] - out[0])/ 2)
        elif (i == "B") or (i == "R"):
            out[0] = out[1] - floor((out[1] - out[0])/ 2)
    return int(out[0])


with open("input/day5.txt") as fh:
    infile = fh.read().splitlines()
fh.close()

stack = []

for i in infile:
    r = calc(i[:7],127)
    c = calc(i[-3:],7)
    bp = BoardingPass(r, c)
    stack.append(bp)

seat_ids = []
for i in stack:
    seat_ids.append(i.get_id())

seat_ids = sorted(seat_ids)
print('The highest of the', len(seat_ids), 'IDs is:', max(seat_ids))

for i in range(len(seat_ids) -1):
    if (seat_ids[i + 1] - seat_ids[i]) > 1:
        print(seat_ids[i] + 1, "should be my seat")


