classdef TheoreticalScheme < Scheme
    %THEORETICALSCHEME For theoretical error curves.
    %   Any class derived from TheoreticalScheme does not represent a real
    %   communication scheme, but rather a theoretical error value. Thus, the
    %   run() method of this class does nothing, and the compute_mse() method
    %   just uses the simulation parameters (source variance, SNR) to compute
    %   a theoretical MSE value. 
    
    % $Id$
    
    properties
    end
    
    methods
        % The constructor just passes on the arguments to the base constructor.
        function obj = TheoreticalScheme(sv, s)
            obj@Scheme(sv, s);
        end
        
    end
    
end

