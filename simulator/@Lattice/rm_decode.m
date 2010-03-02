function y = rm_decode(x)
% RM_DECODE   Decoder for First-order Reed-Muller Code
%    Y = RM_DECODE(X). If X is a real vector of length 2^m, Y is the
%    closest codeword in a [2^m, m+1] first-order Reed-Muller code.
%    If X is a matrix, decoding is performed row-wise.
%
%    Note: The code in question is assumed to be in +1/-1 notation. This is
%    normally the case when a codeword was transmitted over an additive
%    noise channel using binary PAM.

% $Id$

% Some elementary parameter checks.
if log2(size(x,2)) ~= floor(log2(size(x,2)))
    error('The length of X must be an integer power of 2.');
end

m = log2(size(x,2));

% The Hadamard matrix used for decoding.
H = hadamard(2^m);

% The codewords of the [2^m, m+1] Reed-Muller code in +1/-1 notation.
C = rm_code(m);

% Compute the Hadamard transform of x.
p = x * H;

% Find the maximum absolute value in each row of p.
[nil, ind] = max(abs(p), [], 2);

% Assign the corresponding codewords 
y = C(ind,:);

% Where the value leading to the maximum above was negative, we need to
% flip the bits of y.
flipind = p(sub2ind(size(p), (1:size(p,1))', ind)) < 0;
y(flipind,:) = -y(flipind,:);

end



% This function returns a matrix whose rows are the codewords of a
% first-order [2^m, m+1] Reed-Muller code in +1/-1 notation.
function C = rm_code(m)

% The Generator matrix.
G = [ones(1, 2^m);
    de2bi((0:2^m-1)',m, 'left-msb')'];

c = mod(de2bi((0:2^(m+1)-1)',m+1,'left-msb') * G,2);
C = (-1).^c;

end