"//////////////////
"{{{1 Miscellaneous"
"//////////////////

" For nested syntax highlighting in markdown code blocks
let g:markdown_fenced_languages = ['python', 'sh']

" Set <leader> for mappings
let mapleader = ","
let maplocalleader = ","

let g:netrw_bufsettings = 'noma nomod nu rel nobl nowrap ro'

"//////////////////
"{{{1 Options
"//////////////////
function! Set_opts() " Configure various settings
	"Make horizontal split open below (resp. right of) current window 
	set splitbelow splitright

	"Make :grep act as :vimgrep
	set grepprg=internal

	"Enable flag g by default in :substitute
	set gdefault

	"Ignore case in search patterns
	"Enable smartcase (don't ignore case if the search is mixed case)
	set ignorecase smartcase

	"Display line numbers
	set number 
	set relativenumber

	"Show partial command in status line
	set showcmd

	"Enable incremental search
	"Change working directory automatically when editing a file
	"Wrap long lines at a character in 'breakat'
	set incsearch autochdir linebreak

	"Enable mouse
	"Make tabs 4 characters wide
	"Make indent shift 4 characters wide
	set mouse=a tabstop=4 shiftwidth=4

	"Copy indent from current line when starting a new line
	"No search result highlighting
	set autoindent nohlsearch

	"Auto-wrap text and comments using textwidth,  allow formatting of comments with "gq", Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode and <Enter> in Insert mode
	set formatoptions=tcqro

	"Make Vim adapt syntax highlighting for dark background
	"C indent
	"Display fold column
	set background=dark cinoptions="" 
	set foldcolumn=2

	"Tabs are of the form [tabpagenumber: modified_flag filename |]
	"Set maximum nesting level for 'indent' and 'syntax' foldmethods
	set tabline=%!SetTabLine() foldnestmax=3

	" Enable current line highlighting
	" Highlight whole line when wrapped, but not line number
	set cursorline cursorlineopt=line
endfunction

"//////////////////
"{{{1 Highlighting
"//////////////////

function! Set_highlighting() " Cosmetics
	"Enable syntax highlighting
	syntax on

	" Use 'torte' colorscheme
	colorscheme torte

	" Enable 24-bit colors if possible
	if has("termguicolors")
		set termguicolors
	endif

	"Make ColorColumn darkgrey
	highlight ColorColumn ctermbg=0
highlight ColorColumn ctermbg=0
	"Make tab line red and white
	highlight TabLine cterm=NONE ctermfg=6 ctermbg=0 guifg=black guibg=white
	highlight TabLineSel cterm=bold ctermfg=3 ctermbg=8 guifg=white guibg=blue
	highlight TabLineFill cterm=NONE ctermbg=0

	"Highlight cursor line. This MUST be done after :syntax on
	highlight CursorLine ctermbg=235 cterm=NONE guibg=#452000

	" Insert mode completion menu 
	highlight Pmenu ctermfg=0 ctermbg=208 guibg=#F05000 guifg=Black
	highlight PmenuSel ctermfg=214 ctermbg=235 guibg=Black guifg=#F05000

	highlight Normal guibg=#250000

	highlight! link Folded StatusLine
	highlight! link FoldColumn StatusLine
endfunction

"//////////////////
"{{{1 Mappings
"//////////////////

function! Set_autocomplete() " Get some as-you-type completion
	inoremap a a<C-N><C-P>
	inoremap b b<C-N><C-P>
	inoremap c c<C-N><C-P>
	inoremap d d<C-N><C-P>
	inoremap e e<C-N><C-P>
	inoremap f f<C-N><C-P>
	inoremap g g<C-N><C-P>
	inoremap h h<C-N><C-P>
	inoremap i i<C-N><C-P>
	inoremap j j<C-N><C-P>
	inoremap k k<C-N><C-P>
	inoremap l l<C-N><C-P>
	inoremap m m<C-N><C-P>
	inoremap n n<C-N><C-P>
	inoremap o o<C-N><C-P>
	inoremap p p<C-N><C-P>
	inoremap q q<C-N><C-P>
	inoremap r r<C-N><C-P>
	inoremap s s<C-N><C-P>
	inoremap t t<C-N><C-P>
	inoremap u u<C-N><C-P>
	inoremap v v<C-N><C-P>
	inoremap w w<C-N><C-P>
	inoremap x x<C-N><C-P>
	inoremap y y<C-N><C-P>
	inoremap z z<C-N><C-P>
endfunction

