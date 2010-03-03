# vim:ft=gnuplot
# This file creates a table of the plot of the capacity-cost function for a
# binary symmetric channel.

# Parameters
a = 0.23;    # rho(0)
b = 0.99;    # rho(1)   (these denote the input cost function)
eps = 0.1;   # The BSC crossover probability

# Define binary entropy function (in bits)
h(x) = -x*log(x)/log(2) - (1-x)*log(1-x)/log(2);

# Define optimal input probability (of zero symbol) for a given power
# constraint.
p0(P) = P < a ? 1/0 : P >= (a+b)/2 ? 0.5 : (b-P)/(b-a);

# Define the mutual information as a function of the power constraint, if the
# optimal input distribution is used.
MI(P) = h((1-eps)*p0(P) + eps*(1-p0(P))) - h(eps);

set yrange [0:1];

set table "bsccuc_curve.table"; set format "%.5f";
plot[a:1.3*(a+b)/2] MI(x);

set table "bsccuc_tangent.table";
plot[0:1.1*(a+b)/2] x;
