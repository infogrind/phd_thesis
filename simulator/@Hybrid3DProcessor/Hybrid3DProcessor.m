classdef Hybrid3DProcessor < PracticalPerformanceProcessor
    %HYBRID3DPROCESSOR Computes Eq and Ee for 3 ch. uses / source symbol
    %   This processor is for hybrid schemes with m = 1 and n = p = 3. It was
    %   used to test some peculiar behavior; at this point it may be obsolete.
    
    properties (Access = 'public')
        q1e
        q2e
        ee
    end
    
    methods (Access = 'protected')
        function initialize(obj)
            initialize@PracticalPerformanceProcessor(obj);
            obj.q1e = zeros(nb_schemes(obj), length(obj.snr));
            obj.q2e = zeros(nb_schemes(obj), length(obj.snr));
            obj.ee  = zeros(nb_schemes(obj), length(obj.snr));
        end
        
        function save_scheme_data(obj, scheme, j, k)
            save_scheme_data@PracticalPerformanceProcessor(obj, scheme, j, k);
            % Get all needed data from scheme object.
            q  = scheme.compute_q();
            q1 = q(1,:);
            q2 = q(2,:);
            
            qh = scheme.compute_qh();
            q1h = qh(1,:);
            q2h = qh(2,:);
            
            e  = scheme.compute_e();
            eh = scheme.compute_eh();
            b  = scheme.compute_beta();
            
            % Check validity of assumptions.
            assert(size(q,1) == 2);
            assert(size(qh, 1) == 2);
            assert(size(e, 1) == 1);
            assert(size(eh, 1) == 1);
            
            obj.q1e(j, k) = mean((q1 - q1h).^2);
            obj.q2e(j, k) = mean((q2 - q2h).^2);
            obj.ee(j, k)  = mean((e - eh).^2) / b^2;
            
            if (obj.q1e(j,k) < 1e-9)
                fprintf('*** Good case: err = %.2e\n', obj.q1e(j,k));
            else
                fprintf('*** Bad case:  err = %.2e\n', obj.q1e(j,k));
                fprintf('*** Number of errors: %d\n', ...
                    nnz((q1 - q1h).^2 ~= 0));
            end
        end
        
        function post_process(obj) %#ok<MANU>
            % Does nothing.
        end
    end
    
end

