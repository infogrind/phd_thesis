classdef SchemeProcessor < handle
    %SCHEMEPROCESSOR Runs a list of schemes for various CSNR values.
    %   SchemeProcessor is the base class on which to build if you want to run
    %   some schemes for multiple CSNR values and/or parameters. It takes care
    %   of creating the random source and runs all the scheme. Any derived class
    %   can make use of the do_processing() function and it must implement the
    %   post_process() method. 
    
    % $Id$
    
    properties (Access = 'protected')
        
        % Source samples
        s
        
        % Cell-arrays of schemes and parameter lists
        schemes
        parameters
    end
    
    
    properties (Access = 'public')
        
        % Source variance
        sv = 1;
        
        % SNR range initialized to default value
        snr = 10.^(0:.1:4);
        
        % The number of source samples to produce.
        N = 100000;
        
        % Whether some extra output should be produced.
        verbose = false;
        
        % The legend mode: If 'off', never show legend. If 'on', always show
        % legend. If 'auto', only show legend when > 1 scheme. 
        legendmode = 'auto';

        % The output module
        output_module = [];

    end
    
    
    methods (Access = 'public')
        % Constructor
        function obj = SchemeProcessor()
            % Create random source samples.
            obj.s = create_source_samples(obj);
            
            % Initialize the output module to the default.
            obj.output_module = default_output_module(obj);
        end
        
        
        % The process() method takes a list of schemes and parameters and
        % processes them. (What else would it do, I ask you?)
        function process(obj, schemes, parameters)
            
            set_schemes(obj, schemes, parameters);
            initialize(obj);
            do_processing(obj);
            post_process(obj);

        end
    end
    
    
    % Get/set methods
    methods
        function set.N(obj, N)
            if N < 1 || floor(N) ~= N
                error('N must be a positive integer.');
            else
                obj.N = N;
            end
            
            % Generate new list of source symbols of length N.
            obj.s = create_source_samples(obj);
        end
        
        function set.sv(obj, sv)
            if sv <= 0
                error('sv must be positive.');
            else
                obj.sv = sv;
            end
            
            % Generate new source samples with the updated variance.
            obj.s = create_source_samples(obj);
        end
        
        
        function set.verbose(obj, v)
            obj.verbose = v;
        end
        
        function set.legendmode(obj, lm)
            switch lower(lm)
                case {'on', 'off', 'auto'}
                    obj.legendmode = lower(lm);
                otherwise
                    error('Invalid legend mode.');
            end
        end
        
        function set.output_module(obj, output_module)
            obj.output_module = output_module;
        end
        
        function om = get.output_module(obj)
            om = obj.output_module;
        end
    end
    

    methods (Access = 'protected')
        
        % This function takes a cell array of scheme names and a cell array of
        % parameter vectors and stores it as illustrated by the following
        % example.
        %   schemes = {'Shannon', 'LatticeD4'};
        %   parameters = {[1 2], [1 0.7 0.5]};
        % After calling set_schemes(obj, schemes, parameters), the properties of
        % obj will be
        %   obj.schemes = {'Shannon', 'Shannon', 'LatticeD4', 'LatticeD4', 
        %     'LatticeD4'}
        %   obj.parameters = {[1], [2], [1], [0.7], [0.5]}
        function set_schemes(obj, schemes, parameters)
            % Count required length of obj.schemes.
            obj.schemes = {};
            obj.parameters = {};
            
            flatten_schemes(obj, schemes, parameters);
        end
        
        
        % This function does the actual "flattening" of the given schemes and
        % parameters arrays, as explained in the introducing comment of
        % set_schemes().
        function flatten_schemes(obj, s, p)
            ctr = 0;
            for j = 1:length(s)
                if isempty(p{j})                % Scheme without parameters
                    ctr = ctr + 1;
                    obj.schemes{ctr} = s{j};
                    obj.parameters{ctr} = [];
                else                            % Scheme with parameters
                    
                    % Make sure the parameter is a scalar, vector, or
                    % matrix.
                    if ~isnumeric(p{j})
                        error('Non-numeric parameters are not supported.');
                    end
                    
                    % Each row of the parameter matrix corresponds to a
                    % different parameter. We need to separate the matrix
                    % into columns, and duplicate the scheme entry for each
                    % column. 
                    c = p{j};
                    nruns = size(c, 2);
                    
                    for k = 1:nruns
                        ctr = ctr + 1;
                        obj.schemes{ctr} = s{j};
                        obj.parameters{ctr} = make_cell(c(:, k));
                    end

                end
            end
        end
        
        
        % Runs all schemes
        function do_processing(obj)
            for j = 1:length(obj.schemes)
                scheme = create_scheme(obj, j);
                
                verbmsg(obj, 'Processing scheme %s with parameters %s...\n', ...
                    obj.schemes{j}, cell2str(obj.parameters{j}));
                
                
                % Run the scheme for all SNR values and post process each time
                % to gather statistics. 
                for k = 1:length(obj.snr)
                    scheme.set_snr(obj.snr(k));
                    save_scheme_data(obj, scheme, j, k);
                    
                    print_progress(obj, k, length(obj.snr));
                end
                
            end
        end
        
        
        % This function creates a scheme object from a scheme name; the
        % parameters j and k are the indices into the snr array and the
        % schemes/parameters array, respectively. 
        function s = create_scheme(obj, k)
            % Create constructor function handle from scheme name.
            fh = str2func(obj.schemes{k});
            
            % Depending on whether the scheme uses a parameter we call the
            % constructor either with three or with four arguments.
            p = obj.parameters{k};
            if isempty(p)
                s = fh(obj.sv, obj.s);
            else
                s = fh(obj.sv, obj.s, p{:});
            end
            
            % Set verbose flag according to own verbose flag.
            s.verbose = obj.verbose;
            
        end
        
        
        function n = nb_schemes(obj)
            n = length(obj.schemes);
        end
        
        
        function s = create_source_samples(obj)
            
            % First we reset the random number generator to its initial state,
            % so we get repeatable results.
            reset(RandStream.getDefaultStream);
            
            % And now we generate N(0,1) Gaussian samples, scaled to have the
            % desired variance. 
            s = sqrt(obj.sv) * randn(1, obj.N);
        end
        
        
        % This function creates a plot with the given data for each of the
        % schemes and handles the labeling.
        function plot_vs_snr(obj, m)
            obj.output_module.x = 10*log10(obj.snr);
            obj.output_module.y = m;
            obj.output_module.xlabel = 'SNR [dB]';
            obj.output_module.grid = true;
            
            % We only print a legend if there are several schemes or if the
            % legend mode is 'on'.
            if strcmp(obj.legendmode, 'on') || ...
                    (length(obj.schemes) > 1 && strcmp(obj.legendmode, 'auto'))
                obj.output_module.legendpos = 'NorthWest';
                obj.output_module.legend = ...
                    printify(obj.schemes, obj.parameters);
            else
                obj.output_module.legend = {};
            end
            
            obj.output_module.do_plot();
        end
        
        
        % Same as above, but uses dB for the y axis.
        function plot_vs_snr_db(obj, m)
            plot_vs_snr(obj, 10*log10(m));
        end

        % Returns the default output module. This is in a separate function so
        % that derived classes can change the default behavior.
        function om = default_output_module(obj)
            om = MatlabPlotModule();
        end
        
    end
    
    
    
    methods (Access = 'protected', Abstract = true)
        
        % Before starting the actual processing, the initalize() method is
        % called, which derived classes can use to initialize variables.
        initialize(obj);
        
        % Derived classes must implement the save_scheme_data method, which
        % gathers data after every run. 
        save_scheme_data(obj, scheme, j, k)
        
        % The post_process function is called after all schemes have been
        % processed.
        post_process(obj)
    end
    
    methods (Access = 'private')
        % This function generates a verbose progress message, as the
        % percentage of k of t. 
        function print_progress(obj, k, t)
            verbmsg(obj, '%d%% done.\n', floor(100 * k / t));
        end
        
        % Print a message if verbose mode is enabled.
        function verbmsg(obj, varargin)
            if obj.verbose
                fprintf(varargin{:});
            end
        end
    end
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELPER FUNCTIONS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% This function converts a row or column vector into a 1 x n cell array
% containing the elements of the vector.
function c = make_cell(v)

