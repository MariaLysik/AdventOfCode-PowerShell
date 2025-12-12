from functools import cache
from os import path

data = open(path.join(path.dirname(__file__), "1.1.txt")).read()
graph = {f: ts.split() for f,ts in [line.split(": ") for line in data.split("\n")]}

@cache
def countPaths(start, end):
  return 1 if start == end else sum(countPaths(n, end) for n in graph.get(start, []))

print("Part 1:", countPaths("you", "out"))
p2  = countPaths("svr", "fft") * countPaths("fft", "dac") * countPaths("dac", "out")
p2 += countPaths("svr", "dac") * countPaths("dac", "fft") * countPaths("fft", "out")
print("Part 2:", p2)