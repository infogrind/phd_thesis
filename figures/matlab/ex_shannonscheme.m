% This example demonstrates how to use the performance processor to plot the
% performance of an existing communication scheme. 
addpath('../../simulator');

% Set basic parameters
snrrange = 10.^(0:.1:4);
sv = 1;
nv = 1;

% Create the performance processor
pp = PerformanceProcessor(); % MK:SHOW

% Create a PGF plot output module, set the file name, and attach it to the
% performance processor.
om = MatlabFilePlotModule();
om.fn = 'ex_shannonscheme.pdf';
om.force = true;
pp.om = om;

% Plot the performance for the Shannon scheme with three different parameters.
%%% MK:STARTSHOW
schemes = {'ShannonScheme'};
parameters = {[1 2 3 4]};
pp.plot_performance(schemes, parameters);
%%% MK:ENDSHOW
