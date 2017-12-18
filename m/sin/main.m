%% Define parameters. They must match with solution.
% y = y0 + ampl .* sin(w .* (x - xc));
ampl_0 = 10; w_0 = 6; xc_0 = 1;
nparams = 3;

%% Create testing set. 
x = 0 : 0.001 : 10;
y = test_sample_creator_sin(x, ampl_0, w_0, xc_0);

%% Solve nonlinear problem.
% Solver parameters
al = 1e-7; % Tikhonov regularization param
eps_stop = 0.1;
% Initial seeking coefficients values.
ampl = max(y); w = 0; xc = 1;

% Frequency has to be estimated in advance.
L = length(y);
Fs = L;
NFFT = 2 ^ nextpow2(L); % Next power of 2 from length of y
Y = fft(y, NFFT) / L;
f = Fs / 2 * linspace(0, 1, NFFT / 2 + 1);

% Plot single-sided amplitude spectrum.
figure, plot(f, 2 * abs(Y(1 : NFFT / 2 + 1)))
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
[max_val, f_res] = max(abs(Y));
w_max = 2 * pi * f_res / max(x);
w = w_max;

% Approximation loop
stop = 0;
i = 0;
N_iter = 10000;
while stop == 0 && i < N_iter
    y_calc = ampl .* sin(w .* (x - xc));
    
    [dydA, dydw, dydxc] = derivatives_sin(x, ampl, w, xc);
    A = [dydA; dydw; dydxc;];
    B = y - y_calc;
    
    % Reshape singular matrix to square shape
    AE = A * A';
    BE = A * B';
    % Linear LSM.
    corrs = (AE + al * eye(nparams)) \ BE;
    % corrs = lsqlin(A',B);
    
    % Solution vector correction.
    ampl = ampl + corrs(1); 
    w = w + corrs(2);
    xc = xc + corrs(3);
    
    % Root square of sum of squares.
    if rssq(corrs) < eps_stop
        stop = 1;
    end
    i = i + 1;
end

y_s = test_sample_creator_sin(x, ampl, w, xc);