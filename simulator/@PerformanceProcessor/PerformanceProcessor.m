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
        function plot_performance(obj, ah, schemes, parameters)
%             % Reset random number generator.
%             reset_rng(obj);
            
            set_schemes(obj, schemes, parameters);
            obj.mse = zeros(nb_schemes(obj), length(obj.snr));
            
            process_schemes(obj);
            
            perf_plot(obj, ah);
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
        function perf_plot(obj, ah)
            cla(ah);
            hold(ah, 'off');
            plot_vs_csnr_db(obj, ah, obj.sv ./ obj.mse);
            ylabel(ah, 'SDR [dB]');
            title('SDR vs. SNR');
        end
    end
    
end
