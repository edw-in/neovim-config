"
" init.vim
"
source $VIMRUNTIME/mswin.vim
behave mswin
:autocmd BufNewFile *.cpp 0r ~/.config/nvim/templates/skeleton.cpp
set mouse=a
" vim-plug {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/minimal_nvim/plugged')

" === functionality ===================================== "
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-endwise'
Plug 'rstacruz/vim-closer'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'

" === subtleties ======================================= "
Plug 'machakann/vim-highlightedyank'
Plug 'psliwka/vim-smoothie'

" === themes ============================================ "
Plug 'pgdouyon/vim-yin-yang'
Plug 'owickstrom/vim-colors-paramount'
Plug 'arcticicestudio/nord-vim'
Plug 'dracula/vim', { 'commit': '147f389f4275cec4ef43ebc25e2011c57b45cc00' }

" === engine ============================================ "
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale'

" === language-specific ================================= "
Plug 'lervag/vimtex'
Plug 'sheerun/vim-polyglot'

" === git =============================================== "
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" === miscellaneous ===================================== "
Plug 'chrisbra/Colorizer'
Plug 'vimlab/split-term.vim'

call plug#end()
" }}}
" detect environment {{{
if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os = "Windows"
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif
if !has("nvim")
	throw 'no neovim!'
endif
" }}}
" options {{{
set tabstop=4 softtabstop=4 shiftwidth=4
set list lcs=tab:┆·,trail:·,precedes:,extends:
set hidden noshowmode nowrap termguicolors splitright splitbelow switchbuf=useopen
set ignorecase smartcase number relativenumber
set clipboard=unnamedplus
set inccommand=nosplit
let g:tex_flavor = 'latex'
let g:highlightedyank_highlight_duration = 300
runtime macros/sandwich/keymap/surround.vim " use vim-surround keybinds
call operator#sandwich#set('all', 'all', 'highlight', 1) " use good highlighting colors
" }}}
" functions | commands {{{
command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
command! -nargs=0 Focus exec "normal! mzzMzvzz`z"

" C++ compilation {{{
function! TermWrapper(command) abort
	if !exists('g:split_term_style') | let g:split_term_style = 'vertical' | endif
	if g:split_term_style ==# 'vertical'
		let buffercmd = 'vnew'
	elseif g:split_term_style ==# 'horizontal'
		let buffercmd = 'new'
	else
		echoerr 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'' but is currently set to ''' . g:split_term_style . ''')'
		throw 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'')'
	endif
	exec buffercmd
	if exists('g:split_term_resize_cmd')
		exec g:split_term_resize_cmd
	endif
	exec 'term ' . a:command
	exec 'startinsert'
endfunction

command! -nargs=0 CompileAndRun call TermWrapper(printf('g++ -std=c++11 %s && ./a.out', expand("%")))
command! -nargs=1 CompileAndRunWithFile call TermWrapper(printf('g++ -std=c++11 %s && ./a.out < %s', expand("%"), <args>))
autocmd FileType cpp nnoremap <leader>fw :CompileAndRun<CR>
" }}}
" Python Compilation {{{
function! TermWrapper(command) abort
	if !exists('g:split_term_style') | let g:split_term_style = 'vertical' | endif
	if g:split_term_style ==# 'vertical'
		let buffercmd = 'vnew'
	elseif g:split_term_style ==# 'horizontal'
		let buffercmd = 'new'
	else
		echoerr 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'' but is currently set to ''' . g:split_term_style . ''')'
		throw 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'')'
	endif
	exec buffercmd
	if exists('g:split_term_resize_cmd')
		exec g:split_term_resize_cmd
	endif
	exec 'term ' . a:command
	exec 'startinsert'
endfunction

