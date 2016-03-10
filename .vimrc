"Options"
"""""""""
"Ignore case in search patterns
set ignorecase

"Display line numbers
set number

"Enable mouse
set mouse=a

"Make tabs 4 characters wide
set tabstop=4
set shiftwidth=4

"Show partial command in status line
set showcmd

"Enable incremental search
set incsearch

"Change working directory automatically when editing a file
set autochdir

"Wrap long lines at a character in 'breakat'
set linebreak

"Copy indent from current line when starting a new line
set autoindent

"Auto-wrap text and comments using textwidth,  allow formatting of comments with "gq", Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode and <Enter> in Insert mode
set formatoptions=tcqro

"Make Vim adapt syntax highlighting for dark background
set background=dark

"C indent
set cinoptions=""

"Miscellaneous"
"""""""""""""""

"Make ColorColumn darkgrey
highlight ColorColumn ctermbg=8

"Enable syntax highlighting
syn on

"Set <leader> for mappings
let mapleader = ","
let maplocalleader = ","

"Insert mode mappings"
""""""""""""""""""""""

"CTRL-A to select all
inoremap <C-A> <ESC>maggVG<ESC>`a:'<,'>

"Use tab for completion
inoremap <Tab><Tab> <C-N>

"Easy return to normal mode
inoremap jk <ESC>
inoremap JK <ESC>

"Normal mode mappings"
""""""""""""""""""""""


"CTRL-A to select all
nnoremap <C-A> maggVG<ESC>`a:'<,'>

"Delete whole line
nnoremap cc d^d$

"Open all folds
nnoremap zO zR

"Open all folds under cursor recursively
nnoremap zR zO

"Close all folds
nnoremap zC zM

"Close all folds under cursor recursively
nnoremap zM zC

"Shortcut for helpgrep
nnoremap :hg :helpgrep

"d<character> = delete until caracter (excluded)
nnoremap d; dt;
nnoremap d. dt.
nnoremap d, dt,
nnoremap d" dt"

"Save instead of save and quit
nnoremap :x<CR> :w<CR>

"Alias for :w
nnoremap :W<CR> :w<CR>

"move across windows
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>


"Convenient fold until matching bracket/parenthesis
nnoremap zff zf%

"Up down motion in wrapped lines
nnoremap j gj
nnoremap k gk

"Erase whole document
nnoremap DD :%d<CR>

"Move current line up or down
nnoremap - :m .-2<CR>
nnoremap + :m .+1<CR>

"Move to previous or next tab page
nnoremap <S-Tab> :tabp<CR>
nnoremap <Tab> :tabn<CR>

"Alias for CTRL-I, because CTRL-I is now :tabn<CR>
nnoremap <C-Y> <C-I>

"Edit and load vim configuration
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

"Edit and load abbreviations file
nnoremap <leader>abb :vsp ~/.vim/abbr.vim<CR>
nnoremap <leader>labb :source ~/.vim/abbr.vim<CR>

"Commenting
"C line comment
nnoremap <leader>:: I//<ESC>j
"Latex comment
nnoremap <leader>ù I%<ESC>j
"Vim comment
nnoremap <leader>" I"<ESC>j
"Bash comment
nnoremap <leader># I#<ESC>j

"<CR> inserts newline in normal mode
nnoremap <CR> i<CR><ESC>

"Remove trailing spaces and save view before saving
nnoremap :w<CR> ma:%s/\s\+$//e<CR>:mkview<CR>`a:w<CR>

"When jumping to next occurence, put it in the middle of the screen
nnoremap n nzz

"Adapt QWERTY commands for AZERTY keyboards
nnoremap à 0
nnoremap é ~
nnoremap ; .
nnoremap ù %

