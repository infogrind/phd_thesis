function test_jumps()

fprintf('Random = %.2f\n', randn(1,1));
fprintf('Random = %.2f\n', randn(1,1));

snr = 10^5.7;
N = 20;
nv = 1 / snr; % Theoretical noise variance.

hp = Hybrid3DProcessor();
hp.verbose = false;
hp.snr = snr * ones(1, N);
hp.N = 1e5;

s = {'AltLambertScalarHybridScheme'};
p = {[3; 3]};

hp.process(s, p);

figure;
ah1 = subplot(2,1,1);
ah2 = subplot(2,1,2);

figure;
ah3 = subplot(3,1,1);
ah4 = subplot(3,1,2);
ah5 = subplot(3,1,3);

om1 = MatlabPlotModule();
om2 = MatlabPlotModule();
om3 = MatlabPlotModule();
om4 = MatlabPlotModule();
om5 = MatlabPlotModule();

om1.ah = ah1;
om2.ah = ah2;
om3.ah = ah3;
om4.ah = ah4;
om5.ah = ah5;

om1.grid = true;
om2.grid = true;
om3.grid = true;
om4.grid = true;
om5.grid = true;

om1.x = 1:N;
om2.x = om1.x;
om3.x = om1.x;
om4.x = om1.x;
om5.x = om1.x;

om1.xlabel = 'tries';
om2.xlabel = om1.xlabel;
om3.xlabel = om1.xlabel;
om4.xlabel = om1.xlabel;
om5.xlabel = om1.xlabel;

% Compute empirical SNR.
snremp = hp.Pemp ./ hp.nvemp;

tosort = [hp.mse; hp.q1e; hp.q2e; hp.ee];
[snremp_sorted, sorted] = sort_stuff(snremp, tosort);

mse_sorted = sorted(1,:);
q1e_sorted = sorted(2,:);
q2e_sorted = sorted(3,:);
ee_sorted = sorted(4,:);

om1.plottitle = 'MSE vs empirical SNR';
om1.y = 10*log10(mse_sorted);
om1.ylabel = 'MSE [dB]';

om2.y = 10*log10([snremp_sorted; hp.snr]);
om2.ylabel = 'Empirical input power [dB]';
om2.legend = {'empirical SNR', 'theoretical SNR'};

%om2.legend = {'Empirical \sigma_Z^2', 'Theoretical \sigma_Z^2'};

om1.set_color_mode('bw');
om2.set_color_mode('bw');
om3.set_color_mode('bw');
om4.set_color_mode('bw');
om5.set_color_mode('bw');

om1.do_plot();
om2.do_plot();

% Plot hybrid processor results.
om3.plottitle = 'Hybrid errors';
om3.y = q1e_sorted;
om3.ylabel = 'Error in Q_1';
om4.y = q2e_sorted;
om4.ylabel = 'Error in Q_2';
om5.y = ee_sorted;
om5.ylabel = 'Error in E';

om3.do_plot();
om4.do_plot();
om5.do_plot();

% And another figure with the MSE and E_Q1 on the same plot.
figure;
plotyy(om1.x, om1.y, om3.x, om3.y);
xlabel('tries');
ylabel('error');
title('MSE compared with E_{Q_1}');
grid('on');

end



function [snr_s, sorted] = sort_stuff(snr, tosort)

m = [snr', tosort'];
ms = sortrows(m,1)';

snr_s = ms(1,:);
sorted = ms(2:end,:);

end