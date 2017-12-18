function [dydA, dydB, dydC, dydt0, dydw] = derivatives_esin(x, amplA, amplB, amplC, t0, w)

% y = ampl .* exp(-x / t0) .* sin(w .* (x - xc));

dydA = exp(-x / t0) .* (amplC .* cos(w .* x) + amplB .* sin(w .* x));

dydB = amplA .* exp(-x / t0) .* sin(w .* x);
  
dydC = amplA .* exp(-x / t0) .* cos(w .* x);
 
dydt0 = (amplA .* x .* exp(-x / t0) .* (amplC .* cos(w .* x) + amplB .* sin(w .* x))) / t0^2;
 
dydw = amplA .* exp(-x / t0) .* (amplB .* x .* cos(w .* x) - amplC .* x .* sin(w .* x));
