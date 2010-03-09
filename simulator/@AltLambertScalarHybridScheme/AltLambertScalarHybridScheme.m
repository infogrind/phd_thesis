classdef AltLambertScalarHybridScheme < ScalarHybridScheme
    %ALTLAMBERTSCALARHYBRIDSCHEME SNR^\epsilon computed from achievability bds.
    %   Detailed explanation goes here
    
    properties
        c1
        c2
    end
    
    methods (Access = 'public')
        function obj = AltLambertScalarHybridScheme(sv, s, p, c1, c2)
            % For this scheme, m = 1 and p is arbitrary.
            % We can pass an arbitrary value for e (here 1) since this class
            % will compute it dynamically as a function of the SNR.
            obj@ScalarHybridScheme(sv, s, p, 1);
            
            % Default value for c1: 8
            if nargin < 4
                c1 = 8;
            end
            
            % Default value for c2: 8
            if nargin < 5
                c2 = 8;
            end
            
            obj.c1 = c1;
            obj.c2 = c2;
        end
        
        
        function b = compute_beta(obj)
            % Shortcuts for n, c, and snr to clear up the following code.
            n = obj.n;
            snr = obj.snr;
            c1 = obj.c1;
            c2 = obj.c2;
            
            % This is the solution of SNR^\epsilon from the lower bound theorem.
            SNRe = c1 * (n-1) * ...
                lambertw(snr^(n / (n-1)) / ( c2*(n-1) ));
            
            % Set beta as a function of SNR^\epsilon.
            b = ceil(sqrt(snr / SNRe));
        end        
    end    
end

