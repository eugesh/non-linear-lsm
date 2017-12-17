%% Define parameters. They must match with solution.
% y = ampl * exp(-x / t0) * sin(w * (x - xc));
ampl_0 = 10; t0_0 = 1; w_0 = 6; xc_0 = 1;
nparams = 4;

%% Create testing set. 
x = 0 : 0.01 : 10;
y = test_sample_creator_esin(x, ampl_0, t0_0, w_0, xc_0);

%% Solve nonlinear probleme.
% Solver parameters
al = 1e-7; % Tikhonov regularization param
% al = 0; % Tikhonov regularization param


% Initial seeking coefficients values.
% Estimate amplitude
ampl = max(y);
% Estimate attenuation.
N = length(y);
Abegin = ampl;
Aend = max(y(0.9 * N : N));
t0 = 1; 
% Frequency has to be estimated in advance.
w = 6; xc = 1;

% Approximation loop
for i = 1:1000
    y_calc = ampl .* exp(-x / t0) .* sin(w .* (x - xc));
    
    [dydA, dydt0, dydw, dydxc] = derivatives_esin(x, ampl, t0, w, xc);
    A = [dydA; dydt0; dydw; dydxc;];
    B = y - y_calc;
    
    % Reshape singular matrix to square shape
    AE = A * A';
    BE = A * B';
    % Linear LSM.
    %corrs = (AE + al * eye(nparams) ) \ BE;
    corrs = lsqlin(A', B);
    
    % Solution vector correction.
    ampl = ampl + corrs(1);
    t0 = t0 + corrs(2);
    w = w + corrs(3);
    xc = xc + corrs(4);
end