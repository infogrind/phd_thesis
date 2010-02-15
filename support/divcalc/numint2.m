function n = numint2(fh, xmin, xmax, ymin, ymax, dx)
% NUMINT2   Simple twodimensional numerical integration.
%    NUMINT2(FH, XMIN, XMAX, YMIN, YMAX) approximates the definite Riemann
%    integral of the function specified by the handle FH between XMIN and XMAX
%    and YMIN and YMAX. The default DX is 0.01. NUMINT(..., DX) allows you to
%    specify your own DX.

% $Id$

% Set default dx value if not specified.
if nargin < 6
    dx = 0.01;
end

% Initializing the sum.
n = 0;

% Initializing the position counter.
x = xmin;

% Number of intervals over which to sum.
nix = floor((xmax - xmin) / dx);
niy = floor((ymax - ymin) / dx);

% Sum by approximating the functions by rectangles over the intervals.
for k = 1 : nix
    y = ymin;
    for l = 1 : niy
        n = n + fh(x, y) * dx^2;
        y = y + dx;
    end
    x = x + dx;
end

end