classdef ScalarHybridCompScheme < PracticalScheme
    %SCALARHYBRIDCOMPSCHEME Scalar Hybrid Scheme for Bandwidth Compression
    %   This is a scheme to transmit an n-dimensional uniform source across
    %   a single channel use.
    
    % $Id$
    
    properties
        beta    % Quantization resolution.
        epsilon % To compute the quantization resolution beta.
    end
    
    methods
        function obj = ScalarHybridCompScheme(sv, s, k, epsilon)
            obj@PracticalScheme(sv, s, k, 1);
            
            obj.epsilon = epsilon;
        end
    end
    
    methods (Access = 'protected')
        function x = encode(obj, s)
            % Remark: s is a k x N matrix, each row corresponding to a source
            % dimension. 
            
            % Make sure all source symbols are in the proper intervall.
            assert(all(all(s >= -.5 & s <= .5)));
            
            % 1) Compute quantization of first k-1 source dimensions
            q = quantize_first(obj, s);
            
            % 2) Compute linear combination of quantizer outputs and last source
            %    dimension, weighting by beta^i, i = 0, -1, ..., k-1
            % 3) Scale to satisfy power constraint. 
            % Since the linear combination is itself approximately uniformly
            % distributed, its variance is 1/12.
            x = sqrt(12 * obj.P) * combine(obj, q, s(end, :));
        end
        
        
        % This function takes the first k-1 rows of the source and quantizes
        % them using a quantization interval of 1/beta. 
        function q = quantize_first(obj, s)
            q = round(obj.beta * s(1:end-1,:)) / obj.beta;
        end 
        
        % This function takes the quantized first k-1 source values and the
        % unquantized last source value and combines them in a reversible
        % fashion. 
        function c = combine(obj, q, s_end)
            % Verify equal number of columns.
            assert(size(q,2) == size(s_end,2));
            
            % Allocate space for the result.
            c = zeros(1, size(q, 2));
            
            % Create linear combination.
            for i = 0:obj.k-2
                c = c + q(i+1,:) * obj.beta^(-i);
            end
            
            % Add the unquantized part of the source.
            c = c + s_end * obj.beta^-(obj.k-1);
        end
        
        
        function sh = decode(obj, y)
            % 1) Scale back received value.
            %%y_scaled = y / sqrt(12 * obj.P);
            y_scaled = y / sqrt(12*obj.P);
            
            % 2) Decompose by repeatedly quantizing and scaling.
            [q, s_end] = decompose(obj, y_scaled);
            
            % 3) The result is the estimate.
            sh = [q; s_end];
        end
        
        
        % This function uses repeated quantization and scaling, just like for
        % the encoding of the bandwidth expanding hybrid scheme, to recover the
        % quantized individual source dimensions and the last, unquantized,
        % source dimension.
        function [q, s_end] = decompose(obj, y_scaled)
            % Make sure y_scaled is a row vector.
            assert(size(y_scaled,1) == 1);
            
            % Allocate matrix for decomposed quantizer outputs.
            q = zeros(obj.k-1, size(y_scaled, 2));
            
            % Repeatedly quantize and scale. 
            last_error = y_scaled;
            for i = 1:obj.k-1
                q(i, :) = round(obj.beta * last_error) / obj.beta;
                last_error = obj.beta * (last_error - q(i, :));
            end
            
            % And the estimate of the last row is simply the remaining
            % quantization error.
            s_end = last_error;
        end
        
        
        
        function update_variable_parameters(obj)
            update_variable_parameters@PracticalScheme(obj);
            
            % Set epsilon based on the SNR.
            %c = epsilon_constant(obj);
            %obj.epsilon = log(obj.n * log(obj.snr) * c) / log(obj.snr);
            % The above is deactivated for now, since we specify epsilon
            % manually. The optimal epsilon as a function of SNR needs yet to be
            % determined.
            
            obj.beta = compute_beta(obj);
        end
        
        
        % This function returns the constant used to compute epsilon. According
        % to the paper, it is 8 * \gamma^2. Here \gamma^2 = source variance.
        function c = epsilon_constant(obj)
            c = 8 * obj.sv^2;
        end
        
        
        function b = compute_beta(obj)
            % The standard beta definition from the thesis.
            b = ceil(obj.snr ^ ((1 - obj.epsilon)/2));
        end
    end
    
end

