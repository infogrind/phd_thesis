classdef OptHybrid2DScheme < Hybrid2DScheme
    %OPTHYBRID2DSCHEME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = 'public')
        function obj = OptHybrid2DScheme(sv, s)
            obj@Hybrid2DScheme(sv, s, 1);
        end
    end
    
    methods (Access = 'protected')
        % We extend update_variable_parameters() to update epsilon whenever SNR
        % has changed.
        function update_variable_parameters(obj)
            update_variable_parameters@Hybrid2DScheme(obj);
            n = 2;
            obj.epsilon = log(n * log(obj.snr) * 4 * obj.sv) / log(obj.snr);
        end
    end
    
end

