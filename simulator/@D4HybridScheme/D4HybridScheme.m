classdef D4HybridScheme < HybridScheme
    %D4HYBRIDSCHEME 4-D quantization using D4 lattice for discrete part.
    %   This scheme encodes 4 source symbols into 4p channel inputs using the D4
    %   (checkerboard) lattice for quantization.
    
    properties
    end
    
    methods (Access = 'public')
        function obj = D4HybridScheme(sv, s, p, e)
            % For this scheme, m = 4 and p is arbitrary.
            obj@HybridScheme(sv, s, 4, p, e);
        end
    end
    
    
    methods (Access = 'protected')
        function y = lattice(obj, x)

            % Verify that x has 4 columns.
            assert(size(x, 2) == 4);

            % Checkerboard lattice D4 quantizer.
            y = Lattice.lattice_dn(x);
        end
        
        function r = covering_radius(obj)
            % The covering radius of the D4 lattice is 1.
            % (See Conway & Sloane, Sec. 7.2)
            r = 1;
        end
    end
    
end

