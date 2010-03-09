function test_lambert_constant()
% The purpose of this function is to compare OptScalarHybridScheme with
% AltLambertScalarHybridScheme and to find out the influence of the constant c1
% of the latter.

hp = Hybrid3DProcessor();
hp.snr = 10.^(0:.25:10);
hp.verbose = true;

s = {'AltLambertScalarHybridScheme'};
p = {[3 3 3 3; 2 4 6 8]};

hp.process(s, p);

nplots = 2;

persistent ah;
if isempty(ah) || ~ishandle(ah{1})
    figure;
    ah = cell(1,nplots);
    for k = 1:nplots
        ah{k} = subplot(nplots,1,k);
    end
end

oms = cell(1,nplots);
for k = 1:nplots
    oms{k} = MatlabPlotModule();
    oms{k}.ah = ah{k};
    oms{k}.x = 10*log10(hp.snr);
    oms{k}.xlabel = 'SNR [dB]';
    oms{k}.grid = true;
end

oms{1}.y = 10*log10(hp.q1e);
oms{1}.ylabel = 'Error in Q_1';

% oms{2}.y = hp.q2e;
% oms{2}.ylabel = 'Error in Q_2';

oms{2}.y = 10*log10(hp.ee);
oms{2}.ylabel = 'Error in E';

oms{1}.legend = {'c = 2', 'c = 4', 'c = 6', 'c = 8'};

for k = 1:nplots
    oms{k}.do_plot();
end