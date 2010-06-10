classdef AltLambertScalarHybridScheme < ScalarHybridScheme
    %ALTLAMBERTSCALARHYBRIDSCHEME SNR^\epsilon computed from achievability bds.
    %   This scheme computes the optimal epsilon using the two upper bounds on
    %   the MSE from the achievability theorem. I.e., from
    %
    %     \E_Q \in O(exp{-SNR/8\gamma^2 \beta^2})
    %
    %   and
    %
    %     \E_E/\beta^{2(n-1)} \in O(SNR^{-1} \beta^{-2(n-1)})
    %
    %   with \beta^2 = SNR^{1-\e} we can solve this for SNR^\e to obtain
    %
    %     SNR^\e = 8\gamma^2 (n-1) W(SNR^{n/(n-1)} / (n-1) 8 \gamma^2).
    %   
    %   This is exactly used in the function compute_snre() below. Here we use
    %   Gamma = 1. 
    %
    %   For experimental purposes, the constant 8 \gamma^2 appearing in two
    %   places in the above formula for SNR^\e can be set manually as c1 and c2,
    %   however, this does not increase the performance. (Note that due to low Q
    %   error probability at high SNR (around 10^-12 for 50 dB), the standard
    %   length of the source sequence is not enough to capture the average
    %   error, so it may sometimes appear that with a different constant c1 the
    %   SDR is higher, but actually it isn't.)
    
    % $Id$
    
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
        
        
        % This function returns SNR^\epsilon from the lower bound theorem.
        function s = compute_snre(obj)
            % Shortcuts for n, c, and snr to clear up the following code.
            n = obj.n;
            snr = obj.snr;
            c1 = obj.c1; %#ok<PROP>
            c2 = obj.c2; %#ok<PROP>
            
            % This is the solution of SNR^\epsilon from the lower bound theorem.
            s = c1 * (n-1) * ...
                lambertw(snr^(n / (n-1)) / ( c2*(n-1) )); %#ok<PROP>
        end
    end    
end

