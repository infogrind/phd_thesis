function y = lattice_dn(x)
% LATTICE_DN   Find closest point in Schlaefli (or Checkerboard) lattice Dn
%    Y = LATTICE_DN(X) finds for a point X in R^N the closest point in the
%    N-dimensional Schlaefli lattice D_N.
%    The algorithm is taken from Conway & Sloane (1988), Ch. 20.

% $Id$

[f, w, k] = myround(x);

% Round all coordinates to nearest integer; if the sum of coordinates is
% not even then change the coordinate that leads to the smallest rounding
% error. 
y = f;

% In positions where the coordinates sum to an odd number, use w instead
% of f.
oddind = ~Lattice.iseven(sum(f,2));

% Now we compute a matrix that contains those indices of y where we need to
% replace the value with the corresponding value of w. 
repind = sub2ind(size(f), vec2ind(oddind)', k(oddind));

% This allows us to directly access y and w like this:
y(repind) = w(repind);


end


% Rounding function as described in C&S, p. 20
function [f, w, k] = myround(x)

f = round(x); % Round towards the nearest integer

% w is the result of rounding differently:
w = zeros(size(f));
w(x > 0 & f <= x) = f(x > 0 & f <= x) + 1;
w(x > 0 & x < f)  = f(x > 0 & x <  f) - 1;
w(x == 0) = 1;
w(x < 0 & f >= x) = f(x < 0 & f >= x) - 1;
w(x < 0 & f < x)  = f(x < 0 & f < x) + 1;

% Compute coordinate position of smallest quantization error.
[nil, k] = max(abs(f - x),[],2);

end