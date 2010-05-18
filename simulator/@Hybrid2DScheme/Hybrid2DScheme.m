classdef Hybrid2DScheme < PracticalScheme
    %HYBRID2DSCHEME Implementation of simple Globecom-style scheme for n = 2.
    %   This scheme does essentially the same as ScalarHybridScheme with
    %   parameter n = 2. I don't quite remember why I implemented it, I believe
    %   it had something to do that I wanted to analyze certain things
    %   particular to 1:2 bandwidth expansion, using the Hybrid2DProcessor.
    
    % $Id$
    
    properties (Access = 'protected')
        epsilon
        q
        qh
        e
        eh
    end
    
    methods (Access = 'public')
        function obj = Hybrid2DScheme(sv, s, e)
            obj@PracticalScheme(sv, s, 1, 2);
            obj.epsilon = e;
        end
        
        function q = compute_q(obj)
            q = obj.q;
        end
        
        function qh = compute_qh(obj)
            qh = obj.qh;
        end
        
        function e = compute_e(obj)
            e = obj.e;
        end
        
        function eh = compute_eh(obj)
            eh = obj.eh;
        end
        
        function b = compute_beta(obj)
            b = ceil(obj.snr^((1 - obj.epsilon)/2));
        end
        
    end
    
    methods (Access = 'protected')
        
        function x = encode(obj, s)
            b = compute_beta(obj);
            obj.q = round(b * s) / b;
            obj.e = b * (s - obj.q);
            
            % Allocate matrix with two rows for x.
            x = zeros(2, length(s));
            
            % Simplifying assumption: var(q) = var(s), and e is uniform.
            x(1, :) = sqrt(obj.P / obj.sv) * obj.q;
            x(2, :) = sqrt(12 * obj.P) * obj.e;
        end
        
        
        function sh = decode(obj, y)
            b = compute_beta(obj);
            j = round(sqrt(obj.sv / obj.P) * b * y(1,:));
            obj.qh = j / b;
            
            obj.eh = sqrt(obj.P/12) / (obj.P + obj.nv) * y(2,:);
            
            sh = obj.qh + obj.eh / b;
        end
        
        
    end
    
end

