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
            
            % Boundary value for support of the Y's: 3 standard deviations of a
            % Gaussian distribution.
            b = 3 * sqrt(P + sq);
            
            % Integrate the divergence function over a square.
            fh = @(y1, y2) divel(obj, y1, y2, P, sq);
            
            fprintf('Integrating over y1 and y2 in [-%.2f, %.2f]\n', b, b);
            %plot(-b:.01:b, fh(-b:.01:b, 0));
            %d = dblquad(fh, -b, b, -b, b, 1e-2);
            d = numint2(fh, -b, b, -b, b, 0.1);
        end
        
        
        % This is the function over which you need to intergrate to get the
        % divergence.
        function dv = divel(obj, y1, y2, P, sq)
            
            % This function is passed as a handle to dblquad. Hence it must
            % accept a vector element y1. To vectorize the function we simply do
            % a loop.
            
            % Allocate space for return value.
            dv = zeros(size(y1));
            
            for k = 1:length(y1)
                % First integrate p(y1,y2|s)p(s) over s to get p(y1,y2).
                fh = @(s) pys(obj, y1(k), y2, s, P, sq);
                %py = quad(fh, -1/2, 1/2);
                py = numint(fh, -1/2, 1/2);

                % Now compute the distribution of Gaussian Y1 and Y2 with the
                % same variance.
                pytilde = normpdf(y1(k), 0, P+sq) * normpdf(y2, 0, P+sq);

                % Finally the end result.
                if (py == 0)
                    dv(k) = 0;
                else
                    dv(k) = py .* log(py ./ pytilde);
                end
                
            end
        end
        
        
        % And finally the joint distribution of y1, y2, and s.
        function p = pys(obj, y1, y2, s, P, sq)
            snr = P/sq;
            b = beta(obj, snr);
            
            % Compute quantized value and quantization error.
            q = round(b * (s + 0.5)) / b - 0.5;
            e = b * (s - q);
            assert(all(q >= -.5) && all(q <= .5));
            assert(all(e >= -.5) && all(e <= .5));
            
            % x1 and x2 are computed by scaling q and e so that their variance
            % is approximately P.
            x1 = sqrt(12*P) * q;
            x2 = sqrt(12*P) * e;
            
            % Finally, since y1 and y2 are independent given s, the joint
            % density can be factored. Furthermore, the density of s is constant
            % and equal to one, so it doesn't occcur in the following
            % expression.
            p = normpdf(y1, x1, sq) .* normpdf(y2, x2, sq);
        end
        
        
        
        % Here is a helper function computing beta as a function of the SNR.
        function b = beta(obj, snr)
            % First we compute epsilon, as in the paper. The constant k is here
            % 1 / (8 * the variance normalizing factor) which is 1/12 here, so
            % k = 12 / 8.
            k = 12 / 8;
            n = 2;             % Two-dimensional channel input
            
            e = log(n * log(snr) / k) / log(snr);
            assert(e >= 0 && e <= 1);
            b = ceil(sqrt(snr^(1 - e)));
        end
    end
    
end

