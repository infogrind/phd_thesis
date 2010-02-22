classdef Scheme < handle
    %SCHEME Base class for all communication schemes.
    %   Any communication scheme inherits from this base class. If a scheme is
    %   practical rather than just theoretical, it should extend
    %   PracticalScheme.
    
    % $Id$
    
    properties
        % Source variance
        sv
        
        % Channel SNR (power per source sample divided by noise variance)
        snr
        
        % Should extra information be given?
        verbose = false;
    end
    
    properties (Access = 'protected')
        % A flag indicating whether the run() method has already been called.
        has_run = false
    end
    
    methods
        % The constructor takes two values: The source variance and the source
        % symbols. Note that this base class ignores the source symbols; only
        % classes derived from PracticalScheme will store s. 
        function obj = Scheme(sv, s)
            obj.sv = sv;
        end
    end
    
    methods (Access = 'public')
        % The run method first saves the SNR and sets the flag. The do_run()
        % method is abstract and must be implemented by derived classes.
        function run(obj, snr)
            obj.snr = snr;
            obj.has_run = true;
        end
        
%         function set_snr(obj, snr)
%             if snr <= 0
%                 error('SNR must be positive.');
%             else
%                 obj.snr = snr;
%             end
%         end
        
    end
    
    
   methods (Abstract = true)
        % Every scheme must at least return the MSE.
        mse = compute_mse(obj)
    end
    
end

