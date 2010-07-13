classdef OptThHybrid2DScheme < TheoreticalHybrid2DScheme
    %OPTTHHYBRID2DSCHEME Optimized version of base class using e = e(SNR).
    %   As opposed to its base class, the parameter epsilon is computed directly
    %   as a function of the SNR in an order-optimal way (still only for n = 2).
    
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

