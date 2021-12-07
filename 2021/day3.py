#!/usr/bin/env python
# AoC 2021 Day 3

import numpy as np

def getdecimal(binarray):
    return binarray.dot(2**np.arange(binarray.size)[::-1])

def getmajor(array,coll):
    return np.count_nonzero(array[:,coll], axis=0)

array = np.genfromtxt("input/day3.txt", dtype=None, delimiter=1)
gamma = np.count_nonzero(array, axis=0)

with np.nditer(gamma, op_flags=['readwrite']) as it:
    for x in it:
        if x / 1000 > 0.5:
            x[...] = 1
        else:
            x[...] = 0


print('Gamma rate: ', getdecimal(gamma))
print(gamma)
epsilon = 1-gamma
print('Epsilon rate: ', getdecimal(epsilon))
print('Power consumption: ', getdecimal(epsilon)*getdecimal(gamma))
print('---------------Life Support Rating-----------------')
o2gen = np.empty(12)
co2scrubber = np.empty(12)






