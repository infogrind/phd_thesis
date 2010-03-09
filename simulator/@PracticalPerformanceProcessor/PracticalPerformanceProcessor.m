classdef PracticalPerformanceProcessor < PerformanceProcessor
    %PRACTICALPERFORMANCEPROCESSOR Special performance processor.
    %   This performance processor is like the regular performance processor,
    %   but in addition it saves some empirical data like empirical input power
    %   and empirical SNR. Therefore it only works for practical schemes, not
    %   for theoretical schemes.
    
    properties (Access = 'public')
        Pemp   % Empirical input power (per channel input symbol).
        nvemp  % Empirical noise variance
    end
    
    methods (Access = 'protected')
        % Extend the base class' function with the initialization of the new
        % data variables.
        function initialize(obj)
            initialize@PerformanceProcessor(obj);
            obj.Pemp = zeros(nb_schemes(obj), length(obj.snr));
            obj.nvemp = zeros(nb_schemes(obj), length(obj.snr));
        end
        
        % Extend the base class' function by gathering the extra data.
        function save_scheme_data(obj, scheme, j, k)
            save_scheme_data@PerformanceProcessor(obj, scheme, j, k);
            obj.Pemp(j, k)  = scheme.compute_Pemp();
            obj.nvemp(j, k) = scheme.compute_nvemp();
        end
    end
    
end

