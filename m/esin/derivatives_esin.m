function [dydy0, dydA, dydt0, dydw, dydxc] = derivatives_esin(x, ampl, t0, w, xc)

% y = y0 + ampl .* exp(-x / t0) .* sin(pi .* (x - xc) / w);

N = size(x, 2);

dydy0 = ones(1, N); 

dydA = exp(-x / t0) .* sin((pi .* (x - xc)) / w);

dydt0 = (ampl .* x .* exp(-x / t0) .* sin((pi .* (x - xc)) / w)) / (t0 ^ 2);
 
dydw = -(pi .* ampl .* exp(-x / t0) .* cos((pi .* (x - xc)) / w) .* (x - xc)) / (w ^ 2);

dydxc = -(pi .* ampl .* exp(-x / t0) .* cos((pi .* (x - xc)) / w)) / w;