command! -nargs=0 PythonRun call TermWrapper(printf('python3 %s', expand("%")))
autocmd FileType py nnoremap <leader>fw :PythonRun<CR>
" }}}
" LaTeX {{{
" command! -nargs=0 LatexCompile w <bar> !pdflatex % && pdflatex % && bibtex %:r
command! -nargs=0 LatexCompile w <bar> !pdflatex %
" }}}
" Lterm {{{
" let g:lterm_window = -1
" let g:lterm_buffer = -1
" let g:lterm_job_id = -1
" function! LtermOpen()
" 	if !bufexists(g:lterm_buffer)
" 		echo "opening"
" 		new lterm_w
" 		let g:lterm_job_id = termopen($SHELL)
" 		silent file lterm_b
" 		let g:lterm_window = win_getid()
" 		let g:lterm_buffer = bufnr('%')
" 		set nobuflisted
" 	else
" 		if !win_gotoid(g:lterm_window)
" 			sp
" 			wincmd L
" 			buffer lterm_b
" 			let g:lterm_window = win_getid()
" 		endif
" 	endif
" endfunction
" function! LtermToggle()
" 	if win_gotoid(g:lterm_window)
" 		call LtermClose()
" 	else
" 		call LtermOpen()
" 	endif
" endfunction
" function! LtermClose()
" 	if win_gotoid(g:lterm_window) | hide | endif
" endfunction
" function! LtermExec(cmd)
" 	if !win_gotoid(g:lterm_window) call | LtermOpen() | endif
" 	call jobsend(g:lterm_job_id, "clear\n")
" 	call jobsend(g:lterm_job_id, a:cmd . "\n")
" 	normal! G
" 	wincmd p
" endfunction
" }}}

" }}}
" Visual Mode */# from Scrooloose {{{

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" }}}
" keybinds {{{
let mapleader=" "

nnoremap <silent> <leader>n :nohl<CR>

nnoremap <silent> <leader>wh <C-w>h
nnoremap <silent> <leader>wj <C-w>j
nnoremap <silent> <leader>wk <C-w>k
nnoremap <silent> <leader>wl <C-w>l
nnoremap <silent> <leader>w= <C-w>=

nnoremap <silent> <leader>eh <C-w>H
nnoremap <silent> <leader>ej <C-w>J
nnoremap <silent> <leader>ek <C-w>K
nnoremap <silent> <leader>el <C-w>L
nmap <C-t> :!gnome-terminal<ENTER>
nnoremap <silent> <leader>to :call LtermOpen()<CR>
nnoremap <silent> <leader>tc :call LtermClose()<CR>
nmap <C-c>:%y+<CR>
nnoremap <silent> <leader>wt :w<CR>:sb term:<CR>i<Up><CR><C-\><C-n><C-w><C-p>
nnoremap <F6> :CompileAndRun<CR>
nnoremap <F8> :PythonRun<CR>
tnoremap <Esc> <C-\><C-n>

" }}}
" statusline {{{

" main {{{
" helper {{{
" * No funky separators. Just straight lines. (None of this: )
let g:mode_dict = {
			\ 'n': { 'icon': '', 'name': 'N', 'style': 'StlNormalMode' },
			\ 'no': { 'icon': '', 'name': 'O', 'style': 'StlOpPendMode' },
			\ 'nov': { 'icon': '', 'name': 'O', 'style': 'StlOpPendMode' },
			\ 'noV': { 'icon': '', 'name': 'O', 'style': 'StlOpPendMode' },
			\ "no\<C-v>": { 'icon': '', 'name': 'O', 'style': 'StlOpPendMode' },
			\ 'niI': { 'icon': '', 'name': 'I', 'style': 'StlNormalMode' },
			\ 'niR': { 'icon': '', 'name': 'I', 'style': 'StlNormalMode' },
			\ 'niV': { 'icon': '', 'name': 'I', 'style': 'StlNormalMode' },
			\ 'v': { 'icon': '', 'name': 'V', 'style': 'StlVisualMode' },
			\ 'V': { 'icon': '', 'name': 'V', 'style': 'StlVisualMode' },
			\ "\<C-v>": { 'icon': '', 'name': 'V', 'style': 'StlVisualMode' },
			\ 's': { 'icon': '', 'name': 'S', 'style': 'StlSelectMode' },
			\ 'S': { 'icon': '', 'name': 'S', 'style': 'StlSelectMode' },
			\ "\<C-s>": { 'icon': '', 'name': 'S', 'style': 'StlSelectMode' },
			\ 'i': { 'icon': '', 'name': 'I', 'style': 'StlInsertMode' },
			\ 'ic': { 'icon': '', 'name': 'I', 'style': 'StlInsertMode' },
			\ 'ix': { 'icon': '', 'name': 'I', 'style': 'StlInsertMode' },
			\ 'R': { 'icon': 'ﰉ', 'name': 'R', 'style': 'StlReplaceMode' },
			\ 'Rc': { 'icon': 'ﰉ', 'name': 'R', 'style': 'StlReplaceMode' },
			\ 'Rv': { 'icon': 'ﰉ', 'name': 'R', 'style': 'StlReplaceMode' },
			\ 'Rx': { 'icon': 'ﰉ', 'name': 'R', 'style': 'StlReplaceMode' },
			\ 'c': { 'icon': 'ﱕ', 'name': 'C', 'style': 'StlCommandMode' },
			\ 'cv': { 'icon': 'ﱕ', 'name': 'C', 'style': 'StlCommandMode' },
			\ 'ce': { 'icon': 'ﱕ', 'name': 'C', 'style': 'StlCommandMode' },
			\ 'r': { 'icon': '', 'name': 'Q', 'style': 'StlPendingMode' },
			\ 'rm': { 'icon': '', 'name': 'Q', 'style': 'StlPendingMode' },
			\ 'r?': { 'icon': '', 'name': 'Q', 'style': 'StlPendingMode' },
			\ '!': { 'icon': '', 'name': 'J', 'style': 'StlExternMode' },
			\ 't': { 'icon': '', 'name': 'T', 'style': 'StlTerminalMode' },
			\ 'unknown': { 'icon': '', 'name': 'Unknown Mode', 'style': 'StlUnknownMode' }
			\ }

