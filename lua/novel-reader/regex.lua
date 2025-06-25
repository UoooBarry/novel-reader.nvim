local M = {
    chapter_pattern = "第\\d\\+章"
}

local function is_valid_regex(pattern)
    local ok, _ = pcall(function()
        vim.regex(pattern)
    end)
    return ok
end

function M.set_chapter_pattern(pattern)
    if not is_valid_regex(pattern) then
        vim.notify("Error: Invalid regex pattern", vim.log.levels.ERROR)
        return
    end

    M.chapter_pattern = pattern
end


function M.validate(pattern)
    local ok, _ = pcall(function()
        vim.regex(pattern)
    end)
    return ok
end

function M.compile()
    return vim.regex(M.chapter_pattern)
end

return M
