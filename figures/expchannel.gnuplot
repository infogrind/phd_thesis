# vim:ft=gnuplot
# Capacity plot for exponential channel example in fidelity chapter.

# Constants determining input distribution.
a = 1;
b = 1;

# Define binary logarithm and exponential constant.
log2(x) = log(x)/log(2);
e = exp(1);

# This is the minimum cost, for P < Pmin, C(P) is not defined.
Pmin = log2(1 + a/b) - a * log2(e)/(a+b);
# Define capacity curve.
C(P) = P <= Pmin ? 1/0 : \
  log2(1 + ( (a+b)/log2(e) * (P - log2(1 + a/b)) + a) / b);

# Do the plot, including the tangent and a horizontal line at I(X;Y).
set yrange [0:2];
set table "expchannel_curve.table"; set format "%.5f";
plot[1.01*Pmin:1.5] C(x);

# ... and as always the tangent.
set table "expchannel_tangent.table";
plot[0:1.5] x;
