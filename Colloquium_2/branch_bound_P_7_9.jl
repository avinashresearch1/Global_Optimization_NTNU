using JuMP
using GLPK
using OrderedCollections

m = JuMP.Model()

@variables(m, begin
    0 <= x
    0 <= y1 <= 1
    0 <= y2 <= 1
    0 <= y3 <= 1
end)


# RMILP
@constraints(m, begin   
    −x + 3y1 + 2y2 + y3 ≤ 0
    −5y1 − 8y2 − 3y3 ≤ −9  
end) #sadasd

@objective(m, Min, x + y1 + 3y2 + 2y3)

print(m)
set_optimizer(m, GLPK.Optimizer)
# Solving the optimization problem:

# Simple post-processing
function run_node(m)
    JuMP.optimize!(m)
    println(solution_summary(m))
    vars = [x, y1, y2, y3]
    return soln_dict = OrderedDict(var => value(var) for var in vars)
end

# RMILP - Root node
run_node(m)

# Add y1 = 0
fix(y1, 0; force = true)
run_node(m)

# Add y1 = 0 and y3 = 0
fix(y3, 0; force = true)
run_node(m)

# Add y1 = 0 and y3 = 1
fix(y3, 1; force = true)
run_node(m)

# Add y1 = 0, y3 = 1, y2 = 0
fix(y2, 0; force = true)
run_node(m)

# Add y1 = 0, y3 = 1, y2 = 1
fix(y2, 1; force = true)
run_node(m)

# Add y1 = 1
# Start from line 5 here to keep UBDs on y2 
fix(y1, 1; force = true)
run_node(m)

# Add y1 = 1, y2 = 0
fix(y2, 0; force = true)
run_node(m)

# Add y1 = 1, y2 = 1
fix(y2, 1; force = true)
run_node(m)
