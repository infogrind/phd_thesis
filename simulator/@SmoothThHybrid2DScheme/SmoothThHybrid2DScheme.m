classdef SmoothThHybrid2DScheme < TheoreticalHybrid2DScheme
    %SMOOTHTHHYBRID2DSCHEME Smooth version of base class (without ceil() )
    %   This class removes the restriction that the parameter beta must be
    %   integer. However, the theoretical result is not quite correct, because
    %   the performance has been computed analytically only for integer beta and
    %   might not be correct here, so beware.
    
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

