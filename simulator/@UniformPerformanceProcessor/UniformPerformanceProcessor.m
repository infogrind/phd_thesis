classdef UniformPerformanceProcessor < PerformanceProcessor
    %UNIFORMPERFORMANCEPROCESSOR Performance processor using uniform source.
    %   The only difference to PerformanceProcessor is that while the latter
    %   produces Gaussian source symbols, this one produces uniform source
    %   symbols with a default variance of 1/12 (i.e., lying between -1/2 and
    %   1/2). 
    
    properties
    end
    
    methods (Access = 'public')
        % The constructor sets a new default source variance.
        function obj = UniformPerformanceProcessor()
            obj@PerformanceProcessor();
            obj.sv = 1/12;
        end
    end
    
    methods (Access = 'protected')
        
        function s = create_source_samples(obj)
            
            % First we reset the random number generator to its initial state,
            % so we get repeatable results.
            reset(RandStream.getDefaultStream);
            
            % And now we generate uniform samples, scaled to have the
            % desired variance. 
            s = sqrt(12*obj.sv) * (rand(1, obj.N) - .5);
        end
    end
    
end

