classdef Test1
    %TEST1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function dv = compute_divergence(obj, snrrange)
            dv = log2(get_const(obj)) + log2(log(snrrange));
        end
        
        function c = get_const(obj)
            c = 2;
        end
    end
    
end

