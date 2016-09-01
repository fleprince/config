" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set guifont=Monospace\ 8

nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F7> :NERDTree<CR>

hi MarkWord1  ctermbg=Cyan     ctermfg=Black  guibg=#8CCBEA    guifg=Black
hi MarkWord2  ctermbg=Green    ctermfg=Black  guibg=#A4E57E    guifg=Black
hi MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi MarkWord4  ctermbg=Red      ctermfg=Black  guibg=#FF7272    guifg=Black
hi MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
hi MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black
hi MarkWord7  ctermbg=Gray     ctermfg=Black  guibg=#736F6E    guifg=Black
hi MarkWord8  ctermbg=None     ctermfg=Blue   guibg=White      guifg=Blue
hi MarkWord9  ctermbg=None     ctermfg=Red    guibg=White      guifg=Red

" Flo's changes :
if has('gui_running')
    set background=dark
    colorscheme dragon
else
    "colorscheme desert256
endif
"colorscheme dragon

set number
set wildmode=longest:full
set wildmenu
" Indentations are 4 spaces...
set tabstop=4
set tabpagemax=50
set shiftwidth=4
set expandtab
"set noexpandtab

" Flo's changes :
" retour arrière en mode insertion
set backspace=indent,eol,start
" supprime les espaces en fin de ligne
autocmd BufWritePre * :%s/\s\+$//e
" passage d'une ligne à l'autre avec les flèches latérales
set whichwrap=<,>,[,]


autocmd CursorMoved * silent! exe printf('match CursorLine /\<%s\>/', expand('<cword>'))

" Display all files on open file dialog
let b:browsefilter = "All Files (*.*)\t*.*\n"

" Créé le squelette et entête des nouveaux fichiers
let g:email = "floleprince@gmail.com"
let g:user = "Florian Leprince"
let g:license = "GNU GPL V2"

set scrolloff=2
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

nnoremap <C-Down> 3<C-e>
nnoremap <C-Up> 3<C-y>

set foldmethod=syntax
set foldlevel=20

execute pathogen#infect()

