classdef AltOptScalarHybridScheme < OptScalarHybridScheme
    %ALTOPTSCALARHYBRIDSCHEME Like optimal scheme, but lets you vary a constant.
    %   This scheme was used to experiment with the constant c used in the
    %   computation of epsilon. 
    %
    %   While the "correct" constant is clearly given by the paper (and is the
    %   one used in OptScalarHybridScheme), it seemed at some point that
    %   changing this constant resulted in a better performance. However, this
    %   turned out to be only because at high SNR the simulation was no longer
    %   accurate (because the error probability was very low and the number of
    %   samples was not big enough). Therefore this class has no real use
    %   anymore.
    
    % $Id$
    
    properties
        % Constant used to compute epsilon.
        c
    end
    
    methods (Access = 'public')
        function obj = AltOptScalarHybridScheme(sv, s, n, c)
            obj@OptScalarHybridScheme(sv, s, n);
            obj.c = c;
        end
    end
    
    methods (Access = 'protected')
        function c = epsilon_constant(obj)
            c = obj.c;
        end
    end
end

