% -*- mode: LaTeX -*-

\documentclass[12pt]{article}

\usepackage{fullpage}
\usepackage{enumitem}
\usepackage{multicol}

\setlist{itemsep=1in}

\begin{document}

\pagestyle{empty}

\LARGE

\begin{center}
\bf \huge
Emma's Math Sheets\\
\end{center}

\vspace{1in}

\begin{multicols}{2}
\begin{enumerate}[label=\arabic*)]
$for(problems)$\item \hspace{1ex} $$ $problems$ = $$
$endfor$
\end{enumerate}
\end{multicols}

\end{document}
