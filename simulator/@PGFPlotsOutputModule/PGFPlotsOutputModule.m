classdef PGFPlotsOutputModule < OutputModule
    %PGFPLOTSOUTPUTMODULE Output module using the PGFPlots package for LaTeX
    %   PGFPlotsOutputModule creates files containing LaTeX code for the
    %   PGFPlots package.
    
    properties (Access = 'public')
        fn = '';        % Name of file to save plot in.
        force = false;  % Set to true if it's OK to overwrite files.
    end
    
    properties (Access = 'protected')
        colormode = 'color';
        
        % This cell array can be filled using set_plot_options. If its nth entry
        % is nonempty, then its contents will be added as options to the
        % "\addplot" command for the respective data series.
        plot_options = {};
    end

    
    methods (Access = 'public')
        function set_color_mode(obj, c)
            switch c
                case 'color'
                    obj.colormode = 'color';
                case 'bw'
                    obj.colormode = 'bw';
                case 'empty'
                    obj.colormode = 'empty';
                case 'black white'
                    obj.colormode = 'black white';
                otherwise
                    error('%s is not a valid color mode.', c);
            end
        end
        
        
        % This function lets you set the plot options for a particular data
        % series.
        function set_plot_options(obj, n, opt)
            obj.plot_options{n} = opt;
        end

    end
    
    methods (Access = 'protected')
        function do_actual_plot(obj)
            fid = fopen(obj.fn, 'w');
            if (fid == -1)
                error('Could not open file %s for writing.', obj.fn);
            end
            
            % Write header, footer, and plots.
            write_file_header(obj, fid);
            write_plots(obj, fid);
            write_file_footer(obj, fid);
            
            fclose(fid);
        end
        
        
        function write_file_header(obj, fid)
            fprintf(fid, '%% vim:ft=tex\n');
            fprintf(fid, '%% THIS FILE WAS AUTOMATICALLY GENERATED.\n');
            write_extra_headers(obj, fid);
            fprintf(fid, '\\begin{tikzpicture}\n');
            

            % Write axis command with options.
            fprintf(fid, '\\begin{axis}[%s]\n', ...
                optstring(obj, axisopts(obj)));
            
        end
        
        % This function does nothing by default, but can be overridden by
        % derived classes to add extra style options.
        function write_extra_headers(obj, fid)
            % Nothing here.
        end
        
        
        function s = optstring(obj, opts)
            if isempty(opts)
                s = '';
            else
                s = opts{1};
                for k = 2:length(opts)
                    s = strcat(s, ',', opts{k});
                end
            end
        end
        
        
        function o = axisopts(obj)
            
            % Create option string based on grid setting.
            if obj.grid
                gridstr = 'major';
            else
                gridstr = 'none';
            end
            
            % Create the cycle list string.
            clstr = cycle_list_string(obj);
            
            % Create the list of axis options.
            o = {
                sprintf('%s', clstr),
                'width=.95\textwidth',
                sprintf('xlabel={%s}', obj.xlabel),
                sprintf('ylabel={%s}', obj.ylabel),
                sprintf('grid=%s', gridstr)
                };
            
            % If the legend position is set, add a corresponding option.
            s = legendpos2str(obj);
            if ~isempty(s)
                o{length(o) + 1} = sprintf('legend pos=%s', s);
            end

            % Make legend entries left aligned rather than centered.
            o{length(o) + 1} = 'legend style={cells={anchor=west}}';
        end
        
        
        function s = cycle_list_string(obj)
            switch obj.colormode
                case 'color'
                    s = 'cycle list name=color list';
                case 'bw'
                    s = ['cycle list={{mark=o},{mark=x},{mark=+},', ...
                        '{mark=asterisk},mark={star},{mark=square},', ...
                        '{mark=diamond},{mark=triangle},mark={pentagon},', ...
                        '{mark=oplus},{mark=otimes}}'];
                case 'empty'
                    s = 'cycle list={{black,mark=none}}';
                case 'black white'
                    s = 'cycle list name=black white';
                otherwise
                    % We should never reach here, error checking should be done
                    % before.
                    assert(false);
            end
        end

        
        function s = legendpos2str(obj)
            switch (obj.legendpos)
                case ''
                    s = '';
                case 'NorthEast'
                    s = 'north east';
                case 'NorthWest'
                    s = 'north west';
                case 'SouthEast'
                    s = 'south east';
                case 'SouthWest'
                    s = 'south west';
                case 'NorthEastOutside'
                    s = 'outer north east';
                otherwise
                    warning('MK:invalidlegendpos', ...
                        'Invalid legend position');
            end
        end

        
        function write_plots(obj, fid)
            % Write a separate plot command for each row of y.
            for k = 1:size(obj.y, 1)
                write_plot(obj, fid, obj.x, obj.y(k,:), k)
                
                % Add a legend entry if one exists.
                if length(obj.legend) >= k
                    fprintf(fid, '\\addlegendentry{%s}\n', obj.legend{k});
                end
            end
        end
        
        function write_plot(obj, fid, x, y, k)
            
            % Add the addplot PGFplots command, including options if any options
            % have been specified for the current data series.
            if length(obj.plot_options) >= k && ~isempty(obj.plot_options{k})
                fprintf(fid, '\\addplot[%s] coordinates{ \n', ...
                    obj.plot_options{k});
            else
                fprintf(fid, '\\addplot coordinates{ \n');
            end
            
            % Add the data points.
            for k = 1:length(x)
                fprintf(fid, '  (%.2f,%.2f)\n', x(k), y(k));
            end
            
            % Final right brace to close the \addplot command.
            fprintf(fid, '};\n\n');
        end
        
        
        function write_file_footer(obj, fid)
            fprintf(fid, '\\end{axis}\n');
            fprintf(fid, '\\end{tikzpicture}\n');
        end
        
        
        function check_parameters(obj)
            check_parameters@OutputModule(obj);
            
            if ~obj.force && exist(obj.fn, 'file')
                error('File %s already exists.', obj.fn);
            end
        end
    end

    
end

