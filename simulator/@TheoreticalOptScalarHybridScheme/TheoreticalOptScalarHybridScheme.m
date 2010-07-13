classdef TheoreticalOptScalarHybridScheme < TheoreticalScheme
    %THEORETICALHYBRIDSCHEME Theoretical scaling of the 1:n hybrid scheme.
    %   This is the "optimal" scaling obtained by [Kleiner/Rimoldi 2009]
    %   (Globecom 2009). Instead of computing beta as a function of epsilon and
    %   epsilon in turn as a function of SNR, the MSE is computed directly as a
    %   function of the SNR. The resulting performance is only correct in the
    %   order sense. 
    
    properties
        n % Channel uses per source symbol
    end
    
    methods (Access = 'public')
        function obj = TheoreticalOptScalarHybridScheme(sv, s, n)
            obj@TheoreticalScheme(sv, s);
            obj.n = n;
        end
    end
    
    methods (Access = 'protected')
        function update_mse(obj)
            obj.mse = obj.snr^(-obj.n) * (log(obj.snr))^(obj.n-1);
        end
    end
    
end

