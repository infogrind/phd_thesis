classdef UncodedScheme < PracticalScheme
    
    methods (Access = 'public')
        function obj = UncodedScheme(sv, s)
            obj@PracticalScheme(sv, s, 1, 1);
        end
    end
    
    methods (Access = 'protected')
        function x = encode(obj, s)
            x = sqrt(obj.P / obj.sv) * s;
        end
        
        function sh = decode(obj, y)
            sh = sqrt(obj.P * obj.sv) / (obj.P + obj.nv) * y;
        end
    end
    
end

