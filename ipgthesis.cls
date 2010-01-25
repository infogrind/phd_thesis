\ProvidesClass{ipgthesis}[2008/02/26 v0.4 IPG thesis class]
\NeedsTeXFormat{LaTeX2e}

% $Id: ipgthesis.cls 385 2008-03-10 23:57:13Z berlin $

\RequirePackage{textfit}
%\RequirePackage[french,german,italian,english]{babel}
\RequirePackage[english]{babel}

\newif\if@epfl\@epflfalse
\newif\if@review\@reviewfalse
\newif\ifbooklet\bookletfalse
% note that \ifbooklet is available to the latex document, so, e.g.,
% figures could be scaled appropriately.
\DeclareOption{epfl}{\@epfltrue\@reviewfalse\bookletfalse
	\PassOptionsToClass{12pt}{memoir}}
\DeclareOption{review}{\@reviewtrue\@epflfalse\bookletfalse
	\PassOptionsToClass{12pt}{memoir}}
\DeclareOption{booklet}{\booklettrue\@epflfalse\@reviewfalse}
% ignore size options.
\DeclareOption{9pt}{}\DeclareOption{10pt}{}
\DeclareOption{11pt}{}\DeclareOption{12pt}{}
\DeclareOption{13pt}{}\DeclareOption{14pt}{}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\PassOptionsToClass{twoside}{memoir}
\ExecuteOptions{booklet}
\ProcessOptions
\if@epfl\else\if@review\else\ifbooklet\else%
\ClassError{ipgthesis}{no booklet, epfl, or review option.}%
	{Use this package with \documentclass[opt]{ipgclass} with\MessageBreak
	opt being one of epfl, booklet or review.}
\fi\fi\fi
\LoadClass{memoir}
\setstocksize{297mm}{210mm} % printing on a4 paper
\ifbooklet %
	\settrimmedsize{247mm}{170mm}{*}
	\settrims{50mm}{40mm}
	\settypeblocksize{194mm}{120mm}{*}
	\setulmargins{28mm}{*}{*}
	\setlrmargins{17mm}{*}{*}
	\setheadfoot{12pt}{25pt}
	\setheaderspaces{*}{5mm}{*}
	\checkandfixthelayout
\else%
	\settrimmedsize{297mm}{210mm}{*} % no trimming
	\settrims{0mm}{0mm}
	% the typeblock in the booklet and non-booklet versions
	% should be coordinated so that the pages contain more or less
	% the same amount of text.  Note that Computer Modern Roman
	% fonts are optically scaled, 12pt fonts are not magnified 10pt
	% fonts.
	\settypeblocksize{227mm}{140mm}{*}
	\setulmargins{28mm}{*}{*}
	\if@epfl%
		\setlrmargins{25mm}{*}{*}
	\else%
		% for the review version make outside margin very large.
		\setlrmargins{15mm}{*}{*}
	\fi
	\setheadfoot{15pt}{30pt}
	\setheaderspaces{*}{6mm}{*}
	\checkandfixthelayout
\fi


% Chapter style
% Dropped chapter number with lines above and below
%
% *****************************************
%
%          TO BE CHECKED
%
%		Font size for the drop numeral should be scaled
%		differently - doesnt quite look the same for the
%		booklet form.
%
% *****************************************


