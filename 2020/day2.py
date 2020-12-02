#!/usr/bin/env python
# AoC 2020 Day 2
good_pwds = 0
good_pwds2 = 0
fh = open("input/day2.txt", "r")
line = fh.readline()


def checkpass(pol, pwd):
    (number, string) = pol.split()
    (low, high) = number.split('-')
    if int(low) <= pwd.count(string) <= int(high):
        return True


def checkpass2(pol, pwd):
    (number, string) = pol.split()
    (first, sec) = number.split('-')
    first = int(first) - 1
    sec = int(sec) - 1
    if (pwd[first] == string) ^ (pwd[sec] == string):
        return True


while line:
    (policy, passwd) = line.split(':')
    if checkpass(policy, passwd.strip()):
        good_pwds = good_pwds + 1
    if checkpass2(policy, passwd.strip()):
        good_pwds2 = good_pwds2 + 1
    line = fh.readline()
fh.close()

print('The inputfile has ', good_pwds, ' valid passwords according to Part 1.\n')
print('The inputfile has ', good_pwds2, ' valid passwords according to Part 2.\n')