function! SetStlHi(hex, text)
	return '%#' . a:hex . '#' . a:text . '%*'
endfunction

function! StlPad(text, ...)
	let leftpad = get(a:, 1, 1)
	let rightpad = get(a:, 2, leftpad)
	let leftspacepadding = repeat(' ', leftpad)
	let rightspacepadding = repeat(' ', rightpad)
	return leftspacepadding . a:text . rightspacepadding
endfunction

function! ModFlag(mod)
	return a:mod ? '' : ''
endfunction

function! ReadOnlyFlag(ro)
	return a:ro ? '' : ''
endfunction

function! PaddingController(...)
	let flagstring = '' " initial flagstring
	let xflag = 0
	for flag in a:000
		if flag !=# ''
		" if flag !=# '' && match(flag, '#%*') != -1
			let xflag = 1
			let flagstring .= flag
			let flagstring .= ' '
		endif
	endfor
	return xflag == 0 ? '' : flagstring
endfunction

function! AwareHighlight(hlgroup, themecolor, ...)
	if a:hlgroup !=# 'StlFileNameText'
		let secondarycolor = &background ==# 'dark' ? '#222222' : 'white'
		let themecolor = a:themecolor
	else
		let secondarycolor = &background ==# 'dark' ? 'white' : '#222222'
		let themecolor = &background ==# 'dark'? '#222222' : 'white'
	endif
	let command = 'hi ' . a:hlgroup . ' guifg=' . secondarycolor . ' guibg=' . themecolor
	exec command
	let command = 'hi ' . a:hlgroup . 'Rev guifg=' . secondarycolor . ' guibg=' . themecolor . ' gui=reverse'
	exec command
endfunction
" }}}

" test
function! ActiveStatus()
	let mode = get(g:mode_dict, mode(1), g:mode_dict.unknown)
	let mode_widget = SetStlHi(mode.style, StlPad(mode.icon, 1))
	" let modified_widget = SetStlHi(mode.style . 'Rev', ModFlag(&mod))
	" let readonly_widget = SetStlHi(mode.style . 'Rev', ReadOnlyFlag(&ro))
	" let filename_widget = SetStlHi('StlFileNameText', '%f')
	let statusline = ''
	" let statusline .= SetStlHi(mode.style, StlPad(mode.name, 1))
	let statusline .= mode_widget
	" let statusline .= '%{PaddingController(filename_widget)'
	let statusline .= SetStlHi('StlFileNameText', ' %f ')
	" let statusline .= '%{PaddingController(SetStlHi(''StlFileNameText'', '' %f ''),SetStlHi(mode.style . ''Rev'', ''%{PaddingController(ModFlag(&mod),ReadOnlyFlag(&ro))}))}'
	let statusline .= SetStlHi(mode.style . 'Rev', '%{PaddingController(ModFlag(&mod),ReadOnlyFlag(&ro))}')
	let statusline .= SetStlHi(mode.style, '%( %{PaddingController(coc#status(),AleLinterStatus(),FugitiveStatusline())}%)')
	let statusline .= SetStlHi('StatusLine', '%=')
	let statusline .= SetStlHi(mode.style, StlPad('%l/%L', 1))
	return statusline
endfunction
" 
function! InactiveStatus()
	let statusline=''
	let statusline .= '  %f'
	return statusline
endfunction

augroup Status
	autocmd!
	autocmd VimEnter,WinEnter,BufEnter *
		\ setlocal statusline=%!ActiveStatus()
	autocmd VimLeave,WinLeave,BufLeave *
		\ setlocal statusline=%!InactiveStatus()
augroup END
" }}}

