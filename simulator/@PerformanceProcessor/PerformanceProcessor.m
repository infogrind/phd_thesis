classdef PerformanceProcessor < SchemeProcessor
    %PERFORMANCEPROCESSOR Evaluates performance of communication schemes.
    %   The performance processor takes a list of schemes, possibly each with a
    %   list of parameters, and creates a plot with the SDR vs. SNR of each
    %   scheme.
    
    % $Id$
    
    properties
        mse
    end
    
    methods (Access = 'public')
        function plot_performance(obj, schemes, parameters)
%             % Reset random number generator.
%             reset_rng(obj);
            
            set_schemes(obj, schemes, parameters);
            obj.mse = zeros(nb_schemes(obj), length(obj.snr));
            
            process_schemes(obj);
            
            perf_plot(obj);
        end
        
%         function c = get_snr(obj)
%             c = obj.snr;
%         end
    end
    
    methods (Access = 'protected')
        % Implementation of the abstract method post_process().
        function post_process(obj, scheme, j, k)
            % Store MSE of scheme.
            obj.mse(k, j) = scheme.compute_mse();
        end
    end
    
    methods (Access = 'protected')
        function perf_plot(obj)
            obj.om.ylabel = 'SDR [dB]';
            obj.om.plottitle = 'SDR vs. SNR';
            plot_vs_csnr_db(obj, obj.sv ./ obj.mse);
        end
    end
    
end
