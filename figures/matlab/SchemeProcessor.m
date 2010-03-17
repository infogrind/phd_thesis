classdef SchemeProcessor < handle
    properties (Access = 'protected')
        s           % Source sample sequence.
        schemes     % Cell array of schemes to process.
        parameters  % Parameters for each scheme (if any).
    end
    
    properties (Access = 'public')
        sv = 1;               % Source variance.
        snr = 10.^(0:.1:4);   % SNR range.
        N = 100000;           % Sample size.
    end
    
    methods (Access = 'public')
        function obj = SchemeProcessor()
            obj.s = create_source_samples(obj);
        end
        
        function process(obj, schemes, parameters)
            set_schemes(obj, schemes, parameters);
            initialize(obj);
            do_processing(obj);
            post_process(obj);   
        end
    end
    
    methods (Access = 'protected')
        function do_processing(obj)
            for j = 1:length(obj.schemes)
                scheme = create_scheme(obj, j);
                
                % Run the scheme for all SNR values and save data for
                % each run.
                for k = 1:length(obj.snr)
                    scheme.set_snr(obj.snr(k));
                    save_scheme_data(obj, scheme, j, k);
                end
            end
        end
    end
    
    methods (Access = 'protected', Abstract = true)
        initialize(obj);
        save_scheme_data(obj, scheme, j, k)
        post_process(obj)
    end
end
