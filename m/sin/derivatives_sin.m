function [dydA, dydw, dydxc] = derivatives_sin(x, ampl, w, xc)

N = size(x, 2);

dydx = ampl .* w .* cos(w .* (x - xc));

% dydy0 = 1;
% dydy0 = ones(1, N);
 
dydA = sin(w .* (x - xc));

dydw = ampl .* cos(w .* (x - xc)) .* (x - xc);
 
dydxc = -ampl .* w .* cos(w .* (x - xc));
