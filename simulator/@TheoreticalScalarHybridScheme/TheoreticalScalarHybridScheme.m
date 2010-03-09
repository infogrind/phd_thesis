classdef TheoreticalScalarHybridScheme < TheoreticalScheme
    %THEORETICALSCALARHYBRIDSCHEME Abstract base class - MSE for general beta
    %   This abstract base class computes the so far most exact upper bound on
    %   the mean squared error by taking into account the errors due to all Q_i
    %   for i = 1, ..., n-1 and due to E. Furthermore, the only upper bounds
    %   were done for a) using the covering radius upper bound and b) upper
    %   bounding the Q() function using exp(-x^2/2)/2. At least the latter
    %   converges for large x.
    %
    %   The scheme considered is the scalar hybrid scheme for 1:n (i.e., using
    %   the integer lattice for quantization).
    
    properties
        n   % Channel uses per source symbol
    end
    
    methods (Access = 'public')
        function obj = TheoreticalScalarHybridScheme(sv, s, n)
            obj@TheoreticalScheme(sv, s);
            obj.n = n;
        end
    end
    
    methods (Access = 'protected')
        function update_mse(obj)
            qe = compute_qe(obj);   % Error vector for Q_1, ..., Q_{n-1}
            ee = compute_ee(obj);   % Error for E_{n-1}
            b = compute_beta(obj);
            
            % Compute error as sum of errors of all components, as done in
            % paper.
            obj.mse = 0;
            for k = 1:obj.n - 1
                obj.mse = obj.mse + qe(k) / b^(2*(k - 1));
            end
            obj.mse = obj.mse + ee / b^(2*(obj.n - 1));
        end
        
        
        function qe = compute_qe(obj)
            b = compute_beta(obj);
            snr = obj.snr;
            qe = zeros(1, obj.n-1);
            
            % The errors are all the same, except that for Q_1 a different gamma
            % is used. I.e., for Q_1, gamma^2 = source variance, and for other
            % Q, gamma^2 = 1/12.
            for k = 1:obj.n - 1
                if k == 1
                    g = sqrt(obj.sv);   % Gamma = sqrt(sv)
                else
                    g = sqrt(1/12);     % 1/12 = 2nd moment of integer lattice
                end
                
                qe(k) = (1/b^2) * exp(-snr / (8*g^2 * b^2)) * ( ...
                    3*g*b / sqrt(2*pi*snr) + g^2*b^2/snr + 1/4 );
            end
        end
        
        
        function ee = compute_ee(obj)
            seq = 1/12;  % Variance of E_{n-1}, which is approximately  uniform.
            g = sqrt(1/12);  % Gamma used to compute X_n from E_{n-1}.
            
            ee = seq / (1 + obj.snr * seq / g^2);
        end
    end
    
    methods (Access = 'protected', Abstract = true)
        b = compute_beta(obj)
    end
    
end

