#!/usr/bin/env python
# AoC 2021 Day 3

import numpy as np


def getdecimal(binarray):
    return binarray.dot(2**np.arange(binarray.size)[::-1])


def getmajor(a, coll):
    n = np.count_nonzero(a[:, coll], axis=0) / a.shape[0]
    if n >= 0.5:
        return 1
    elif n < 0.5:
        return 0


def reduce(a, coll, n):
    np.delete(a, np.where(a[:, coll] != n)[0], axis=0)


array = np.genfromtxt("input/day3.txt", dtype=None, delimiter=1)
gamma = np.count_nonzero(array, axis=0)

with np.nditer(gamma, op_flags=['readwrite']) as it:
    for x in it:
        if x / array.shape[0] > 0.5:
            x[...] = 1
        else:
            x[...] = 0


print('Gamma rate: ', getdecimal(gamma))
print(gamma)
epsilon = 1-gamma
print('Epsilon rate: ', getdecimal(epsilon))
print('Power consumption: ', getdecimal(epsilon)*getdecimal(gamma))
print('---------------Life Support Rating-----------------')
o2gen = array.copy()
co2scrubber = array.copy()
print(o2gen.shape)

for i in range(o2gen.shape[1]):
    if o2gen.shape[0] > 1:
        major = getmajor(o2gen, i)
        o2gen = np.delete(o2gen, np.where(o2gen[:, i] != major)[0], axis=0)

for i in range(co2scrubber.shape[1]):
    if co2scrubber.shape[0] > 1:
        major = getmajor(co2scrubber, i)
        co2scrubber = np.delete(co2scrubber, np.where(co2scrubber[:, i] == major)[0], axis=0)

print('O2 gen rat: ', o2gen, getdecimal(o2gen), 'CO2 scrub rat: ', co2scrubber, getdecimal(co2scrubber))
print('Life Support rating: ', getdecimal(o2gen) * getdecimal(co2scrubber))
