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
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

-- vim.g.mapleader = ','
vim.g.mapleader = ';'

vim.pack.add({
    { src = "https://github.com/cemkagank/apple.nvim", },
    { src = 'https://github.com/romus204/tree-sitter-manager.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = "https://github.com/ibhagwan/fzf-lua", },
    { src = "https://github.com/karb94/neoscroll.nvim", },
    { src = "https://github.com/rmagatti/gx-extended.nvim", },
})

-- monkeypatch the is_dark to not follow defaults, since I use variable mode
require("apple.util").is_dark = function() return true end
vim.cmd[[colorscheme apple]]

require("tree-sitter-manager").setup({
    ensure_installed = {
        "bash",
        "dockerfile",
        "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
        "go", "gomod", "gosum",
        "json", "toml", "yaml",
        "lua",
        "make",
        "markdown",
        "python",
        "terraform",
        "vim", "vimdoc",
    }
})

require('gx-extended').setup{
  enable_github_file_line = true,
  open_fn = function(url) vim.ui.open(url) end,
}

require("neoscroll").setup({ duration_multiplier = 0.4 })

vim.api.nvim_create_autocmd("FileType", { -- enable treesitter highlighting and indents
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start()
    end
  end
})

vim.lsp.enable('bashls')
vim.lsp.enable('gopls')
vim.lsp.enable('pyright')
vim.lsp.enable('terraformls')
vim.lsp.enable('yamlls')

vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
      },
    },
  }
})

require("fzf-lua").setup()
--vim.keymap.set("n", "<leader>gd", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {noremap = true, silent = true})
-- leader-ff find by files
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", {noremap = true, silent = true})
-- leader-fg find by string (aka grep aka live_grep)
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", {noremap = true, silent = true})

-- leader-tt to open lsp error message on current word
vim.keymap.set("n", "<leader>tt", vim.diagnostic.open_float, {noremap = true, silent = true})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- leader-ss to show LSP documentation for function
    vim.keymap.set('n', '<leader>ss', vim.lsp.buf.signature_help, { buffer = args.buf })
    -- K is the default in 0.10+ on LspAttach, so you can drop the explicit one
  end,
})

-- toggle comment of current line or visual mode selection with cmd-/
-- NOTE: these require kitty keyboard protocol (kitty/ghostty/etc)
vim.keymap.set("v", "<D-/>", "gc",  { remap = true, silent = true, desc = "Toggle comment (visual mode)" })
vim.keymap.set("n", "<D-/>", "gcc", { remap = true, silent = true, desc = "Toggle comment (normal mode)" })
