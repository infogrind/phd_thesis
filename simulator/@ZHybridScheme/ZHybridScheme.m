classdef ZHybridScheme < HybridScheme
    %ZHYBRIDSCHEME Quantization using integer lattice of arbitrary dimension.
    %   This is just a generalization of Z4HybridScheme and makes the latter in
    %   principle obsolete.
    
    % $Id$
    
    properties
    end
    
    methods (Access = 'public')
        function obj = ZHybridScheme(sv, s, m, p, e)
            % For this scheme, m and p are arbitrary.
            obj@HybridScheme(sv, s, m, p, e);
        end
    end
    
    
    methods (Access = 'protected')
        function y = lattice(obj, x)

            % Verify that x has m columns.
            assert(size(x, 2) == obj.m);

            % Simple scalar quantizer.
            y = round(x);
        end
        
        function r = covering_radius(obj)
            % The covering radius of the Z4 lattice is sqrt(m/4)=sqrt(m)/2.
            r = sqrt(obj.m)/2;
        end
    end    
end

