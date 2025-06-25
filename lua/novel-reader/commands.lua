local state = require('novel-reader.state')
local regex = require('novel-reader.regex')

local M = {}

function M.setup()
    local function gotoChapter()
        local line_num = state.get_location()
        if line_num then
            vim.api.nvim_win_set_cursor(0, { line_num, 0 })
        else
            vim.notify("No more chapters found", vim.log.levels.WARN)
        end
    end

    vim.api.nvim_create_user_command('NovelReaderSetRegex', function(opts)
        if not opts.args or opts.args == "" then
            vim.notify("Error: Please provide a regex pattern", vim.log.levels.ERROR)
        end
        regex.set_chapter_pattern(opts.args)
        vim.notify("Chapter regex pattern updated to: " .. opts.args, vim.log.levels.INFO)
    end, {
        nargs = 1,
        complete = function(ArgLead, CmdLine, CursorPos)
            return {
                "/第\\d\\+章",
                "\\v^第[一二三四五六七八九十百千]+章",
                "\\v^Chapter\\s\\d+",
                "\\v^\\d+\\.\\s",
                "\\v^[A-Z]+\\d+"
            }
        end,
        desc = "Set the chapter detection regex pattern"
    })


    vim.api.nvim_create_user_command('NovelReaderNextChapter', function()
        state.next_chapter()

        gotoChapter()
    end, {
        desc = "Go to next chapter"
    })

    vim.api.nvim_create_user_command('NovelReaderPrevChapter', function()
        state.prev_chapter()

        gotoChapter()
    end, {
        desc = "Go to previous chapter"
    })

    vim.api.nvim_create_user_command('NovelReaderCurrentChapter', function()
        local current = state.get_current_chapter()
        vim.notify(string.format("Current chapter: %d", current), vim.log.levels.INFO)
    end, {
        desc = "Show current chapter number"
    })

    vim.api.nvim_create_user_command('NovelReaderCacheStatus', function()
        vim.notify(string.format(
            "Chapter cache: %d locations, current index: %d",
            #state.chapter_locations,
            state.current_chapter_index or 0
        ), vim.log.levels.INFO)
    end, {
        desc = "Show chapter cache status"
    })

    vim.api.nvim_create_user_command('NovelReaderSetChapter', function(opts)
        if not opts.args and opts.args:match("^%-?%d+$") then
            vim.notify("Error: Please provide a valid chapter number", vim.log.levels.ERROR)
        end

        state.set_chapter(tonumber(opts.args))
        gotoChapter()
    end, {
        nargs = 1,
        complete = function(ArgLead, CmdLine, CursorPos)
            return { "1", "2", "3", "<Number>" }
        end,
        desc = "Set the chapter detection regex pattern"
    })
end

return M
