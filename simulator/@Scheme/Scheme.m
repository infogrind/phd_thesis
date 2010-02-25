classdef Scheme < handle
    %SCHEME Base class for all communication schemes.
    %   Any communication scheme inherits from this base class. If a scheme is
    %   practical rather than just theoretical, it should extend
    %   PracticalScheme.
    
    % $Id$
    
    properties (Access = 'public')
        % Source variance
        sv
        
        % Should extra information be given?
        verbose = false;
    end
    
    
    
    properties (Access = 'protected')
        % Channel SNR (power per channel input divided by noise variance)
        snr
    end
    
    
    
    methods (Access = 'public')
        % The constructor takes two values: The source variance and the source
        % symbols. Note that this base class ignores the source symbols; only
        % classes derived from PracticalScheme will store s. 
        function obj = Scheme(sv, s) %#ok<INUSD>
            obj.sv = sv;
        end
        
        
        % When the SNR is changed to a different value, the abstract function
        % snr_updated() is called so that derived classes can update the
        % simulation results.
        function set_snr(obj, snr)
            % The isempty test is crucial here: Otherwise, if obj.snr is
            % empty (to which it is initialized), the ~= test will always
            % evaluate to false. 
            if isempty(obj.snr) || (obj.snr ~= snr)
                obj.snr = snr;
                snr_updated(obj);
            end
        end
        
        
    end
    
    
    
    methods (Access = 'public', Abstract = true)
        % Every scheme must at least return the MSE.
        mse = compute_mse(obj)
    end
    
    
    
    methods (Access = 'protected', Abstract = true)
        % This function is called each time the SNR is changed to a different
        % value.
        snr_updated(obj)
        
    end
    
end

