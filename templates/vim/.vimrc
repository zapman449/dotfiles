"call pathogen#infect()
syntax enable
filetype plugin indent on
"let g:solarized_contrast="high"	   "default value is normal
"let g:solarized_visibility="high"  "default value is normal
set background=dark
"colorscheme solarized
"colorscheme torte
set gfn=Inconsolata\ 12
set hlsearch
set statusline=%f         " Path to the file

set statusline+=\ -\      " Separator
set statusline+=FileType: " Label
set statusline+=%y        " Filetype of the file

set statusline+=%=        " Switch to the right side
set statusline+=%l        " Current line
set statusline+=\         " Separator
set statusline+=/         " Separator
set statusline+=\         " Separator
set statusline+=%L        " Total lines
set statusline+=\ \       " Separator
set laststatus=2
