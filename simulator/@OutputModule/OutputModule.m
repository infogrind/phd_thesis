classdef OutputModule < handle
    %OUTPUTMODULE Abstract base class for output modules
    %   The OutputModule class is the base class from which all output module
    %   classes are derived. It defines the output interface by abstractly
    %   declaring all required functions.
    
    properties (Access = 'public')
        x = [];       % x-coordinates of plot points (must be a vector)
        y = [];       % y-coordinates of plot points (can have several rows, but
                      % must have the same row length as x)
        
        xlabel = '';  % Label for x-axis
        ylabel = '';  % Label for y-axis
        
        plottitle = '';  % Plot title label
        
        legend = [];     % Legend entries
        legendpos = '';  % Legend position
        
        grid = false;    % Grid status (true = on, false = off)
        
    end
    
    methods
        % Set-accessor method for the legend. The legend must be either an empty
        % cell array (if no legend is required) or a cell array with one row.
        function set.legend(obj, l)
            if ~iscell(l)
                error('Legend must be a cell array.');
            elseif ~isempty(l) && size(l, 1) ~= 1
                error('Legend must be a cell array with a single row.');
            end
            
            obj.legend = l;
        end
    end
    
    methods (Access = 'public')
        % This function performs the actual plotting, to a "medium" specified
        % previously. E.g., to an axis handle, or to a tex file, etc. The base
        % class method does some elementary error checking; the rest is left to
        % the function do_actual_plot, which must be implemented by derived
        % classes.
        function do_plot(obj)
            check_parameters(obj);
            do_actual_plot(obj);
        end
    end
    
    
    methods (Access = 'protected', Abstract = true)
        % This is the method that does the plotting (no error checking here,
        % that is all done in check_parameters). It must be implemented by the
        % derived classes.
        do_actual_plot(obj)
    end
    
    
    methods (Access = 'protected')
        % This function does some basic checks of the parameters. It can be
        % extended by derived classes. Derived classes should always call the
        % base class's check_parameters method (except for very particular
        % circumstances, whatever they may be).
        function check_parameters(obj)
            % The data must have been set.
            if isempty(obj.x)
                error('X data not set.');
            end
            if isempty(obj.y)
                error('Y data not set.');
            end
            
            % The number of columns of X and Y must be the same.
            if size(obj.x, 2) ~= size(obj.y, 2)
                error('X and Y must have the same length.');
            end
            
            % Display warnings if some of the labels have not been set.
            if isempty(obj.xlabel)
                warning('MK:noxlabel', 'X label not set.');
            end
            if isempty(obj.ylabel)
                warning('MK:noylabel', 'Y label not set.');
            end
            if isempty(obj.plottitle)
                warning('MK:noplottitle', 'Plot title not set.');
            end
            
            % Issue a warning if the number of entries in the legend is smaller
            % than the number of rows of y; issue an error if it is larger.
            if ~isempty(obj.legend)
                if length(obj.legend) < size(obj.y, 1)
                    warning('MK:notenoughlegends', ...
                        'There are less legend entries than data series.');
                elseif length(obj.legend) > size(obj.y, 1)
                    error('There are more legend entries than data series.');
                end
            end    
        end % check_parameters
        
    end
    
    
    
end

