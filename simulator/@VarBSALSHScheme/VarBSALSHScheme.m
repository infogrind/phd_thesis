classdef VarBSALSHScheme < SmoothAltLSHScheme
    %VARBSALSHSCHEME Adds support for constant multiplication of beta.
    %   This class, whose complete name would be 
    %   VarBetaSmoothAltLambertScalarHybridScheme, is like its parent class
    %   except that it adds the possibility to specify a constant K by which the
    %   parameter beta is multiplied. This is used to verify certain theoretical
    %   results, that say that if K is big then the SDR at high SNR should be
    %   decreased by a constant, but it should take longer for the error due to
    %   the Q to vanish.
    
    properties
        K   % Constant by which to multiply beta.
    end
    
    methods
        function obj = VarBSALSHScheme(sv, s, n, K)
            obj@SmoothAltLSHScheme(sv, s, n);
            
            obj.K = K;
        end
        
        % To compute beta we simply take the value computed by the base class
        % and multiply it by K.
        function b = compute_beta(obj)
            b = obj.K * compute_beta@SmoothAltLSHScheme(obj);
        end
    end
    
end

