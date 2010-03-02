function test_schemes()

allschemes = {'ShannonScheme', 'UncodedScheme', 'LinearScheme', ...
    'ScalarHybridScheme', 'OptScalarHybridScheme'};
allparams = {[1 2 3], [], [1 2 3], [3 4; 0.7 0.6], [3 4]};

pp = PerformanceProcessor();
pp.verbose = true;
om1 = MatlabPlotModule();
om2 = MatlabPlotModule();
om3 = MatlabPlotModule();

pp.output_module = om1;
pp.process(allschemes, allparams);

pp.output_module = om2;
pp.process({'ShannonScheme', 'UncodedScheme'}, {[1 2 3 4], []});

pp.output_module = om3;
pp.process({'LinearScheme'}, {[5]});


end