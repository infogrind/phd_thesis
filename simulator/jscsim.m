function jscsim()
% JSCSIM   GUI for the Joint Source-Channel Coding simulator, JSCsim.
%    JSCSIM() starts the GUI.

% $Id$

% Parameters
x = 200;           % Initial figure position, x and y coordinate
y = 300;           % (from the bottom left corner).
w = 800;           % Figure width and height. 
h = 500;

verbose = true;

% Scheme array.
schemes = {};
parameters = {};

% Create a performance processor.
pp = PerformanceProcessor();
pp.snr = 10.^(0:.5:10);

% Create a figure. Initially the figure is invisible.
fh = figure('Name', 'JSCsim', 'NumberTitle', 'off', 'Resize', 'off', ...
    'Position', [x y w h], 'MenuBar', 'none', 'Toolbar', 'none', ...
    'Visible', 'off');

% Create axes and point the output module to them.
ah = axes('Parent', fh, 'Position', [0.5, 0.15, .45, 0.7]);
pp.output_module.ah = ah;

% Create the list box. Initially it is empty.
lx = 30;
ly = 250;
lw = 250;
lh = 200;
lbh = uicontrol(fh, 'Style', 'listbox', 'Position', [lx ly lw lh], ...
    'String', schemes, ...
    'Callback', @listbox_callback);

% Initially, nothing is selected.
lval = [];

% Initially the value of the list box is empty, since there are no entries.
set(lbh, 'Value', lval);

% Add a label above the list box.
uicontrol(fh, 'Style', 'text', 'String', 'Schemes', 'Position', [lx ly+lh lw 20]);

% This is the height of the edit box for scheme names, which determines also the
% width, height, and position of the plus and minus buttons.
eh = 25;

% Add plus / minus buttons.
minusbh = uicontrol(fh, 'Style', 'pushbutton', 'String', '-', ...
    'Position', [lx, ly - eh, eh, eh], ...
    'Callback', @minus_callback, ...
    'Enable', 'off');
plusbh = uicontrol(fh, 'Style', 'pushbutton', 'String', '+', ...
    'Position', [lx + lw - eh, ly - eh, eh, eh], ...
    'Callback', @plus_callback);

% Add an edit field to enter a scheme name. Pressing return in the edit field
% has the same effect as clicking the plus button, so the edit field has the
% same callback function as the plus button.
sedith = uicontrol(fh, 'Style', 'edit', 'String', '', ...
    'Position', [lx + eh, ly - eh, lw - 2*eh, eh], ...
    'Callback', @plus_callback);
% This flag indicated whether the scheme name has already been changed once.
seditchg = false;

% An edit field to enter/manipulate parameters, and a corresponding text label.
% It has the same callback function as the set button, since pressing return
% should have the same effect as clicking set.
setw = 30;  % With and height of the 'set' button.
seth = 25;
pedith = uicontrol(fh, 'Style', 'edit', 'String', '', ...
    'Position', [lx, ly - 4*eh, lw - setw, seth], ...
    'Callback', @set_callback);
uicontrol(fh, 'Style', 'text', 'String', 'Parameters', ...
    'Position', [lx, ly - 3*eh, lw, 20]);

% A button to set the parameter of a scheme.
setbh = uicontrol(fh, 'Style', 'pushbutton', 'String', 'Set', ...
    'Position', [lx + lw - setw, ly - 4*eh, setw, seth], ...
    'Callback', @set_callback, ...
    'Enable', 'off');

% A big button to start the simulation.
simbh = uicontrol(fh, 'Style', 'pushbutton', 'String', 'GO!', ...
    'Callback', @sim_callback, ...
    'Position', [lx, ly - 8*eh, lw, 3*eh], ...
    'FontSize', 18, ...
    'FontWeight', 'bold', ...
    'ForegroundColor', [1 0 0]);

