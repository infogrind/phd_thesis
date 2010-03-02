classdef AltOptScalarHybridScheme < OptScalarHybridScheme
    %ALTOPTSCALARHYBRIDSCHEME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Constant used to compute epsilon.
        c
    end
    
    methods (Access = 'public')
        function obj = AltOptScalarHybridScheme(sv, s, n, c)
            obj@OptScalarHybridScheme(sv, s, n);
            obj.c = c;
        end
    end
    
    methods (Access = 'protected')
        function c = epsilon_constant(obj)
            c = obj.c;
        end
    end
end

