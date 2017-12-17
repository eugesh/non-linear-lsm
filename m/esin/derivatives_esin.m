function [dydA, dydt0, dydw, dydxc] = derivatives_esin(x, ampl, t0, w, xc)

% y = ampl .* exp(-x / t0) .* sin(w .* (x - xc));

dydA = exp(-x/t0).*sin(w.*(x - xc));
 
dydt0 = (ampl.*x.*exp(-x/t0).*sin(w.*(x - xc)))/t0^2;
 
dydw = ampl.*exp(-x/t0).*cos(w.*(x - xc)).*(x - xc);
 
dydxc = -ampl.*w.*exp(-x/t0).*cos(w.*(x - xc));
