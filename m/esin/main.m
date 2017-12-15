%% Define parameters. They must match with solution.
% y = y0 + ampl * exp(-x / t0) * sin(pi * (x - xc) / w);
y0_0 = 0; ampl_0 = 10; t0_0 = 1; w_0 = 1 / 60; xc_0 = 1;
nparams = 5;

%% Create testing set. 
x = 0 : 0.0001 : 10;
y = test_sample_creator_esin(x, y0_0, ampl_0, t0_0, w_0, xc_0);

%% Solve nonlinear probleme.
% Solver parameters
al = 1e-7; % Tikhonov regularization param
% al = 0; % Tikhonov regularization param
% Initial seeking coefficients values.
y0 = mean(y); ampl = max(y); t0 = 1; w = 1/50; xc = 1;

% Approximation loop
for i = 1:1000
    y_calc = y0 + ampl .* exp(-x / t0) .* sin(pi .* (x - xc) / w);
    
    [dydy0, dydA, dydt0, dydw, dydxc] = derivatives_esin(x, ampl, t0, w, xc);
    A = [dydy0; dydA; dydt0; dydw; dydxc;];
    B = y - y_calc;
    
    % Reshape singular matrix to square shape
    AE = A * A';
    BE = A * B';
    % Linear LSM.
    % corrs = (AE + al * eye(nparams)) \ BE;
    corrs = lsqlin(A',B);
    
    % Solution vector correction.
    y0 = y0 + corrs(1);
    ampl = ampl + corrs(2);
    t0 = t0 + corrs(3);
    w = w + corrs(4);
    xc = xc + corrs(5);
end