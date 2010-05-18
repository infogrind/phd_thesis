classdef ShannonScheme < TheoreticalScheme
    %SHANNONSCHEME Theoretical limit using separation.
    %   This class doesn't implement a practical communication scheme. All it
    %   does is compute and return the best possible MSE corresponding to
    %   separation and perfect source/channel codes. 
    
    % $Id$
    
    properties (Access = 'protected')
        n   % The number of channel uses per time unit. 
        k   % The number of source symbols per time unit.
    end
    
    
    
    methods (Access = 'public')
        function obj = ShannonScheme(sv, s, n, k)
            % Pass first two arguments to superclass constructor
            obj = obj@TheoreticalScheme(sv, s);
            obj.n = n;
            
            if nargin < 4
                obj.k = 1;
            else
                obj.k = k;
            end
            
        end
    end

    
    
    methods (Access = 'protected')
        % When the SNR is updated, we need to recompute the MSE.
        function update_mse(obj)
            obj.mse = obj.sv / (1 + obj.snr)^(obj.n/obj.k);
        end
    end
    
end

