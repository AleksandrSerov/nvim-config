set encoding=UTF-8
set nocompatible
set rnu
" Enables default dir to cwd
" set autochdir
set signcolumn=yes
call plug#begin('~/.vim/plugged')
filetype plugin indent on
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'HerringtonDarkholme/yats.vim' " Typescript syntax support
Plug 'peitalin/vim-jsx-typescript' " JSX syntax support
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'tomasiser/vim-code-dark' " Theme
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'neoclide/coc.nvim', {'branch': 'release'} " provides LSP
Plug 'APZelos/blamer.nvim' " Show last editor of current line
Plug 'vim-airline/vim-airline' " Provides bottom status bar
Plug 'ryanoasis/vim-devicons' " icons
Plug 'nvim-tree/nvim-web-devicons' " NvimTree icons
Plug 'nvim-lua/plenary.nvim' " dep for telescope
Plug 'nvim-telescope/telescope.nvim' " file browser
Plug 'BurntSushi/ripgrep' " Search engine for telescope
Plug 'nvim-telescope/telescope-file-browser.nvim' " File browser
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " Telescope dep
Plug 'lewis6991/gitsigns.nvim' " Git changes highlighting
Plug 'ctrlpvim/ctrlp.vim'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' } " Customize bufferline
Plug 'nvim-tree/nvim-tree.lua' " Tree file browser
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'} " Terminal in vim
Plug 'tpope/vim-surround' " Commands for surrounding
call plug#end()
imap jj <Esc>
" Do this fix locally for stylelint lsp working
" https://github.com/bmatcuk/coc-stylelintplus/issues/37#issuecomment-1418949263
let g:coc_global_extensions = ['coc-css', 'coc-tsserver', 'coc-eslint', 'coc-prettier', 'coc-graphql', 'coc-stylelintplus', 'coc-spell-checker']
let g:typescript_indent_disable = 1
" Source Vim configuration file and install plugins
nnoremap <silent><leader>1 :source ~/.config/nvim/init.vim \| :PlugInstall<CR>

" CLose all buffers
map <leader>t :%bd\|e#\|bd#<cr>
" Setup theme
let g:codedark_conservative=0
let g:airline_theme = 'codedark'
colorscheme codedark

" Setup toggleterm
lua << EOF

local toggleterm = require("toggleterm")
toggleterm.setup {
      direction = 'vertical',
      open_mapping = [[<c-t>]],
      size = 40
}
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
EOF

" Setup NvimTree
lua << EOF
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

EOF
" Remap exit from terminal mode
:tnoremap <Esc> <C-\><C-n>

" NvimTree Mappings
nnoremap <leader>b :NvimTreeToggle<CR>
nnoremap <leader>nf :NvimTreeFindFile<CR>

" Bufferline setup

set termguicolors
lua << EOF
local bufferline = require("bufferline")
bufferline.setup {
  options = {
    diagnostics = "coc",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true
      }
    }

  }
 }
EOF

" Bufferline mappings
nnoremap <silent>L :BufferLineCycleNext<CR>
nnoremap <silent>H :BufferLineCyclePrev<CR>

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:blamer_enabled = 1 " enable blamer
let g:blamer_show_in_insert_modes = 0 " disable blamer in insert mode
let g:blamer_show_in_visual_modes = 0 " disable blamer in insert mode

" Telescope bindings
nnoremap <Space>ff <cmd>Telescope find_files<cr>
nnoremap <Space>fg <cmd>Telescope live_grep<cr>
nnoremap <Space>fb <cmd>Telescope buffers<cr>
nnoremap <Space>gst <cmd>Telescope git_status<cr>

" CoC extensions
let g:coc_global_extensions = ['coc-tsserver']

" CoC prettier
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
nnoremap gp :silent %!prettier --stdin-filepath %<CR>
" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Command for format
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" switch the lines around
" <A-j> ∆, <A-k> ˚
"
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use K to either doHover or show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Telescope fzf plugin
lua << EOF
require('telescope').load_extension('fzf')
EOF

" Setup gitsigns
lua << EOF
require('gitsigns').setup {
   signs = {
    add          = { text = ' ' },
    change       = { text = ' ' },
    delete       = { text = ' ' },
    topdelete    = { text = ' ' },
    changedelete = { text = ' ' },
    untracked    = { text = ' ' },
  },
}
EOF
" Automatically format frontend files with prettier after file save
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 1

let g:airline_powerline_fonts = 1 "Powerline fonts support
let g:Powerline_symbols='unicode' "unicode support

set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h19
