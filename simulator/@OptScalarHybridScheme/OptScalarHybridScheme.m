classdef OptScalarHybridScheme < ScalarHybridScheme
    %OPTSCALARHYBRIDSCHEME Scalar hybrid scheme with epsilon = epsilon(SNR).
    %   As opposed to the base class, where epsilon is fixed (and specified as a
    %   parameter), this scheme computes epsilon as a function of the SNR as in
    %   Eq. 19 of the Globecom paper. 
    %
    %   While this way of computing epsilon leads to the optimal scaling, there
    %   are better ways to compute epsilon, see e.g.
    %   AltLambertScalarHybridScheme.
    
    % $Id$
    
    properties
    end
    
    methods (Access = 'public')
        function obj = OptScalarHybridScheme(sv, s, n)
            % We pass 1 for the epsilon parameter of the base class, since here
            % we determine epsilon dynamically. 
            obj@ScalarHybridScheme(sv, s, n, 1);
        end
    end
    
    methods (Access = 'protected')
        function update_variable_parameters(obj)
            update_variable_parameters@ScalarHybridScheme(obj);
            
            % Set epsilon based on the SNR.
            c = epsilon_constant(obj);
            obj.epsilon = log(obj.n * log(obj.snr) * c) / log(obj.snr);
        end
        
        % This function returns the constant used to compute epsilon. According
        % to the paper, it is 8 * \gamma^2. Here \gamma^2 = source variance.
        function c = epsilon_constant(obj)
            c = 8 * obj.sv^2;
        end
    end
    
end

