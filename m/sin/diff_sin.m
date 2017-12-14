syms x ampl y0 w xc

y = y0 + ampl * sin(w * (x - xc));

dy = diff(y, x);

dydy0 = diff(y, y0)
dydA = diff(y, ampl)
dydw = diff(y, w)
dydxc = diff(y, xc)
