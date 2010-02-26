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
    
    
    properties (SetAccess = 'public')
        
        % Source variance
        sv = 1;
        
        % SNR range initialized to default value
        snr = 10.^(0:.1:4);
        
        % The number of source samples to produce.
        N = 100000;
        
        % Whether some extra output should be produced.
        verbose = false;

        % The output module
        om = [];
    end
    
    
    methods (Access = 'public')
        % Constructor
        function obj = SchemeProcessor()
            % Create random source samples.
            obj.s = create_source_samples(obj);
            
            % Initialize the output module to the default.
            obj.om = MatlabPlotModule();
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
        
        function set.om(obj, om)
            obj.om = om;
        end
        
        function om = get.om(obj)
            om = obj.om;
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
                    
                    % If the parameter is a cell array consisting only of
                    % vectors, we rearrange the vectors in to a list of cell
                    % arrays containing each exactly one element from each
                    % vector.
                    if iscell(p{j})
                        c = rearrange_parameter_cell(p{j});
                    else
                        c = p{j};
                    end
                    
                    for k = 1:length(c)
                        ctr = ctr + 1;
                        obj.schemes{ctr} = s{j};
                        % Different access depending on whether c is a vector
                        % or a cell array
                        if iscell(c)
                            obj.parameters{ctr} = c{k};
                        else
                            obj.parameters{ctr} = c(k);
                        end
                    end
                end
            end
        end
        
        
        % Runs all schemes
        function do_processing(obj)
            for k = 1:length(obj.schemes)
                scheme = create_scheme(obj, k);
                
                % Run the scheme for all SNR values and post process each time
                % to gather statistics. 
                for j = 1:length(obj.snr)
                    scheme.set_snr(obj.snr(j));
                    save_scheme_data(obj, scheme, j, k);
                end
                
                % Display percentage of schemes complete if verbose mode is
                % enabled.
                if obj.verbose
                    print_progress(obj, k);
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
                s = fh(obj.sv, obj.s, p);
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
            randn('state', 0);
            
            % And now we generate N(0,1) Gaussian samples, scaled to have the
            % desired variance. 
            s = sqrt(obj.sv) * randn(1, obj.N);
        end
        
        
        % This function creates a plot with the given data for each of the
        % schemes and handles the labeling.
        function plot_vs_snr(obj, m)
            obj.om.x = 10*log10(obj.snr);
            obj.om.y = m;
            obj.om.xlabel = 'SNR [dB]';
            obj.om.grid = true;
            
            % We only print a legend if there are several schemes.
            if length(obj.schemes) > 1
                obj.om.legend = printify(obj.schemes, obj.parameters);
                obj.om.legendpos = 'NorthWest';
            else
                obj.om.legend = {};
            end
            
            obj.om.do_plot();
        end
        
        
        % Same as above, but uses dB for the y axis.
        function plot_vs_snr_db(obj, m)
            plot_vs_snr(obj, 10*log10(m));
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
        function print_progress(obj, k)
            fprintf('%d%% done.\n', floor(100 * k / length(obj.schemes)));
        end
    end
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELPER FUNCTIONS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This function rearranges an element of the parameter cell array as follows.
% Suppose an element of the parameter list is
%   p{j} = {[1 2 3 4], [0.2 0.3 0.5 0.5]}.
% Then the output of the following function is
%   c = { {1, 0.2}, {2, 0.3}, {3, 0.5}, {4, 0.5} }.
% The idea is that the former version is easier to specify lists for various
% parameters, but the actual parameters passed to the scheme will be of the
% second form. 
function c = rearrange_parameter_cell(p)

% This function only does something if all elements of p are vectors.
if ~all_numeric(p)
    c = p;
    return;
end

% All vectors in p of length > 1 must have the same length. 
[b, l] = vector_length_correct(p);
assert(b);

% Now we construct the new cell array c from p. 
c = cell(1, l);
for k = 1:l
    c{k} = cell(1, length(p));
    for j = 1:length(p)
        % If the corresponding element of p is a scalar, we just add this
        % scalar. Otherwise we add the k-th element. 
        if isscalar(p{j})
            c{k}{j} = p{j};
        else
            c{k}{j} = p{j}(k);
        end
    end

end

end


% This function returns true if all elements of the cell array p are either
% scalars or vectors of the same fixed length. 
% In addition, if b is true then l is the length of the non-scalar elements of
% p.
function [b, l] = vector_length_correct(p)

% Input must be a cell.
assert(iscell(p));

% Initially, we assume the assumption to be correct, this will assure that the
% all-scalar case passes. 
b = true;

% Length of first non-scalar seen. Initialized to 1, since if all elements of p
% are scalars, that's the right value to return.
l = 1;

for k = 1:length(p)
    
    % Scalars are OK.
    if isscalar(p{k})
        continue;
    end
    
    % The contents must be vectors or scalars. 
    if ~isvector(p{k})
        b = false;
        return
    end
    
    % If this is the first non-scalar element, store its length. Otherwise
    % compare the length to the stored value.
    if l == 1
        l = length(p{k});
    elseif length(p{k}) ~= l
        b = false;
        return
    end
end

end


% This function returns true if all elements of the cell array p are numeric
% (i.e., scalars, vectors, or matrices), and false otherwise. 
function b = all_numeric(p)

% Input must be a cell.
assert(iscell(p));

% If we find a non-numeric element, the assertion is false, and it is true
% otherwise. 
b = true;
for k = 1:length(p)
    if ~isnumeric(p{k})
        b = false;
        return;
    end
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

