syms x y0 ampl t0 xc w 

% ft_a = fittype('A*exp(-x/t0)*sin(pi*(x-xc)/w)');
y = y0 + ampl * exp(-x / t0) * sin(pi * (x - xc) / w);

dydx = diff(y, x);
dydy0 = diff(y, y0)
dydA = diff(y, ampl)
dydt0 = diff(y, t0)
dydw = diff(y, w)
dydxc = diff(y, xc)

