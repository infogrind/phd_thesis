% This file creates a figure comparing the scalar hybrid scheme for two fixed
% epsilon values and for the optimal epsilon = epsilon(snr).
addpath('../../simulator');

% Create performance processor and set output to PGFplots in black & white.
pp = PerformanceProcessor();
pp.output_module = PGFPlotsOutputModule();
pp.output_module.set_color_mode('black white');
pp.output_module.fn = 'fig_scalar_comparison.tex_t';
pp.output_module.force = true;
pp.verbose = true;

% Range: 0 to 100dB
pp.snr = 10.^(0:.5:10);

% Define schemes and parameters.
s = {'ShannonScheme', 'ScalarHybridScheme', 'OptScalarHybridScheme'};
p = {4, [4 4; 0.3 0.5], 4};

% Set custom legend.
pp.set_legend({'theoretical optimum', '$\epsilon = 0.3$', ...
    '$\epsilon = 0.5$', '$\epsilon = \epsilon(\textsc{SNR})$'});

pp.process(s, p);
