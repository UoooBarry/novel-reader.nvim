local state = require('novel-reader.state')
local regex = require('novel-reader.regex')
local api = require('novel-reader.api')

local M = {}

function M.setup()
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
        api.next_chapter()
    end, {
        desc = "Go to next chapter"
    })

    vim.api.nvim_create_user_command('NovelReaderPrevChapter', function()
        api.prev_chapter()
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
            api.get_current_chapter() or 0
        ), vim.log.levels.INFO)
    end, {
        desc = "Show chapter cache status"
    })

    vim.api.nvim_create_user_command('NovelReaderSetChapter', function(opts)
        api.set_chapter(opts.args)
    end, {
        nargs = 1,
        complete = function(ArgLead, CmdLine, CursorPos)
            return { "1", "2", "3", "<Number>" }
        end,
        desc = "Set the chapter detection regex pattern"
    })
end

return M
