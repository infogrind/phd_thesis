# Thesis – LaTeX Source Code

## Requirements

* [TeXLive](https://www.tug.org/texlive/) or a derived distribution (e.g.
  [MacTeX](https://www.tug.org/mactex/)), or any other TeX distribution that
  contains the `latexmk` wrapper and the necessary tools `pdflatex` and
  `bibtex`.
* A recent enough version of [TikZ and PGF](http://www.texample.net/tikz/).
  Anything from 2010 or newer should be fine.
* `gnuplot` (used by certain function plots using TikZ)
* MATLAB to automatically create plots from simulations. This is optional; see
  “How to Build” below.
* GNU `make`


## How to Build

This section describes how to build the thesis as PDF from the source code.

If you have MATLAB (the `matlab` command line program must be available on your
path):

```sh
make
```

If you do not have MATLAB:

```sh
make USEMATLAB=0
```

The latter command uses pre-generated image files in `figures/matlab/matlab_gen`
rather than building them from the MATLAB source files.

The usual targets are supported (each also with the `USEMATLAB=0` option):

```sh
make clean    # Cleans all generated stuff
make force    # Abbreviation for 'make clean all'
```


## Alternate Versions

There are versions with different formatting. Each of these are available in
a separate branch:

* `ebook`: Smaller physical page size, suitable for e-readers, e.g. iPad
* `ipg_booklet`: Physical size A4, with crop marks to print in the booklet form
  used at EPFL's *Information Processing Group*
* `epfl_version`: A4 version used for the official EPFL print.
