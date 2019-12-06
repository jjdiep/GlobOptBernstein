function [cost,constraints,feasible_point] = setup_problem_matrix_more_2(num)
cost = [[   0,   0, -424.75]
        [ 1.0,   0,   299.0]
        [ 2.0,   0,   -99.0]
        [   0, 1.0,   600.0]];

degree = [   0,     0;
             2,     0;
             0,     2;
             1,     1;
             1,     0;
             0,     1];
         
constraints = cell(num,1);

feasible_point = rand(2,1);

for i = 1:num
    rand_num = 10 * rand(5,1) - 5;
    coef = [0;rand_num];
    con_mat = [degree,coef];
    diff = evaluate_function(con_mat,feasible_point);
    if diff >= 0
        con_mat(1,3) = con_mat(1,3) - diff - rand() / 10;
    end
    
    constraints(i) = {con_mat};
end

end