" raw highlight groups {{{
" hi StlNormalMode guibg=#82B5FF guifg=white
" hi StlOpPendMode guibg=#C77A57 guifg=white
" hi StlVisualMode guibg=#20BED4 guifg=white
" hi StlSelectMode guibg=#345623 guifg=white
" hi StlInsertMode guibg=#BEDF96 guifg=white
" hi StlReplaceMode guibg=#8ebf7c guifg=white
" hi StlCommandMode guibg=#F5807B guifg=white
" hi StlPendingMode guibg=#C7A5A5 guifg=white
" hi StlExternMode guibg=#F5DC7A guifg=white
" hi StlTerminalMode guibg=#CB9EF0 guifg=white
" hi StlUnknownMode guibg=#FF0000 guifg=white
" }}}

" background aware highlighting {{{
" if this is not used, make sure to define Reverse highlight styles, i.e.,
" StlNormalModeRev StlOpPendModeRev etc
" use HSL(*, 35%, 61%) colors
function! StlLoadHighlights()
	" the thematic color
	call AwareHighlight('StlNormalMode', '#79a0be')
	call AwareHighlight('StlOpPendMode', '#be79a0')
	call AwareHighlight('StlVisualMode', '#7abfa6')
	call AwareHighlight('StlSelectMode', '#bf987a')
	call AwareHighlight('StlInsertMode', '#a0be79')
	call AwareHighlight('StlReplaceMode', '#7abdbf')
	call AwareHighlight('StlCommandMode', '#d98484')
	call AwareHighlight('StlPendingMode', '#C7A5A5')
	call AwareHighlight('StlExternMode', '#F5DC7A')
	call AwareHighlight('StlTerminalMode', '#9979be')
	call AwareHighlight('StlUnknownMode', '#FF0000')
	call AwareHighlight('StlFileNameText', 'NONE')
endfunction

augroup StlHighlights
	autocmd!
	autocmd ColorScheme * call StlLoadHighlights()
	autocmd ColorScheme * call SneakLoadHighlights()
augroup END
" }}}

" hi StlModeNameText gui=italic,bold
" hi StlFileNameText guibg=white guifg=black

set laststatus=2
" }}}
" coc.nvim {{{

set cmdheight=2 updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
	" Recently vim can merge signcolumn and number column into one
	set signcolumn=number
else
	set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
	inoremap <silent><expr> <c-space> coc#refresh()
else
	inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
" if exists('*complete_info')
" 	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" else
" 	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup CocStuff
	autocmd!
	" Update signature help on jump placeholder.
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-p> <Plug>(coc-range-select)
xmap <silent> <C-p> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

nnoremap <silent><nowait> <space>ce  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>cc  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>cd  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>cj  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>ck  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>co  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>cp  :<C-u>CocListResume<CR>
nnoremap <silent><nowait> <space>cs  :<C-u>CocList -I symbols<cr>
nmap <leader>cr <Plug>(coc-rename)

xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)
xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>cac  <Plug>(coc-codeaction)
nmap <leader>cq  <Plug>(coc-fix-current)

" }}}
" sneak {{{
let g:sneak#streak = 1
function! SneakLoadHighlights()
	highlight Sneak guifg=white guibg=#F5807B
	highlight SneakScope guifg=white guibg=black
	highlight SneakLabel gui=bold guifg=white guibg=#F5807B
	highlight SneakLabelMask guifg=#F5807B guibg=#F5807B
endfunction
let g:sneak#use_ic_scs=1 " ignore case
" }}}
" ale {{{
function! AleLinterStatus() abort
	let l:counts = ale#statusline#Count(bufnr(''))

	let l:all_errors = l:counts.error + l:counts.style_error
	let l:all_non_errors = l:counts.total - l:all_errors

	return l:counts.total == 0 ? '' : printf(
	\   '%dw %de',
	\   all_non_errors,
	\   all_errors
	\)
endfunction
" }}}
" colors {{{
syntax enable 
color dracula
set background=dark
" }}}
" folding {{{
function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount - 2) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()
" function! CustomFold() " {{{
" 	let line = getline(v:foldstart)

" 	let nucolwidth = &fdc + &number * &numberwidth
" 	let windowwidth = winwidth(0) - nucolwidth - 3
" 	let foldedlinecount = v:foldend - v:foldstart

" 	let onetab = repeat(' ', &tabstop)
" 	let line = substitute(line, '\t', onetab, 'g')

" 	let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
" 	let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
" 	return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
" endfunction " }}}

" set foldtext=CustomFold()
" }}}

" vim: set fdm=marker fdl=0: (fold subsections)