assert(isvector(v));

% Convert to row vector. 
v = v(:)';
c = num2cell(v);
end



% Convert a cell of scalars into a string. This function works only for row
% cell vectors.
function s = cell2str(c)

if isempty(c)
    s = '{}';
    return;
end

assert(size(c, 1) == 1);
n = length(c);
if n == 1
    s = sprintf('{%s}', num2str(c{1}));
else
    s = '{';
    for k = 1:length(c) - 1
        s = strcat(s, sprintf('%s, ', num2str(c{k})));
    end
    s = strcat(s, sprintf('%s}', num2str(c{end})));
end

end



% Function to convert cell array of strings such that it can be used for
% plot labels (converts e.g. _ into \_)
function t = printify(s, p)

assert(length(s) == length(p));

% Create a cell array that will contain the legend entries.
t = cell(1, length(s));

% Go through all scheme names and add a corresponding entry to the legend. If
% the scheme has a parameter, it will go in parenthesis after the scheme name.
for k = 1:length(s)
    % Escape underscores.
    s_s = strrep(s{k}, '_', '\_');
    if isempty(p{k})
        t{k} = s_s;
    else
        % For multi-value parameters, the legend entry will be of the form
        % 'Scheme (p1, p2, ...)'.
        if iscell(p{k})
            % Multiple-value parameter
            l = length(p{k});
            % Add first parameter
            t{k} = sprintf('%s (%.2f', s_s, p{k}{1});
            % Add other parameters, separated by commas.
            for j = 2:l
                t{k} = sprintf('%s, %.2f', t{k}, p{k}{j});
            end
            % Add final parenthesis
            t{k} = sprintf('%s)', t{k});
        else
            t{k} = sprintf('%s (%.2f)', s_s, p{k});
        end
    end
end

end

