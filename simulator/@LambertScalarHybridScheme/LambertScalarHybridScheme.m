classdef LambertScalarHybridScheme < ScalarHybridScheme
    %LAMBERTSCALARHYBRIDSCHEME Computing beta using the Lambert W function.
    %   Detailed explanation goes here
    
    properties
        % This is the constant used in the lambert formula to compute
        % SNR^\epsilon. I am not sure what it should be, so I am leaving it as a
        % variable parameter to play around with.
        c
    end
    
    methods (Access = 'public')
        function obj = LambertScalarHybridScheme(sv, s, p, c)
            % For this scheme, m = 1 and p is arbitrary.
            % We can pass an arbitrary value for e (here 1) since this class
            % will compute it dynamically as a function of the SNR.
            obj@ScalarHybridScheme(sv, s, p, 1);
            obj.c = c;
        end
        
        
        function b = compute_beta(obj)
            % Shortcuts for n, c, and snr to clear up the following code.
            n = obj.n;
            snr = obj.snr;
            c = obj.c; %#ok<*PROP>
            
            % This is the solution of SNR^\epsilon from the lower bound theorem.
            SNRe = (n - 3/2) / c * ...
                lambertw(c * snr^(2*(n-1)/(2*n-3)) / (n - 3/2));
            
            % Set beta as a function of SNR^\epsilon.
            b = ceil(sqrt(snr / SNRe));
        end        
    end

end