"Visual mode mappings"
"""""""""""""""""""""

"Move selected lines up or down. Cannot be repeated
vnoremap + :m '>+1<CR>
vnoremap - :m '<-2<CR>

"Autocommands"
""""""""""""""

"Call Maps_tex when editing .tex files (TODO: make it local to buffer)
autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.tex :call Maps_tex()

"Use Markdown syntax highlighting for .md files
autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.md :set syntax=markdown
"Use Java syntax highlighting for .pde files
autocmd Bufnewfile,bufread *.pde :set syn=java

"Use Prolog syntax highlighting for .P files
autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.P :source $VIMRUNTIME/syntax/prolog.vim

"Autocommands common to C and C++
"Enable cindent
autocmd Bufnewfile,bufreadpre,bufread,bufreadpost {*.c,*.cpp} :set cindent
"Don't break text using textwidth
autocmd FileType {c,cpp} :set formatoptions=cqro
"Color Column 80
autocmd FileType {c,cpp} :set cc=80
"set foldmethod to 'syntax'
autocmd FileType {c,cpp} :set foldmethod=syntax

"C-specific autocommands
"Write minimal C code
autocmd Bufnewfile *.c :0r ~/.vim/minC.c

"C++-specific autocommands
"Write minimal C++ code
autocmd Bufnewfile *.cpp :0r ~/.vim/minCpp.cpp


"Defines mappings for .tex documents
function! Maps_tex ()
	if &ft != 'tex' && &ft != 'plaintex'
		return
	endif
	set tw=80

	"En-tête
	inoreabbr usepackages \documentclass[a4paper]{article}<CR>\usepackage[utf8]{inputenc}<CR>\usepackage[T1]{fontenc}<CR>\%\usepackage[francais]{babel}<CR>%\usepackage[left=1cm, bottom=1cm, top=0.5cm, right=1cm]{geometry}<CR>\usepackage{color}<CR>%\usepackage{graphicx}
	inoreabb colortitles \definecolor{turquoise}{rgb}{.17,.97,.7}<CR> \definecolor{vert}{rgb}{.17,.97,.34}<CR> \newcommand{\cpart}[1]{\part{\textcolor{blue}{#1}}}<CR> \newcommand{\csection}[1]{\section{\textcolor{turquoise}{#1}}}<CR> \newcommand{\csubsection}[1]{\subsection{\textcolor{vert}{#1}}}

	"Sections & paragraphs mappings
	inoremap <leader>cpart \cpart{}<Left>
	inoremap <leader>csec \csection{}<Left>
	inoremap <leader>csub \csubsection{}<Left>
	inoremap <leader>cssub \csubsubsection{}<Left>
	inoremap <leader>part \part{}<Left>
	inoremap <leader>sec \section{}<Left>
	inoremap <leader>sub \subsection{}<Left>
	inoremap <leader>ssub \subsubsection{}<Left>
	inoremap <leader>par \paragraph{}<Left>
	inoremap <leader>spar \subparagraph{}<Left>

	"Lists mappings
	inoremap <leader>item \begin{itemize}<CR><Tab><CR><BS>\end{itemize}<ESC>ka
	inoremap <leader>desc \begin{description}<CR><Tab><CR><BS>\end{description}<Up><Right>\item
	inoremap <leader>enum \begin{enumerate}<CR><Tab><CR><BS>\end{enumerate}<Up><Right>\item
	inoremap <leader>- \item
	inoremap <leader>p- \item[$\bullet$]

	"Environments mappings
	inoremap <leader>beg \begin{}<CR>\end{}<Up><Right><Right><CR><Tab><Up><Right><Right><Right>
	inoremap <leader>\[ \[\]<Left><Left><CR><CR><Up><Tab><Right>
	inoremap <leader>tabular \begin{tabular}{\|\|}<CR><Tab><CR><BS>\end{tabular}<Up>
	inoremap <leader>matrix \left(\begin{tabular}{}<CR><Tab><CR><BS>\end{tabular}\right)<Up>

	"Other mappings
	inoremap <leader>emp \emph{}<Left>
	inoremap <leader>tbs \textbackslash{}
	inoremap _ \
	inoremap \ _

	nnoremap <C-C> :!make<CR>
endfunction
