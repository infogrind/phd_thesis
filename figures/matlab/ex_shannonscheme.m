% This example demonstrates how to use the performance processor to plot the
% performance of an existing communication scheme. 
addpath('../../simulator');

% Set basic parameters
snrrange = 10.^(0:.1:4);
sv = 1;
nv = 1;

% Setup schemes and parameters.
%%% MK:STARTSHOW
schemes = {'ShannonScheme'};
parameters = {[1 2 3]};
%%% MK:ENDSHOW

% Create a PGF plot output module, set the file name, and attach it to the
% performance processor.
pp = PerformanceProcessor(); % MK:SHOW
om = MatlabFilePlotModule();
om.fn = 'ex_shannonscheme.pdf';
om.force = true;
pp.om = om;

% Plot the performance for the Shannon scheme with three different parameters. 
pp.plot_performance(schemes, parameters); % MK:SHOW
