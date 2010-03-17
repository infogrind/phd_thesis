classdef Scheme < handle % MK:SHOW
    %SCHEME Base class for all communication schemes.
    %   Any communication scheme inherits from this base class. If a scheme is
    %   practical rather than just theoretical, it should extend
    %   PracticalScheme.
    
    % $Id$
    
    properties (Access = 'public')
        % Should extra information be given?
        verbose = false;
    end

    
    %%% MK:STARTSHOW
    properties (Access = 'protected')
        sv    % Source variance.
        snr   % SNR (power per channel input symbol).
        mse   % Mean squared error resulting from the simulation.
    end
    
    %%% MK:ENDSHOW

 
    methods (Access = 'public') % MK:SHOW
        % The constructor takes two values: The source variance and the source
        % symbols. Note that this base class ignores the source symbols; only
        % classes derived from PracticalScheme will store s. 
        %%% MK:STARTSHOW
        function obj = Scheme(sv, s)
            obj.sv = sv;
        end
        
        %%% MK:ENDSHOW
        
        % When the SNR is changed, the abstract function snr_updated() is called
        % so that derived classes can update the simulation results.
        %%% MK:STARTSHOW
        function set_snr(obj, snr)
            obj.snr = snr;
            snr_updated(obj);
        end

        %%% MK:ENDSHOW
        
        
        % Every scheme must at least return the MSE.
        %%% MK:STARTSHOW
        function mse = compute_mse(obj)
            mse = obj.mse;
        end
    end
    
    %%% MK:ENDSHOW
    
    methods (Access = 'protected', Abstract = true) % MK:SHOW
        % This function is called each time the SNR is changed to a different
        % value.
        snr_updated(obj) % MK:SHOW
    end % MK:SHOW
end % MK:SHOW

