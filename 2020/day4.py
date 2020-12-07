#!/usr/bin/env python
# AoC 2020 Day 4

# Define Object
from dataclasses import dataclass
@dataclass
class ID:
    byr: str = None
    iyr: str = None
    eyr: str = None
    hgt: str = None
    hcl: str = None
    ecl: str = None
    pid: str = None
    cid: str = None

    def valid(self):
        args = [self.byr, self.iyr, self.eyr, self.hgt, self.hcl, self.ecl, self.pid, self.cid]
        return all(args)

    def valid_cid(self):
        args = [self.byr, self.iyr, self.eyr, self.hgt, self.hcl, self.ecl, self.pid]
        return all(args)

    def print(self):
        print(self.byr, self.iyr, self.eyr, self.hgt, self.hcl, self.ecl, self.pid, self.cid)


with open("input/day4.txt") as fh:
    infile = fh.read().splitlines()
fh.close()

id_batch = []
id = ID()

for line in infile:
    if line == '':
        id_batch.append(id)
        id = ID()
    else:
        for pair in line.split(' '):
            (field, value) = pair.split(':')
            setattr(id, field, value)
id_batch.append(id)

valid_ids = 0
valid_miss_cid = 0
for x in id_batch:
    x.print()
    if x.valid():
        valid_ids += 1
    if x.valid_cid():
        valid_miss_cid += 1

print('The Batch has ', len(id_batch), "IDs and ", valid_ids, ' are realy valid, and ', valid_miss_cid, ' without cid.')
