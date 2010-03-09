classdef TheoreticalLambertScalarHybridScheme < TheoreticalEpsilonScalarHybridScheme
    %THEORETICAL...SCHEME Here epsilon is computed like in AltLambert...Scheme.
    %   Detailed explanation goes here
    
    properties
        c1    % Constant used to compute optimal SNR^\epsilon.
    end
    
    methods (Access = 'public')
        function obj = TheoreticalLambertScalarHybridScheme(sv, s, n, c1)
            obj@TheoreticalEpsilonScalarHybridScheme(sv, s, n, 1);
            obj.c1 = c1;
        end
    end
    
    
    methods (Access = 'protected')
        % This function is directly copied from AltLambertScalarHybridScheme,
        % except that here c2 is not a class property but hardcoded. (We have
        % found earlier that c2 doesn't really have an influence on the MSE.)
        function b = compute_beta(obj)
            % Shortcuts for n, c, and snr to clear up the following code.
            n = obj.n;
            snr = obj.snr;
            c1 = obj.c1; %#ok<*PROP>
            c2 = 8;
            
            % This is the solution of SNR^\epsilon from the lower bound theorem.
            SNRe = c1 * (n-1) * ...
                lambertw(snr^(n / (n-1)) / ( c2*(n-1) ));
            
            % Set beta as a function of SNR^\epsilon.
            b = ceil(sqrt(snr / SNRe));
        end        
    end
    
end

