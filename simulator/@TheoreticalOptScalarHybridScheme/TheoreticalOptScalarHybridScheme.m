classdef TheoreticalOptScalarHybridScheme < TheoreticalScheme
    %THEORETICALHYBRIDSCHEME Theoretical scaling of the 1:n hybrid scheme.
    %   Detailed explanation goes here
    
    properties
        n % Channel uses per source symbol
    end
    
    methods (Access = 'public')
        function obj = TheoreticalOptScalarHybridScheme(sv, s, n)
            obj@TheoreticalScheme(sv, s);
            obj.n = n;
        end
    end
    
    methods (Access = 'protected')
        function update_mse(obj)
            obj.mse = obj.snr^(-obj.n) * (log(obj.snr))^(obj.n-1);
        end
    end
    
end

