syms x ampl w xc

y = ampl * sin(w * (x - xc));

dy = diff(y, x);

% dydy0 = diff(y, y0)
dydA = diff(y, ampl)
dydw = diff(y, w)
dydxc = diff(y, xc)
