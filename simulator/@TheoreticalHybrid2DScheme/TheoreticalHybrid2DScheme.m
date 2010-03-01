classdef TheoreticalHybrid2DScheme < TheoreticalScheme
    %THEORETICALHYBRID2DSCHEME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        epsilon
        n = 2;
    end
    
    methods (Access = 'public')
        function obj = TheoreticalHybrid2DScheme(sv, s, e)
            obj@TheoreticalScheme(sv, s);
            obj.epsilon = e;
        end
    end
    
    methods (Access = 'protected')
        function update_mse(obj)
            obj.mse = obj.snr^-(obj.n - (obj.n-1)*obj.epsilon);
        end
    end
    
end

