function divv = divcalc(c)
% DIVCALC   Compute divergence between actual and Gaussian output distribution
%    Syntax: DIVCALC(C)
%    Arguments:
%            C - cell array of class names. All classes must implement
%                the function 'compute_divergence(snrrange)'.

% $Id$

% Define the SNR range. Here we go from 0 to 60 dB.
snrrange = 10.^(1:.25:6);

% Allocate space to store the results.
divv = zeros(length(c), length(snrrange));

% Compute the divergence for all classes.
for k = 1:length(c)
    divv(k, :) = run_class(c{k}, snrrange);
end

% Plot everything
fh = figure;
ah = gca();

plot(ah, 10*log10(snrrange), 2.^divv, '-x');
grid on;
xlabel('SNR [dB]');
ylabel('2^{D(SNR)}');
legend(c, 'Location', 'NorthWest');

end



% Helper function to create class constructor handle from string and run the
% compute_divergence function.
function dv = run_class(c, snrrange)

fh = str2func(c);
s = fh();
dv = compute_divergence(s, snrrange);

end