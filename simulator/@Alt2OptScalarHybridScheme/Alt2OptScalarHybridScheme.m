classdef Alt2OptScalarHybridScheme < OptScalarHybridScheme
    %ALT2OPTSCALARHYBRIDSCHEME Like optimal scheme, but computes beta differently
    %   This scheme uses the expression for SNR^\epsilon from the error lower
    %   bound theorem to compute beta.
    
    properties
    end
    
    methods (Access = 'public')
        function obj = Alt2OptScalarHybridScheme(sv, s, n)
            obj@OptScalarHybridScheme(sv, s, n);
        end
    end
    
    methods (Access = 'protected')
        function b = compute_beta(obj)
            % This alternative definition is from the lower bound.
            
            % Compute SNR^\epsilon.
            SNRe = log(obj.snr);
            
            b = ceil(sqrt(obj.snr/ SNRe));
        end
    end
    
end

