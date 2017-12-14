%% Define parameters. They must match with solution.
% y = y0 + ampl .* sin(w .* (x - xc));
y0 = 0; ampl = 10; w = 1/6; xc = 1;
nparams = 4;

%% Create testing set. 
x = 0 : 0.01 : 10;
y = test_sample_creator_sin(x, y0, ampl, w, xc);

%% Solve nonlinear probleme.
% Solver parameters
al = 1e-7; % Tikhonov regularization param
% Initial seeking coefficients values.
y0 = 0; ampl = 1; w = 1/5; xc = 1;

% Approximation loop
for i = 1:10000
    y_calc = y0 + ampl .* sin(w .* (x - xc));
    
    [dydy0, dydA, dydw, dydxc] = derivatives_sin(x, ampl, w, xc);
    A = [dydy0; dydA; dydw; dydxc;];
    B = y - y_calc;
    
    % Reshape singular matrix to square shape
    AE = A * A';
    BE = A * B';
    % Linear LSM.
    %     corrs = (AE + al * eye(nparams)) \ BE;
    corrs = lsqlin(A',B);
    
    % Solution vector correction.
    y0 = y0 + corrs(1);
    ampl = ampl + corrs(2); 
    w = w + corrs(3);
    xc = xc + corrs(4);
end