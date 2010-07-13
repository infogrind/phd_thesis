% THEORETICALSCHEME Abstract base class for all theoretical schemes
%   Theoretical schemes are "virtual" communication schemes. Their performance
%   is obtained as a result of a mathematical formula, rather than by simulating
%   Gaussian noise and computing the empirical distortion.
%
%   Derived classes must implement update_mse(), which is called whenever the
%   SNR is changed. 

%%% MK:STARTSHOW
classdef TheoreticalScheme < Scheme
    
    methods (Access = 'public')
        function obj = TheoreticalScheme(sv, s)
            obj@Scheme(sv, s);
        end
    end
    
    methods (Access = 'protected')
        function snr_updated(obj)
            update_mse(obj);
        end
    end
    
    methods (Access = 'protected', Abstract = true)
        update_mse(obj)
    end
    
end
%%% MK:ENDSHOW
