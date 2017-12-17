syms x ampl t0 xc w 

% ft_a = fittype('A*exp(-x/t0)*sin(pi*(x-xc)/w)');
y = ampl * exp(-x / t0) * sin(w * (x - xc));

dydx = diff(y, x);
dydA = diff(y, ampl)
dydt0 = diff(y, t0)
dydw = diff(y, w)
dydxc = diff(y, xc)

