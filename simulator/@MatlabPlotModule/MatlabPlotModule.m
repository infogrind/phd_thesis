classdef MatlabPlotModule < OutputModule
    %MATLABPLOTMODULE Plot module using standard MATLAB plot function
    %   This output module creates a plot on a MATLAB figure.
    
    properties (Access = 'public')
        ah = []    % Handle to the axis on which to create the plot.
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
            if isempty(obj.ah)
                fh = figure();
                ah = axes();
                obj.ah = ah;
            end
        end
        
        
        function set_plot_labels(obj)
            if ~isempty(obj.xlabel)
                xlabel(obj.ah, obj.xlabel);
            end
            if ~isempty(obj.ylabel)
                ylabel(obj.ah, obj.ylabel);
            end
            if ~isempty(obj.plottitle)
                title(obj.ah, obj.plottitle);
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
                legend(obj.ah, obj.legend);
            end
        end
        
        
        % In addition to the base class's checks, this function checks that ah
        % is a valid axis handle.
        function check_parameters(obj)
            check_parameters@OutputModule(obj);
            
            if ~ishandle(obj.ah)
                error('AH is not a valid axis handle.');
            end
        end % check_parameters
        
        
    end
    
end

