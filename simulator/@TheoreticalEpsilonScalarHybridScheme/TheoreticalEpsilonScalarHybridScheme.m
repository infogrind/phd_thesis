classdef TheoreticalEpsilonScalarHybridScheme < TheoreticalScalarHybridScheme
    %THEORETICAL...SCHEME Precise MSE upper bound for beta^2 = SNR^(1-e).
    %   This class uses the exact computations of TheoreticalScalarHybridScheme
    %   with beta^2 = ceil(SNR^(1-epsilon)), epsilon being a class parameter.
    
    properties
        epsilon
    end
    
    methods (Access = 'public')
        function obj = TheoreticalEpsilonScalarHybridScheme(sv, s, n, e)
            obj@TheoreticalScalarHybridScheme(sv, s, n);
            obj.epsilon = e;
        end
    end
    
    
    methods (Access = 'protected')
        function b = compute_beta(obj)
            b = ceil( obj.snr^((1 - obj.epsilon)/2) );
        end
    end
    
end

