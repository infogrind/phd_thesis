classdef SmoothThHybrid2DScheme < TheoreticalHybrid2DScheme
    %SMOOTHTHHYBRID2DSCHEME Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = 'public')
        function obj = SmoothThHybrid2DScheme(sv, s, e)
            obj@TheoreticalHybrid2DScheme(sv, s, e);
        end
    end
    
    methods (Access = 'protected')
        function b = compute_beta(obj)
            b = obj.snr^((1 - obj.epsilon)/2);
        end
    end
    
end

