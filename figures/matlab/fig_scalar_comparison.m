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
s = {'ShannonScheme', 'ScalarHybridScheme', 'LambertScalarHybridScheme'};
p = {4, [4 4; 0.3 0.5], [4; 0.2]};

% Run the scheme processor.
pp.process(s, p);

% Get the MSE and plot the SDR on a new output module.
om = PGFPlotsOutputModule();
om.fn = 'fig_scalar_comparison.tex_t';
om.force = true;
om.set_color_mode('black white');
om.x = 10*log10(pp.snr);
om.y = 10*log10(pp.sv ./ pp.mse);

om.legend = {'theoretical optimum', '$\epsilon = 0.3$', ...
    '$\epsilon = 0.5$', '$\epsilon = \epsilon(\textsc{SNR})$'};

% Set labels and grid.
om.xlabel     = 'SNR [dB]';
om.ylabel     = 'SDR [dB]';
om.plottitle  = 'SDR vs. SNR';
om.grid       = true;
om.legendpos  = 'NorthWest';

% Create the plot.
om.do_plot();