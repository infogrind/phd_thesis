function plot_marginals(snr)
% PLOT_MARGINALS   Plot the marginal distributions of channel outputs.
%    PLOT_MARGINALS(SNR) plots the marginal distributions of Y1 and Y2 for the
%    given SNR and compares it to the Gaussian distribution of the same
%    variance.

% $Id$

% The support set of the y's.
P = 1;
sq = P / snr;
ysupp = 3 * sqrt(P + sq) * [-1:0.01:1];

% Plot everything
fh = figure;
ah1 = subplot(2,1,1);
ah2 = subplot(2,1,2);

sb = StandardBeta();

[py1 py2 pyt] = compute_marginals(sb, ysupp, snr);

plot(ah1, ysupp, [py1; pyt]);
legend(ah1, {'P(Y_1)', 'Pt(Y_1)'}, 'Location', 'NorthWest');
grid(ah1, 'on');
xlabel('Y_1');
title(ah1, sprintf('Marginals of Y for SNR = %.2f dB', 10*log10(snr)));

plot(ah2, ysupp, [py2; pyt]);
legend(ah2, {'P(Y_2)', 'Pt(Y_2)'}, 'Location', 'NorthWest');
grid(ah2, 'on');
xlabel('Y_2');