function! Set_mappings() " Define key mappings
	"Insert mode mappings"
	""""""""""""""""""""""

	"Easy return to normal mode
	inoremap jk <ESC>
	inoremap JK <ESC>

	"Normal mode mappings"
	""""""""""""""""""""""

	"Make CTRL-G show full path and buffer number
	nnoremap <C-G> 2<C-G>

	"Scroll up/down and leave cursor on same line
	nnoremap <M-Up> <c-Y>gk
	nnoremap <M-Down> <C-E>gj

	"Modify windows height and width
	nnoremap <F2> <C-W>=
	nnoremap <F3> :resize<CR>:vertical resize<CR>

	"Delete whole line
	nnoremap DD 0d$

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
	nnoremap gj j
	nnoremap gk k

	"Move current line up or down
	nnoremap - :m .-2<CR>
	nnoremap + :m .+1<CR>

	"Move to previous or next tab page
	nnoremap <M-Left> gT
	nnoremap <M-Right> gt

	"Edit and load vim configuration
	nnoremap <leader>ev :vsp $MYVIMRC<CR>
	nnoremap <leader>sv :source $MYVIMRC<CR>

	"Edit and load abbreviations file
	nnoremap <leader>abb :vsp ~/.vim/abbr.vim<CR>
	nnoremap <leader>labb :source ~/.vim/abbr.vim<CR>

	"Adapt QWERTY commands for AZERTY keyboards
	nnoremap à 0
	nnoremap é ~
	nnoremap ; .
	nnoremap . ;
	nnoremap ù %

	"Enclose Word between quotes/brackets
	nnoremap <leader>" ciW""<ESC>P
	nnoremap <leader>' ciW''<ESC>P
	nnoremap <leader>( ciW()<ESC>P
	nnoremap <leader>) ciW()<ESC>P
	nnoremap <leader>[ ciW[]<ESC>P
	nnoremap <leader>] ciW[]<ESC>P

	"Visual mode mappings"
	"""""""""""""""""""""

	"Move selected lines up or down.
	vnoremap + :m '>+1<CR>'<V'>
	vnoremap - :m '<-2<CR>'<V'>

	"Enclose selection in quotes/brackets
	vnoremap <leader>" <ESC>`>a"<ESC>`<i"<ESC>
	vnoremap <leader>' <ESC>`>a'<ESC>`<i'<ESC>
	vnoremap <leader>( <ESC>`>a)<ESC>`<i(<ESC>
	vnoremap <leader>) <ESC>`>a)<ESC>`<i(<ESC>
	vnoremap <leader>[ <ESC>`>a]<ESC>`<i[<ESC>
	vnoremap <leader>] <ESC>`>a]<ESC>`<i[<ESC>
	")]
endfunction

"//////////////////
"{{{1 Filetype actions
"//////////////////
function! Set_FtActions() " Do specific actions depending on file type
	"Call Maps_tex when editing .tex files (TODO: make it local to buffer)
	autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.tex :call Maps_tex()

	"Syntax highlighting
	"i3 config files
	autocmd Bufnewfile,bufreadpre,bufread,bufreadpost */i3/config :set syntax=i3config
	".md files
	autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.md :set syntax=markdown
	".pde files
	autocmd Bufnewfile,bufread *.pde :set syn=java
	".P files
	autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.P :source $VIMRUNTIME/syntax/prolog.vim
	".fish files
	autocmd Bufnewfile,bufreadpre,bufread,bufreadpost *.fish :set syntax=fish

	"Autocommands common to C and C++
	"Enable cindent
	autocmd Bufnewfile,bufreadpre,bufread,bufreadpost {*.c,*.cpp} :set cindent
	"Don't break text using textwidth
	autocmd FileType {c,cpp} :set formatoptions=cqro
endfunction

function! Maps_tex () "Defines mappings for .tex documents
    if &ft != 'tex' && &ft != 'plaintex'
        return
    endif

    "Make '_' be counted as part of words
    set iskeyword+=_

    set tw=80

    "En-tête
    inoreabbr <buffer> usepackages \documentclass[a4paper]{article}<CR>\usepackage[utf8]{inputenc}<CR>\usepackage[T1]{fontenc}<CR>\%\usepackage[francais]{babel}<CR>%\usepackage[left=1cm, bottom=1cm, top=0.5cm, right=1cm]{geometry}<CR>\usepackage{color}<CR>%\usepackage{graphicx}
    inoreabb <buffer> colortitles \definecolor{turquoise}{rgb}{.17,.97,.7}<CR> \definecolor{vert}{rgb}{.17,.97,.34}<CR> \newcommand{\cpart}[1]{\part{\textcolor{blue}{#1}} }<CR> \newcommand{\csection}[1]{\section{\textcolor{turquoise}{#1}} }<CR> \newcommand{\csubsection}[1]{\subsection{\textcolor{vert}{#1}} }

    "Sections & paragraphs mappings
    inoremap <buffer> <leader>cpart \cpart{}<Left>
    inoremap <buffer> <leader>csec \csection{}<Left>
    inoremap <buffer> <leader>csub \csubsection{}<Left>
    inoremap <buffer> <leader>cssub \csubsubsection{}<Left>
    inoremap <buffer> <leader>part \part{}<Left>
    inoremap <buffer> <leader>sec \section{}<Left>
    inoremap <buffer> <leader>sub \subsection{}<Left>
    inoremap <buffer> <leader>ssub \subsubsection{}<Left>
    inoremap <buffer> <leader>par \paragraph{}<Left>
    inoremap <buffer> <leader>spar \subparagraph{}<Left>

    "Lists mappings
    inoremap <buffer> <leader>item \begin{itemize}<CR><Tab><CR><BS>\end{itemize}<ESC>ka
    inoremap <buffer> <leader>desc \begin{description}<CR><Tab><CR><BS>\end{description}<Up><Right>\item
    inoremap <buffer> <leader>enum \begin{enumerate}<CR><Tab><CR><BS>\end{enumerate}<Up><Right>\item
    inoremap <buffer> <leader>- \item~
    inoremap <buffer> <leader>p- \item[$\bullet$]

    "Environments mappings
    inoremap <buffer> <leader>beg \begin{}<CR>\end{}<Up><Right><Right><CR><Tab><Up><Right><Right><Right>
    inoremap <buffer> <leader>\[ \[\]<Left><Left><CR><CR><Up><Tab><Right>
    inoremap <buffer> <leader>tabular \begin{tabular}{\|\|}<CR><Tab><CR><BS>\end{tabular}<Up>
    inoremap <buffer> <leader>matrix \left(\begin{tabular}{}<CR><Tab><CR><BS>\end{tabular}\right)<Up>

    "Other mappings
    inoremap <buffer> <leader>emp \emph{}<Left>
    inoremap <buffer> <leader>tbs \textbackslash{}
    inoremap <buffer> _ \
    inoremap <buffer> \ _

    nnoremap <buffer> <C-C> :!make<CR>
endfunction

"//////////////////
"{{{1 Tab line
"//////////////////
"Customizes the way information is displayed in tab line
"The current tab is always displayed last, so that it is always visible
function! SetTabLine()
    let s = ''
	let current_tab_s = ''

	"Loop accross all tabs
	for i in range(tabpagenr('$'))
		let tabpage = i + 1
		let tab_string = ''
		let hl = '%#TabLine#'

		"If the tabpage is the current tabpage use highlight group for
		"selected tab
		if tabpage == tabpagenr()
			let hl = '%#TabLineSel#'
		endif
		let tab_string .= hl
		let tab_string .= '%' . tabpage . 'T'

		" the label is made by MyTabLabel()
		let tab_string .= '[' . tabpage . ': %{MyTabLabel(' . tabpage . ')} ]'

		if tabpage == tabpagenr()
			let current_tab_s .= tab_string
		else
			let s .= tab_string
		endif
	endfor
	let s .= current_tab_s

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999XX'
	endif

	return s
endfunction

function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let label = fnamemodify(bufname(buflist[winnr - 1]), ':t')
    if getbufvar(buflist[winnr - 1], "&mod") == 1
        let label = '[+]' . label
    endif
    return label
endfunction

function! CloseOtherTabs()
	for i in range(tabpagenr('$'))
		if i+1 == tabpagenr()
			continue
		endif
		execute('tabclose ' . i)
	endfor
endfunction

"//////////////////
"{{{1 Custom functions
"//////////////////
function! Tee(target, command, ...)
	let s = a:command
	let output = execute(a:command)
	let output = split(output, '\n')
	call writefile(output, a:target)
	call execute("tabe " . a:target)
endfunction

function! NextColorScheme()
	""" Cycle through colorschemes

	let rpath_list = split(&runtimepath, ',', 1)
	let runtime_folder = v:none
	let available_schemes = []
	let current_scheme = execute('colorscheme')[1:]
	let color_files = v:none
	let current_options = execute('set')
	let current_options = split(current_options, '\n')[1:]

	" Find folder read by :colorscheme
	for path in rpath_list
		if isdirectory(path . '/colors')
			let runtime_folder = path
			break
		end
	endfor

	" Stop if folder is not found
	if runtime_folder == v:none
		return
	endif
	
	" Get the list of color scheme files
	let color_files = glob(runtime_folder . '/colors/*.vim')
	let color_files = split(color_files, '\n')

	" Store names of color schemes in a list
	for color_file in color_files
		let output = system('basename ' . color_file)
		let output = split(output, '\.')[0]
		call add(available_schemes, output)
	endfor

	" Apply next color scheme
	let idx = index(available_schemes, current_scheme)
	if exists('g:next_index')
		let g:next_index = (g:next_index + 1) % len(available_schemes)
	else
		let g:next_index = (idx + 1) % len(available_schemes)
	endif
	exec 'colorscheme ' . available_schemes[g:next_index]

	call Set_opts()
	call Set_highlighting()

	" Display name of newly applied colorscheme
	redraw! " Necessary for the subsequent echo to display something
	echo available_schemes[g:next_index]
endfunction

"//////////////////
"{{{1 User-defined commands
"//////////////////

command! Changeindentstyle set expandtab! smarttab!|retab
command! -nargs=? -complete=buffer Vsb vert sb <args>

call Set_opts()
call Set_highlighting()
call Set_mappings()
call Set_autocomplete()
call Set_FtActions()
