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
    end

    methods
        % Verify that the specified axis handle is valid if it is given
        % explicitly.
        function set.ah(obj, ah)
            if ~isscalar(ah) || ~ishandle(ah)
                error('The specified axis handle is not valid.');
            else
                obj.ah = ah;
            end
        end
    end
    
    methods (Access = 'protected')
        function do_actual_plot(obj)
            % At this point we can assume all the data is in correct format.
            verify_axis(obj);
            plot(obj.ah, obj.x, obj.y);
            set_plot_labels(obj);
            set_plot_grid(obj);
            set_plot_legend(obj);
        end
        
        
        % If the ah property of the object is not set to a valid axis handle,
        % this function creates a new figure with a new axis.
        function verify_axis(obj)
            if isempty(obj.ah) || ~ishandle(obj.ah)
                fh = figure();
                ah = axes();
                obj.ah = ah;
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
            
            % Make sure the provided axis handle is avlid.
            if ~ishandle(obj.ah)
                error('AH is not a valid axis handle.');
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
        
        
    end
    
end

