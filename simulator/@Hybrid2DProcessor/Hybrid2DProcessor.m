classdef Hybrid2DProcessor < SchemeProcessor
    %HYBRID2DPROCESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        om1
        om2
        
        qe
        ee
    end
    
    methods (Access = 'public')
        function obj = Hybrid2DProcessor()
            obj@SchemeProcessor();
            obj.om1 = obj.output_module();
            obj.om2 = MatlabPlotModule();
        end
    end
    
    methods (Access = 'protected')
        function initialize(obj)
            % Create big all-zero matrices.
            obj.qe = zeros(obj.nb_schemes(), length(obj.snr));
            obj.ee = obj.qe;
        end
        
        function save_scheme_data(obj, scheme, j, k)
            obj.qe(j, k) = mean((scheme.compute_q() - scheme.compute_qh()).^2);
            obj.ee(j, k) = ...
                mean((scheme.compute_e() - scheme.compute_eh()).^2) / ...
                scheme.compute_beta()^2;
        end
        
        function post_process(obj)
            obj.output_module = obj.om1;
            obj.output_module.ylabel = '$(Q - Qh)^2$';
            obj.output_module.plottitle = 'Error in Q';
            plot_vs_snr_db(obj, obj.qe);
            
            obj.output_module = obj.om2;
            obj.output_module.ylabel = '$(E - Eh)^2 / \beta^2$';
            obj.output_module.plottitle = 'Error in E';
            plot_vs_snr_db(obj, obj.ee);
        end
    end
    
end