% Update all controls and show the figure.
update_controls();
set(fh, 'Visible', 'on');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Callback function for the plus button.
    function plus_callback(hObject, eventdata) %#ok<*INUSD>
        verbmsg('plus_callback\n');
        add_scheme(get(sedith, 'String'));
        set(sedith, 'String', '');
    end

    % Callback function for the plus button.
    function minus_callback(hObject, eventdata)
        if ~isempty(get(lbh, 'String'))
            verbmsg('The selected scheme has position ''%d''.\n', ...
                get(lbh, 'Value'));
            remove_scheme(get(lbh, 'Value'));
        else
            verbmsg('No schemes to remove.\n');
        end
    end


    % Callback function for the list box.
    function listbox_callback(hObject, eventdata)
        verbmsg('listbox_callback()\n');
        
        % Update all controls.
        update_controls();
        
    end


    function set_callback(hObject, eventdata)
        try
            e = eval(get(pedith, 'String'));
            set_parameter(e);
        catch me
            errordlg('You must enter a matrix in proper MATLAB syntax.');
        end
    end


    function sim_callback(hObject, eventdata)
        % During the simulation, the callback button is disabled.
        set(simbh, 'Enable', 'off');
        set(simbh, 'String', 'running...');
        drawnow;    % Force window update.
        verbmsg('Starting simulation...\n');
        try
            pp.process(schemes, parameters);
        catch e
            % Before rethrowing, we need to re-enable the button.
            verbmsg('Simulation aborted with an error.\n');
            reset_sim_button();
            rethrow(e);
        end
        
        verbmsg('Simulation ended successfully.\n');
        reset_sim_button();
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % This function updates all controls based on the current dialog state.
    function update_controls()
        update_go();
        update_listbox();
        update_pedit();
        update_set();
        update_minus_status();
    end
    
    % This function updates the parameter edit box based on the listbox
    % selection.
    function update_pedit()
        v = get(lbh, 'Value');
        if ~isempty(v) && v > 0
            set(pedith, 'String', mat2str(parameters{v}));
        else
            set(pedith, 'String', '');
        end
    end

    function update_go()
        if ~isempty(schemes)
            set(simbh, 'Enable', 'on');
        else
            set(simbh, 'Enable', 'off');
        end
    end

    % Function to update list box from schemes array.
    function update_listbox()
        verbmsg('Updating listbox.\n');
        % Get current properties.
        s = get(lbh, 'String');
        v = get(lbh, 'Value');
        
        % Update schemes.
        set(lbh, 'String', schemes);
        
        % If the listbox is now empty, set the value to the empty matrix. If the
        % If the listbox has more entries than before, select the newest entry. 
        % If the listbox has less entries than before and the selected entry was
        % the last in the list, select the "new" last entry.
        % If the listbox has less entries than before but the entry selected
        % previously was not the last one, don't change the value unless it was
        % empty. 
        % If the number of entries has not changed and is not empty but the
        % previous value was empty, set the value to the first entry. 
        if isempty(schemes)
            set(lbh, 'Value', []);
        elseif length(schemes) > length(s)
            set(lbh, 'Value', length(schemes));
        elseif length(schemes) < length(s) && v == length(s)
            set(lbh, 'Value', length(schemes));
        else
            % Here either the number of entries is positive and the same as
            % before, or less than before but the previously selected entry was
            % not the last one. In any case, we only do something if by some
            % reason the selection is empty.
            if isempty(v)
                verbmsg('Fixing listbox selection to prevent warning.\n');
                set(lbh, 'Value', 1);
            end
        end
    end


    % This function sets the enabled property of the set button depending on
    % whether an entry of the listbox is selected.
    function update_set()
        v = get(lbh, 'Value');
        if ~isempty(v)
            set(setbh, 'Enable', 'on');
        else
            set(setbh, 'Enable', 'off');
        end
    end


    % This function sets the minus button to enabled if there are entries in the
    % list box, and to disabled otherwise.
    function update_minus_status()
        s = get(lbh, 'String');
        if isempty(s)
            set(minusbh, 'Enable', 'off');
        else
            set(minusbh, 'Enable', 'on');
        end
    end


    function reset_sim_button()
        set(simbh, 'Enable', 'on');
        set(simbh, 'String', 'GO!');
    end

    function verbmsg(varargin)
        if (verbose)
            fprintf(varargin{:});
        end
    end


    % Add string s to the scheme list box unless it is already in the list.
    function add_scheme(s)
        verbmsg('Adding scheme ''%s''.\n', s);
        if ~isempty(s) && ~is_in_cell(schemes, s)
            schemes{length(schemes) + 1} = s;
            parameters{length(parameters) + 1} = [];
            update_controls();
        end
    end

    % Remove string at position n from the schemes list.
    function remove_scheme(n)
        schemes = remove_cell_entry(schemes, n);
        parameters = remove_cell_entry(parameters, n);
        update_controls();
    end

    % This function takes a row cell and an integer and returns a cell with
    % the entry at position n removed.
    function d = remove_cell_entry(c, n)
        assert(length(c) >= n);
        d = {c{1:n-1}, c{n+1:end}};
    end

    % Checks whether the cell array c contains the string s.
    function b = is_in_cell(c, s)
        % Works only with row cells.
        assert(isempty(c) || size(c, 1) == 1);
        for k = 1:length(c)
            if strcmp(c{k}, s)
                verbmsg('Found string in cell at pos %d.\n', k);
                b = true;
                return;
            end
        end
        
        b = false;
    end

    % Sets the parameter of the currently selected listbox entry to e.
    function set_parameter(e)
        v = get(lbh, 'Value');
        if isempty(v)
            errordlg('No scheme selected.', 'Invalid input', 'modal');
            return;
        end
        
        assert(length(parameters) >= v);
        parameters{v} = e;
        update_pedit();
    end
end