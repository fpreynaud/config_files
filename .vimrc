set ignorecase
set number
set mouse=a
set tabstop=4
set shiftwidth=4
set showcmd
set incsearch
set autochdir
set linebreak
set autoindent
set formatoptions=tcqro
highlight Normal ctermbg=181818
set background=dark

syn on

let mapleader = ","
let maplocalleader = ","

"Insert mode mappings
inoremap <C-A> <ESC>maggVG<ESC>`a:'<,'>
inoremap <Tab><Tab> <C-N>
inoremap jk <ESC>
inoremap JK <ESC>

"Normal mode mappings
nnoremap <C-A> maggVG<ESC>`a:'<,'>
nnoremap cc d^d$
"Open all folds
nnoremap zO zR
"Open all folds under cursor recursively
nnoremap zR zO
"Close all folds
nnoremap zC zM
"Close all folds under cursor recursively
nnoremap zM zC
nnoremap :hg :helpgrep
"d<character> = delete until caracter (excluded)
nnoremap d; dt;
nnoremap d. dt.
nnoremap d, dt,
nnoremap d" dt"
"save instead of save and quit
nnoremap :x<CR> :w<CR>
nnoremap :W<CR> :w<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap zff zf%
nnoremap j gj
nnoremap k gk
nnoremap DD :%d<CR>
nnoremap - :m .-2<CR>
nnoremap + :m .+1<CR>
nnoremap <S-Tab> :tabp<CR>
nnoremap <Tab> :tabn<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>abb :vsp ~/.vim/abbr.vim<CR>
nnoremap <leader>labb :source ~/.vim/abbr.vim<CR>
nnoremap <leader>' viw<ESC>a'<ESC>hbi'<ESC>lel
nnoremap <leader>:: I//<ESC>j
nnoremap <CR> i<CR><ESC>
nnoremap :w<CR> ma:%s/\s\+$//e<CR>:mkview<CR>`a:w<CR>
nnoremap n nzz
nnoremap à 0
nnoremap é ~
nnoremap ; .
nnoremap ù %

"Visual mode mapping
vnoremap <leader>" <ESC>`<i"<ESC>`>la"<ESC>l
vnoremap <leader>{ <ESC>'<O{<ESC>'>o}:'<,'>>
vnoremap + :m '>+1<CR>
vnoremap - :m '<-2<CR>

autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.tex :call Maps_tex()
autocmd Bufnewfile,bufread *.pde :set syn=java

"Prolog autocommands
autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.P :source $VIMRUNTIME/syntax/prolog.vim

"C autocommands
"Write minimal C code
autocmd Bufnewfile *.c :0r ~/.vim/minC.c
"Set cindent
autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.c :set cindent
"Autowrap comments using textwidth,
"Allow formating of comments with 'gq',
"Insert comment leader after hitting <Enter> in Insert mode or 'o' or 'O' in Normal mode
autocmd FileType c :set formatoptions=cqro
"Color Column 80
autocmd FileType c :set cc=80

"C++ autocommands
"Write minimal C++ code
autocmd Bufnewfile *.cpp :0r ~/.vim/minCpp.cpp
"Set cindent
autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.cpp :set cindent
"Autowrap comments using textwidth,
"Allow formating of comments with 'gq',
"Insert comment leader after hitting <Enter> in Insert mode or 'o' or 'O' in Normal mode
autocmd FileType cpp :set formatoptions=cqro
"Color Column 80
autocmd FileType cpp :set cc=80
"set foldmethod to 'syntax'
autocmd FileType cpp :set foldmethod=syntax

"C indent
set cinoptions=""

function! Remove_eol_spaces()
	:%s/\s\+$/
endfunction

function! Maps_tex ()
	if &ft != 'tex' && &ft != 'plaintex'
		return
	endif
	set tw=140

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
