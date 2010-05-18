classdef LeechHybridScheme < HybridScheme
    %LEECHHYBRIDSCHEME Hybrid Scheme using Leech lattice
    %   This class implements the hybrid transmission scheme using a
    %   24-dimensional Leech lattice. 
    %
    %   Most of the work is done in the base class, all that is done here is to
    %   specify the lattice and the covering radius.
    
    % $Id$
    
    properties
    end
    
    methods (Access = 'public')
        function obj = LeechHybridScheme(sv, s, p, e)
            % For this scheme, m = 24 and p is arbitrary.
            obj@HybridScheme(sv, s, 24, p, e);
        end
    end
    
    
    methods (Access = 'protected')
        function y = lattice(obj, x)

            % Verify that x has the right dimension.
            assert(size(x, 2) == 24);

            % Leech lattice quantizer.
            y = Lattice.leech_decode(x, 'verbose');
        end
        
        function r = covering_radius(obj)
            % The Leech lattice has covering radius sqrt(2)
            % (see Conway & Sloane, Ch. 4, Sec. 11)
            r = sqrt(2);
        end
    end
    
end

