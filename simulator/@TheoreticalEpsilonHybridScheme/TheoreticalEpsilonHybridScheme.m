classdef TheoreticalEpsilonHybridScheme < TheoreticalScheme
    %THEORETICALEPSILONHYBRIDSCHEME Theoretical hybrid performance with fixed e
    %   Detailed explanation goes here
    
    properties
        epsilon
        n
    end
    
    methods (Access = 'public')
        function obj = TheoreticalEpsilonHybridScheme(sv, s, n, e)
            obj@TheoreticalScheme(sv, s);
            obj.n = n;
            obj.epsilon = e;
        end
    end
    
    methods (Access = 'protected')
        function update_mse(obj)
            n = obj.n; %#ok<*PROP>
            e = obj.epsilon;
            obj.mse = obj.snr^(-n + (n-1)*e);
        end
    end
    
end

