classdef ScalarHybridScheme < HybridScheme
    %SCALARHYBRIDSCHEME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = 'public')
        function obj = ScalarHybridScheme(sv, s, n, e)
            % For this scheme, m = 1 and n is arbitrary.
            obj@HybridScheme(sv, s, 1, n, e);
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
            r = 0.5;
        end
    end
    
end

