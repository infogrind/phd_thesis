classdef SmoothAltLSHScheme < AltLambertScalarHybridScheme
    %SMOOTHALTLSHSCHEME "Smooth" version of AltLambertScalarHybridScheme
    %   The difference of this scheme to the base class is that the "ceil"
    %   function is not used when computing beta, so beta can be non-integer.
    %   This results in a smoother curve while still giving a good performance.
    
    properties
    end
    
    methods
        % Nothing special for the constructor, just call the base class. The
        % varargin parameter is needed because the base class constructor takes
        % a variable number of arguments.
        function obj = SmoothAltLSHScheme(sv, s, varargin)
            obj@AltLambertScalarHybridScheme(sv, s, varargin{:});
        end

        % This overridden function differs from the base class version in that
        % the "ceil" function is omitted in the computation of beta.
        function b = compute_beta(obj)
            % Set beta as a function of SNR^\epsilon.
            SNRe = compute_snre(obj);
            b = sqrt(obj.snr / SNRe);
        end
        
    end
    
end

