classdef MatlabFilePlotModule < MatlabPlotModule
    %MATLABFILEPLOTMODULE Create MATLAB plot and save it to file.
    %   This module creates a MATLAB plot; it doesn't display it but saves it to
    %   a file. 
    
    properties (Access = 'public')
        fn = '';        % Name of file to save figure.
        type = '';      % File type
        pdfres = 600;   % Resolution for saving PDFs.
        
        force = false;  % By default, no files are overwritten, except if this 
                        % is set to true.
    end
    
    properties (Access = 'protected')
        fh = [];        % Figure handle
    end
    
    methods
        % When setting the file name, try to detect the type automatically.
        function set.fn(obj, fn)
            obj.fn = fn;
            autodetect_type(obj, fn);
        end
        
        % Type is always saved lower case.
        function set.type(obj, type)
            obj.type = lower(type);
        end
        
        % PDF resolution must be a positive integer.
        function set.pdfres(obj, res)
            if floor(res) ~= res || ~(res > 0)
                error('The PDF resolution must be a positive integer.');
            end
        end
    end
    
    
    methods (Access = 'public')
        function obj = MatlabFilePlotModule()
            obj@MatlabPlotModule();
            
            % Create a figure and set it to invisible; create axis handle.
            obj.fh = figure('visible', 'off');
            obj.ah = gca();
        end
        
        % The destructor closes the figure handle.
        function delete(obj)
            if ishandle(obj.fh)
                close(fh);
            end
        end
    end
    
    
    methods (Access = 'protected')
        
        function do_actual_plot(obj)
            % First we use the base class's method to create the plot as usual,
            % then we save it to a file. 
            do_actual_plot@MatlabPlotModule(obj);
            save_to_file(obj);
        end
        
        
        function save_to_file(obj)
            % For PDF files we use the function save2pdf by Gabe Hoffmann, for
            % everything else the MATLAB print() function with a '-d<type>'
            % argument.
            if strcmp(obj.type, 'pdf')
                save2pdf(obj.fn, obj.fh, obj.pdfres);
            else
                t = sprintf('-d%s', obj.type);
                print(t, obj.fn);
            end
        end
        
        function check_parameters(obj)
            check_parameters@MatlabPlotModule(obj);
            
            % Make sure file type and file name are set.
            if isempty(obj.fn)
                error('No file name set.');
            end
            if isempty(obj.type)
                error('No output file type set.');
            end
            
            % Unless the force parameter is set, the file must not exist.
            if ~obj.force && exist(obj.fn, 'file')
                error('The file %s already exists.', obj.fn);
            end
            
        end
        
        
        function autodetect_type(obj, fn)
            % Get file extension using regular expression. 
            p = regexp(fn, '\.[^.]+$', 'once');
            if isempty(p)
                return;
            end
            
            % Extract extension from position.
            ext = fn(p+1:end);
            
            % Set type if a known extension is found.
            switch lower(ext)
                case 'ps'
                    obj.type = 'ps';
                case 'eps'
                    obj.type = 'epsc2';
                case {'jpg', 'jpeg'}
                    obj.type = 'jpeg90';
                case 'png'
                    obj.type = 'png';
                case 'pdf'
                    obj.type = 'pdf';
            end
        end
    end
    
    
end

