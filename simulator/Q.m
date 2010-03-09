function y = Q(x)
% Q - Q-function (complement to Gaussian CDF).
% Q(x) = Integral of 1/sqrt(2pi) exp(-x^2/2) from x to +inf.

% $Id$

y = 1 - (1 + erf(x/sqrt(2)))/2;
