%%% MK:STARTSHOW
classdef PerformanceProcessor < SchemeProcessor

    properties
        mse
    end
    
    methods (Access = 'public')
        function plot_performance(obj, schemes, parameters)
            set_schemes(obj, schemes, parameters);
            obj.mse = zeros(nb_schemes(obj), length(obj.snr));
            process_schemes(obj);
            perf_plot(obj);
        end
    end
    
    methods (Access = 'protected')
        function post_process(obj, scheme, j, k)
            obj.mse(k, j) = scheme.compute_mse();
        end

        function perf_plot(obj)
            % ...
%%% MK:ENDSHOW
            obj.om.ylabel = 'SDR [dB]';
            obj.om.plottitle = 'SDR vs. SNR';
            plot_vs_csnr_db(obj, obj.sv ./ obj.mse);
%%% MK:STARTSHOW
        end
    end
    
end
%%% MK:ENDSHOW
