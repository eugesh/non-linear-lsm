% cd(fileparts(mfilename('fullpath')))
pwd
% addpath ./../../common
addpath D:\projects\matlab\nonlinear_lsm\m\common

%% Model description
% y = y0 + ampl .* sin(w .* (x - xc));
nparams = 3;

%% Interaction with user.
[file_name_radio, path_radio, file_name_attenuation, path_attenuation, Rmeas, f_p, comment] = user_input();
fullpath_radio = fullfile(path_radio, file_name_radio);
fullpath_attenuation = fullfile(path_attenuation, file_name_attenuation);

%% Read testing set. 
% Read .csv files.
[pointNumbers1, radioData, start1, increment1] = read_csv(fullpath_radio);
[pointNumbers2, attenuationData, start2, increment2] = read_csv(fullpath_attenuation);

% Recalculate timestamps scale.
t_points_radio = pointNumbers1 * increment1 + start1;
t_points_attenuation = pointNumbers2 * increment2 + start2;

%% Interaction with user.
% Estimate the end of the radio signal and the last analysing point of
% attenutaion signal.
[t_end_radio, t_end_attenuation] = ...
    find_radio_signal_end_user(t_points_radio, radioData, t_points_attenuation, attenuationData);

indices_to_analyze_radio = t_points_radio < t_end_radio;
indices_to_analyze_attenuation = ...
    (t_points_attenuation  >= t_end_radio) & (t_points_attenuation < t_end_attenuation);

t_r = t_points_radio(indices_to_analyze_radio);
y_r = radioData(indices_to_analyze_radio);

t_a = t_points_attenuation(indices_to_analyze_attenuation);
y_a = attenuationData(indices_to_analyze_attenuation);

%% Prepare input data.
% Cum sum.
cumsum_radio = cumsum(y_r);
cumsum_attenuation = cumsum(y_a - mean(y_a));

% Decimation.


% Median filtering or integration(cumsum).
median_radio = medfilt1(y_r, 21);
median_attenuation = medfilt1(y_a, 221);

% Cut off part of timeseries with too small aplitudes.

%% Determine num of peaks finding intersections with zero,
[n_peaks_r, f_r] = peak_analysis(median_radio);
[n_peaks_a, f_a] = peak_analysis(median_attenuation);

%% Estimate Q-quality by measuring amplitudes at the beginning and at the last peak.

% Estimate frequency.

% Estimate phase.

% Fit model, using estimated parameters.

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