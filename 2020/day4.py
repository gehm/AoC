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

import re
def validate(key,value):
    if key == "byr" and int(value) in range(1920, 2003):
        return True
    elif key == "iyr" and int(value) in range(2010, 2021):
        return True
    elif key == "eyr" and int(value) in range(2020, 2031):
        return True
    elif key == "hgt":
        res = re.findall(r'^(\d+)(in|cm)$', value)
        for tuple in res:
            if tuple[1] == "cm" and int(tuple[0]) in range(150, 194):
                return True
            elif tuple[1] == "in" and int(tuple[0]) in range(59, 77):
                return True
    elif key == "hcl" and re.search(r'^\#[a-f0-9]{6}$', value):
        return True
    elif key ==  "ecl" and value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]:
        return True
    elif key == "pid" and re.search(r'^[0-9]{9}$', value):
        return True
    elif key == "cid":
        return True
    else:
        return False

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
            if validate(field, value):
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
