classdef PracticalScheme < Scheme
    %PRACTICALSCHEME Base class for all schemes that require simulation.
    %   The main difference 
    
    % $Id$
    
    properties (Access = 'protected')
        k       % Number of source symbols encoded at a time.
        n       % Number of channel input symbols produced at a time.
        x       % n x N matrix of channel input symbols.
        y       % n x N matrix of channel output symbols.
        s       % k x N matrix of source symbols.
        sh      % k x N matrix of source estimates.
        mse     % Resulting mean-squared error.
        P       % Avg. power per source symbol
        nv      % AWGN noise variance
        
        pad     % Number of padding bits added to s to make it a multiple of k.
    end
    
    methods
        function obj = PracticalScheme(sv, s, k, n)
            obj@Scheme(sv, s)
            
            % Store rate parameters.
            obj.k = k;
            obj.n = n;
            
            % Store the source samples (the base class actually just ignores s.)
            obj.s = s;
            
        end
                
        % Access methods for simulation data.
        function mse = compute_mse(obj)
            assert(obj.has_run);
            mse = obj.mse;
        end
        
        function x = compute_x(obj)
            assert(obj.has_run);
            x = obj.x;
        end
        
        function y = compute_y(obj)
            assert(obj.has_run);
            y = obj.y;
        end
        
        function sh = compute_sh(obj)
            assert(obj.has_run);
            sh = obj.sh;
        end
        
    end
    
    methods (Access = 'protected')
        
        % This method returns the power constraint per channel input.
        function p = power_per_channel_input(obj)
            p = obj.P * obj.k / obj.n;
        end
        
        % This function is called whenever a simulation run is started, in order
        % to update scheme parameters that depend on the SNR. It should be
        % extended as necessary by derived classes. ('extended' means that
        % if the function is overwritten by derived classes, they should call
        % the update_variable_parameters() function of the super class first.)
        function update_variable_parameters(obj)
            init_P_nv(obj);
        end
        
        % Method to initialize power and noise variance. Some schemes keep the
        % noise variance fixed and set P as a function of CSNR and some keep P
        % fixed and set nv as a function of CSNR. By default the power is fixed.
        function init_P_nv(obj)
            obj.P = 1;
            obj.nv = obj.P / obj.snr;
        end
    end
       
    methods (Access = 'protected', Static)
        % Two static helper methods to add padding.
        % add_padding(x, k) adds as many zeros to the row vector x as are needed
        % to make the length of x a multiple of k. 
        function [y, padding] = add_padding(x, k)
            padding = mod(k - mod(length(x), k), k);
            y = [x zeros(1, padding)];
            assert(mod(length(y), k) == 0);
        end

        function y = remove_padding(x, padding)
            y = x(1:end - padding);
        end
    end


    methods (Access = 'protected', Abstract = true)
        
        % The encoder. It receives the source symbols s already as a matrix with
        % k rows and is supposed to produce a matrix with n rows. 
        x = encode(obj, s)
        
        % The decoder.
        sh = decode(obj, y)
    end
    
    
    % We define the run method as sealed. If no derived class can override
    % it, this ensures uniformity of channel. 
    methods (Access = 'public', Sealed = true)
        
        % The main addition of PracticalScheme wrt. Scheme is that now we have a
        % run() method, which does the main steps of the simulation.
        function run(obj, snr)
            run@Scheme(obj, snr);

            % This lets derived classes update parameters that depend on the
            % SNR. 
            update_variable_parameters(obj);
            
            % Convert source symbols to matrix, encode, and verify dimensions of
            % encoder output. 
            obj.x = encode(obj, row_to_block(obj, obj.s));
            assert(size(obj.x, 1) == obj.n);
            
            % If verbose mode is enabled, plot the measured empirical SNR.
            if (obj.verbose)
                fprintf('Empirical SNR = %.3f dB\n', ...
                    10*log10( empirical_P_per_channel_input(obj, obj.x) ...
                    / obj.nv));
            end
            
            % Transmit across AWGN channel.
            obj.y = transmit(obj, obj.x);
            
            % Decode, verify dimensions of decoder output, and convert back to
            % row vector. 
            sh_block = decode(obj, obj.y);
            assert(size(sh_block, 1) == obj.k);
            obj.sh = block_to_row(obj, sh_block);
            
            obj.mse = mean((obj.s - obj.sh).^2);
        end
    end
    
       
    methods (Access = 'private')
        
        % The AWGN channel simulator.
        function y = transmit(obj, x)
            y = awgn_channel(x, obj.nv);
        end


        % This computes the empirical power per channel input symbol.
        function P = empirical_P_per_channel_input(obj, x)
            P = mean(mean(x.^2));
        end
        
        
        % These two functions are used to convert a row vector of source symbols
        % in to a block of k rows, and back. 
        function y = row_to_block(obj, x)
            [y, p] = PracticalScheme.add_padding(x, obj.k);
            obj.pad = p;
            y = reshape(y, obj.k, length(y) / obj.k);
        end
        
        function y = block_to_row(obj, x)
            y = x(:)';
            y = PracticalScheme.remove_padding(y, obj.pad);
        end
    end
    

    
end

function y = awgn_channel(x, nv)

y = x + sqrt(nv) * randn(size(x));

end
