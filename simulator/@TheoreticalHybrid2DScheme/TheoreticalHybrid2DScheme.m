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
            obj.mse = mse_q(obj) + mse_e(obj);
        end
        
        function e = mse_q(obj)
            g = 1; % Gamma = 1
            b = compute_beta(obj);
            snr = obj.snr;
            
            e = .5 * exp(-snr / (8*g^2*b^2)) * ...
                (3*g*b/sqrt(2*pi*snr) + g^2*b^2/snr + .25);
        end
        
        function e = mse_e(obj)
            se = 1/12; % sigma_e, here the error is assumed uniform
            snr = obj.snr;
            b = compute_beta(obj);
            n = obj.n; %#ok<*PROP>
            
            e = se / ( (1 + snr) * b^(2*(n-1)) );
        end
        
        function b = compute_beta(obj)
            b = ceil(obj.snr^((1 - obj.epsilon)/2));
        end
    end
    
end

