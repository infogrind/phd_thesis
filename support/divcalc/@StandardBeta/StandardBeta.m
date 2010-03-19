classdef StandardBeta
    %STANDARDBETA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        % This function computes the divergences for a range of SNR values.
        function dv = compute_divergence(obj, snrrange)
            
            % The power is fixed.
            P = 1;
            
            % Allocate space for the divergence results.
            dv = zeros(size(snrrange));
            
            % Compute resulting divergence for each SNR.
            for k = 1:length(snrrange)
                dv(k) = div(obj, P, P/snrrange(k));
                
                fprintf('%.2f%% done.\n', 100 * k / length(snrrange));
            end
        end
        
        
        % Compute the divergence for a single P and sq (= sigma^2).
        function d = div(obj, P, sq)
            
            % Here S is uniform, so X1 and X2 will be independent, and therefore
            % so will Y1 and Y2. Since Y1_tilde and Y2_tilde are also
            % independent, the joint divergence is the sum of the individual
            % divergences.
            d = divy1(obj, P, sq) + divy2(obj, P, sq);
            
        end
        
        % The divergence between Y1 and a Gaussian.
        function d = divy1(obj, P, sq)
            
        end
        
        
    end
    
end

