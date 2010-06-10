classdef SmoothScalarHybridScheme < ScalarHybridScheme
    %SMOOTHSCALARHYBRIDSCHEME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SmoothScalarHybridScheme(sv, s, p, e)
            obj@ScalarHybridScheme(sv, s, p, e);
        end
        
        function b = compute_beta(obj)
            % The standard beta definition from the thesis.
            SNRe = compute_snre(obj);
            b = sqrt(obj.snr / SNRe);
        end
    end
    
end

