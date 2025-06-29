local state = require('novel-reader.state')

local M = {}

function M.goto_chapter()
    local line_num = state.get_location()
    if line_num then
        vim.api.nvim_win_set_cursor(0, { line_num, 0 })
    else
        vim.notify("No more chapters found", vim.log.levels.WARN)
    end
end

function M.get_current_chapter()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local chapter = state.get_current_chapter_by_row(row)

    return chapter
end

function M.prev_chapter()
    local chapter = M.get_current_chapter()
    M.set_chapter(chapter - 1)
end

function M.next_chapter()
    local chapter = M.get_current_chapter()

    M.set_chapter(chapter + 1)
end

function M.set_chapter(num)
    if not num and num:match("^%-?%d+$") then
        vim.notify("Error: Please provide a valid chapter number", vim.log.levels.ERROR)
    end

    state.set_chapter(tonumber(num))
    M.goto_chapter()
end

return M
