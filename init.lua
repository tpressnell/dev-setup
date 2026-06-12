vim.lsp.config['clang'] = {
        cmd = { 'clangd' },
        filetypes = { 'c', 'cpp', 'h' },
}
vim.lsp.enable('clang')
-- had to add tressitter for cpp at /usr/local/lib/nvim/parser

vim.lsp.config['luals'] = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
}
vim.lsp.enable('luals')
-- download lua-language-server, symlink in usr/bin

vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(args)
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

                -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
                if client:supports_method('textDocument/completion') then
                        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
                end

                -- Auto-format ("lint") on save.
                -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
                if not client:supports_method('textDocument/willSaveWaitUntil')
                    and client:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                                buffer = args.buf,
                                callback = function()
                                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                                end,
                        })
                end
        end,
})


vim.cmd("colorscheme retrobox")

local function SetIndent()
        cppExts = { cpp = true, h = true, c = true }
        filetype = vim.bo.filetype
        if (cppExts[filetype]) then
                vim.opt.shiftwidth = 2
        else
                vim.opt.shiftwidth = 8
        end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
        callback = SetIndent
})

-- gri is goto implementation
-- grr is show references
-- K shows whatever you would be "hovering" over in a regular IDE
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = { trail = '~', tab = '> ' }
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
vim.opt.grepprg = 'ack --nogroup --column $*'
vim.opt.grepformat = '%f:%l:%c:%m'

vim.g.mapleader = ' '
vim.keymap.set('c', 'grep', 'grep!', {})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        callback = function()
                vim.cmd('cwindow')
        end
})

vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
                local cwd = vim.uv.cwd()
                vim.opt.path:append(cwd)
        end
})

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
        pattern = "term://*",
        callback = function()
                vim.cmd("startinsert")
        end,
})

vim.keymap.set('n', '<leader>t', ':vert term<CR>', { desc = 'vertical split terminal' })
vim.keymap.set('n', '<M-j>', ':cnext<CR>', { desc = 'next quickfix item' })
vim.keymap.set('n', '<M-k>', ':cprev<CR>', { desc = 'previous quickfix item' })
vim.keymap.set('n', '<F1>', 'yiw :grep! <C-R>\"<CR>', { desc = 'search for word under cursor' })
vim.keymap.set('t', '<C-W><C-W>', '<C-\\><C-N><C-W><C-W>', { desc = 'Switch from terminal' })

vim.api.nvim_create_user_command('E', 'Explore', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('CC', 'cclose', {})
vim.api.nvim_create_user_command('CO', 'copen', {})
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'show diagnostics' })
