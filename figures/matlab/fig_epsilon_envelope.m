% This file creates a figure comparing the scalar hybrid scheme for two fixed
% epsilon values and for the optimal epsilon = epsilon(snr).
addpath('../../simulator');

% Create performance processor and set output to PGFplots in black & white.
pp = PerformanceProcessor();
pp.output_module = [];
pp.verbose = true;

% Range: 0 to 100dB
pp.snr = 10.^(0:.5:10);

% Define schemes and parameters.
s = {'ShannonScheme', 'SmoothScalarHybridScheme'};
e = [0.95:-0.05:0.2];  % Range of epsilon values
p = {3, [3*ones(size(e)); e]};

% Run the scheme processor.
pp.process(s, p);

% Get the MSE and plot the SDR on a new output module.
om = PGFPlotsOutputModule();
om.fn = 'fig_epsilon_envelope.tex_t';
om.force = true;

%om = MatlabPlotModule();

om.set_color_mode('empty');
om.x = 10*log10(pp.snr);
om.y = 10*log10(pp.sv ./ pp.mse);

om.legend = {'$(1 + \textsc{snr})^n$'};

% Set labels and grid.
om.xlabel     = 'SNR [dB]';
om.ylabel     = 'SDR [dB]';
om.plottitle  = 'SDR vs. SNR';
om.grid       = true;
om.legendpos  = 'NorthWest';

% Set line style of first data series to dashed. 
om.set_plot_options(1, 'dashed');

% Create the plot.
om.do_plot();
