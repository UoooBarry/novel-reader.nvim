local state = require("novel-reader.state")
local cache = require("novel-reader.cache")
local regex = require("novel-reader.regex")
local config = require('novel-reader.config')
local api = require('novel-reader.api')

local M = {
    _chapter_update_timer = nil,
    prev_chapter = api.prev_chapter,
    next_chapter = api.next_chapter,
    set_chapter = api.set_chapter
}

function M.setup(user_config)
    if user_config.default_pattern then
        regex.chapter_pattern = user_config.default_pattern
    end

    vim.api.nvim_create_augroup('NovelReaderAutoCmds', { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
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
    vim.api.nvim_create_autocmd({ "BufWritePost", "VimLeave" }, {
        pattern = "*.txt",
        callback = function()
            config.save_from_state()
            config.save_to_file()
        end
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        pattern = "*.txt",
        group = 'NovelReaderAutoCmds',
        callback = function()
            M.update_chapter_debounced()
        end
    })
    vim.api.nvim_create_autocmd('BufLeave', {
        pattern = "*.txt",
        group = 'NovelReaderAutoCmds',
        callback = function()
            if M._chapter_update_timer and M._chapter_update_timer:is_active() then
                M._chapter_update_timer:stop()
            end
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

function M.update_chapter_debounced()
    if M._chapter_update_timer then
        M._chapter_update_timer:stop()
    else
        M._chapter_update_timer = vim.loop.new_timer()
    end

    M._chapter_update_timer:start(1000, 0, vim.schedule_wrap(function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local chapter = state.get_current_chapter_by_row(row)
        state.set_chapter(chapter)
    end))
end

return M
