classdef Lattice
    %LATTICE Collection of lattice-related methods
    %   This class collects some lattice-related methods as static functions.
    
    properties
    end
    
    methods (Access = 'public', Static)
        y = leech_decode(x, verb)
        [p, dist] = decode_lambda8pp_cosets(x, rho_m)
        b = is_in_lambdap8(x)
        y = lattice_dn(x)
        b = iseven(a)
        v = extract(m, r, c)
    end
    
end