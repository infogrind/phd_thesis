classdef HybridScheme < PracticalScheme
    %HYBRIDSCHEME Base class for hybrid quantization/uncoded tx schemes.
    %   HybridScheme is the abstract base class for all schemes that combine
    %   quantization and uncoded transmission for 1:n respectively m:m*p
    %   bandwidth expansion. 
    %
    %   The only variable thing is the lattice used for the quantization (which
    %   also implies all the dimensions). This lattice must be given by the
    %   derived classes by implementing the abstract methods lattice() and
    %   covering_radius(). (The latter is needed to compute an upper bound to
    %   the variance of the quantizer outputs.)
    
    % $Id$
    
    properties (Access = 'protected')
        % m and p mean that m source symbols are encoded into mp channel inputs.
        m
        p
        
        % Epsilon determines the quantizer scaling.
        epsilon
        
        % Here we store Q and E, the quantizer outputs and the last quantization
        % error.
        q
        e
        
        % Similarly, the estimates for q and e (the 'h' stands for 'hat').
        qh
        eh
        
        % This is the empirical covariance of e, computed by the encoder. The
        % decoder uses this for the LMMSE decoding of e. 
        % (It would of course be better to establish it analytically...)
        Ke
    end
    
    methods (Access = 'public')
        function obj = HybridScheme(sv, s, m, p, e)
            % In the 'language' of PracticalScheme, k is m and n is mp.
            obj@PracticalScheme(sv, s, m, m*p);
            
            % Verify that m and p are integers.
            assert(all(floor(m) == m));
            assert(all(floor(p) == p));
            
            % Save arguments in properties.
            obj.m = m;
            obj.p = p;
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
        
        function m = compute_m(obj)
            m = obj.m;
        end
        
        
        function b = compute_beta(obj)
            % The standard beta definition from the thesis.
            b = ceil(obj.snr ^ ((1 - obj.epsilon)/2));
        end
        
    end
    
    
    methods (Access = 'protected')
        function x = encode(obj, s)
            % Get the source sequence length from s and correspondingly allocate
            % the matrices. The matrix e is used repeatedly to save the
            % quantization error of each round, so we initialize it to s.
            N = size(s, 2);
            obj.q = zeros(obj.m*(obj.p-1), N);
            obj.e = s;
            
            % Also initialize the channel input matrix.
            x = zeros(obj.m*obj.p, N);
            
            % A shorthand for beta.
            b = compute_beta(obj);
            
            % The main loop of the hierarchical quantization. There are n-1
            % quantization rounds.
            for l = 1:obj.p - 1
                % For easier reference afterwards, ind denotes the row indices
                % into q (and x) of the current round.
                ind = ((l-1)*obj.m + 1) : l*obj.m;
                obj.q(ind, :) = quantize(obj, b * obj.e) / b;
                obj.e = b * (obj.e - obj.q(ind,:));

                % Set the corresponding rows of x to a scaled version of the
                % quantizer output. For l = 1, we approximate the variance
                % of the quantizer output by the source variance.
                % For l > 1, we use the fact that the variance of a lattice
                % cell is upper bounded by the squared covering radius.
                if (l == 1)
                    x(ind, :) = obj.q(ind, :) * sqrt(obj.P / obj.sv);
                else
                    x(ind, :) = obj.q(ind, :) * sqrt(obj.m*obj.P) / ...
                        covering_radius(obj);
                end
            end
            
            % Store empirical covariance matrix of e.
            obj.Ke = (obj.e * obj.e') / N;
            assert(all(size(obj.Ke) == [obj.m obj.m]));
            
            % Lastly, we scale the remaining quantization error and put it into
            % the last m rows of x.
            x(end - obj.m + 1 : end, :) = obj.e * sqrt(obj.m*obj.P) / ...
                covering_radius(obj);
                
        end
        
        
        function sh = decode(obj, y)
            obj.qh = decode_q(obj, y(1:obj.m*(obj.p-1), :));
            obj.eh = decode_e(obj, y(end - obj.m + 1 : end, :));
            sh = combine_estimates(obj, obj.qh, obj.eh);
        end
        
        
        function qh = decode_q(obj, yq)
            
            assert(size(yq, 1) == obj.m*(obj.p - 1));
            
            % Allocate space for the returned matrix and get beta.
            qh = zeros(size(yq));
            b = compute_beta(obj);
            
            % Get covering radius.
            R = covering_radius(obj);
            
            % Decoding is performed in blocks of m rows. 
            for l = 1:obj.p - 1
                % Set up relevant row indices.
                ind = ((l - 1)*obj.m + 1) : l*obj.m;
                if l == 1
                    qh(ind, :) = ...
                        quantize(obj, yq(ind, :) * b * sqrt(obj.sv/obj.P)) / b;
                else
                    qh(ind, :) = ...
                        quantize(obj, yq(ind, :) * b * R / sqrt(obj.m*obj.P)) ...
                        / b;
                end
            end
                
        end
        
        
        function eh = decode_e(obj, ye)
            % LMMSE estimation. For this we use the empirical covariance matrix
            % of e, rather than the actual one, for simplicity.
            
            % Some shortcuts.
            R = covering_radius(obj);
            P = obj.P;
            m = obj.m; %#ok<*PROP>
            Ke = obj.Ke;
            nv = obj.nv;
            
            eh = sqrt(P*m) / R * Ke / (m*P/R^2 * Ke + nv*eye(m)) * ye;
        end
        
        
        function sh = combine_estimates(obj, qh, e)
            sh = zeros(size(e));
            b = compute_beta(obj);
            for l = 1:obj.p - 1
                ind = ((l - 1)*obj.m + 1) : l*obj.m;
                sh = sh + qh(ind, :) / b^(l-1);
            end
            sh = sh + e / b^(obj.p - 1);
        end
        
        
        function y = quantize(obj, x)
            % The quantization is done using the supplied lattice function.
            % Note that the lattice function is assumed to operate row wise.
            y = lattice(obj, x')';
        end
    end
    
    
    methods (Access = 'protected', Abstract = true)
        % This function takes the matrix x and returns a matrix of same
        % dimension y. Row-by-row, the entries of y are the lattice-quantized
        % rows of x.
        y = lattice(obj, x)
        
        % This function returns the covering radius of the lattice used in the
        % lattice() method.
        r = covering_radius(obj)
    end
    
end

