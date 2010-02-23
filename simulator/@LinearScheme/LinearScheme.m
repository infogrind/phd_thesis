classdef LinearScheme < PracticalScheme
    %LINEARSCHEME This class implements a linear encoder/decoder to transmit one
    %source symbol across n channel uses.
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = LinearScheme(sv, s, n)
            % Call base class constructor.
            obj@PracticalScheme(sv, s, 1, n);
        end
    end
    
    % Implement protected abstract methods
    methods (Access = 'protected')
        % The encoder. It receives the source symbols s already as a matrix with
        % k rows and is supposed to produce a matrix with n rows. 
        function x = encode(obj, s)
            % We send the same on all channel inputs, which is simply the source
            % scaled to have power P/n per channel input.
            x = repmat(s / sqrt(obj.sv) * sqrt(obj.P), obj.n, 1);
        end
        
        % The decoder.
        function sh = decode(obj, y)
            % This is the MMSE decoder.
            sh = sqrt(obj.P / obj.sv) / (obj.n * obj.P + obj.nv) * ...
                sum(y, 1);
        end
        
        % Method to initialize power and noise variance. Some schemes keep the
        % noise variance fixed and set P as a function of CSNR and some keep P
        % fixed and set nv as a function of CSNR.
        function init_P_nv(obj)
            % The power is constant and the noise variance decreases. 
            obj.P = 1;
            obj.nv = obj.P / obj.snr;
        end
    end
    
end

