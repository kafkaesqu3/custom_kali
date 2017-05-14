" VIM OPTIONS
set wildmenu                    " Better command-line completion
set clipboard=unnamedplus " use system clipboard
                                                        " may require install the packages vim-gtk or vim-gnome
                                                        " may also require x11 server in using putty
" NAVIGATION
set whichwrap+=<,>,h,l,[,]      " enables line wrapping via left/right keys at end of a line

" COLORS/HIGHLIGHTIHNG
syntax on                       " enable syntax processing
set cursorline                  " highlight current line
set showmatch                   " highlight matching [{()}]

" FORMATTING
set tabstop=4                   " number of visual spaces per TAB
set shiftwidth=4                " sets tabs for tab/auto indentation
set number                      " show line numbers
set wrap                        " long lines wrap to next line
"filetype indent on             " load filetype-specific indent files
set autoindent                  " indentation inherited from previous line
set smartindent

" SEARCH
set incsearch                   " search as characters are entered
set hlsearch                    " highlight matches
set ignorecase
set smartcase                   " searches all in lowercase become case insensitive

" PERFORMANCE
set lazyredraw

" OTHER
set mouse=a                             " this lets me scroll from putty while in GNU screen
