%% Define parameters. They must match with solution.
% y = amplA * exp(-x / t0) * (amplB * sin(w * x) + amplC * cos(w * x));

amplA_0 = 10; amplB_0 = 10; amplC_0 = 10; t0_0 = 10; w_0 = 10;
nparams = 5;

%% Create testing set. 
x = 0 : 0.01 : 10;
y = test_sample_creator_esin(x, amplA_0, amplB_0, amplC_0, t0_0, w_0);

y = 2 * y ./ (max(y) - min(y));

%% Solve nonlinear probleme.
% Solver parameters.
al = 1e-7; % Tikhonov regularization param
eps_stop = 0.1;

% Initial seeking coefficients values.
% Estimate amplitude.
amplA = max(y);
amplB = amplA;
amplC = amplA;
% Estimate attenuation t0.
N = length(y);
Abegin = amplA;
Aend = (max(y(0.9 * N : N)) - min(y(0.9 * N : N))) / 2;
n_peaks = size(find([0 diff(sign(y))]~=0)) / 2;
t0_est = log(Abegin / Aend) / n_peaks(2);
t0 = t0_est;

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
w = 10;
t0 = 10;

% Approximation loop
stop = 0;
i = 0;
N_iter = 10000;
while stop == 0 && i < N_iter
    y_calc  = amplA .* exp(-x / t0) .* (amplB .* sin(w .* x) + amplC .* cos(w .* x));
    
    [dydA, dydB, dydC, dydt0, dydw] = derivatives_esin(x, amplA, amplB, amplC, t0, w);
    A = [dydA; dydB; dydC; dydt0; dydw;];
    B = y - y_calc;
    
    % Reshape singular matrix to square shape
    AE = A * A';
    BE = A * B';
    % Linear LSM.
    %     corrs = (AE + al * eye(nparams) ) \ BE;
    corrs = (AE + al .* diag(diag(AE))) \ BE;
    % corrs = lsqlin(A', B);
    
    % Solution vector correction.
    amplA = amplA + corrs(1);
    amplB = amplB + corrs(2);
    amplC = amplC + corrs(3);
    t0 = t0 + corrs(4);
    w = w + corrs(5);
    % Root square of sum of squares.
    if rssq(corrs) < eps_stop
        stop = 1;
    end
    i = i + 1;
end

y_s = test_sample_creator_esin(x, amplA, amplB, amplC, t0, w);
