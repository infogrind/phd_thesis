function b = iseven(a)
% ISEVEN - Checks divisibility by 2
%    B = ISEVEN(A) returns true if A is an integer multiple of 2, false
%    otherwise. 

% $Id$

b = (floor(a/2) == a/2);
