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
            % Get all needed data from scheme object.
            q  = scheme.compute_q();
            qh = scheme.compute_qh();
            e  = scheme.compute_e();
            eh = scheme.compute_eh();
            b  = scheme.compute_beta();
            m  = scheme.compute_m();
            
            obj.qe(j, k) = sum(mean((q - qh).^2, 2)) / m;
            obj.ee(j, k) = sum(mean((e - eh).^2, 2)) / m / b^2;
        end
        
        function post_process(obj)
            if ~isempty(obj.om1)
                obj.output_module = obj.om1;
                obj.output_module.ylabel = '$(Q - Qh)^2$';
                obj.output_module.plottitle = 'Error in Q';
                plot_vs_snr_db(obj, obj.qe);
            end
            
            if ~isempty(obj.om2)
                obj.output_module = obj.om2;
                obj.output_module.ylabel = '$(E - Eh)^2 / \beta^2$';
                obj.output_module.plottitle = 'Error in E';
                plot_vs_snr_db(obj, obj.ee);
            end
        end
    end
    
end

