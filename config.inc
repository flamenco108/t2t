% txt2tags sample config file [[[1
%% vim: set nospell fdm=marker foldmarker=[[[,]]] :
%
% This is a sample for the .txt2tagsrc user config file.
% Part of the txt2tags project (http://txt2tags.org).
%
% Copy this file to $HOME/.txt2tagsrc (or %homepath%/_t2trc
% on Windows) and edit it to fit your needs. All configs are
% COMMENTED, just remove the leading % for the ones you want
% to use.
%
% The config syntax is:
%
%            %!keyword  (target)  :  value
%
% Keywords:
%    target, options, encoding, style, preproc, postproc,
%    guicolors
% Targets:
%    The valid txt2tags targets (i.e.: html, man, tex)
%
% Details:
% - If the '(target)' part is omitted, the config is valid for
%   all targets
% - The %!keyword must be at the line start, no leading spaces
% - All the options defined here can be overwritten by command
%   line options and document config
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Set a default target if none specified
%   Useful if you always use the same target for all documents
%!target: html

% Set the default encoding for all documents
%   Examples: iso-8859-1, UTF-8
%   This can be turned off later with --no-encoding
%%!encoding: UTF-8
%!encoding: utf-8

%%%% CSS
% Always use CSS-friendly tags in HTML and XHTML
%   This uses H1, H2 and H3 for document top title and
%   defines the following DIV areas: header, toc, body
%   This can be turned off later with --no-css-sugar
%!options(html):	--css-sugar
%   Remote CSS always available (as this config)
%!style(html):		http://krzysztof.smirnow.eu/t2t/style.css
%!options(xhtml):	--css-sugar
%!style(xhtml):		http://krzysztof.smirnow.eu/t2t/style.css
%% css file must be included inside the resulting doc
%!options:			--css-inside


% Always mask e-mails from robots in HTML and MOIN documents
%   Example: john@company.com turns to <john (a) company com>
%   This can be turned off later with --no-mask-email
%%!options(html): --mask-email
%%!options(moin): --mask-email
%!options:		 --mask-email

% Always enumerate all title lines for text output
%   This can be turned off later with --no-enum-title
%!options(txt): --enum-title

% Always make TOC (Table of Contents) in LaTeX documents
%   This can be turned off later with --no-toc
%!options(tex): --toc

% Set the TOC depth for all targets
%   Valid values: 1, 2, 3, 4, 5
%   The default is 3
%!options: --toc-level 4

% Change the graphical interface colors (if use of GUI)
%   Valid values for colors: colorname, #RGB, #RRGGBB
%   The order is: bg1, fg1, bg2, fg2
%%!guicolors: blue white brown yellow

%%% LATEX
%!style(tex): polski


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FILTERS
%
% preproc and postproc filters are powerful tools to customize
% txt2tags behavior and perform nice tricks. But be careful,
% they do use Regular Expressions and can be dangerous if bad
% written. Really test them before including here.



% Shorthand for the javascript BACK call in HTML
%   Contribution from Prof. Sergio de Albuquerque Souza
%   Example: [Click here JAVABACK] to go back.
%%!postproc(html):   JAVABACK   javascript:history.back()



% LaTeX and TeX names appearing on their classical formats
%!postproc(tex):   LaTeX   \\LaTeX{}
%!postproc(tex):   \bTeX   \\TeX{}



%%% Vim [[[1
% Useful transformations for use with Vim
% ???



%% Transformation title tags [[[2
%% TO RETHINK LATER (DO PRZEMYŚLENIA PÓŹNIEJ)
%% Titles with anchor [[[3
%%!preproc			: "^{{{1\s*(.*)\s*(\[[^]]*\])"	"=\1=\2"
%%!preproc			: "^{{{2\s*(.*)\s*(\[[^]]*\])"	"==\1==\2"
%%!preproc			: "^{{{3\s*(.*)\s*(\[[^]]*\])"	"===\1===\2"
%%!preproc			: "^{{{4\s*(.*)\s*(\[[^]]*\])"	"====\1====\2"
%%!preproc			: "^{{{5\s*(.*)\s*(\[[^]]*\])"	"=====\1=====\2"
%% Titles normal [[[3
%%!preproc			: "^{{{1\s*(.*)"	"=\1="
%%!preproc			: "^{{{2\s*(.*)"	"==\1=="
%%!preproc			: "^{{{3\s*(.*)"	"===\1==="
%%!preproc			: "^{{{4\s*(.*)"	"====\1===="
%%!preproc			: "^{{{5\s*(.*)"	"=====\1====="


%%%% FOOTNOTES!!!
%%%% Footnotes ((footnote)) as in dokuwiki 
%%%% przypisy to podwójny nawias jak w dokuwiki!!! %%%%%%%
%%!postproc(tex): \(\((.*?)\)\) \\footnote{\1}
%%!postproc(html)	:	'\(\((.*?)\)\)'	'<span class="footnote">[(\1)]</span>'
%%!postproc(xhtml)	:	'\(\((.*?)\)\)'	'<span class="footnote">[(\1)]</span>'
%%!postproc(txt)		:	\(\((.*?)\)\)	[(\1)]



%% Supression of indented writing
%% TO RETHINK LATER (DO PRZEMYŚLENIA PÓŹNIEJ)
%%!preproc			: "^\t*"	""



%% Placing quotes zones
%% TO RETHINK LATER (DO PRZEMYŚLENIA PÓŹNIEJ)
%%!preproc			:	"^>>>>> " "\t\t\t\t\t"
%%!preproc			:	"^>>>> " "\t\t\t\t"
%%!preproc			:	"^>>> " "\t\t\t"
%%!preproc			:	"^>> " "\t\t"
%%!preproc			:	"^> " "\t"



%% Adding newline not jump paragraphs (znacznik nowej linii bez zakładania nowego akapitu)
%!preproc(xhtml)	:	'\\\\' 'LbrL'
%!preproc(html)		:	'\\\\' 'LbrL'
%!preproc(tex)		:	'\\\\' 'LbrL'
%!preproc(txt)		:	'\\\\'	'\n'
%
%!postproc(xhtml)	:	'LbrL' '<br />'
%!postproc(html)	:	'LbrL' '<BR>'
%!postproc(tex)	:	'LbrL' '\\\\'


%% Comments to be seen in result code (komcie co mają przejść do wyniku) (/* cośtam */)
%!preproc(html)		:	'/\*(.*?)\*/' '<!-- \1 -->'
%!preproc(xhtml)	:	'/\*(.*?)\*/' '<!-- \1 -->'
%!preproc(xhtml)	:	'/\*(.*?)\*/' '\% \1'
%% Preserve comments to not be catched by other typographic rules 
%% (zabezpieczenie komentów HTML i XHTML żeby nie łapało z myślnikami)
%!preproc(html)		:	'<!--(.*?)-->' '<!KARMAPACZIENNO\1KARMAPACZIENNO>'
%!postproc(html)	:	'<!KARMAPACZIENNO(.*?)KARMAPACZIENNO>' '<!-- \1 -->'
%!preproc(xhtml)		:	'<!--(.*?)-->' '<!KARMAPACZIENNO\1KARMAPACZIENNO>'
%!postproc(xhtml)	:	'<!KARMAPACZIENNO(.*?)KARMAPACZIENNO>' '<!-- \1 -->'



%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Typography Typografia
%%% When there is preproc used, then I don't see the reason to postproc this...
%% Quotes Cytaty 
%% TO RETHINK LATER (DO PRZEMYŚLENIA PÓŹNIEJ)
%%!preproc			:	'«\s*'	'«'
%%!postproc(html)	:	'«'		'«&nbsp;'
%%!postproc(xhtml)	:	'«'		'«&nbsp;'
%%!postproc(tex)	:	'«'		'\\og'
%%!preproc			:	'\s*»'	'»'
%%!postproc(html)	:	'»'		'&nbsp;»'
%%!postproc(xhtml)	:	'»'		'&nbsp;»'
%%!postproc(tex)	:	'»'		'\\fg{}'



%%% Trademark, copyright etc.
%!postproc(html)	:	'\(c\)'		'&copy;'
%!postproc(xhtml)	:	'\(c\)'		'&copy;'
%!preproc(tex)		:	'\(c\)'		'\copyright'
%!postproc(txt)		:	'\(c\)'		'©'
%
%!postproc(html)	:	'\(tm\)'	'&trade;'
%!postproc(xhtml)	:	'\(tm\)'	'&trade;'
%!preproc(tex)		:	'\(tm\)'	'\texttrademark'
%!postproc(txt)		:	'\(tm\)'	'™'
%
%!postproc(html)	:	'\(r\)'		'&reg;'
%!postproc(xhtml)	:	'\(r\)'		'&reg;'
%!preproc(tex)		:	'\(r\)'		'\textregistered'
%!postproc(txt)		:	'\(r\)'		'®'



%%% Widows&orphans (sieroty i wdowy)
%!postproc(html)		:	(\s+[aiouwz])\s+	 \1&nbsp;
%!postproc(xhtml)	:	(^|\s+[aiouwz])\s+	 \1&nbsp;
%!postproc(tex)		:	(^|\s+[aiouwz])\s+'	 \1~

%%% Subscript & Superscript
% The ^ need to be escaped by \
%!postproc(html):  '\^\^(.*?)\^\^'	'<sup>\1</sup>'
%!postproc(html):  '__(.*?)__'	'<sub>\1</sub>'
%!postproc(xhtml):  '\^\^(.*?)\^\^'	'<sup>\1</sup>'
%!postproc(xhtml):  '__(.*?)__'	'<sub>\1</sub>'


%%%%
%%%% Punctuation Interpunkcja
%% inverted commas (cudzysłów)
%!postproc:	",,"	"„"
%!postproc:	"\'\'"	"”"



% remove space before [\,\.;:!?] punctuation marks 
% (usuwanie spacji sprzed znaków przestankowych)
%!postproc			:	\s+([\,\.;:!?])	\1



%%% en dash & dash by LaTeX notation (półpauza i myślnik wg notacji LaTeX)
%%!postproc(html)	:	--- &mdash;
%%!postproc(html)	:	-- &ndash;
%%!postproc(xhtml)	:	--- &mdash;
%%!postproc(xhtml)	:	-- &ndash;
%%!postproc(txt)		:	--- —
%%!postproc(txt)		:	-- –
%% space+hyphen+space change to space+dash+space (Polish typographic notation)
%!preproc(txt):		'\s-\s'		' --- '
%!preproc(txt):		'^-\s'		'--- '
%!postproc(txt):	'\s---\s'	' — '
%!postproc(txt):	'^---\s' '— '
%!preproc			:	'\s-\s'		' — '
%!preproc			:	'^-\s'		'— '



%%% ellipsis (wielokropek)
%!postproc(html)		:	'\.\.\.' '&hellip;'
%!postproc(xhtml)	:	'\.\.\.' '&hellip;'
%!postproc(txt)		:	'\.\.\.' '…'
%!postproc(tex)		:	'\.\.\.'	'\\dots'
