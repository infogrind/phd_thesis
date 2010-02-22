function test_output_modules()
% This file runs some test for all defined output modules.

% Define here the output modules.
mods = {
    'MatlabPlotModule',
    'MatlabFilePlotModule',
    'PGFPlotsOutputModule'
    };

% Put here the file name for those modules that require one.
filenames = {
    '',
    'hund.pdf',
    'hund.tex_t'
    };

% Define here the data.
x = -2:.1:2;
y = [x.^2; x.^3/3; x.^4/8];

xl = '$x$';
yl = '$f(x)$';
pt = 'Hello';
g = true;       % Grid

% The legend entries and the legend position.
lg = {'squared', 'cubed', 'fourthigy'};
lpos = 'NorthEastOutside';

for k = 1:length(mods)
    fh = str2func(mods{k});
    m = fh();
    
    m.x = x;
    m.y = y;
    m.xlabel = xl;
    m.ylabel = yl;
    m.plottitle = pt;
    m.grid = g;
    
    m.legend = lg;
    m.legendpos = lpos;
    
    if ~isempty(filenames{k})
        m.fn = filenames{k};
        m.force = true;     % overwrite files
    end
    
    % And create the plot.
    m.do_plot();
end