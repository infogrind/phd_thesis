function b = is_in_lambdap8(x)
% IS_IN_LAMBDAP8 - Checks if a vector is in the lattice Lambda_8'.
%    B = IS_IN_LAMBDAB8(X) returns true if the 8-dimensional real vector X
%    is a point of the lattice Lambda_8'.

% Elements of lambdap8 have only even components.
if ~all(Lattice.iseven(x))
    b = false;
    return;
end

% Scale down by 2 and reduce modulo 2 to get a matrix of 0s and 1s.
y = mod(x/2, 2);

% We use a Reed-Muller [8,4] parity-check matrix.
H = [1 0 0 0
    1 0 0 1
    1 0 1 0
    1 0 1 1
    1 1 0 0
    1 1 0 1
    1 1 1 0
    1 1 1 1];

% A
z = mod(y * H, 2);

if all(z == 0)
    b = true;
else
    b = false;
end

end

