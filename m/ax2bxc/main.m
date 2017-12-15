%% Define parameters. They must match with solution.
% y = c + b * x + a * x * x;
a_0  = 10; b_0 = 10; c_0 = 1;
nparams = 3;

%% Create testing set. 
x = 0 : 0.1 : 10;
y = test_sample_creator_axxbxc(x, a_0, b_0, c_0);

%% Solve nonlinear probleme.
% Solver parameters
al = 1e-7; % Tikhonov regularization param
al = 0; % Tikhonov regularization param
% Initial seeking coefficients values.
a = 0; b = 1; c = 1/5;

% Approximation loop
for i = 1:1
    y_calc = c + b .* x + a .* x .* x;
    
    [dyda, dydb, dydc] = derivatives_axxbxc(x);
    A = [dyda; dydb; dydc;];
    B = y - y_calc;
    
    % Reshape singular matrix to square shape
    AE = A * A';
    BE = A * B';
    % Linear LSM.
    corrs = (AE + al * eye(nparams)) \ BE;
    % corrs = lsqlin(A',B);
    
    % Solution vector correction.
    a = a + corrs(1);
    b = b + corrs(2); 
    c = c + corrs(3);
end