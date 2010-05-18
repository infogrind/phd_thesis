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
        P       % Avg. power per source symbol
        nv      % AWGN noise variance
        Pemp    % Empirical channel input power (per input symbol).
        nvemp   % Empirical noise variance.
        z       % Noise matrix.
        
        pad     % Number of padding bits added to s to make it a multiple of k.
    end
    
    methods
        function obj = PracticalScheme(sv, s, k, n)
            obj@Scheme(sv, s);
            
            % Store rate parameters.
            obj.k = k;
            obj.n = n;
            
            % Store the source samples (the base class actually just ignores s.)
            obj.s = s;
            
        end
                
        function x = compute_x(obj)
            x = obj.x;
        end
        
        function y = compute_y(obj)
            y = obj.y;
        end
        
        function sh = compute_sh(obj)
            sh = obj.sh;
        end
        
        function Pemp = compute_Pemp(obj)
            Pemp = obj.Pemp;
        end
        
        function nvemp = compute_nvemp(obj)
            nvemp = obj.nvemp;
        end
        
    end
    
    methods (Access = 'protected')
        
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
    methods (Access = 'protected', Sealed = true)
        
        % The main addition of PracticalScheme wrt. Scheme is that now we have a
        % snr_updated() method that does the main steps of the simulation.
        function snr_updated(obj)
            % This lets derived classes update parameters that depend on the
            % SNR. 
            update_variable_parameters(obj);
            
            % And now, run the actual simulation.
            run_simulation(obj);
        end


        % This function actually simulates the encoding, transmission, and
        % decoding.
        function run_simulation(obj)
            % Convert source symbols to matrix, encode, and verify dimensions of
            % encoder output. 
            obj.x = encode(obj, row_to_block(obj, obj.s));
            assert(size(obj.x, 1) == obj.n);
            
            % Save the empirical input power.
            obj.Pemp = empirical_P_per_channel_input(obj, obj.x);
            
            % Transmit across AWGN channel.
            obj.y = transmit(obj, obj.x);
            
            % If verbose mode is enabled, plot the measured empirical SNR.
            if (obj.verbose)
                snrthdb = 10*log10(obj.snr);
                snremdb = 10*log10(obj.Pemp / obj.nvemp);
                fprintf(['Theoretical/empirical SNR = %.3fdB / %.3fdB ', ...
                    '(difference %.2fdB)\n'], ...
                    snrthdb, ...
                    snremdb, snrthdb - snremdb);
                fprintf('Empirical input power: %.2fdB\n', ...
                    10*log10( empirical_P_per_channel_input(obj, obj.x)));
            end
            
            % Decode, verify dimensions of decoder output, and convert back to
            % row vector. 
            
            %%%%%%%%% ATTENTION: THE LINE BELOW IS THE CORRECT VERSION %%%%%%
            sh_block = decode(obj, obj.y);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%% WHEREAS THE FOLLOWING LINE SHOULD BE REMOVED. %%%%%%%%%
            %sh_block = decode(obj, obj.x);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            assert(size(sh_block, 1) == obj.k);
            obj.sh = block_to_row(obj, sh_block);
            
            obj.mse = mean((obj.s - obj.sh).^2);
        end
    end
    
       
    methods (Access = 'private')
        
        % The AWGN channel simulator.
        function y = transmit(obj, x)
            % Create noise (by passing the all-zero signal though the AWGN
            % channel.
            obj.z = awgn_channel(zeros(size(x)), obj.nv);
            
            % Save empirical noise variance.
            obj.nvemp = mean(mean(obj.z.^2));
            
            % Add noise to input.
            y = x + obj.z;
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
