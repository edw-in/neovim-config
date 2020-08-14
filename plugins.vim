" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " Aesthetics - Main
    Plug 'dracula/vim', { 'commit': '147f389f4275cec4ef43ebc25e2011c57b45cc00' }
    Plug 'pgdouyon/vim-yin-yang'
    Plug 'arcticicestudio/nord-vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/seoul256.vim'
    Plug 'junegunn/vim-journal'
    Plug 'junegunn/rainbow_parentheses.vim'
    Plug 'nightsense/forgotten'
    Plug 'zaki/zazen'

    " Aethetics - Additional
    Plug 'nightsense/nemo'
    Plug 'yuttie/hydrangea-vim'
    Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
    Plug 'rhysd/vim-color-spring-night'

    " Functionalities 
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-surround'
    Plug 'majutsushi/tagbar'
    Plug 'scrooloose/nerdtree'
    Plug 'scrooloose/nerdcommenter'
    Plug 'ervandew/supertab'
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/vim-easy-align'
    Plug 'alvan/vim-closetag'
    Plug 'tpope/vim-abolish'
    Plug 'Yggdroot/indentLine'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'chrisbra/Colorizer'
    Plug 'KabbAmine/vCoolor.vim'
    Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
    Plug 'vim-scripts/loremipsum'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'metakirby5/codi.vim'
    Plug 'dkarter/bullets.vim'

    " Entertainment
    "Plug 'ryanss/vim-hackernews'

call plug#end()

