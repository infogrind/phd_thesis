classdef ScalarHybridScheme < HybridScheme
    %SCALARHYBRIDSCHEME Hybrid scheme using 1-D integer lattice.
    %   This class implements the simples version of the quantize/uncoded hybrid
    %   scheme described in my thesis. Since most of the general work is already
    %   done by the base class, all we need to do here is to specify the integer
    %   lattice.
    
    % $Id$
    
    properties
    end
    
    methods (Access = 'public')
        function obj = ScalarHybridScheme(sv, s, p, e)
            % For this scheme, m = 1 and p is arbitrary.
            obj@HybridScheme(sv, s, 1, p, e);
        end
    end
    
    
    methods (Access = 'protected')
        function y = lattice(obj, x)

            % Verify that x is a column vector.
            assert(size(x, 2) == 1);

            % Simple scalar quantizer.
            y = round(x);
        end
        
        function r = covering_radius(obj)
            % The covering radius of the scalar quantizer is 0.5.
            %r = 0.5;
            % Alternatively, however, we can set this to sqrt(1/12), since the
            % covering radius is used as upper bound on the standard deviation
            % of the quantization error. In general, a more accurate value would
            % be the square root of the second moment of a Voronoi cell of the
            % quantizing lattice. For the 1-dimensional integer lattice this is
            % sqrt(1/12).
            r = sqrt(1/12);
        end
    end
    
end

