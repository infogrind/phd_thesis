classdef Z4HybridScheme < HybridScheme
    %Z4HYBRIDSCHEME Hybrid scheme with Z4 lattice for quantization.
    %   This is a scheme that uses the Z4 lattice as quantizer. Its performance
    %   should essentially be the same as that of ScalarHybridScheme.
    
    properties
    end
    
    methods (Access = 'public')
        function obj = Z4HybridScheme(sv, s, p, e)
            % For this scheme, m = 4 and p is arbitrary.
            obj@HybridScheme(sv, s, 4, p, e);
        end
    end
    
    
    methods (Access = 'protected')
        function y = lattice(obj, x)

            % Verify that x has 4 columns.
            assert(size(x, 2) == 4);

            % Simple scalar quantizer.
            y = round(x);
        end
        
        function r = covering_radius(obj)
            % The covering radius of the Z4 lattice is sqrt(.25+.25+.25+.25)=1.
            r = 1;
        end
    end    
end

