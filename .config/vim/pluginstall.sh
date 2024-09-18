# Run inside %HOME%\vimfiles or ~/.vim directory

mkdir -p pack/dist/opt

GITCMD="git -C ./pack/dist/opt clone --depth=1"

$GITCMD https://github.com/junegunn/fzf.git
$GITCMD https://github.com/junegunn/fzf.vim.git
$GITCMD https://github.com/tpope/vim-commentary.git
$GITCMD https://github.com/tpope/vim-surround.git
$GITCMD https://github.com/tpope/vim-repeat.git
$GITCMD https://github.com/tpope/vim-fugitive.git
$GITCMD https://github.com/junegunn/rainbow_parentheses.vim.git
$GITCMD https://github.com/chengzeyi/multiterm.vim.git
$GITCMD https://github.com/sheerun/vim-polyglot.git
$GITCMD https://github.com/hauleth/asyncdo.vim.git
$GITCMD https://github.com/jpalardy/vim-slime.git
$GITCMD https://github.com/habamax/vim-dir.git
$GITCMD https://github.com/imranzero/smartpairs.vim.git
$GITCMD https://github.com/imranzero/wintweak.gvim.git
$GITCMD https://github.com/neoclide/coc.nvim.git

$GITCMD --single-branch --branch release/0.x https://github.com/prettier/vim-prettier.git
$GITCMD https://github.com/mattn/emmet-vim.git
$GITCMD https://github.com/fatih/vim-go.git
$GITCMD https://github.com/charlespascoe/vim-go-syntax.git

# $GITCMD https://github.com/Donaldttt/fuzzyy.git
# $GITCMD https://github.com/lilydjwg/colorizer.git
# $GITCMD https://github.com/justinmk/vim-sneak.git
# $GITCMD https://github.com/junegunn/goyo.vim.git

$GITCMD https://github.com/rafi/awesome-vim-colorschemes.git
$GITCMD https://gitlab.com/protesilaos/tempus-themes.git
$GITCMD https://github.com/mvanderkamp/cocoa.vim.git
$GITCMD https://github.com/tobi-wan-kenobi/zengarden.git
