function n = numint(fh, xmin, xmax, dx)
% NUMINT   Simple numerical integration.
%    NUMINT(FH, XMIN, XMAX) approximates the definite Riemann integral of the function
%    specified by the handle FH between XMIN and XMAX. The default DX is 0.01.
%    NUMINT(FH, XMIN, XMAX, DX) allows you to specify your own DX.

% $Id$

% Set default dx value if not specified.
if nargin < 4
    dx = 0.01;
end

% Initializing the sum.
n = 0;

% Initializing the position counter.
x = xmin;

% Number of intervals over which to sum.
ni = floor((xmax - xmin) / dx);

% Sum by approximating the functions by rectangles over the intervals.
for k = 1 : ni
    n = n + fh(x) * dx;
    x = x + dx;
end