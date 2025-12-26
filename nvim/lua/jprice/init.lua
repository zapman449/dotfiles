vim.opt.mouse = ""
vim.opt.clipboard = ""

vim.opt.guicursor = ""

vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
-- vim.opt.signcolumn = "yes"    -- adds two spaces left of 0 line
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

-- vim.g.mapleader = ','
vim.g.mapleader = ';'
-- vim.g.maplocalleader = ','
vim.g.maplocalleader = ';'

vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim", },
    { src = "https://github.com/nvim-lua/plenary.nvim", },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = 'main' },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context", },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = "https://github.com/ibhagwan/fzf-lua", },
    { src = "https://github.com/karb94/neoscroll.nvim", },
    { src = "https://github.com/ruifm/gitlinker.nvim", },
    { src = "https://github.com/tpope/vim-fugitive", },
})

vim.cmd[[colorscheme tokyonight]]

local ts_parsers = {
  "bash",
  "dockerfile",
  "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
  "go", "gomod", "gosum",
  "json", "toml", "yaml",
  "lua",
  "make",
  "markdown",
  "python",
  "vim",
}

local nts = require("nvim-treesitter")
nts.install(ts_parsers)
vim.api.nvim_create_autocmd('PackChanged', { 
    callback = function()
        nts.update()
    end
})

require("treesitter-context").setup({
  max_lines = 3,
  multiline_threshold = 1,
  separator = '-',
  min_window_height = 20,
  line_numbers = true,
})
require("neoscroll").setup({ duration_multiplier = 0.4 })
require("gitlinker").setup({})

vim.api.nvim_create_autocmd("FileType", { -- enable treesitter highlighting and indents
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if vim.treesitter.language.add(lang) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end
  end
})
