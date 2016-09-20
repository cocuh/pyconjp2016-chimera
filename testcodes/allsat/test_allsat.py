import allsat

solver = allsat.AllSAT( [[1,2], [-2,3]])
print(solver.enumerate())
