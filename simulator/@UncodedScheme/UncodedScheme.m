classdef UncodedScheme < PracticalScheme
    % UNCODEDSCHEME Implementation of uncoded transmission.
    %   This scheme implements uncoded transmission for the 1:1 case (no
    %   bandwidth expansion). The encoder scales the source symbol to satisfy
    %   the power constraint and the decoder is the LMMSE decoder. 
    
    % $Id$
    
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
