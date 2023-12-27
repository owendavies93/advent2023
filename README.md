## Advent of Code 2023

### TODO
* Make Day 3 work without modifying the input
   * Just need to fix the edge detection
* Improve Day 10 start node detection
   * Currently just hardcoded for real and example inputs
* Improve Day 17 bounds checking and coordinate extraction
   * Should all be doable in the 1d grid instead of splitting and combining
* Implement a version of Day 24 without shelling out to Mathematica
   * Possibly using Perl Z3 bindings? Although that's not much better
* Make Day 25 work for all inputs

### Current Runtimes
On my crappy VPS.

```
.---------------------------------------.
|                Runtimes               |
+-----+----------------+----------------+
| Day | Part 1 Runtime | Part 2 Runtime |
+-----+----------------+----------------+
|   1 | 142 ms         | 735 ms         |
|   2 | 142 ms         | 131 ms         |
|   3 | 4036 ms        | 1950 ms        |
|   4 | 139 ms         | 139 ms         |
|   5 | 137 ms         | 151 ms         |
|   6 | 159 ms         | 3303 ms        |
|   7 | 281 ms         | 287 ms         |
|   8 | 142 ms         | 176 ms         |
|   9 | 148 ms         | 188 ms         |
|  10 | 236 ms         | 301 ms         |
|  11 | 1315 ms        | 1473 ms        |
|  12 | 538 ms         | 6383 ms        |
|  13 | 167 ms         | 168 ms         |
|  14 | 158 ms         | 10807 ms       |
|  15 | 171 ms         | 166 ms         |
|  16 | 183 ms         | 11386 ms       |
|  17 | 3595 ms        | 13127 ms       |
|  18 | 402 ms         | 109 ms         |
|  19 | 129 ms         | 185 ms         |
|  20 | 763 ms         | 2159 ms        |
|  21 | 582 ms         | 1919 ms        |
|  22 | 17795 ms       | 19459 ms       |
|  23 | 1082 ms        | 52032 ms       |
|  24 | 281 ms         | 139 ms         |
|  25 | 145 ms         | -              |
'-----+----------------+----------------'
```
