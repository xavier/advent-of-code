day = 24

from functools import reduce
from itertools import combinations
from operator import mul

wts = [1, 2, 3, 5, 7, 13, 17, 19, 23, 29, 31, 37, 41, 43, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113]

def day24(num_groups):
    group_size = sum(wts) // num_groups
    for i in range(len(wts)):
        qes = [reduce(mul, c) for c in combinations(wts, i)
              if sum(c) == group_size]
        if qes:
            return min(qes)

print(day24(3))
print(day24(4))