\newif\if@chapprintnum\@chapprintnumfalse
\makechapterstyle{dropnumeral}{%
\renewcommand{\chapterheadstart}{\vspace*{\beforechapskip}%
}
\renewcommand{\afterchaptertitle}{\par\nobreak\rule{\textwidth}{1.2pt}\par\nobreak\vskip \afterchapskip}

 % This seems a bit of a hack - is there a better way to do it?
 \renewcommand{\printchaptername}{}
 \renewcommand{\chapternamenum}{}
 \renewcommand{\printchapternum}{\@chapprintnumtrue}
 \renewcommand{\printchapternonum}{\@chapprintnumfalse}
 \renewcommand{\chaptitlefont}{\normalfont\huge\sffamily\bfseries}  
 \renewcommand{\chapnumfont}{\normalfont\huge\sffamily\bfseries} 
 \renewcommand{\printchaptertitle}[1]{%
   %\interlinepenalty\@M
   \if@chapprintnum
	\vspace{-\baselineskip}
  	\noindent\rule{\textwidth}{1.2pt}\vskip 1.2\baselineskip

	 \chaptitlefont
     \parbox[b][2.6\baselineskip]{.75\textwidth}
     {\raggedright##1}
	 % Q - What to set these sizes to?
     \hfill \chapnumfont\scaletoheight{2.55\baselineskip}{\thechapter}
     \par
   \else
     \chaptitlefont ##1
   \fi
	 }
}

% Make this chapter style the default
\chapterstyle{dropnumeral}

% Page style
% Based on the built in LaTeX Compnaion style
\copypagestyle{ipg-companion}{companion}
\makeevenhead{ipg-companion}{\normalsize\sffamily\bfseries\thepage}{}{\normalsize\sffamily\bfseries\leftmark}
\makeoddhead{ipg-companion}{\normalsize\sffamily\bfseries\rightmark}{}%
                       {\normalsize\sffamily\bfseries\thepage}
% For some reason this doesnt seem to copy correctly
\makeheadposition{ipg-companion}{flushright}{flushleft}{}{}
\makerunningwidth{ipg-companion}{\textwidth}
\makeheadrule{ipg-companion}{\textwidth}{\normalrulethickness}


% Change the default style to this
\pagestyle{ipg-companion}

% Abstract Style
\renewcommand{\abstractnamefont}{\chaptitlefont}
\renewcommand{\abstracttextfont}{\normalfont}

% Division Numbering
% Numbering subsections and above
\maxsecnumdepth{subsection} 

% Division styles
% Set in bold san serif font
\setsecheadstyle{\Large\sffamily\bfseries\raggedright}
\setsubsecheadstyle{\large\sffamily\bfseries\raggedright}
\setsubsubsecheadstyle{\normalsize\sffamily\bfseries\raggedright}


% Captions
\captionnamefont{\normalsize\sffamily\bfseries}
\captiontitlefont{\normalsize\sffamily}
\subcaptionlabelfont{\sffamily}
\subcaptionfont{\sffamily}

% Abstract environments
\abstractnum
\setlength{\absleftindent}{0pt}
\setlength{\absrightindent}{0pt}

\newenvironment{abstract-en}{%
\renewcommand{\abstractname}{Abstract}
\begin{abstract}
}{%
\end{abstract}
}



\newenvironment{abstract-fr}{%
\begin{otherlanguage}{french}
%\renewcommand{\abstractname}{V\'ersion Abr\'eg\'ee}
\begin{abstract}
}{%
\end{abstract}
\end{otherlanguage}
}

% Keywords
\newcommand{\keywordname}{Keywords}
\newenvironment{keywords}{%
\iflanguage{french}{\renewcommand{\keywordname}{Mots-cl\'es}}{}
\iflanguage{german}{}{}
\iflanguage{italian}{}{}
\iflanguage{english}{\renewcommand{\keywordname}{Keywords}}{}
\par\vspace{\baselineskip}
\noindent\textbf{\keywordname:}
}{%
}


% Titling
\setlength{\droptitle}{1.5cm}
\pretitle{\begin{center}\LARGE\bfseries}
\posttitle{\par\end{center}\vskip 3.5em} 
\renewcommand{\predate}{\vskip 10cm}
\renewcommand{\maketitlehookc}{% 
\vskip 10cm
\begin{center}
Submitted for the degree of Docteur \`Es Sciences \\\'Ecole Polytechnique F\'ed\'erale de Lausanne
\end{center}
}

