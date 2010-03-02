function y = leech_decode(x, verb)
% LEECH_DECODE   Find the closest point in the Leech lattice.
%    Y = LEECH_DECODE(X) returns a point Y of the 24-dimensional Leech
%    lattice that is the closest lattice point to the 24-dimensional
%    vector X. 
%    If X is a n-by-24 matrix, decoding is performed rowwise. 
%
%    Y = LEECH_DECODE(X, 'verbose') displays status output.
%
%    The function implements the algorithm given by Conway & Sloane in
%    their 1986 paper. 

% $Id$

% Background:
% The Leech lattice construction on which the algorithm is based is as
% follows. Let Lambda_8'' be defined as
%    Lambda_8'' = c + 4z, 
% where z is any element of Z^8 and c is any codeword of an [8,4]
% first-order Reed-Muller code written in +1/-1 notation (0 -> +1, 
% 1 -> -1). Then the Leech lattice Lambda_24 is defined as
%    Lambda_24 = Lambda_8'' ^ 3 + (a + t, b + t, c + t)
% where ^3 denotes the cartesian product; a, b, c are elements of
% Table V(a) below such that a + b + c is in Lambda_8' (defined as
% Lambda_8'' - (1 1 ... 1)); and t is an element of Table V(b) below.

% Enable verbose mode if specified.
if nargin >= 2 && strcmp(verb, 'verbose')
    verbose = true;
else
    verbose = false;
end

% 1) DESIGN STAGE

% Table V(a) (possible values for a, b, and c).
a_m = [
    0 0 0 0  0 0 0 0
    2 2 0 0  0 0 0 0
    2 0 2 0  0 0 0 0
    2 0 0 2  0 0 0 0
    2 0 0 0  2 0 0 0
    2 0 0 0  0 2 0 0
    2 0 0 0  0 0 2 0
    2 0 0 0  0 0 0 2
    1 1 1 1  1 1 1 1
    -1 -1 1 1  1 1 1 1
    -1 1 -1 1  1 1 1 1
    -1 1 1 -1  1 1 1 1
    -1 1 1 1  -1 1 1 1
    -1 1 1 1  1 -1 1 1
    -1 1 1 1  1 1 -1 1
    -1 1 1 1  1 1 1 -1];

% Table V(b) (possible values for t).
t_m = [
    0 0 0 0  0 0 0 0
    1 1 1 1  -1 1 1 1
    -1 1 1 1  2 0 0 0
    2 0 0 0  1 1 1 1
    1 1 0 2  1 1 0 0
    2 0 1 1  0 0 1 -1
    1 1 0 0  2 0 -1 1
    2 0 -1 1  -1 1 0 0
    1 2 1 0  1 0 1 0
    2 1 0 1  0 -1 0 1
    1 0 1 0  2 1 0 -1
    2 1 0 -1  -1 0 1 0
    1 0 2 1  1 0 0 1
    2 1 1 0  0 1 -1 0
    1 0 0 1  2 -1 1 0
    2 -1 1 0  -1 0 0 1];


% The table rho_m contains all possible sums a+t with a in a_m and t in
% t_m.
rho_m = compute_rho(a_m, t_m);

% The cross-reference table chi_m contains a list of triples of indices
% into rho_m for all possible triples (a+t, b+t, c+t) such that a + b + c
% is in Lambda_8'. 
chi_m = compute_chi(a_m, t_m, rho_m);

% Finally we decode x rowwise.
y = zeros(size(x));
if verbose
    fprintf('Decoding');
end
for k = 1:size(x, 1)
    if verbose
        fprintf('.');
    end
    y(k, :) = leech_decode_single_vector(x(k, :), rho_m, chi_m);
end
if verbose
    fprintf('done.\n');
end


% That's all folks!

end



% This function takes all the tables that have been precomputed and then
% decodes the row vector x to the Leech lattice. 
function y = leech_decode_single_vector(x, rho_m, chi_m)

% 2) PRECOMPUTATION STAGE

% First we decode the closest point to x in the cosets of Lambda_8'' ^ 3,
% where each coset is specified by a particular row of rho_m.
% The function also returns the distance d.
[p, d] = Lattice.decode_lambda8pp_cosets(x, rho_m);


% 3) MAIN STAGE

% Find the index j such that chi_m(j, :) points to the combination (a+t,
% b+t, c+t) that corresponds to the closest point in Lambda_24.
jstar = find_best_j(chi_m, d);

% Finally, we look up the combination of a+t, b+t, c+t corresponding to
% jstar in the cross-reference table to get the desired point of Lambda_24.
y = [p(chi_m(jstar, 1), 1:8), p(chi_m(jstar, 2), 9:16), ...
    p(chi_m(jstar, 3), 17:end)];

