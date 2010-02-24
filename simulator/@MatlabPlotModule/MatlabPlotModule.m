classdef MatlabPlotModule < OutputModule
    %MATLABPLOTMODULE Plot module using standard MATLAB plot function
    %   This output module creates a plot on a MATLAB figure.
    
    properties (Access = 'public')
        ah = []    % Handle to the axis on which to create the plot.
    end
    
    properties (Access = 'protected')
        % This is the interpreter that MATLAB uses for labels. If any of the
        % labels contains a dollar sign, the interpreter is set to 'latex'.
        interpreter = 'tex'
        
        % This is the default "style list". For a plot consisting of several
        % data series, the styles of the different series are obtained by
        % cycling through this list. The styleidx variable points to the index
        % of the next plot. The function next_style() increases the index and
        % returns the next element from the style list.
        stylelist = {'b-', 'g-', 'r-', 'c-', 'm-', 'y-', 'k-'};
        styleidx = 0;
    end

    methods
        % The constructor only installs the default style list.
        function obj = MatlabPlotModule()
            obj@OutputModule();
            set_style_list(obj, 'color');
        end
        
        
        % Verify that the specified axis handle is valid if it is given
        % explicitly.
        function set.ah(obj, ah)
            if ~isscalar(ah) || ~ishandle(ah)
                error('The specified axis handle is not valid.');
            else
                obj.ah = ah;
            end
        end
        
        
        % This function implements an abstract function of the base class. It is
        % called to set the color mode.
        function set_color_mode(obj, c)
            switch c
                case 'color'
                    set_style_list(obj, 'color');
                case 'bw'
                    set_style_list(obj, 'bw');
                otherwise
                    error('%s is not a valid color mode.', c);
            end
        end
        
        
    end
    
    methods (Access = 'protected')
        function do_actual_plot(obj)
            % At this point we can assume all the data is in correct format.
            
            % First reset the style list index, then plot each row of y with a
            % different style.
            obj.styleidx = 0;
            for k = 1:size(obj.y, 1)
                plot(obj.ah, obj.x, obj.y(k, :), next_style(obj));
                hold(obj.ah, 'on');
            end
            set_plot_labels(obj);
            set_plot_grid(obj);
            set_plot_legend(obj);
            hold(obj.ah, 'off');
        end
        
        
        % This function chooses a particular style list.
        function set_style_list(obj, style)
            switch style
                case 'color'
                    obj.stylelist = {'b-', 'g-', 'r-', 'c-', 'm-', 'y-', 'k-'};
                case 'bw'
                    obj.stylelist = {'o-', 'x-', '+-', '*-', 's-', 'd-', ...
                        'v-', '^-', '<-', '>-', 'p-', 'h-'};
                otherwise
                    % We should never reach here, error checking should be done
                    % before.
                    assert(false);
            end
        end
        
        
        function set_plot_labels(obj)
            if ~isempty(obj.xlabel)
                % If the label text contains a dollar sign, we use the latex
                % interpreter.
                xlabel(obj.ah, obj.xlabel, 'Interpreter', obj.interpreter);
            end
            if ~isempty(obj.ylabel)
                ylabel(obj.ah, obj.ylabel, 'Interpreter', obj.interpreter);
            end
            if ~isempty(obj.plottitle)
                title(obj.ah, obj.plottitle, 'Interpreter', obj.interpreter);
            end
        end % set_plot_labels
        
        
        function set_plot_grid(obj)
            if obj.grid
                grid(obj.ah, 'on');
            else
                grid(obj.ah, 'off');
            end
        end % set_plot_grid
        
        
        function set_plot_legend(obj)
            if ~isempty(obj.legend)
                if ~isempty(obj.legendpos)
                    legend(obj.ah, obj.legend, 'Location', obj.legendpos);
                else
                    legend(obj.ah, obj.legend);
                end
            end
        end
        
        
        % In addition to the base class's checks, this function checks that ah
        % is a valid axis handle.
        function check_parameters(obj)
            check_parameters@OutputModule(obj);
            
            % Create a new figure and axes if the specified handle is no longer
            % valid. 
            if isempty(obj.ah) || ~ishandle(obj.ah)
                obj.ah = MatlabPlotModule.new_axis_handle();
            end
            
            % Check label string for latex code.
            check_latex(obj, obj.xlabel);
            check_latex(obj, obj.ylabel);
            check_latex(obj, obj.plottitle);
            
        end % check_parameters
        
        
        % This function sets the 'interpreter' property to 'latex' if the string
        % s contains a dollar sign.
        function check_latex(obj, s)
            if ~isempty(strfind(s, '$'))
                obj.interpreter = 'latex';
            end
        end
        
        % This function cycles to the next element of the style list and returns
        % the corresponding element. 
        function s = next_style(obj)
            obj.styleidx = obj.styleidx + 1;
            if obj.styleidx > length(obj.stylelist)
                obj.styleidx = 1;
            end
            s = obj.stylelist{obj.styleidx};
        end
        
    end
    
    
    methods (Access = 'private', Static = true)
        function ah = new_axis_handle()
            fh = figure();
            ah = axes();
        end
    end
    
end

