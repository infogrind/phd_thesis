function test_schemes()

allschemes = {'ShannonScheme', 'UncodedScheme', 'LinearScheme'};
allparams = {[1 2 3], [], [1 2 3]};

pp = PerformanceProcessor();
om1 = MatlabPlotModule();
om2 = MatlabPlotModule();
om3 = MatlabPlotModule();

pp.om = om1;
pp.process(allschemes, allparams);

pp.om = om2;
pp.process({'ShannonScheme', 'UncodedScheme'}, {[1 2 3 4], []});

pp.om = om3;
pp.process({'LinearScheme'}, {[5]});


end