classdef ShannonScheme < TheoreticalScheme
    %SHANNONSCHEME Theoretical limit using separation.
    %   This class doesn't implement a practical communication scheme. All it
    %   does is compute and return the best possible MSE corresponding to
    %   separation and perfect source/channel codes. 
    
    % $Id$
    
    properties
        % The number of channel uses corresponding to this theoretical limit.
        n
    end
    
    methods
        function obj = ShannonScheme(sv, s, n)
            % Pass first two arguments to superclass constructor
            obj = obj@TheoreticalScheme(sv, s);
            obj.n = n;
        end
        
        function mse = compute_mse(obj)
            mse = obj.sv ./ (1 + obj.snr/obj.n).^obj.n;
        end
    end
    
end

