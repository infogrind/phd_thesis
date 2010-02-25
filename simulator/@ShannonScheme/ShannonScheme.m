classdef ShannonScheme < Scheme
    %SHANNONSCHEME Theoretical limit using separation.
    %   This class doesn't implement a practical communication scheme. All it
    %   does is compute and return the best possible MSE corresponding to
    %   separation and perfect source/channel codes. 
    
    % $Id$
    
    properties
        % The number of channel uses corresponding to this theoretical limit.
        n
        
        % The MSE
        mse
    end
    
    
    
    methods
        function obj = ShannonScheme(sv, s, n)
            % Pass first two arguments to superclass constructor
            obj = obj@Scheme(sv, s);
            obj.n = n;
            
        end
        
        
        function mse = compute_mse(obj)
            mse = obj.mse;
        end
        
        
    end

    
    
    methods (Access = 'protected')
        % When the SNR is updated, we need to recompute the MSE.
        function snr_updated(obj)
            obj.mse = obj.sv / (1 + obj.snr)^obj.n;
        end
        
        
    end
    
end

