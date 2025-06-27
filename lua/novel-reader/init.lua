local state = require("novel-reader.state")
local cache = require("novel-reader.cache")
local regex = require("novel-reader.regex")
local config = require('novel-reader.config')
local api = require('novel-reader.api')

local M = {
    prev_chapter = api.prev_chapter,
    next_chapter = api.next_chapter,
    set_chapter = api.set_chapter,
    get_current_chapter = api.get_current_chapter
}

function M.setup(user_config)
    if user_config.default_pattern then
        regex.chapter_pattern = user_config.default_pattern
    end

    vim.api.nvim_create_augroup('NovelReaderAutoCmds', { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = "*.txt",
        callback = function()
            M.build_cache()
        end
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
        pattern = "*.txt",
        callback = function()
            require('novel-reader.commands').setup()
            config.setup()
            config.load_to_state()
            M.build_cache()
        end
    })
    vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
        pattern = "*.txt",
        callback = function()
            config.save_from_state()
            config.save_to_file()
        end
    })
end

function M.build_cache()
    local locations = cache.build(
        vim.api.nvim_get_current_buf(),
        regex.chapter_pattern
    )
    state.update_cache(locations)
end

return M
