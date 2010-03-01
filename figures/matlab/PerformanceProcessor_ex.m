%%% MK:STARTSHOW
classdef PerformanceProcessor < SchemeProcessor
    
    properties
        mse
    end

    methods (Access = 'protected')
        function initialize(obj)
            obj.mse = zeros(nb_schemes(obj), length(obj.snr));
        end
        
        function save_scheme_data(obj, scheme, j, k)
            obj.mse(j, k) = scheme.compute_mse();
        end
        
        function post_process(obj)
          % Create the performance plot.
          % ...
        %%% MK:ENDSHOW
            obj.om.ylabel = 'SDR [dB]';
            obj.om.plottitle = 'SDR vs. SNR';
            plot_vs_snr_db(obj, obj.sv ./ obj.mse);
        %%% MK:STARTSHOW
        end
    end
end
%%% MK:ENDSHOW
