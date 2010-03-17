%%% MK:STARTSHOW
classdef PracticalScheme < Scheme
    methods (Access = 'protected', Sealed = true) 
        function snr_updated(obj) 
            run_simulation(obj); 
        end 
        
        function run_simulation(obj)
            % Encode the source.
            obj.x = encode(obj, obj.s);

            % Transmit across AWGN channel.
            obj.y = transmit(obj, obj.x);
            
            % Decode the channel output.
            obj.sh = decode(obj, obj.y);
            
            % And compute the empirical MSE.
            obj.mse = mean((obj.s - obj.sh).^2);
        end
    end

    methods (Access = 'protected', Abstract = true)
        x = encode(obj, s)
        sh = decode(obj, y)
    end 
    
end
