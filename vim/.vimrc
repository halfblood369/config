let &termencoding=&encoding
set fileencodings=utf-8
set encoding=utf-8
set scrolloff=5

" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty

" You can also specify a different font, overriding the default font
"if has('gui_gtk2')
"  set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
   set guifont=Courier\ New:h15
"else
"  set guifont=-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1
"endif

" If you want to run gvim with a dark background, try using a different
" colorscheme or running 'gvim -reverse'.
" http://www.cs.cmu.edu/~maverick/VimColorSchemeTest/ has examples and
" downloads for the colorschemes on vim.org

" Source a global configuration file if available
if filereadable("/etc/vim/gvimrc.local")
  source /etc/vim/gvimrc.local
endif
:color lodestone
nnoremap <silent> <F3> :NERDTree<CR>

set laststatus=2
if has("statusline")
        set statusline=%f
        set statusline+=[
        set statusline+=%M
        set statusline+=%R
        set statusline+=%{(&paste?',P':'')}
        set statusline+=]
        set statusline+=%<
        set statusline+=%=
        set statusline+=[%-16.16(%{getreg('*')[:15]}%=%<%)]\ 
        set statusline+=[%-16.16(%{getreg('+')[:15]}%<%=%)]\ 
        set statusline+=%{fugitive#statusline()}\ 
        set statusline+=(%04B)\ 
        set statusline+=[
        set statusline+=%{&fenc!='utf-8'?&fenc:''}
        set statusline+=%{&bomb?',B':''}
        set statusline+=%{&ff=='unix'?'':(','.&ff)}
        set statusline+=%Y
        set statusline+=]\ 
        set statusline+=%-16.(%l/%L,%c%V%)\ %P
endif

function Grep(word)
        if has("win32")
                :execute "noautocmd vimgrep /\\<" . a:word . "\\>/gj **"
        else
                if exists(":Ggrep")
                        :execute ":silent! Ggrep! '\\\<'" . a:word . "'\\\>'"
                else
                        :execute ":silent! grep! -r '\\\<" . a:word . "\\\>' " . (exists("t:GrepPath") ? t:GrepPath : ".")
                endif
        endif
        :botright copen
        :redraw!
endfunction
nnoremap S :call Grep("<C-R>=expand('<cword>')<CR>")<CR>

" 语法高亮
set syntax=on
syntax on
"配色方案
colorscheme torte
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自动缩进
set autoindent
set cindent
" 自动换行
set wrap
" 整词换行
set linebreak
" Tab键的宽度
set tabstop=2
set shiftwidth=2    " use two spaces for each step of autoindent
set tabstop=2   " use two spaces for a <Tab>
set softtabstop=2   " use two spaces for a <Tab>
set expandtab       " use spaces rather than tabs
set backspace=2     " allow <BS> over autoindent, line breaks and insert start"
" 统一缩进为2
set softtabstop=2
set shiftwidth=2
" 不要用空格代替制表符
set noexpandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
set guioptions-=m
set guioptions-=T
" 历史记录数
set history=1000
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
set nowrap
set sidescroll=10
"set grepprg=ack
"let g:ackprg="ack-grep -H --nocolor --nogroup --column"
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {<CR>}<Esc>O
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>
 
function ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf
 
function CloseBracket()
 if match(getline(line('.') + 1), '\s*}') < 0
 return "\<CR>}"
 else
 return "\<Esc>j0f}a"
 endif
endf
 
function QuoteDelim(char)
 let line = getline('.')
 let col = col('.')
 if line[col - 2] == "\\"
 "Inserting a quoted quotation mark into the string
 return a:char
 elseif line[col - 1] == a:char
 "Escaping out of the string
 return "\<Right>"
 else
 "Starting a string
 return a:char.a:char."\<Esc>i"
 endif
endf

function! StartUp()     
    if !exists("s:std_in") && 0 == argc()
        NERDTree
    end
endfunction

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * call StartUp()

set filetype=javascript 
