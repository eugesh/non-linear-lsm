syms x amplA t0 w amplB amplC

% ft_a = fittype('A*exp(-x/t0)*sin(pi*(x-xc)/w)');
y = amplA * exp(-x / t0) * (amplB * sin(w * x) + amplC * cos(w * x));

dydx = diff(y, x);
dydA = diff(y, amplA)
dydB = diff(y, amplB)
dydC = diff(y, amplC)
dydt0 = diff(y, t0)
dydw = diff(y, w)
