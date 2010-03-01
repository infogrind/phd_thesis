classdef OptThHybrid2DScheme < TheoreticalHybrid2DScheme
    %OPTTHHYBRID2DSCHEME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = 'public')
        function obj = OptThHybrid2DScheme(sv, s)
            % We pass 1 for epsilon just because the parameter is required, but
            % this will never be used. 
            obj@TheoreticalHybrid2DScheme(sv, s, 1);
        end
        
    end
    
    methods (Access = 'protected')
        function snr_updated(obj)
            obj.epsilon = log(obj.n * log(obj.snr) * 8 * obj.sv) / log(obj.snr);
            update_mse(obj);
        end
    end
    
end

