classdef PerformanceProcessor < SchemeProcessor
    %PERFORMANCEPROCESSOR Evaluates performance of communication schemes.
    %   The performance processor takes a list of schemes, possibly each with a
    %   list of parameters, and creates a plot with the SDR vs. SNR of each
    %   scheme.
    
    % $Id$
    
    properties
        mse
    end
    

    
    methods (Access = 'protected')
        
        % To initialize the processing, clear the MSE matrix.
        function initialize(obj)
            obj.mse = zeros(nb_schemes(obj), length(obj.snr));
        end
        
        
        % Implementation of the abstract method post_process().
        function save_scheme_data(obj, scheme, j, k)
            % Store MSE of scheme.
            obj.mse(k, j) = scheme.compute_mse();
        end
        
        
        function post_process(obj)
            obj.output_module.ylabel = 'SDR [dB]';
            obj.output_module.plottitle = 'SDR vs. SNR';
            plot_vs_snr_db(obj, obj.sv ./ obj.mse);
        end
        
        
    end
    
end
