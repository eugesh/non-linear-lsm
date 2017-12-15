syms x a b c

y = c + b * x + a * x * x;

dyda = diff(y, a)
dydb = diff(y, b)
dydc = diff(y, c)
dydx = diff(y, x);
