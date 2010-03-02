function v = extract(m, r, c)
% EXTRACT   Extract entries from a matrix.
%    V = EXTRACT(M, R, C) returns a vector V containing the entries of M whose
%    row coordinates are given by the vector R and whose column coordinates are
%    given by the vector C. R and C must thus be vectors of the same size.
%
%    Example:
%
%    M = [1 2 3; 4 5 6; 7 8 9];
%    R = [1 2 3 3];
%    C = [2 2 1 3];
%
%    V = EXTRACT(M, R, C)
%    => V = [2 5 7 9];

% $Id$

if ~all(size(r) == size(c))
  error('R and C must have the same size.');
end

v = m(sub2ind(size(m), r, c));

end