end



% This function returns the index j of the combination of (a+t, b+t, c+t)
% that corresponds to the coset containing the Leech lattice point that is
% closest to x.
function jstar = find_best_j(chi_m, d)

% This is the principal decoding algorithm; everything above was just
% preparation. The goal of the algorithm is to find a+t, b+t, c+t such that
% added to an element of Lambda_8pp the resulting point is closest to x.

% record is the smallest distance seen so far; jstar marks the index of the
% record distance.
record = inf;
jstar = 0;

assert(size(chi_m,1) == 4096);
for j = 1:4096
    
    % Get the indices into rho_m for the current combination of a, b, c,
    % and t. 
    chi = chi_m(j, :);
    
    % Compute the squared distance resulting from the current combination.
    d_tot = d(chi(1), 1) + d(chi(2), 2) + d(chi(3), 3);
    
    % Check if the distance the smallest we've encountered so far and store
    % it if this is the case.
    if d_tot < record
        record = d_tot;
        jstar = j;
    end
end

end



% This function computes all possible combinations of a+t, with a in
% Table V(a) and t in Table V(b).
function rho_m = compute_rho(a_m, t_m)

% This is used in the design stage, so we don't have to worry too much
% about efficiency. 
assert(all(size(a_m) == size(t_m)));

% Allocate space.
rho_m = zeros(size(a_m, 1)^2, size(a_m, 2));

% Row counter into rho_m.
c = 0;

% Compute all possible combinations of a in a_m and t in t_m, sum them and
% put them into the rows of rho_m.
for j = 1:size(a_m, 1)
    for k = 1:size(t_m, 1)
        c = c+1;
        rho_m(c, :) = a_m(j,:) + t_m(k,:);
    end
end

end



% This function computes the cross-reference table chi_m. This is an
% 4096-by-3 matrix; each line corresponds to a particular combination of
% (a+t, b+t, c+t) (where the constraint a+b+c in Lambda_8' is satisfied).
function chi_m = compute_chi(a_m, t_m, rho_m)

% We go through all possible combinations of a, b in a_m and t in t_m, and
% for each combination we compute the c satisfying the constraint a+b+c is
% in Lambda_8'. Then we find the indices of a+t, b+t, and c+t in rho_m and
% put these into the current row of chi_m. 

assert(all(size(a_m) == size(t_m)));

n = size(a_m, 1); % Number of entries in a_m

% Allocate space.
chi_m = zeros(n^3, 3);

% Row counter into chi_m.
i = 0;

for j = 1:n  % Loop over a
    a = a_m(j, :);
    for k = 1:n  % Loop over b
        b = a_m(k, :);
       
        % Compute the c corresponding to a, b and find its position in a_m.
        c = mod_lambdap8(a_m, a+b);
        c_ind = find_in_matrix(a_m, c);
        
        for l = 1:n  % Loop over t
            t = t_m(l, :);
            
            % Increase row counter of chi_m.
            i = i+1;
            
            % We can directly compute the positions of a+t, b+t, and c+t in
            % rho_m.
            chi_m(i, 1) = (j - 1)*n + l;      % Index of a+t in rho_m.
            chi_m(i, 2) = (k - 1)*n + l;      % Index of b+t in rho_m.
            chi_m(i, 3) = (c_ind - 1)*n + l;  % Index of c+t in rho_m.
            
            % Quick check that we have chosen the right indices.
            assert(all(rho_m(chi_m(i, 1), :) == a+t));
            assert(all(rho_m(chi_m(i, 2), :) == b+t));
            assert(all(rho_m(chi_m(i, 3), :) == c+t));

        end
    end
end
            
end



% This function searches a matrix for a given vector and returns the index
% of the row that equals the vector. If no row is found, an empty matrix is
% returned and a warning is issued. If several rows are equal to the
% vector, the index of the first match is returned. 
function i = find_in_matrix(m, v)

assert(size(m, 2) == length(v));

% Loop over rows of the matrix m.
for j = 1:size(m, 1)
    if all(m(j, :) == v)
        i = j;
        return;
    end
end

warning('No row matching v was found in m.');
i = [];

end



% Given an 8-dimensional vector x, this function returns y in a_m such that
% x + y is a point of the lattice Lambda_8'. 
function y = mod_lambdap8(a_m, x)

% Main idea: Check every element c of a_m until we find one such that c + x
% is in Lambda_8'.
for k = 1:size(a_m, 1)
    c = a_m(k, :);
    if Lattice.is_in_lambdap8(x + c)
        y = c;
        return;
    end
end

% If no c is found, there must have been an error.
error('No y in a_m was found such that x+y are in Lambda_8''.');

end





