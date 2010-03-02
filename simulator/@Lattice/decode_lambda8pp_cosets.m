function [p, dist] = decode_lambda8pp_cosets(x, rho_m)
% DECODE_LAMBDA8PP_COSETS - Find closest point in cosets of Lambda_8''.
%    P = DECODE_LAMBDA8PP_COSETS(X, RHO_M) operates on the 24-dimensional
%    vector X in blocks of 8. For each block x_i, the closest point to x_i
%    is found in each of the 256 cosets of Lambda_8'' specified by the
%    vectors in RHO_M. 

% $Id$

% First we do the precomputations as explained in the Conway & Sloane
% paper. These are such that for each rho, x - rho = d' + 4*z, where
% d' = d at positions where s = 0 and d' = 2-d where s = 1.
[d, z, s] = lambda8pp_precomputations(x);

% Next, we allocate the space for the returned matrices.
p = zeros(size(rho_m, 1), size(x, 2));
dist = zeros(size(rho_m, 1), 3);

% Finally we decode the Lambda_8'' points vertically block by block (each
% block containing 256 8-dimensional vectors).
inds = [1:8; 9:16; 17:24];
for k = 1:size(inds,1)
    ind = inds(k,:);
    p(:, ind) = decode_lambda8pp_block(rho_m, ...
        d(:,ind), z(:,ind), s(:,ind));
    
    % Lastly we need to add rho_m to get back to the right cosets. (At this
    % point, the vectors in p are points in Lambda_8''.)
    p(:, ind) = p(:, ind) + rho_m;
    
    % As an extra goodie we return the squared distance of each x_i to the
    % closest coset point.
    dist(:, k) = sum(gensub(p(:, ind), x(ind)).^2, 2);
    
end

end



% Helper function to subtract a row vector from each row of a matrix.
function z = gensub(x, y)

z = zeros(size(x));
for k = 1:size(x, 1)
    z(k, :) = x(k, :) - y;
end

end


% This function decodes a block of 8-dimensional vectors to their closest
% points in Lambda_8'' using the the method outlined in Paragraph (12) of
% the Conway & Sloane paper. The quantities d, z, and s are the result of
% the precomputations as explained in Section IV of the paper.
function p = decode_lambda8pp_block(rho_m, d, z, s)

% Let us first resume the roles of the parameters d, z, and s.
% They are all 7-by-8 matrices with components in [-1,1]. The columns
% correspond to x_i, ..., x_{i+7}, where i in {1, 9, 17}. The 7 rows
% correspond to the possible values of the entries of rho_m, i.e., integers
% between -2 and 4. 
% d - The possible values of x + m after subtracting a multiple of 4 and
%     possibly flipping around 1 to get a number between -1 and 1.
% z - The number of times 4 was subtracted (or added) to x + m in order to
%     get between -1 and 3.
% s - An 1 if the corresponding position in d has been flipped around 1,
%     and 0 otherwise.

% The trick is to use rho_m as index into d, z, and s, respectively. First,
% we use it as index into d and apply the Reed-Muller decoder.
p = Lattice.rm_decode(extract_rho(rho_m, d));

% Next, we have to flip the entries of p back around 1 if they have been
% flipped in the precomputation phase.
p(extract_rho(rho_m, s)) = 2 - p(extract_rho(rho_m, s));

% Finally we add again the multiples of 4 that were subtracted to get d.
p = p + 4*extract_rho(rho_m, z);

end


% A helper function for decode_lambda8pp_block(). It uses rho_m as index
% into a 7-by-8 matrix.
function b = extract_rho(rho_m, a)

b = Lattice.extract(a, rho_m+3, repmat(1:size(a,2), size(rho_m,1), 1));

end


% This function does the precomputations for the Lambda_8'' decoder.
function [d, z, s] = lambda8pp_precomputations(x)

% To start, a table with all possible combinations x_i - m, where m is in
% {-2, -1, ..., 4} (i.e., all possible values of components of rho_m). 
y = repmat(x, 7, 1) - repmat((-2:4)', 1, 24);

% For each entry in y, we find z such that y - 4z is in [-1, 3].
z = floor((y+1)/4);
d = y - 4*z;

% Next we find the positions where d is between 1 and 3. Those we need to
% "flip" around 1 to bring them into [-1,1].
s = d > 1;
d(s) = 2 - d(s);

% A final check.
assert(all(all(d >= -1)) && all(all(d <= 1)));

end