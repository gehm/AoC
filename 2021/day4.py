#!/usr/bin/env python
# AoC 2021 Day 4

import numpy as np

seq = np.genfromtxt("input/day4.txt", dtype=int, delimiter=',', max_rows=1)


def marknumber(a, num):
    #a = np.where(a == num, 'x', a)
    a[a == num] = np.nan

def bingo(a):
    #if bingo in a.tolist() or bingo in b.tolist():
    if np.apply_along_axis(allnans, 1, arr=a).any() or np.apply_along_axis(allnans, 0, arr=a).any():
        return 1
    else:
        return 0

def allnans(x):
    return np.isnan(x).all()


fields = np.genfromtxt("input/day4.txt", skip_header=1)
# print(a.shape)

list_of_array = np.array_split(fields, fields.shape[0]/5)
# print(array[0])
total = len(list_of_array)
isbingo = []

# gen = (x for x in seq if not isbingo)
#for x in gen:
for x in seq:
    print('The next number is: ', x)
    for i in list_of_array:
        marknumber(i, x)
        #print(i)
        #print(' ')
        if bingo(i):
            isbingo.append(np.nansum(i)*x)
            print('BINGO!', isbingo[-1])
            i.fill(-1)


print('\n-----------------------------\nFirst board checksum: ', isbingo[0], '\nLast board checksum: ', isbingo[-1])

