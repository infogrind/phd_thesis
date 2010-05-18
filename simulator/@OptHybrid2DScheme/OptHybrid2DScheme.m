classdef OptHybrid2DScheme < Hybrid2DScheme
    %OPTHYBRID2DSCHEME Like Hybrid2DScheme, but with epsilon = epsilon(SNR).
    %   The difference between this scheme and Hybrid2DScheme is that in the
    %   latter epsilon is specified as a parameter, where as here it is computed
    %   as a function of the SNR.
    
    % $Id$
    
    properties
    end
    
    methods (Access = 'public')
        function obj = OptHybrid2DScheme(sv, s)
            % The value of epsilon is determined later as a function of the SNR,
            % but the base class requires us to specify epsilon so we just set
            % it to 1. (Could be any other value, it is not used anyway.)
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

