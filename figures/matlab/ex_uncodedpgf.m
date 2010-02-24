% Performance of uncoded versus optimal transmission.
addpath('../../simulator');

% Set basic parameters
snrrange = 10.^(0:.1:4);
sv = 1;
nv = 1;

% Setup schemes and parameters.
%%% MK:STARTSHOW
schemes = {'UncodedScheme', 'ShannonScheme'};
parameters = {[], [1 2]};
%%% MK:ENDSHOW

% Create a PGF plot output module, set the file name, and attach it to the
% performance processor.
pp = PerformanceProcessor(); % MK:SHOW
om = PGFPlotsOutputModule();
om.set_color_mode('bw');
om.fn = 'ex_uncodedpgf.tex_t';
om.force = true;
pp.om = om;

% Plot the performance for the Shannon scheme with three different parameters. 
pp.plot_performance(schemes, parameters); % MK:SHOW
